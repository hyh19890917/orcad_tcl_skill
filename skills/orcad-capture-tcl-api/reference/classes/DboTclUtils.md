# DboTclUtils (23 methods)

| method | params | note |
| --- | --- | --- |
| `ConvertDBObjectToSWIGId` | `pInterp,pBase,rID` | argc=1 |
| `CreateJSONForProperties` | `pProps,pDefProps,pObjType,pAppName` | argc=1 |
| `EvalTCLCommand` | `pCommand,commandResult` | argc=1 |
| `GetComponentsAndCountInJSON` | `` | overloaded-C++ |
| `GetDesignFlatNetNameInJSON` | `pDsn` | argc=1 |
| `GetDesignHierarchyInJSON` | `` | overloaded-C++ |
| `GetDesignHierarchyInJSONWithoutPages` | `` | overloaded-C++ |
| `GetOptionStringCmdVal` | `optionName,defaultValue` | argc=1 |
| `GetPropertyBlockHierachy` | `pDesign,pProperty` | argc=1 |
| `GetReferenceFromID` | `pDesign,pId` | argc=1 |
| `GetReferencePrefix` | `cstrRef` | argc=1 |
| `GetTclInterpreter` | `` | zero-arg-ok |
| `sApplyFeatureName` | `pDesign,pRefSet,pPropNameValJSON,pTransferToDesignMapJSON` | argc=1 |
| `sFindSimilarPartBasedOnProp` | `pDesign,pstrPartInfoJSON,pstrPropNameJSON,pPropToRead,prStrJSONProp` | argc=1 |
| `sGetActiveDesignComponents` | `pDesign,pDsnCompPartPropList,pPartsToIgnoreWithPropNameVal,pPropToIgnore,pStrJSONActDsnComp` | argc=1 |
| `sGetDesignPartGroupByMatchProp` | `pDesign,pPropToMatch,pPropToRead,pPartsToIgnoreWithPropNameVal,prStrJSON` | argc=1 |
| `sGetDesignPartGroupByOccJSON` | `pDesign,pPropToRead,pPartsToIgnoreWithPropNameVal,prStrJSON` | argc=1 |
| `sGetDesignPartPropertyJSON` | `pDesign,pPropToIgnoreSet,prStrJSONProp` | argc=1 |
| `sGetETOEURL` | `pPart,pPackageName,pPartID` | argc=1 |
| `sGetPartRefAllOccOfParts` | `pDesign,pOccId,pPropToRead,prStrJSONProp` | argc=1 |
| `sGetSelectedPartPropertyJSON` | `pDesign,pOccID,pPropToIgnoreSet,prStrJSONProp` | argc=1 |
| `sGetTIPartsData` | `pDesign,pTIVersion,pModelLibVersion,pOSVersion,pForumURL,pPartsURL` | argc=1 |
| `sSetInterpAndGetPkgVersion` | `pInterp` | argc=1 |

Usage (object form): `$obj <method> <args...>`  /  global form: `DboTclUtils_<method> $obj <args...>`
