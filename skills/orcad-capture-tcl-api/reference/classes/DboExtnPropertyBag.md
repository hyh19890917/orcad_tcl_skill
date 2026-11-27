# DboExtnPropertyBag (10 methods, official_calls(upper bound)=39)

| method | params | note | official | shared |
| --- | --- | --- | --- | --- |
| `AddProperty` | `self,BagType,pBagName,pPropName,pPropValue` | argc=1 | 0 | 1 |
| `Copy` | `self` | argc=1 | 38 | 8 |
| `GetBagTypeString` | `self,bagType` | argc=1 | 0 | 1 |
| `GetPropertyBag` | `self,BagType` | argc=1 | 0 | 2 |
| `GetPropertyNameValueMap` | `self,BagType,aBagName,lPropertyNameValue` | argc=1 | 0 | 1 |
| `GetPropertyTypeMap` | `self` | argc=1 | 0 | 1 |
| `GetPropertyValue` | `self,BagType,aBagName,PropName,PropValue` | argc=1 | 0 | 1 |
| `sGetExtension` | `pHandle` | argc=1 | 0 | 3 |
| `sLoad` | `pExtensionData` | argc=1 | 0 | 4 |
| `Store` | `self,pExtensionData` | argc=1 | 1 | 5 |

Usage: `$obj <method> <args...>`  |  `DboExtnPropertyBag_<method> $obj <args...>`
