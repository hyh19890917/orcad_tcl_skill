# DboExtBlobHandlerRegistry (5 methods, official_calls(upper bound)=0)

| method | params | note | official | shared |
| --- | --- | --- | --- | --- |
| `GetPassThruHandler` | `self` | argc=1 | 0 | 1 |
| `LookupHandler` | `self,pType,pVersion` | argc=1 | 0 | 1 |
| `RegisterHandler` | `self,pType,pVersion,pHandler` | argc=1 | 0 | 1 |
| `RemoveHandler` | `self,pType,pVersion` | argc=1 | 0 | 1 |
| `sGetInstance` | `` | zero-arg-ok | 0 | 4 |

Usage: `$obj <method> <args...>`  |  `DboExtBlobHandlerRegistry_<method> $obj <args...>`
