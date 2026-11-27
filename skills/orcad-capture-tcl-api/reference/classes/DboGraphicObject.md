# DboGraphicObject (24 methods, official_calls(upper bound)=116)

| method | params | note | official | shared |
| --- | --- | --- | --- | --- |
| `Clear` | `self` | argc=1 | 17 | 2 |
| `DeleteVector` | `self,pVector` | argc=1 | 0 | 1 |
| `GetBoundingBox` | `self` | argc=1 | 79 | 16 |
| `GetColor` | `self,status` | argc=1 | 0 | 12 |
| `GetGraphicsArray` | `self` | argc=1 | 0 | 1 |
| `NewArc` | `` | overloaded-C++ | 2 | 2 |
| `NewBezier` | `` | overloaded-C++ | 0 | 1 |
| `NewBitMap` | `self,status,BoundingBox,location,bmDimension,dwSize,lpDib` | argc=1 | 0 | 1 |
| `NewBox` | `` | overloaded-C++ | 0 | 2 |
| `NewCommentText` | `self,status,text,rectBound,location,font` | argc=1 | 0 | 2 |
| `NewEllipse` | `` | overloaded-C++ | 0 | 2 |
| `NewFill` | `` | overloaded-C++ | 0 | 1 |
| `NewLine` | `` | overloaded-C++ | 2 | 2 |
| `NewOleEmbed` | `self,status,BoundingBox,location,bmDimension,dwSize,lpByte` | argc=1 | 0 | 1 |
| `NewPolygon` | `` | overloaded-C++ | 0 | 2 |
| `NewPolyline` | `` | overloaded-C++ | 0 | 2 |
| `NewSymbolVector` | `self,status,location` | argc=1 | 0 | 1 |
| `NewVectorsIter` | `self,status,mode` | argc=1 | 1 | 2 |
| `PinsAllowed` | `self,status` | argc=1 | 0 | 2 |
| `SetBoundingBox` | `self,box` | argc=1 | 4 | 16 |
| `SetColor` | `self,color` | argc=1 | 10 | 11 |
| `sGetColor` | `obj,status` | argc=1 | 0 | 8 |
| `sGetName` | `obj,status` | argc=1 | 1 | 15 |
| `sSetColor` | `obj,color` | argc=1 | 0 | 3 |

Usage: `$obj <method> <args...>`  |  `DboGraphicObject_<method> $obj <args...>`
