# DboExtensionManager (14 methods)

| method | params | note |
| --- | --- | --- |
| `AddExtension` | `self,pHandle,pExtension` | argc=1 |
| `CopyExtensions` | `self,pDest,pSource` | argc=1 |
| `CreateHandle` | `` | overloaded-C++ |
| `DeleteHandle` | `self,pHandle` | argc=1 |
| `GetExtension` | `self,pHandle,pExtensionType` | argc=1 |
| `GetNumElements` | `self,pHandle` | argc=1 |
| `IsEmpty` | `self,pHandle` | argc=1 |
| `LoadExtensions` | `self,pBufferSize,pBuffer` | argc=1 |
| `NewExtensionIter` | `self,pHandle,status` | argc=1 |
| `RemoveAllExtensions` | `self,pHandle` | argc=1 |
| `RemoveExtension` | `` | overloaded-C++ |
| `ReplaceExtension` | `self,pHandle,pNewExtension` | argc=1 |
| `sGetInstance` | `` | zero-arg-ok |
| `StoreExtensions` | `self,pHandle,pBufferSize,pBuffer` | argc=1 |

Usage (object form): `$obj <method> <args...>`  /  global form: `DboExtensionManager_<method> $obj <args...>`
