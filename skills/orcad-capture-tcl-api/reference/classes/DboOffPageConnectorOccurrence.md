# DboOffPageConnectorOccurrence (22 methods, official_calls(upper bound)=400)

| method | params | note | official | shared |
| --- | --- | --- | --- | --- |
| `DeleteEffectiveProp` | `self,name` | argc=1 | 6 | 10 |
| `GetEffectivePropValueExists` | `self,name,bExists` | argc=1 | 0 | 7 |
| `GetEffectivePropValueType` | `self,name,nType,bEditable,bDeletable` | argc=1 | 0 | 9 |
| `GetId` | `self,status` | argc=1 | 37 | 15 |
| `GetInstance` | `self,status` | argc=1 | 0 | 6 |
| `GetName` | `self,name` | argc=1 | 185 | 18 |
| `GetObjectType` | `self` | argc=1 | 86 | 57 |
| `GetOffPageConnectorId` | `self,status` | argc=1 | 0 | 1 |
| `GetPathName` | `` | overloaded-C++ | 7 | 7 |
| `GetRefPathName` | `` | overloaded-C++ | 0 | 7 |
| `GetSchematic` | `self,status` | argc=1 | 4 | 7 |
| `GetSchematicPath` | `self,name` | argc=1 | 0 | 2 |
| `NewEffectivePropsIter` | `` | overloaded-C++ | 6 | 12 |
| `SetEffectivePropStringValue` | `` | overloaded-C++ | 13 | 11 |
| `SetEffectivePropStringValueForIref` | `self,name,value` | argc=1 | 0 | 2 |
| `SetId` | `self,nId` | argc=1 | 55 | 10 |
| `SetOccName` | `self,name` | argc=1 | 0 | 1 |
| `SetOffPageConnectorId` | `self,nOffPageId` | argc=1 | 0 | 1 |
| `sGetId` | `obj,status` | argc=1 | 0 | 8 |
| `sGetName` | `obj,status` | argc=1 | 1 | 15 |
| `sGetPathName` | `obj,status` | argc=1 | 0 | 5 |
| `sGetSchematicPath` | `obj,status` | argc=1 | 0 | 2 |

Usage: `$obj <method> <args...>`  |  `DboOffPageConnectorOccurrence_<method> $obj <args...>`
