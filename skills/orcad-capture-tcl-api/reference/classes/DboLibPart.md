# DboLibPart (38 methods, official_calls(upper bound)=64)

| method | params | note | official | shared |
| --- | --- | --- | --- | --- |
| `GetCellPtr` | `self` | argc=1 | 0 | 1 |
| `GetContents` | `self,status` | argc=1 | 1 | 3 |
| `GetContentsLibName` | `self,name` | argc=1 | 0 | 2 |
| `GetContentsViewName` | `self,name` | argc=1 | 1 | 2 |
| `GetContentsViewType` | `self,status` | argc=1 | 2 | 2 |
| `GetPackagePtr` | `self` | argc=1 | 1 | 1 |
| `GetPartValue` | `self,value` | argc=1 | 0 | 4 |
| `GetPin` | `` | overloaded-C++ | 0 | 3 |
| `GetPinNamesAreRotated` | `self,status` | argc=1 | 0 | 2 |
| `GetPinNamesAreVisible` | `self,status` | argc=1 | 2 | 2 |
| `GetPinNumbersAreVisible` | `self,status` | argc=1 | 2 | 2 |
| `GetReference` | `self,name` | argc=1 | 5 | 5 |
| `GetReferenceDesignator` | `self,refDes` | argc=1 | 6 | 4 |
| `GetSemanticString` | `self,str` | argc=1 | 0 | 8 |
| `GetSuffix` | `self` | argc=1 | 0 | 1 |
| `IsEquivalent` | `self,pObj` | argc=1 | 1 | 8 |
| `MarkModified` | `self` | argc=1 | 13 | 13 |
| `NewLPinsIter` | `` | overloaded-C++ | 4 | 1 |
| `SetCellPtr` | `self,pCell` | argc=1 | 2 | 1 |
| `SetContentsLibName` | `self,libName` | argc=1 | 3 | 2 |
| `SetContentsViewName` | `self,viewName` | argc=1 | 3 | 2 |
| `SetContentsViewType` | `self,viewType` | argc=1 | 3 | 2 |
| `SetPackagePtr` | `self,pPkg` | argc=1 | 2 | 1 |
| `SetPartValue` | `self,name` | argc=1 | 2 | 3 |
| `SetPinNamesAreRotated` | `self,bVal` | argc=1 | 2 | 1 |
| `SetPinNamesAreVisible` | `self,bVal` | argc=1 | 2 | 1 |
| `SetPinNumbersAreVisible` | `self,bVal` | argc=1 | 2 | 1 |
| `SetReference` | `self,name` | argc=1 | 5 | 4 |
| `sGetContentsLibName` | `obj,status` | argc=1 | 0 | 3 |
| `sGetContentsViewName` | `obj,status` | argc=1 | 0 | 3 |
| `sGetContentsViewType` | `obj,status` | argc=1 | 0 | 3 |
| `sGetPartValue` | `obj,status` | argc=1 | 0 | 3 |
| `sGetPinCount` | `obj,status` | argc=1 | 0 | 2 |
| `sGetPinNamesAreRotated` | `obj,status` | argc=1 | 0 | 1 |
| `sGetPinNamesAreVisible` | `obj,status` | argc=1 | 0 | 1 |
| `sGetPinNumbersAreVisible` | `obj,status` | argc=1 | 0 | 1 |
| `sGetReference` | `obj,status` | argc=1 | 0 | 3 |
| `sGetReferenceDesignator` | `obj,status` | argc=1 | 0 | 3 |

Usage: `$obj <method> <args...>`  |  `DboLibPart_<method> $obj <args...>`
