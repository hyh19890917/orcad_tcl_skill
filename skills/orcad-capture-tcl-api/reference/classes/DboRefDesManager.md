# DboRefDesManager (11 methods)

| method | params | note |
| --- | --- | --- |
| `~delete` | `self` | argc=1 |
| `AddInstOccToPending` | `self,pInstOcc` | argc=1 |
| `AssignRefDesToPendingInstOccs` | `self` | argc=1 |
| `ClearPendingInstOccs` | `self` | argc=1 |
| `GetInstanceRefDesMap` | `self` | argc=1 |
| `GetOccRefDesMap` | `self` | argc=1 |
| `IsDesignLevelAutoReferenceEnabled` | `` | zero-arg-ok |
| `ProcessObjectDelete` | `self,pDboBaseObj` | argc=1 |
| `ProcessRefDesModify` | `self,pDboBaseObj` | argc=1 |
| `RefreshInstanceRefDesMap` | `self` | argc=1 |
| `RefreshOccRefDesMap` | `` | overloaded-C++ |

Usage (object form): `$obj <method> <args...>`  /  global form: `DboRefDesManager_<method> $obj <args...>`
