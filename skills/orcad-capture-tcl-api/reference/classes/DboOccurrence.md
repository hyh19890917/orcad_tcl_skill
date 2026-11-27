# DboOccurrence (30 methods, official_calls(upper bound)=323)

| method | params | note | official | shared |
| --- | --- | --- | --- | --- |
| `CopyOccData` | `` | overloaded-C++ | 0 | 2 |
| `DeleteUserProp` | `self,name` | argc=1 | 0 | 7 |
| `DeleteUserPropValue` | `self,name` | argc=1 | 0 | 5 |
| `GetBackannotatedStringValue` | `self,name,value` | argc=1 | 0 | 1 |
| `GetBackannotation` | `self,name,status` | argc=1 | 0 | 1 |
| `GetCanonicalName` | `self,bVHDL` | argc=1 | 0 | 4 |
| `GetContainingLib` | `self` | argc=1 | 2 | 20 |
| `GetDepth` | `self,status` | argc=1 | 0 | 1 |
| `GetDesignTransactionCount` | `self` | argc=1 | 0 | 1 |
| `GetEffectivePropStringValue` | `` | overloaded-C++ | 109 | 8 |
| `GetEffectivePropStringValueNC` | `self,name,value` | argc=1 | 0 | 3 |
| `GetEffectivePropValueType` | `self,name,nType,bEditable,bDeletable` | argc=1 | 0 | 9 |
| `GetId` | `self,status` | argc=1 | 37 | 15 |
| `GetIdPathName` | `` | overloaded-C++ | 0 | 1 |
| `GetInstance` | `self,status` | argc=1 | 0 | 6 |
| `GetObjectType` | `self` | argc=1 | 86 | 57 |
| `GetOccProp` | `self,name,status` | argc=1 | 0 | 1 |
| `GetOwner` | `self` | argc=1 | 69 | 19 |
| `GetParent` | `self` | argc=1 | 5 | 2 |
| `GetParentObj` | `self` | argc=1 | 0 | 18 |
| `GetPathName` | `` | overloaded-C++ | 7 | 7 |
| `GetRefPathName` | `` | overloaded-C++ | 0 | 7 |
| `GetSchematic` | `self,status` | argc=1 | 4 | 7 |
| `HasPropertyThatExists` | `self,status` | argc=1 | 0 | 3 |
| `IsRootOccurrence` | `self,status` | argc=1 | 0 | 1 |
| `MakeVHDL` | `self,conName` | argc=1 | 0 | 1 |
| `NewOccurrenceEdit` | `self` | argc=1 | 0 | 1 |
| `NewUserProp` | `` | overloaded-C++ | 4 | 8 |
| `SetDesignTransactionCount` | `self,nCount` | argc=1 | 0 | 1 |
| `SetUserPropStringValue` | `self,name,value` | argc=1 | 0 | 6 |

Usage: `$obj <method> <args...>`  |  `DboOccurrence_<method> $obj <args...>`
