# DboPort (10 methods, official_calls(upper bound)=89)

| method | params | note | official | shared |
| --- | --- | --- | --- | --- |
| `GetObjectOccurrence` | `self,pParentSchematicOcc` | argc=1 | 13 | 9 |
| `GetObjectOccurrences` | `` | overloaded-C++ | 0 | 8 |
| `GetPinType` | `self,status` | argc=1 | 8 | 9 |
| `GetPortSymbol` | `self,status` | argc=1 | 0 | 2 |
| `IsBundleObject` | `self` | argc=1 | 2 | 10 |
| `SetMirror` | `self,mirror` | argc=1 | 0 | 9 |
| `SetName` | `self,name` | argc=1 | 66 | 17 |
| `SetPinType` | `self,pinType` | argc=1 | 0 | 7 |
| `SetRotation` | `self,rotation` | argc=1 | 0 | 13 |
| `sGetPinType` | `obj,status` | argc=1 | 0 | 4 |

Usage: `$obj <method> <args...>`  |  `DboPort_<method> $obj <args...>`
