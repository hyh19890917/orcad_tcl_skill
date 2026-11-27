# DboDBQuery (20 methods)

| method | params | note |
| --- | --- | --- |
| `GetPortOccFromCanonicalName` | `` | overloaded-C++ |
| `sClearPathHistory` | `pPath` | argc=1 |
| `sCreateCanonicalNameForCMObjects` | `` | overloaded-C++ |
| `sFindFlatNetFromCanonicalName` | `` | overloaded-C++ |
| `sGetAllFlatNetsOfDesign` | `` | overloaded-C++ |
| `sGetAllPartsOfDesign` | `` | overloaded-C++ |
| `sGetAllPinsOfDesign` | `` | overloaded-C++ |
| `sGetAllPinsOfFlatNet` | `` | overloaded-C++ |
| `sGetAllPinsOfPart` | `` | overloaded-C++ |
| `sGetAlternateNetName` | `pFlatnet` | argc=1 |
| `sGetAlternatePartName` | `pPartOcc` | argc=1 |
| `sGetAlternatePinName` | `pPartOcc,pPortOcc` | argc=1 |
| `sGetCurrentTime` | `` | zero-arg-ok |
| `sGetDesign` | `pDesignName` | argc=1 |
| `sGetFlatNetFromPortOcc` | `DboPortOccurrence,*` | argc=1 |
| `sGetFlatNetJSON` | `aFlatNetCName,aFlatNetPhysicalName` | argc=1 |
| `sGetLibraryFileMetadata` | `apSession,apLibPathArr,aJSON` | argc=1 |
| `sGetObjectsFromJSON` | `pObjectsJSON,pTitle,pObjects` | argc=1 |
| `sGetPinNumber` | `aPortOcc,aPinNumber` | argc=1 |
| `sGetPinPhysicalNameToPortOccMap` | `` | overloaded-C++ |

Usage (object form): `$obj <method> <args...>`  /  global form: `DboDBQuery_<method> $obj <args...>`
