# XMATIC (18 methods)

| method | params | note |
| --- | --- | --- |
| `AddPropertyInTcl` | `pPropertyName,pPropertyValue` | argc=1 |
| `CAP2EDIF` | `pCapPathIn,pEdifPathOut,pCfgPath` | argc=1 |
| `DSN2XML` | `` | overloaded-C++ |
| `EDIF2CAP` | `pEdifPathIn,pCapPathOut,pCfgPath` | argc=1 |
| `ExportDesignInXML` | `aDsn,aXML` | argc=1 |
| `ExportNetGroupXML` | `pDsnPathIn,pXmlPathOut,pXsdPath,pLogFilePath` | argc=1 |
| `GetCacheLib` | `` | overloaded-C++ |
| `GetDboSessionFromXML` | `` | overloaded-C++ |
| `GetDesignXml` | `` | overloaded-C++ |
| `GetLibXml` | `` | overloaded-C++ |
| `GetPackageXml` | `` | overloaded-C++ |
| `GetPageXml` | `aPage,aXML` | argc=1 |
| `GetSymbolXml` | `` | overloaded-C++ |
| `OLB2XML` | `` | overloaded-C++ |
| `SavePageXML` | `aCacheLibXMLFilePath,aDesignXMLFilePath,aDesignPath,aStatus` | argc=1 |
| `sSaveNewPartInLib` | `pLib,pPartInfo` | argc=1 |
| `XML2DSN` | `` | overloaded-C++ |
| `XML2OLB` | `` | overloaded-C++ |

Usage (object form): `$obj <method> <args...>`  /  global form: `XMATIC_<method> $obj <args...>`
