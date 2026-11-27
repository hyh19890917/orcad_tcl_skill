# DboExtCentral (8 methods, official_calls(upper bound)=0)

| method | params | note | official | shared |
| --- | --- | --- | --- | --- |
| `CopyExtensions` | `self,pSource,pDest` | argc=1 | 0 | 3 |
| `CreateBlobExtension` | `self,pObject,pType,pSubType,pVersion` | argc=1 | 0 | 2 |
| `CreateExtension` | `self,pObject,pType` | argc=1 | 0 | 2 |
| `GetBlobExtension` | `self,pObject,pSubType,pVersion` | argc=1 | 0 | 1 |
| `GetExtension` | `self,pObject,pType` | argc=1 | 0 | 2 |
| `RegisterBlobHandler` | `self,pType,pVersion,pHandler` | argc=1 | 0 | 1 |
| `SetExtension` | `self,pObject,pExtension` | argc=1 | 0 | 1 |
| `sGetInstance` | `` | zero-arg-ok | 0 | 4 |

Usage: `$obj <method> <args...>`  |  `DboExtCentral_<method> $obj <args...>`
