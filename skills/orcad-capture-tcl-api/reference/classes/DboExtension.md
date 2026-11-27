# DboExtension (10 methods, official_calls(upper bound)=39)

| method | params | note | official | shared |
| --- | --- | --- | --- | --- |
| `~delete` | `self` | argc=1 | 0 | 151 |
| `Copy` | `self` | argc=1 | 38 | 8 |
| `GetDataHeaderSize` | `` | zero-arg-ok | 0 | 1 |
| `GetExtensionName` | `self` | argc=1 | 0 | 1 |
| `GetExtensionType` | `` | overloaded-C++ | 0 | 1 |
| `GetSignature` | `` | zero-arg-ok | 0 | 1 |
| `IsSignatureValid` | `pSignature` | argc=1 | 0 | 1 |
| `IsValid` | `self` | argc=1 | 0 | 1 |
| `IsValidType` | `pExtension` | argc=1 | 0 | 1 |
| `Store` | `self,pExtensionData` | argc=1 | 1 | 5 |

Usage: `$obj <method> <args...>`  |  `DboExtension_<method> $obj <args...>`
