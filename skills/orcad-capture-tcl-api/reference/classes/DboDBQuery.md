# DboDBQuery (20 methods, official_calls(upper bound)=0)

| method | params | note | official | shared |
| --- | --- | --- | --- | --- |
| `GetPortOccFromCanonicalName` | `` | overloaded-C++ | 0 | 1 |
| `sClearPathHistory` | `pPath` | argc=1 | 0 | 2 |
| `sCreateCanonicalNameForCMObjects` | `` | overloaded-C++ | 0 | 1 |
| `sFindFlatNetFromCanonicalName` | `` | overloaded-C++ | 0 | 1 |
| `sGetAllFlatNetsOfDesign` | `` | overloaded-C++ | 0 | 1 |
| `sGetAllPartsOfDesign` | `` | overloaded-C++ | 0 | 1 |
| `sGetAllPinsOfDesign` | `` | overloaded-C++ | 0 | 1 |
| `sGetAllPinsOfFlatNet` | `` | overloaded-C++ | 0 | 1 |
| `sGetAllPinsOfPart` | `` | overloaded-C++ | 0 | 1 |
| `sGetAlternateNetName` | `pFlatnet` | argc=1 | 0 | 1 |
| `sGetAlternatePartName` | `pPartOcc` | argc=1 | 0 | 1 |
| `sGetAlternatePinName` | `pPartOcc,pPortOcc` | argc=1 | 0 | 1 |
| `sGetCurrentTime` | `` | zero-arg-ok | 0 | 1 |
| `sGetDesign` | `pDesignName` | argc=1 | 0 | 1 |
| `sGetFlatNetFromPortOcc` | `DboPortOccurrence,*` | argc=1 | 0 | 1 |
| `sGetFlatNetJSON` | `aFlatNetCName,aFlatNetPhysicalName` | argc=1 | 0 | 1 |
| `sGetLibraryFileMetadata` | `apSession,apLibPathArr,aJSON` | argc=1 | 0 | 1 |
| `sGetObjectsFromJSON` | `pObjectsJSON,pTitle,pObjects` | argc=1 | 0 | 1 |
| `sGetPinNumber` | `aPortOcc,aPinNumber` | argc=1 | 0 | 3 |
| `sGetPinPhysicalNameToPortOccMap` | `` | overloaded-C++ | 0 | 1 |

Usage: `$obj <method> <args...>`  |  `DboDBQuery_<method> $obj <args...>`
