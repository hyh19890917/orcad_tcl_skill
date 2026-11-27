# DboPackage (34 methods, official_calls(upper bound)=221)

| method | params | note | official | shared |
| --- | --- | --- | --- | --- |
| `AddAlias` | `self,alias` | argc=1 | 0 | 1 |
| `AddPartInst` | `self,pPartInst` | argc=1 | 0 | 1 |
| `Cleanup` | `self` | argc=1 | 8 | 2 |
| `DeleteDevice` | `self,position` | argc=1 | 0 | 1 |
| `GetBundleTemplateMap` | `self` | argc=1 | 0 | 3 |
| `GetDesignator` | `self,designator` | argc=1 | 1 | 3 |
| `GetDevice` | `` | overloaded-C++ | 5 | 2 |
| `GetExternalModifiedFlag` | `self` | argc=1 | 0 | 1 |
| `GetObjectType` | `self` | argc=1 | 86 | 57 |
| `GetPCBFootprint` | `self,footprint` | argc=1 | 3 | 2 |
| `GetPCBLib` | `self,lib` | argc=1 | 0 | 2 |
| `GetReferenceTemplate` | `self,csRefTmpl` | argc=1 | 4 | 1 |
| `GetSemanticString` | `self,str` | argc=1 | 0 | 8 |
| `GetSize` | `self,status` | argc=1 | 2 | 6 |
| `isBundleTemplateExists` | `self` | argc=1 | 0 | 3 |
| `IsEquivalent` | `self,pObj` | argc=1 | 1 | 8 |
| `IsHomogeneous` | `self,status` | argc=1 | 0 | 1 |
| `NewAliasesIter` | `self,status` | argc=1 | 6 | 2 |
| `NewDevice` | `self,designator,position,cell,status` | argc=1 | 2 | 1 |
| `NewDevicesIter` | `self,status` | argc=1 | 5 | 1 |
| `NewPartsIter` | `self,status` | argc=1 | 11 | 4 |
| `RemovePartInst` | `self,pPartInst` | argc=1 | 0 | 1 |
| `ReplaceSchematicNameInReferencedPartInstList` | `self,pOldName,pNewName` | argc=1 | 0 | 1 |
| `SetDesignator` | `self,designator` | argc=1 | 0 | 3 |
| `SetEffectivePropStringValue` | `` | overloaded-C++ | 13 | 11 |
| `SetExternalModifiedFlag` | `self,aFlag` | argc=1 | 0 | 1 |
| `SetName` | `self,name` | argc=1 | 66 | 17 |
| `SetPCBFootprint` | `self,footprint` | argc=1 | 4 | 2 |
| `SetPCBLib` | `self,libName` | argc=1 | 2 | 2 |
| `SetReferenceTemplate` | `self,csRefTmpl` | argc=1 | 2 | 1 |
| `sGetPCBFootprint` | `obj,status` | argc=1 | 0 | 2 |
| `sGetPCBLib` | `obj,status` | argc=1 | 0 | 2 |
| `sGetReferenceTemplate` | `obj,status` | argc=1 | 0 | 1 |
| `sGetSize` | `obj,status` | argc=1 | 0 | 2 |

Usage: `$obj <method> <args...>`  |  `DboPackage_<method> $obj <args...>`
