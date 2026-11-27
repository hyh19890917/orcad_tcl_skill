# DboGraphicBezierInst (9 methods, official_calls(upper bound)=15)

| method | params | note | official | shared |
| --- | --- | --- | --- | --- |
| `GetDboBezier` | `self` | argc=1 | 0 | 1 |
| `Move` | `self,offset` | argc=1 | 14 | 20 |
| `MovePoint` | `self,nPoint,offset` | argc=1 | 0 | 7 |
| `NewPoint` | `` | overloaded-C++ | 1 | 7 |
| `SetLineStyle` | `self,style` | argc=1 | 0 | 18 |
| `SetLineWidth` | `self,width` | argc=1 | 0 | 18 |
| `sGetLineStyle` | `obj,status` | argc=1 | 0 | 15 |
| `sGetLineWidth` | `obj,status` | argc=1 | 0 | 15 |
| `StatefulCreate` | `self` | argc=1 | 0 | 11 |

Usage: `$obj <method> <args...>`  |  `DboGraphicBezierInst_<method> $obj <args...>`
