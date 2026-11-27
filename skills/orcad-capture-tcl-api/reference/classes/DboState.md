# DboState (29 methods)

| method | params | note |
| --- | --- | --- |
| `~delete` | `self` | argc=1 |
| `AssignVoltageOnDCNets` | `pDesign` | argc=1 |
| `ClearDesignUndoRedo` | `pDesignName` | argc=1 |
| `Code` | `self` | argc=1 |
| `CrossProbeNetCMToNet` | `pFlatnet,pSelect` | argc=1 |
| `DispPropBoundingBox` | `pDispProp,pViewOccurrence` | argc=1 |
| `Failed` | `self` | argc=1 |
| `GetBackAnnotationData` | `pDesignName,pNetlistDir,pBoardFile,pAllegroCfgFile,pOutputFile` | argc=1 |
| `GetExtendedText` | `self` | argc=1 |
| `GetLicenseString` | `` | zero-arg-ok |
| `GetOptionString` | `lOptionName,defaultValue` | argc=1 |
| `GetOrCADCMTierFlag` | `` | zero-arg-ok |
| `IsCMProp` | `pName,pPropType,pPropCategory` | argc=1 |
| `IsPspLicChekedout` | `` | zero-arg-ok |
| `m_SCode_get` | `self` | argc=1 |
| `m_SCode_set` | `self,m_SCode` | argc=1 |
| `Message` | `self,msg` | argc=1 |
| `OK` | `self` | argc=1 |
| `OpenPasswordDialog` | `pTitle,pDesignName,pSetPassword` | argc=1 |
| `RemoveFilesFromActivePM` | `pFolderName,pFileNameVec` | argc=1 |
| `RunBackAnnotation` | `pDesignName,pNetlistDir,pBoardFile,pAllegroCfgFile,pOutputFile,pRunGenfeed` | argc=1 |
| `RunFrontToBackTool` | `pDesignName,pNetlistDir,pBoardFile,pAllegroCfgFile,pOutputDir` | argc=1 |
| `SaveDesign` | `pDesign` | argc=1 |
| `Severity` | `self` | argc=1 |
| `sIsObjectBelongsToMasterSession` | `pObject` | argc=1 |
| `sIsTimeProfilingON` | `` | zero-arg-ok |
| `Succeeded` | `self` | argc=1 |
| `WriteToSessionLog` | `str` | argc=1 |
| `WriteToStatusBar` | `str` | argc=1 |

Usage (object form): `$obj <method> <args...>`  /  global form: `DboState_<method> $obj <args...>`
