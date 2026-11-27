# `orjson_*`：Capture 里的 JSON 工具集（64 个命令）

Capture 的 Tcl 没有 `json` 包，但宿主自带一整套 `orjson_*`。官方脚本里用了上千次（`orjson_push_back` 425、`orjson_new_a` 300、`orjson_get` 228、`orjson_as_string` 216），**写插件要拼/解 JSON 时应该用它，不要自己 `format` 字符串**。

## 1. 成员分组（真机导出，共 64 条）

| 角色 | 命令 |
| --- | --- |
| 构造 | `orjson_new` `orjson_new_a` `orjson_new_b` `orjson_new_f` `orjson_new_i` `orjson_new_stream` |
| 解析 / 序列化 | `orjson_parse` `orjson_parse_unformatted` `orjson_write` `orjson_write_formatted` `orjson_strip_white_space` |
| 取值 / 转换 | `orjson_get` `orjson_get_nocase` `orjson_at` `orjson_as_string` `orjson_as_int` `orjson_as_float` `orjson_as_bool` `orjson_as_array` `orjson_as_node` `orjson_as_binary` `orjson_type` `orjson_size` `orjson_name` `orjson_get_comment` |
| 结构操作 | `orjson_push_back` `orjson_pop_back` `orjson_pop_back_at` `orjson_pop_back_nocase` `orjson_insert` `orjson_insert_multi` `orjson_erase` `orjson_erase_multi` `orjson_delete` `orjson_delete_stream` `orjson_clear` `orjson_merge` `orjson_swap` `orjson_copy` `orjson_duplicate` `orjson_cast` `orjson_nullify` `orjson_reserve` `orjson_empty` `orjson_equal` `orjson_free` |
| 命名 / 赋值 | `orjson_set_name` `orjson_set_a` `orjson_set_b` `orjson_set_f` `orjson_set_i` `orjson_set_n` `orjson_set_binary` `orjson_set_comment` |
| 查找 | `orjson_find` `orjson_find_nocase` |
| 流式 | `orjson_begin` `orjson_end` `orjson_stream_push` `orjson_stream_reset` |
| Base64 | `orjson_encode64` `orjson_decode64` |
| 校验 | `orjson_is_valid` `orjson_is_valid_unformatted` |

## 2. 已见调用形态（官方脚本原文）

```tcl
set rootNode [orjson_new "\5"]                 ;# 新建容器节点（类型标记，见 §3）
set lLog     [orjson_new "\4"]
orjson_set_name $lLog "log"                    ;# 给节点命名（对象里的 key）
set lProp [orjson_new_a "refer" $lReference]   ;# 新建键值节点：key=refer, value=…
orjson_push_back $lLog $lProp                  ;# 把子节点挂到父节点
set prop [orjson_new_a "" $index]              ;# 空 key（用于数组元素）

set node [orjson_at $arr $i]                   ;# 取数组第 i 个元素（返回节点）
set n    [orjson_size $arr]                    ;# 元素个数
set text [orjson_write $rootNode]              ;# 序列化成字符串

set obj [orjson_parse $jsonStr]                ;# 解析字符串
set v   [orjson_get $obj "outputDirectory"]
set s   [orjson_as_string $v]
set i   [orjson_as_int $v]
```

## 3. 类型标记（`orjson_new "\N"`）

官方只用过两种：`orjson_new "\5"` 与 `orjson_new "\4"`；从后续 `push_back`/`set_name`/`at` 的用法看，`\5` 用于**对象**（带 key），`\4` 用于**数组**（按索引）。这是从调用点推断的，**没有官方文档佐证**——写代码时更稳的做法是：对象/数组都先用 `orjson_new "\5"` 试，`push_back` 后 `orjson_write` 看输出形状是否符合预期。

## 4. 五个高频配方

```tcl
# ① 建一个对象并填两个字段
set o [orjson_new "\5"]
set a [orjson_new_a "design" $designName];  orjson_push_back $o $a
set b [orjson_new_a "count"  $n];            orjson_push_back $o $b
puts [orjson_write $o]        ;# {"design":"…","count":N}

# ② 解析 → 取字符串 → 转 Tcl 值（注意必须 as_*）
set j [orjson_parse $jsonText]
set v [orjson_get $j "PaperSize"]
set paperIndex [orjson_as_int $v]

# ③ 遍历数组
set arr  [orjson_get $j "items"]
set size [orjson_size $arr]
for {set i 0} {$i < $size} {incr i} {
    set item [orjson_at $arr $i]
    set name [orjson_as_string [orjson_get $item "name"]]
}

# ④ 大小写不敏感取键（配置项常见）
set v [orjson_get_nocase $j "papertypesize"]

# ⑤ 二进制/内嵌数据
set b64  [orjson_encode64 $node]
set node2 [orjson_decode64 $b64]
```

## 5. 坑

1. **`orjson_get` 返回节点不是字符串**：必须 `orjson_as_string/int/float/bool` 转换；直接当字符串用会得到节点对象名（形如 `_xxxx_p_...`）。
2. **`write` 与 `write_formatted`**：前者紧凑（适合塞进协议字段），后者带缩进（适合日志/调试）；两者输出都是**字符串**，不是文件——要落盘自己 `open/puts`。
3. **`parse` 与 `parse_unformatted`**：后者用于"已知无多余空白"的紧凑输入，遇到畸形输入时行为更严格；不确定就用 `parse`。
4. **`push_back` 是唯一的追加方式**：`insert`/`insert_multi` 按位置插入，`set_name` 给节点改名（数组元素名留空即可）。
5. **`orjson_free` 存在**：长循环里大量建节点时显式释放，避免会话内存上涨。

## 6. 一键补齐参数表

`scripts/export-host-commands.tcl` 已支持按前缀扩探测：

```tcl
::hostdump::Run "D:/tmp/capture-host-bom" --probe-bom
```

`--probe-bom` 会把 `CNewBOm|CVariant|DboTclBom|DBXMLWriter|orjson` 纳入零参探测，一次导出就能拿到这些家族每个命令的参数个数与参数名。
