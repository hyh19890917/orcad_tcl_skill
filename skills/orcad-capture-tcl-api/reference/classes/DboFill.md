# DboFill (12 methods, official_calls(upper bound)=104)

| method | params | note | official | shared |
| --- | --- | --- | --- | --- |
| `GetFillStyle` | `self,status` | argc=1 | 1 | 4 |
| `GetHatchStyle` | `self,status` | argc=1 | 1 | 4 |
| `GetObjectType` | `self` | argc=1 | 86 | 57 |
| `GetStart` | `self,status` | argc=1 | 2 | 4 |
| `Move` | `self,ptOffset` | argc=1 | 14 | 20 |
| `SetFillStyle` | `self,style` | argc=1 | 0 | 8 |
| `SetHatchStyle` | `self,style` | argc=1 | 0 | 8 |
| `SetStart` | `self,point` | argc=1 | 0 | 5 |
| `sGetFillStyle` | `obj,status` | argc=1 | 0 | 7 |
| `sGetHatchStyle` | `obj,status` | argc=1 | 0 | 7 |
| `sGetStartX` | `obj,status` | argc=1 | 0 | 5 |
| `sGetStartY` | `obj,status` | argc=1 | 0 | 5 |

Usage: `$obj <method> <args...>`  |  `DboFill_<method> $obj <args...>`
