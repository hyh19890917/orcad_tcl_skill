# XMATIC (18 methods, official_calls(upper bound)=0)

| method | params | note | official | shared |
| --- | --- | --- | --- | --- |
| `AddPropertyInTcl` | `pPropertyName,pPropertyValue` | argc=1 | 0 | 1 |
| `CAP2EDIF` | `pCapPathIn,pEdifPathOut,pCfgPath` | argc=1 | 0 | 1 |
| `DSN2XML` | `` | overloaded-C++ | 0 | 1 |
| `EDIF2CAP` | `pEdifPathIn,pCapPathOut,pCfgPath` | argc=1 | 0 | 1 |
| `ExportDesignInXML` | `aDsn,aXML` | argc=1 | 0 | 1 |
| `ExportNetGroupXML` | `pDsnPathIn,pXmlPathOut,pXsdPath,pLogFilePath` | argc=1 | 0 | 1 |
| `GetCacheLib` | `` | overloaded-C++ | 0 | 1 |
| `GetDboSessionFromXML` | `` | overloaded-C++ | 0 | 1 |
| `GetDesignXml` | `` | overloaded-C++ | 0 | 1 |
| `GetLibXml` | `` | overloaded-C++ | 0 | 1 |
| `GetPackageXml` | `` | overloaded-C++ | 0 | 1 |
| `GetPageXml` | `aPage,aXML` | argc=1 | 0 | 1 |
| `GetSymbolXml` | `` | overloaded-C++ | 0 | 1 |
| `OLB2XML` | `` | overloaded-C++ | 0 | 1 |
| `SavePageXML` | `aCacheLibXMLFilePath,aDesignXMLFilePath,aDesignPath,aStatus` | argc=1 | 0 | 1 |
| `sSaveNewPartInLib` | `pLib,pPartInfo` | argc=1 | 0 | 1 |
| `XML2DSN` | `` | overloaded-C++ | 0 | 1 |
| `XML2OLB` | `` | overloaded-C++ | 0 | 1 |

Usage: `$obj <method> <args...>`  |  `XMATIC_<method> $obj <args...>`
