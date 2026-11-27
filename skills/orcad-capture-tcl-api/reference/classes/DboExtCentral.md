# DboExtCentral (8 methods)

| method | params | note |
| --- | --- | --- |
| `CopyExtensions` | `self,pSource,pDest` | argc=1 |
| `CreateBlobExtension` | `self,pObject,pType,pSubType,pVersion` | argc=1 |
| `CreateExtension` | `self,pObject,pType` | argc=1 |
| `GetBlobExtension` | `self,pObject,pSubType,pVersion` | argc=1 |
| `GetExtension` | `self,pObject,pType` | argc=1 |
| `RegisterBlobHandler` | `self,pType,pVersion,pHandler` | argc=1 |
| `SetExtension` | `self,pObject,pExtension` | argc=1 |
| `sGetInstance` | `` | zero-arg-ok |

Usage (object form): `$obj <method> <args...>`  /  global form: `DboExtCentral_<method> $obj <args...>`
