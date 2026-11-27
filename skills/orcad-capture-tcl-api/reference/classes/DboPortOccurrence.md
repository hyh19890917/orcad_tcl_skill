# DboPortOccurrence (33 methods)

| method | params | note |
| --- | --- | --- |
| `DeleteEffectiveProp` | `self,name` | argc=1 |
| `FindInstance` | `self,status` | argc=1 |
| `GetCanonicalName` | `self,bVHDL` | argc=1 |
| `GetCanonicalNameBasedOnPinPos` | `self,bVHDL` | argc=1 |
| `GetCanonicalNameWithChipsInfo` | `self,bVHDL` | argc=1 |
| `GetEffectivePropValueExists` | `self,name,bExists` | argc=1 |
| `GetEffectivePropValueType` | `self,name,nType,bEditable,bDeletable` | argc=1 |
| `GetFlatNet` | `self` | argc=1 |
| `GetId` | `self,status` | argc=1 |
| `GetInstance` | `self,status` | argc=1 |
| `GetName` | `self,name` | argc=1 |
| `GetObjectType` | `self` | argc=1 |
| `GetPathName` | `` | overloaded-C++ |
| `GetPathNameNumber` | `` | overloaded-C++ |
| `GetPinName` | `self,name` | argc=1 |
| `GetPinNumber` | `self,number` | argc=1 |
| `GetPort` | `self,status` | argc=1 |
| `GetPortInst` | `self,status` | argc=1 |
| `GetPortInstPinID` | `self` | argc=1 |
| `GetRefPathName` | `` | overloaded-C++ |
| `GetSchematic` | `self,status` | argc=1 |
| `GetSchematicPortName` | `self` | argc=1 |
| `IsOrphanPort` | `self` | argc=1 |
| `MorphPortOccurrence` | `` | overloaded-C++ |
| `NewEffectivePropsIter` | `` | overloaded-C++ |
| `ProcessFlatNetForPortOccurrence` | `self` | argc=1 |
| `SetEffectivePropStringValue` | `` | overloaded-C++ |
| `SetEffectivePropStringValueForIref` | `self,name,value` | argc=1 |
| `SetId` | `self,nId` | argc=1 |
| `SetPortInstPinID` | `self,nPinID` | argc=1 |
| `SetSchematicPortName` | `self,pSchematicPortName` | argc=1 |
| `sGetId` | `obj,status` | argc=1 |
| `sGetPathName` | `obj,status` | argc=1 |

Usage (object form): `$obj <method> <args...>`  /  global form: `DboPortOccurrence_<method> $obj <args...>`
