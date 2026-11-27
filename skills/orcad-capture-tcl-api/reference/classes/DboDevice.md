# DboDevice (30 methods, official_calls(upper bound)=205)

| method | params | note | official | shared |
| --- | --- | --- | --- | --- |
| `Cleanup` | `self` | argc=1 | 8 | 2 |
| `DeletePinNumber` | `self,position` | argc=1 | 0 | 1 |
| `DeletePinNumberAtPosition` | `self,position` | argc=1 | 0 | 1 |
| `GeneratePinNumber` | `self,position,UniqueName` | argc=1 | 0 | 1 |
| `GetCell` | `self,status` | argc=1 | 5 | 2 |
| `GetCellName` | `self,name` | argc=1 | 0 | 2 |
| `GetContainingLib` | `self` | argc=1 | 2 | 20 |
| `GetDesignator` | `self,designator` | argc=1 | 1 | 3 |
| `GetIsShared` | `self,position,status` | argc=1 | 0 | 3 |
| `GetObjectType` | `self` | argc=1 | 86 | 57 |
| `GetOwner` | `self` | argc=1 | 69 | 19 |
| `GetParentObj` | `self` | argc=1 | 0 | 18 |
| `GetPinCount` | `self,status` | argc=1 | 3 | 3 |
| `GetPinNumber` | `self,position,PinNumber` | argc=1 | 8 | 4 |
| `GetPinPosition` | `self,pinNumber,status` | argc=1 | 4 | 5 |
| `GetPinSwapId` | `self,position,status` | argc=1 | 0 | 2 |
| `GetPosition` | `self,status` | argc=1 | 0 | 3 |
| `GetSemanticString` | `self,str` | argc=1 | 0 | 8 |
| `GetSize` | `self,status` | argc=1 | 2 | 6 |
| `IsEquivalent` | `self,pObj` | argc=1 | 1 | 8 |
| `MarkModified` | `self` | argc=1 | 13 | 13 |
| `NewPinNumber` | `` | overloaded-C++ | 2 | 1 |
| `NewPinNumbersIter` | `self` | argc=1 | 1 | 1 |
| `SetCell` | `self,cell` | argc=1 | 0 | 1 |
| `SetDesignator` | `self,name` | argc=1 | 0 | 3 |
| `SetIsShared` | `self,position,isShared` | argc=1 | 0 | 1 |
| `SetPinNumber` | `self,position,pinNumber` | argc=1 | 0 | 3 |
| `SetPinSwapId` | `self,position,nSwapId` | argc=1 | 0 | 1 |
| `sGetDesignator` | `obj,status` | argc=1 | 0 | 2 |
| `sGetSize` | `obj,status` | argc=1 | 0 | 2 |

Usage: `$obj <method> <args...>`  |  `DboDevice_<method> $obj <args...>`
