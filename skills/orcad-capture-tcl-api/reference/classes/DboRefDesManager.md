# DboRefDesManager (11 methods, official_calls(upper bound)=0)

| method | params | note | official | shared |
| --- | --- | --- | --- | --- |
| `~delete` | `self` | argc=1 | 0 | 151 |
| `AddInstOccToPending` | `self,pInstOcc` | argc=1 | 0 | 1 |
| `AssignRefDesToPendingInstOccs` | `self` | argc=1 | 0 | 1 |
| `ClearPendingInstOccs` | `self` | argc=1 | 0 | 1 |
| `GetInstanceRefDesMap` | `self` | argc=1 | 0 | 1 |
| `GetOccRefDesMap` | `self` | argc=1 | 0 | 1 |
| `IsDesignLevelAutoReferenceEnabled` | `` | zero-arg-ok | 0 | 1 |
| `ProcessObjectDelete` | `self,pDboBaseObj` | argc=1 | 0 | 1 |
| `ProcessRefDesModify` | `self,pDboBaseObj` | argc=1 | 0 | 2 |
| `RefreshInstanceRefDesMap` | `self` | argc=1 | 0 | 1 |
| `RefreshOccRefDesMap` | `` | overloaded-C++ | 0 | 1 |

Usage: `$obj <method> <args...>`  |  `DboRefDesManager_<method> $obj <args...>`
