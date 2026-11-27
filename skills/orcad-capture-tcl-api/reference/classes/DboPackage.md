# DboPackage (34 methods)

| method | params | note |
| --- | --- | --- |
| `AddAlias` | `self,alias` | argc=1 |
| `AddPartInst` | `self,pPartInst` | argc=1 |
| `Cleanup` | `self` | argc=1 |
| `DeleteDevice` | `self,position` | argc=1 |
| `GetBundleTemplateMap` | `self` | argc=1 |
| `GetDesignator` | `self,designator` | argc=1 |
| `GetDevice` | `` | overloaded-C++ |
| `GetExternalModifiedFlag` | `self` | argc=1 |
| `GetObjectType` | `self` | argc=1 |
| `GetPCBFootprint` | `self,footprint` | argc=1 |
| `GetPCBLib` | `self,lib` | argc=1 |
| `GetReferenceTemplate` | `self,csRefTmpl` | argc=1 |
| `GetSemanticString` | `self,str` | argc=1 |
| `GetSize` | `self,status` | argc=1 |
| `isBundleTemplateExists` | `self` | argc=1 |
| `IsEquivalent` | `self,pObj` | argc=1 |
| `IsHomogeneous` | `self,status` | argc=1 |
| `NewAliasesIter` | `self,status` | argc=1 |
| `NewDevice` | `self,designator,position,cell,status` | argc=1 |
| `NewDevicesIter` | `self,status` | argc=1 |
| `NewPartsIter` | `self,status` | argc=1 |
| `RemovePartInst` | `self,pPartInst` | argc=1 |
| `ReplaceSchematicNameInReferencedPartInstList` | `self,pOldName,pNewName` | argc=1 |
| `SetDesignator` | `self,designator` | argc=1 |
| `SetEffectivePropStringValue` | `` | overloaded-C++ |
| `SetExternalModifiedFlag` | `self,aFlag` | argc=1 |
| `SetName` | `self,name` | argc=1 |
| `SetPCBFootprint` | `self,footprint` | argc=1 |
| `SetPCBLib` | `self,libName` | argc=1 |
| `SetReferenceTemplate` | `self,csRefTmpl` | argc=1 |
| `sGetPCBFootprint` | `obj,status` | argc=1 |
| `sGetPCBLib` | `obj,status` | argc=1 |
| `sGetReferenceTemplate` | `obj,status` | argc=1 |
| `sGetSize` | `obj,status` | argc=1 |

Usage (object form): `$obj <method> <args...>`  /  global form: `DboPackage_<method> $obj <args...>`
