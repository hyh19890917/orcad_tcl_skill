# DboExtBlobNodeImage (11 methods, official_calls(upper bound)=12)

| method | params | note | official | shared |
| --- | --- | --- | --- | --- |
| `~delete` | `self` | argc=1 | 0 | 151 |
| `GetImageStream` | `self` | argc=1 | 0 | 1 |
| `GetImageStreamSize` | `self` | argc=1 | 0 | 1 |
| `GetImageType` | `self` | argc=1 | 0 | 1 |
| `Init` | `self` | argc=1 | 12 | 3 |
| `LoadNodeData` | `self,pNodeData` | argc=1 | 0 | 5 |
| `SetImageStream` | `self,pStream,pSize` | argc=1 | 0 | 1 |
| `SetImageType` | `self,pType` | argc=1 | 0 | 1 |
| `sImageTypeToName` | `pType` | argc=1 | 0 | 1 |
| `sNameToImageType` | `pTypeExt` | argc=1 | 0 | 1 |
| `StoreNodeData` | `self,pBuffer` | argc=1 | 0 | 5 |

Usage: `$obj <method> <args...>`  |  `DboExtBlobNodeImage_<method> $obj <args...>`
