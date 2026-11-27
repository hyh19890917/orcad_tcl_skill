# DboCell (9 methods, official_calls(upper bound)=103)

| method | params | note | official | shared |
| --- | --- | --- | --- | --- |
| `AddPart` | `self,part` | argc=1 | 2 | 1 |
| `FindPart` | `self,index,status` | argc=1 | 0 | 1 |
| `GetObjectType` | `self` | argc=1 | 86 | 57 |
| `GetPart` | `self,name,status` | argc=1 | 1 | 3 |
| `GetSemanticString` | `self,str` | argc=1 | 0 | 8 |
| `GetSize` | `self,status` | argc=1 | 2 | 6 |
| `IsEquivalent` | `self,pObj` | argc=1 | 1 | 8 |
| `NewPartNamesIter` | `self,status` | argc=1 | 0 | 2 |
| `NewPartsIter` | `self,status` | argc=1 | 11 | 4 |

Usage: `$obj <method> <args...>`  |  `DboCell_<method> $obj <args...>`
