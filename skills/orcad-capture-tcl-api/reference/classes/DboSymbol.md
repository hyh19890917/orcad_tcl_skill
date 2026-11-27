# DboSymbol (22 methods)

| method | params | note |
| --- | --- | --- |
| `Clear` | `self` | argc=1 |
| `DeleteDisplayProp` | `self,pProp` | argc=1 |
| `DeleteSymbolPin` | `self,nPos` | argc=1 |
| `DeleteSymbolPinAtPosition` | `self,nPos` | argc=1 |
| `GetDisplayPropsPermitted` | `self,status` | argc=1 |
| `GetDispPropArray` | `self` | argc=1 |
| `GetPinCount` | `` | overloaded-C++ |
| `GetPinPosition` | `self,pPin,status` | argc=1 |
| `GetSemanticString` | `self,str` | argc=1 |
| `GetSize` | `self,status` | argc=1 |
| `GetSymbolPin` | `` | overloaded-C++ |
| `IsEquivalent` | `self,pObj` | argc=1 |
| `MarkModified` | `self` | argc=1 |
| `NewDisplayProp` | `` | overloaded-C++ |
| `NewDisplayPropsIter` | `self,status` | argc=1 |
| `NewGraphicBitMapInstFromDib` | `self,mStatus,pBase64BmpData,pBBox,pLocation` | argc=1 |
| `NewPinsIter` | `` | overloaded-C++ |
| `NewSymbolPinBus` | `` | overloaded-C++ |
| `NewSymbolPinScalar` | `` | overloaded-C++ |
| `PinsAllowed` | `self,status` | argc=1 |
| `RemoveSymbolPinFromPosition` | `self,nPos` | argc=1 |
| `RemoveSymbolPins` | `self` | argc=1 |

Usage (object form): `$obj <method> <args...>`  /  global form: `DboSymbol_<method> $obj <args...>`
