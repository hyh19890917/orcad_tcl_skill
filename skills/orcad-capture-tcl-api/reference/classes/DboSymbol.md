# DboSymbol (22 methods, official_calls(upper bound)=70)

| method | params | note | official | shared |
| --- | --- | --- | --- | --- |
| `Clear` | `self` | argc=1 | 17 | 2 |
| `DeleteDisplayProp` | `self,pProp` | argc=1 | 4 | 3 |
| `DeleteSymbolPin` | `self,nPos` | argc=1 | 0 | 1 |
| `DeleteSymbolPinAtPosition` | `self,nPos` | argc=1 | 0 | 1 |
| `GetDisplayPropsPermitted` | `self,status` | argc=1 | 0 | 6 |
| `GetDispPropArray` | `self` | argc=1 | 0 | 5 |
| `GetPinCount` | `` | overloaded-C++ | 3 | 3 |
| `GetPinPosition` | `self,pPin,status` | argc=1 | 4 | 5 |
| `GetSemanticString` | `self,str` | argc=1 | 0 | 8 |
| `GetSize` | `self,status` | argc=1 | 2 | 6 |
| `GetSymbolPin` | `` | overloaded-C++ | 0 | 1 |
| `IsEquivalent` | `self,pObj` | argc=1 | 1 | 8 |
| `MarkModified` | `self` | argc=1 | 13 | 13 |
| `NewDisplayProp` | `` | overloaded-C++ | 12 | 7 |
| `NewDisplayPropsIter` | `self,status` | argc=1 | 3 | 6 |
| `NewGraphicBitMapInstFromDib` | `self,mStatus,pBase64BmpData,pBBox,pLocation` | argc=1 | 0 | 2 |
| `NewPinsIter` | `` | overloaded-C++ | 9 | 2 |
| `NewSymbolPinBus` | `` | overloaded-C++ | 0 | 3 |
| `NewSymbolPinScalar` | `` | overloaded-C++ | 2 | 3 |
| `PinsAllowed` | `self,status` | argc=1 | 0 | 2 |
| `RemoveSymbolPinFromPosition` | `self,nPos` | argc=1 | 0 | 1 |
| `RemoveSymbolPins` | `self` | argc=1 | 0 | 1 |

Usage: `$obj <method> <args...>`  |  `DboSymbol_<method> $obj <args...>`
