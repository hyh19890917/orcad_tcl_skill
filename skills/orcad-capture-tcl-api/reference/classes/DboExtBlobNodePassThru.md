# DboExtBlobNodePassThru (7 methods, official_calls(upper bound)=12)

| method | params | note | official | shared |
| --- | --- | --- | --- | --- |
| `~delete` | `self` | argc=1 | 0 | 151 |
| `GetPassThruStream` | `self` | argc=1 | 0 | 1 |
| `GetPassThruStreamSize` | `self` | argc=1 | 0 | 1 |
| `Init` | `self` | argc=1 | 12 | 3 |
| `LoadNodeData` | `self,pNodeData` | argc=1 | 0 | 5 |
| `SetPassThruStream` | `self,pStream,pSize` | argc=1 | 0 | 1 |
| `StoreNodeData` | `self,pBuffer` | argc=1 | 0 | 5 |

Usage: `$obj <method> <args...>`  |  `DboExtBlobNodePassThru_<method> $obj <args...>`
