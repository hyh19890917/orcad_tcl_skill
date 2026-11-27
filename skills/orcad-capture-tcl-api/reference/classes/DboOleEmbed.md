# DboOleEmbed (16 methods, official_calls(upper bound)=192)

| method | params | note | official | shared |
| --- | --- | --- | --- | --- |
| `GetBitmapDimension` | `self,status` | argc=1 | 0 | 2 |
| `GetBoundingBox` | `self` | argc=1 | 79 | 16 |
| `GetByte` | `self,status` | argc=1 | 0 | 1 |
| `GetDibSize` | `self,status` | argc=1 | 0 | 2 |
| `GetLocation` | `self,status` | argc=1 | 14 | 7 |
| `GetObjectType` | `self` | argc=1 | 86 | 57 |
| `SetBitmapDimension` | `self,nWidth,nHeight` | argc=1 | 0 | 2 |
| `SetBoundingBox` | `self,box` | argc=1 | 4 | 16 |
| `SetByte` | `self,pByte` | argc=1 | 0 | 1 |
| `SetLocation` | `self,point` | argc=1 | 9 | 12 |
| `sGetBoundingBoxBottom` | `obj,status` | argc=1 | 0 | 8 |
| `sGetBoundingBoxLeft` | `obj,status` | argc=1 | 0 | 8 |
| `sGetBoundingBoxRight` | `obj,status` | argc=1 | 0 | 8 |
| `sGetBoundingBoxTop` | `obj,status` | argc=1 | 0 | 8 |
| `sGetLocationX` | `obj,status` | argc=1 | 0 | 8 |
| `sGetLocationY` | `obj,status` | argc=1 | 0 | 8 |

Usage: `$obj <method> <args...>`  |  `DboOleEmbed_<method> $obj <args...>`
