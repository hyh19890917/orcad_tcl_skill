# DboExtension (10 methods)

| method | params | note |
| --- | --- | --- |
| `~delete` | `self` | argc=1 |
| `Copy` | `self` | argc=1 |
| `GetDataHeaderSize` | `` | zero-arg-ok |
| `GetExtensionName` | `self` | argc=1 |
| `GetExtensionType` | `` | overloaded-C++ |
| `GetSignature` | `` | zero-arg-ok |
| `IsSignatureValid` | `pSignature` | argc=1 |
| `IsValid` | `self` | argc=1 |
| `IsValidType` | `pExtension` | argc=1 |
| `Store` | `self,pExtensionData` | argc=1 |

Usage (object form): `$obj <method> <args...>`  /  global form: `DboExtension_<method> $obj <args...>`
