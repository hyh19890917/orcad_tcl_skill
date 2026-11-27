# DboConnectivityChangeIter (5 methods, official_calls(upper bound)=0)

| method | params | note | official | shared |
| --- | --- | --- | --- | --- |
| `~delete` | `self` | argc=1 | 0 | 151 |
| `NextAddorModifiedDbObject` | `self,pUniqueKey,pObject` | argc=1 | 0 | 1 |
| `NextDeletedDbObject` | `self,pUniqueKey,pObject` | argc=1 | 0 | 1 |
| `NextFlatNetChange` | `self,pFlatNetName,pFlatNetCanonicalPath,pFlatNet,pState,pFlatNetNameAnother,pOtherFlatNetCanonicalPath,pFlatNetAnother` | argc=1 | 0 | 1 |
| `NextPinChange` | `self,pPinCanonicalName,pPinNumber,pPartRef,pPartDesignator,pIsGlobal,pPinCategory,pState,pOtherPinCanonicalName,pOtherPinNumber,pOtherPartRef,pOtherPartDesignator,pOtherIsGlobal,pOtherPinCategory` | argc=1 | 0 | 1 |

Usage: `$obj <method> <args...>`  |  `DboConnectivityChangeIter_<method> $obj <args...>`
