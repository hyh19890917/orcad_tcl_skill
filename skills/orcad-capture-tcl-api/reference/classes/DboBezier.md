# DboBezier (14 methods, official_calls(upper bound)=109)

| method | params | note | official | shared |
| --- | --- | --- | --- | --- |
| `GetCount` | `self,status` | argc=1 | 3 | 3 |
| `GetLineStyle` | `self,status` | argc=1 | 1 | 11 |
| `GetLineWidth` | `self,status` | argc=1 | 1 | 11 |
| `GetObjectType` | `self` | argc=1 | 86 | 57 |
| `Move` | `self,ptOffset` | argc=1 | 14 | 20 |
| `MovePoint` | `self,position,ptOffset` | argc=1 | 0 | 7 |
| `NewPoint` | `` | overloaded-C++ | 1 | 7 |
| `NewPointsIter` | `self,status` | argc=1 | 3 | 3 |
| `RemoveAllPoints` | `self` | argc=1 | 0 | 3 |
| `RemovePoint` | `self,nIndex` | argc=1 | 0 | 3 |
| `SetLineStyle` | `self,style` | argc=1 | 0 | 18 |
| `SetLineWidth` | `self,width` | argc=1 | 0 | 18 |
| `sGetLineStyle` | `obj,status` | argc=1 | 0 | 15 |
| `sGetLineWidth` | `obj,status` | argc=1 | 0 | 15 |

Usage: `$obj <method> <args...>`  |  `DboBezier_<method> $obj <args...>`
