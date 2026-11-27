# DboFlatNet (31 methods, official_calls(upper bound)=532)

| method | params | note | official | shared |
| --- | --- | --- | --- | --- |
| `ComputeName` | `` | overloaded-C++ | 0 | 1 |
| `DeleteEffectiveProp` | `self,name` | argc=1 | 6 | 10 |
| `GetAttributeLockingInfo` | `self,propName,lLock,preTrigger,postTrigger` | argc=1 | 0 | 5 |
| `GetColor` | `self,status` | argc=1 | 0 | 12 |
| `GetContainingLib` | `self` | argc=1 | 2 | 20 |
| `GetEffectivePropStringValue` | `` | overloaded-C++ | 109 | 8 |
| `GetFlatNetCanonicalName` | `` | overloaded-C++ | 0 | 1 |
| `GetId` | `self,status` | argc=1 | 37 | 15 |
| `GetIsGlobal` | `self,status` | argc=1 | 2 | 4 |
| `GetIsPower` | `self,aStatus` | argc=1 | 0 | 1 |
| `GetLineStyle` | `self,status` | argc=1 | 1 | 11 |
| `GetLineWidth` | `self,status` | argc=1 | 1 | 11 |
| `GetName` | `self,Name` | argc=1 | 185 | 18 |
| `GetNameStrategy` | `self` | argc=1 | 0 | 1 |
| `GetObjectOccurrences` | `` | overloaded-C++ | 0 | 8 |
| `GetObjectType` | `self` | argc=1 | 86 | 57 |
| `GetOwner` | `self` | argc=1 | 69 | 19 |
| `GetParentObj` | `self` | argc=1 | 0 | 18 |
| `GetTopNet` | `self,status` | argc=1 | 1 | 1 |
| `NewEffectivePropsIter` | `` | overloaded-C++ | 6 | 12 |
| `NewNetOccurrencesIter` | `self` | argc=1 | 0 | 1 |
| `NewNetsIter` | `` | overloaded-C++ | 2 | 3 |
| `NewPortOccurrencesIter` | `` | overloaded-C++ | 1 | 1 |
| `NewWiresIter` | `` | overloaded-C++ | 10 | 4 |
| `SetEffectivePropStringValue` | `` | overloaded-C++ | 13 | 11 |
| `sGetColor` | `obj,status` | argc=1 | 0 | 8 |
| `sGetId` | `obj,status` | argc=1 | 0 | 8 |
| `sGetIsGlobal` | `obj,status` | argc=1 | 0 | 4 |
| `sGetLineStyle` | `obj,status` | argc=1 | 0 | 15 |
| `sGetLineWidth` | `obj,status` | argc=1 | 0 | 15 |
| `sGetName` | `obj,status` | argc=1 | 1 | 15 |

Usage: `$obj <method> <args...>`  |  `DboFlatNet_<method> $obj <args...>`
