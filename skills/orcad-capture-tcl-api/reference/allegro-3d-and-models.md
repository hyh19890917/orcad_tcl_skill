# 封装与 3D 模型绑定（Allegro 侧 + 清单设计）

做"器件库工具"时，**绑定**这件事最容易做成"把 STEP 塞进封装文件就算完"，然后换机器/换模型/重生成之后没人知道对不对。下面这条链是实测出来能站住的做法：清单存哈希与来源、宿主侧挂载后读回、不通过不发布。

## 1. Allegro 的 3D 能力面（SKILL）

| 动作 | SKILL 调用 | 说明 |
| --- | --- | --- |
| 挂主 3D 模型 | `(axlStepSet 'primary nil "<step 路径>" <mapping>)` | `mapping` 含方向与偏移；参数必须是有限数值 |
| 读回 | `(axlStepGet nil 'primary nil)` | 返回结构里的字段逐个与期望比较 |
| 比较 | `(lessp (abs (difference actual expected)) 0.00011)` | 容差 1e-4，避免浮点抖动误判 |
| 写高度属性 | `(axlDBAddProp shape (list "PACKAGE_HEIGHT_MAX" (axlMKSConvert <mm> "millimeters")))` | 高度挂在 package shape 上 |
| 删高度属性 | `(axlDBDeleteProp shape (list "PACKAGE_HEIGHT_MAX"))` | 重生成前先清，避免旧值残留 |
| 回读高度 | `(/ (axlMKS2UU value) (axlMKSConvert 1.0 "millimeters"))` | 换算回 mm 打印，供主进程核对 |

工程习惯：把结果写进状态文件（`STEP_SET=…`、`HEIGHT|%.10f`），由主进程读回判定；不要只看 SKILL 返回值。

## 2. 清单：一条记录绑住 2D、3D、高度、来源

每个封装一条记录（明文 JSON 或数据库行都行），字段与理由：

```jsonc
{
  "name": "FILTER-SMD_4P-L4R8-W4R5-BL",
  "converter_revision": "2026-11-09.1",        // 生成器版本：换算法能识别旧产物
  "files": [                                    // 2D 产物 + 指纹
    {"path": "...\\x.dra", "sha256": "..."},
    {"path": "...\\x.psm", "sha256": "..."},
    {"path": "...\\x.pad", "sha256": "..."},
    {"path": "...\\x.txt", "sha256": "..."}
  ],
  "geometry_sha256": "...",                     // 2D 轮廓指纹
  "model": {"path": "...\\X.step", "sha256": "..."},
  "height_mm": 1.82,
  "height_source": {"rotation": [0,0,0], "bottom_mm": 0.0, "source_id": "..."},
  "binding": null                                // null=自动推导；非空=人工覆盖（记录是谁、何时）
}
```

为什么这些字段都不能省：

| 字段 | 省了会怎样 |
| --- | --- |
| `files[].sha256` | 库被同事改过，工具还以为是最新 |
| `geometry_sha256` | 同名封装换了轮廓（焊盘改了），3D 是否还对得上无从判断 |
| `model.sha256` | 只存路径：模型被替换、换机路径失效，全都不报警 |
| `height_source` | 只存高度：模型换了朝向/原点后高度对不上，且无法复算解释 |
| `binding` | 分不清自动结果与人工修正，重生成会覆盖人的决定 |

## 3. STEP 侧：对齐与高度是"测"出来的

1. 读 STEP 网格（包围盒/三角面），得到 z 范围 → `height_mm` 与 `bottom_mm`（底面不在 0 时要记下来）。
2. 由包围盒与封装原点算 `rotation_x/y/z` 与 `offset_x/y/z`，让模型落位到封装坐标。
3. 把**测得的值**写进清单的 `height_source`，而不是当配置项——这样别人能复算、能解释。

## 4. 校验（不通过不发布）

```text
生成 2D 产物 → 逐文件 sha256 记账
挂 STEP → axlStepGet 读回 → 逐字段比较（1e-4）
写 PACKAGE_HEIGHT_MAX → 回读 HEIGHT|%.10f → 与清单 height_mm 比
任一步不等 → 不发布（产物留工作目录）
```

## 5. 反模式

1. **只把 STEP 路径写进封装**：换模型/换机器后无声失效。
2. **高度写成常量**：换封装/换模型后没人改。
3. **重生成时不先删旧属性**：旧 `PACKAGE_HEIGHT_MAX` 残留，读回永远"通过"。
4. **只信 `axlStepSet` 的返回值**：它可能成功但映射参数被截断；必须读回比。
5. **明文清单不加锁/不含版本戳**：并发写或换生成器后无法判断哪份新。

## 6. 代码骨架

```lisp
;; 生成器产出的 SKILL 片段（片段，非完整脚本）
(setq _step_set_result (axlStepSet 'primary nil "<STEP>" (list <rot> <offset>)))
(when _step_set_result
  (let ((got (axlStepGet nil 'primary nil)))
    (unless (and (lessp (abs (difference (nth 0 got) <rot0>)) 0.00011) ...)
      (error "STEP_READBACK_MISMATCH"))))
(axlDBDeleteProp shape (list "PACKAGE_HEIGHT_MAX"))
(axlDBAddProp shape (list "PACKAGE_HEIGHT_MAX" (axlMKSConvert <mm> "millimeters")))
(let ((f (outfile "_height_verify.txt")))
  (fprintf f "HEIGHT|%.10f\n" (/ (axlMKS2UU shape->prop->PACKAGE_HEIGHT_MAX)
                                 (axlMKSConvert 1.0 "millimeters")))
  (close f))
```

主进程侧（Python/Tcl 均可）读 `_height_verify.txt`，与清单 `height_mm` 比对，差超 1e-4 就判失败——和"OLB 重开枚举"是同一套思路：**宿主自己说成了不算，读回来一致才算**。
