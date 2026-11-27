# DboGraphicObject (24 methods)

| method | params | note |
| --- | --- | --- |
| `Clear` | `self` | argc=1 |
| `DeleteVector` | `self,pVector` | argc=1 |
| `GetBoundingBox` | `self` | argc=1 |
| `GetColor` | `self,status` | argc=1 |
| `GetGraphicsArray` | `self` | argc=1 |
| `NewArc` | `` | overloaded-C++ |
| `NewBezier` | `` | overloaded-C++ |
| `NewBitMap` | `self,status,BoundingBox,location,bmDimension,dwSize,lpDib` | argc=1 |
| `NewBox` | `` | overloaded-C++ |
| `NewCommentText` | `self,status,text,rectBound,location,font` | argc=1 |
| `NewEllipse` | `` | overloaded-C++ |
| `NewFill` | `` | overloaded-C++ |
| `NewLine` | `` | overloaded-C++ |
| `NewOleEmbed` | `self,status,BoundingBox,location,bmDimension,dwSize,lpByte` | argc=1 |
| `NewPolygon` | `` | overloaded-C++ |
| `NewPolyline` | `` | overloaded-C++ |
| `NewSymbolVector` | `self,status,location` | argc=1 |
| `NewVectorsIter` | `self,status,mode` | argc=1 |
| `PinsAllowed` | `self,status` | argc=1 |
| `SetBoundingBox` | `self,box` | argc=1 |
| `SetColor` | `self,color` | argc=1 |
| `sGetColor` | `obj,status` | argc=1 |
| `sGetName` | `obj,status` | argc=1 |
| `sSetColor` | `obj,color` | argc=1 |

Usage (object form): `$obj <method> <args...>`  /  global form: `DboGraphicObject_<method> $obj <args...>`
