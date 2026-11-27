# DboBezier (14 methods)

| method | params | note |
| --- | --- | --- |
| `GetCount` | `self,status` | argc=1 |
| `GetLineStyle` | `self,status` | argc=1 |
| `GetLineWidth` | `self,status` | argc=1 |
| `GetObjectType` | `self` | argc=1 |
| `Move` | `self,ptOffset` | argc=1 |
| `MovePoint` | `self,position,ptOffset` | argc=1 |
| `NewPoint` | `` | overloaded-C++ |
| `NewPointsIter` | `self,status` | argc=1 |
| `RemoveAllPoints` | `self` | argc=1 |
| `RemovePoint` | `self,nIndex` | argc=1 |
| `SetLineStyle` | `self,style` | argc=1 |
| `SetLineWidth` | `self,width` | argc=1 |
| `sGetLineStyle` | `obj,status` | argc=1 |
| `sGetLineWidth` | `obj,status` | argc=1 |

Usage (object form): `$obj <method> <args...>`  /  global form: `DboBezier_<method> $obj <args...>`
