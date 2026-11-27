# DboConnectivityChangeIter (5 methods)

| method | params | note |
| --- | --- | --- |
| `~delete` | `self` | argc=1 |
| `NextAddorModifiedDbObject` | `self,pUniqueKey,pObject` | argc=1 |
| `NextDeletedDbObject` | `self,pUniqueKey,pObject` | argc=1 |
| `NextFlatNetChange` | `self,pFlatNetName,pFlatNetCanonicalPath,pFlatNet,pState,pFlatNetNameAnother,pOtherFlatNetCanonicalPath,pFlatNetAnother` | argc=1 |
| `NextPinChange` | `self,pPinCanonicalName,pPinNumber,pPartRef,pPartDesignator,pIsGlobal,pPinCategory,pState,pOtherPinCanonicalName,pOtherPinNumber,pOtherPartRef,pOtherPartDesignator,pOtherIsGlobal,pOtherPinCategory` | argc=1 |

Usage (object form): `$obj <method> <args...>`  /  global form: `DboConnectivityChangeIter_<method> $obj <args...>`
