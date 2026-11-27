# DboExtensionManager (14 methods, official_calls(upper bound)=0)

| method | params | note | official | shared |
| --- | --- | --- | --- | --- |
| `AddExtension` | `self,pHandle,pExtension` | argc=1 | 0 | 1 |
| `CopyExtensions` | `self,pDest,pSource` | argc=1 | 0 | 3 |
| `CreateHandle` | `` | overloaded-C++ | 0 | 1 |
| `DeleteHandle` | `self,pHandle` | argc=1 | 0 | 1 |
| `GetExtension` | `self,pHandle,pExtensionType` | argc=1 | 0 | 2 |
| `GetNumElements` | `self,pHandle` | argc=1 | 0 | 1 |
| `IsEmpty` | `self,pHandle` | argc=1 | 0 | 2 |
| `LoadExtensions` | `self,pBufferSize,pBuffer` | argc=1 | 0 | 1 |
| `NewExtensionIter` | `self,pHandle,status` | argc=1 | 0 | 1 |
| `RemoveAllExtensions` | `self,pHandle` | argc=1 | 0 | 1 |
| `RemoveExtension` | `` | overloaded-C++ | 0 | 1 |
| `ReplaceExtension` | `self,pHandle,pNewExtension` | argc=1 | 0 | 1 |
| `sGetInstance` | `` | zero-arg-ok | 0 | 4 |
| `StoreExtensions` | `self,pHandle,pBufferSize,pBuffer` | argc=1 | 0 | 1 |

Usage: `$obj <method> <args...>`  |  `DboExtensionManager_<method> $obj <args...>`
