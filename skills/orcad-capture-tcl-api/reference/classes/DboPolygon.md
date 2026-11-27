# DboPolygon (20 methods, official_calls(upper bound)=111)

| method | params | note | official | shared |
| --- | --- | --- | --- | --- |
| `GetCount` | `self,status` | argc=1 | 3 | 3 |
| `GetFillStyle` | `self,status` | argc=1 | 1 | 4 |
| `GetHatchStyle` | `self,status` | argc=1 | 1 | 4 |
| `GetLineStyle` | `self,status` | argc=1 | 1 | 11 |
| `GetLineWidth` | `self,status` | argc=1 | 1 | 11 |
| `GetObjectType` | `self` | argc=1 | 86 | 57 |
| `Move` | `self,ptOffset` | argc=1 | 14 | 20 |
| `MovePoint` | `self,position,ptOffset` | argc=1 | 0 | 7 |
| `NewPoint` | `` | overloaded-C++ | 1 | 7 |
| `NewPointsIter` | `self,status` | argc=1 | 3 | 3 |
| `RemoveAllPoints` | `self` | argc=1 | 0 | 3 |
| `RemovePoint` | `self,nIndex` | argc=1 | 0 | 3 |
| `SetFillStyle` | `self,style` | argc=1 | 0 | 8 |
| `SetHatchStyle` | `self,style` | argc=1 | 0 | 8 |
| `SetLineStyle` | `self,style` | argc=1 | 0 | 18 |
| `SetLineWidth` | `self,width` | argc=1 | 0 | 18 |
| `sGetFillStyle` | `obj,status` | argc=1 | 0 | 7 |
| `sGetHatchStyle` | `obj,status` | argc=1 | 0 | 7 |
| `sGetLineStyle` | `obj,status` | argc=1 | 0 | 15 |
| `sGetLineWidth` | `obj,status` | argc=1 | 0 | 15 |

Usage: `$obj <method> <args...>`  |  `DboPolygon_<method> $obj <args...>`
