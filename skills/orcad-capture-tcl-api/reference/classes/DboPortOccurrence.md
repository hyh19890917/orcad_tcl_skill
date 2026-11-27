# DboPortOccurrence (33 methods, official_calls(upper bound)=424)

| method | params | note | official | shared |
| --- | --- | --- | --- | --- |
| `DeleteEffectiveProp` | `self,name` | argc=1 | 6 | 10 |
| `FindInstance` | `self,status` | argc=1 | 0 | 3 |
| `GetCanonicalName` | `self,bVHDL` | argc=1 | 0 | 4 |
| `GetCanonicalNameBasedOnPinPos` | `self,bVHDL` | argc=1 | 0 | 1 |
| `GetCanonicalNameWithChipsInfo` | `self,bVHDL` | argc=1 | 0 | 1 |
| `GetEffectivePropValueExists` | `self,name,bExists` | argc=1 | 0 | 7 |
| `GetEffectivePropValueType` | `self,name,nType,bEditable,bDeletable` | argc=1 | 0 | 9 |
| `GetFlatNet` | `self` | argc=1 | 4 | 3 |
| `GetId` | `self,status` | argc=1 | 37 | 15 |
| `GetInstance` | `self,status` | argc=1 | 0 | 6 |
| `GetName` | `self,name` | argc=1 | 185 | 18 |
| `GetObjectType` | `self` | argc=1 | 86 | 57 |
| `GetPathName` | `` | overloaded-C++ | 7 | 7 |
| `GetPathNameNumber` | `` | overloaded-C++ | 0 | 2 |
| `GetPinName` | `self,name` | argc=1 | 10 | 4 |
| `GetPinNumber` | `self,number` | argc=1 | 8 | 4 |
| `GetPort` | `self,status` | argc=1 | 0 | 4 |
| `GetPortInst` | `self,status` | argc=1 | 3 | 3 |
| `GetPortInstPinID` | `self` | argc=1 | 0 | 1 |
| `GetRefPathName` | `` | overloaded-C++ | 0 | 7 |
| `GetSchematic` | `self,status` | argc=1 | 4 | 7 |
| `GetSchematicPortName` | `self` | argc=1 | 0 | 1 |
| `IsOrphanPort` | `self` | argc=1 | 0 | 1 |
| `MorphPortOccurrence` | `` | overloaded-C++ | 0 | 1 |
| `NewEffectivePropsIter` | `` | overloaded-C++ | 6 | 12 |
| `ProcessFlatNetForPortOccurrence` | `self` | argc=1 | 0 | 1 |
| `SetEffectivePropStringValue` | `` | overloaded-C++ | 13 | 11 |
| `SetEffectivePropStringValueForIref` | `self,name,value` | argc=1 | 0 | 2 |
| `SetId` | `self,nId` | argc=1 | 55 | 10 |
| `SetPortInstPinID` | `self,nPinID` | argc=1 | 0 | 1 |
| `SetSchematicPortName` | `self,pSchematicPortName` | argc=1 | 0 | 1 |
| `sGetId` | `obj,status` | argc=1 | 0 | 8 |
| `sGetPathName` | `obj,status` | argc=1 | 0 | 5 |

Usage: `$obj <method> <args...>`  |  `DboPortOccurrence_<method> $obj <args...>`
