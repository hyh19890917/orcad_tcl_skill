# DboTclUtils (23 methods, official_calls(upper bound)=0)

| method | params | note | official | shared |
| --- | --- | --- | --- | --- |
| `ConvertDBObjectToSWIGId` | `pInterp,pBase,rID` | argc=1 | 0 | 1 |
| `CreateJSONForProperties` | `pProps,pDefProps,pObjType,pAppName` | argc=1 | 0 | 1 |
| `EvalTCLCommand` | `pCommand,commandResult` | argc=1 | 0 | 1 |
| `GetComponentsAndCountInJSON` | `` | overloaded-C++ | 0 | 1 |
| `GetDesignFlatNetNameInJSON` | `pDsn` | argc=1 | 0 | 1 |
| `GetDesignHierarchyInJSON` | `` | overloaded-C++ | 0 | 1 |
| `GetDesignHierarchyInJSONWithoutPages` | `` | overloaded-C++ | 0 | 1 |
| `GetOptionStringCmdVal` | `optionName,defaultValue` | argc=1 | 0 | 1 |
| `GetPropertyBlockHierachy` | `pDesign,pProperty` | argc=1 | 0 | 1 |
| `GetReferenceFromID` | `pDesign,pId` | argc=1 | 0 | 1 |
| `GetReferencePrefix` | `cstrRef` | argc=1 | 0 | 1 |
| `GetTclInterpreter` | `` | zero-arg-ok | 0 | 1 |
| `sApplyFeatureName` | `pDesign,pRefSet,pPropNameValJSON,pTransferToDesignMapJSON` | argc=1 | 0 | 1 |
| `sFindSimilarPartBasedOnProp` | `pDesign,pstrPartInfoJSON,pstrPropNameJSON,pPropToRead,prStrJSONProp` | argc=1 | 0 | 1 |
| `sGetActiveDesignComponents` | `pDesign,pDsnCompPartPropList,pPartsToIgnoreWithPropNameVal,pPropToIgnore,pStrJSONActDsnComp` | argc=1 | 0 | 1 |
| `sGetDesignPartGroupByMatchProp` | `pDesign,pPropToMatch,pPropToRead,pPartsToIgnoreWithPropNameVal,prStrJSON` | argc=1 | 0 | 1 |
| `sGetDesignPartGroupByOccJSON` | `pDesign,pPropToRead,pPartsToIgnoreWithPropNameVal,prStrJSON` | argc=1 | 0 | 1 |
| `sGetDesignPartPropertyJSON` | `pDesign,pPropToIgnoreSet,prStrJSONProp` | argc=1 | 0 | 1 |
| `sGetETOEURL` | `pPart,pPackageName,pPartID` | argc=1 | 0 | 1 |
| `sGetPartRefAllOccOfParts` | `pDesign,pOccId,pPropToRead,prStrJSONProp` | argc=1 | 0 | 1 |
| `sGetSelectedPartPropertyJSON` | `pDesign,pOccID,pPropToIgnoreSet,prStrJSONProp` | argc=1 | 0 | 1 |
| `sGetTIPartsData` | `pDesign,pTIVersion,pModelLibVersion,pOSVersion,pForumURL,pPartsURL` | argc=1 | 0 | 1 |
| `sSetInterpAndGetPkgVersion` | `pInterp` | argc=1 | 0 | 1 |

Usage: `$obj <method> <args...>`  |  `DboTclUtils_<method> $obj <args...>`
