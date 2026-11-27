# DboERC (10 methods, official_calls(upper bound)=9)

| method | params | note | official | shared |
| --- | --- | --- | --- | --- |
| `GetDetail` | `self,detail` | argc=1 | 0 | 1 |
| `GetError` | `self,error` | argc=1 | 0 | 1 |
| `GetLocationString` | `self,location` | argc=1 | 0 | 1 |
| `GetSeverity` | `self,status` | argc=1 | 0 | 1 |
| `SetLocation` | `self,location` | argc=1 | 9 | 12 |
| `SetMirror` | `self,mirror` | argc=1 | 0 | 9 |
| `SetRotation` | `self,rotation` | argc=1 | 0 | 13 |
| `sGetDetail` | `obj,status` | argc=1 | 0 | 1 |
| `sGetError` | `obj,status` | argc=1 | 0 | 1 |
| `sGetSeverity` | `obj,status` | argc=1 | 0 | 1 |

Usage: `$obj <method> <args...>`  |  `DboERC_<method> $obj <args...>`
