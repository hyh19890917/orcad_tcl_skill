# DboExtBlobHandlerRegistry (5 methods)

| method | params | note |
| --- | --- | --- |
| `GetPassThruHandler` | `self` | argc=1 |
| `LookupHandler` | `self,pType,pVersion` | argc=1 |
| `RegisterHandler` | `self,pType,pVersion,pHandler` | argc=1 |
| `RemoveHandler` | `self,pType,pVersion` | argc=1 |
| `sGetInstance` | `` | zero-arg-ok |

Usage (object form): `$obj <method> <args...>`  /  global form: `DboExtBlobHandlerRegistry_<method> $obj <args...>`
