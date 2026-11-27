# DboBitMap (20 methods)

| method | params | note |
| --- | --- | --- |
| `GetBitmapDimension` | `self,status` | argc=1 |
| `GetBoundingBox` | `self` | argc=1 |
| `GetDib` | `self,status` | argc=1 |
| `GetDibSize` | `self,status` | argc=1 |
| `GetLocation` | `self,status` | argc=1 |
| `GetObjectType` | `self` | argc=1 |
| `sDeleteCBitmapDIB` | `apByte` | argc=1 |
| `SetBitmapDimension` | `self,nWidth,nHeight` | argc=1 |
| `SetBoundingBox` | `self,box` | argc=1 |
| `SetLocation` | `self,point` | argc=1 |
| `sGetBase64ImageData` | `pDboBitmap,pOutEncodedString,rStatus` | argc=1 |
| `sGetBoundingBoxBottom` | `obj,status` | argc=1 |
| `sGetBoundingBoxLeft` | `obj,status` | argc=1 |
| `sGetBoundingBoxRight` | `obj,status` | argc=1 |
| `sGetBoundingBoxTop` | `obj,status` | argc=1 |
| `sGetCBitmapDIB` | `aBmpFileName,apBitMapDimension,apDIBSize` | argc=1 |
| `sGetDibFromBase64ImageData` | `pEncodedString,pDib,pDibSize,bmDimension,rStatus` | argc=1 |
| `sGetImageFromDboBitMap` | `pDboBitmap,pFilePath,rStatus` | argc=1 |
| `sGetLocationX` | `obj,status` | argc=1 |
| `sGetLocationY` | `obj,status` | argc=1 |

Usage (object form): `$obj <method> <args...>`  /  global form: `DboBitMap_<method> $obj <args...>`
