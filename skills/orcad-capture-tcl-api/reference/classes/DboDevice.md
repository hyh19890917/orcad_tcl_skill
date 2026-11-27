# DboDevice (30 methods)

| method | params | note |
| --- | --- | --- |
| `Cleanup` | `self` | argc=1 |
| `DeletePinNumber` | `self,position` | argc=1 |
| `DeletePinNumberAtPosition` | `self,position` | argc=1 |
| `GeneratePinNumber` | `self,position,UniqueName` | argc=1 |
| `GetCell` | `self,status` | argc=1 |
| `GetCellName` | `self,name` | argc=1 |
| `GetContainingLib` | `self` | argc=1 |
| `GetDesignator` | `self,designator` | argc=1 |
| `GetIsShared` | `self,position,status` | argc=1 |
| `GetObjectType` | `self` | argc=1 |
| `GetOwner` | `self` | argc=1 |
| `GetParentObj` | `self` | argc=1 |
| `GetPinCount` | `self,status` | argc=1 |
| `GetPinNumber` | `self,position,PinNumber` | argc=1 |
| `GetPinPosition` | `self,pinNumber,status` | argc=1 |
| `GetPinSwapId` | `self,position,status` | argc=1 |
| `GetPosition` | `self,status` | argc=1 |
| `GetSemanticString` | `self,str` | argc=1 |
| `GetSize` | `self,status` | argc=1 |
| `IsEquivalent` | `self,pObj` | argc=1 |
| `MarkModified` | `self` | argc=1 |
| `NewPinNumber` | `` | overloaded-C++ |
| `NewPinNumbersIter` | `self` | argc=1 |
| `SetCell` | `self,cell` | argc=1 |
| `SetDesignator` | `self,name` | argc=1 |
| `SetIsShared` | `self,position,isShared` | argc=1 |
| `SetPinNumber` | `self,position,pinNumber` | argc=1 |
| `SetPinSwapId` | `self,position,nSwapId` | argc=1 |
| `sGetDesignator` | `obj,status` | argc=1 |
| `sGetSize` | `obj,status` | argc=1 |

Usage (object form): `$obj <method> <args...>`  /  global form: `DboDevice_<method> $obj <args...>`
