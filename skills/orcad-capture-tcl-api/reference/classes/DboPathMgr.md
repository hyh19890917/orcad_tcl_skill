# DboPathMgr (43 methods)

| method | params | note |
| --- | --- | --- |
| `DboFileEncryptionData` | `` | No constructor available. |
| `DboFileEncryptionData_mbEncrypted_get` | `self` | argc=1 |
| `DboFileEncryptionData_mbEncrypted_set` | `self,mbEncrypted` | argc=1 |
| `DboFileEncryptionData_mFileName_get` | `self` | argc=1 |
| `DboFileEncryptionData_mFileName_set` | `self,mFileName` | argc=1 |
| `DboFileEncryptionData_mPassword_get` | `self` | argc=1 |
| `DboFileEncryptionData_mPassword_set` | `self,mPassword` | argc=1 |
| `DboFileEncryptionData_mRefCount_get` | `self` | argc=1 |
| `DboFileEncryptionData_mRefCount_set` | `self,mRefCount` | argc=1 |
| `DboFileEncryptionData_mState_get` | `self` | argc=1 |
| `DboFileEncryptionData_mState_set` | `self,mState` | argc=1 |
| `DboPathRecordS` | `` | No constructor available. |
| `DboPathRecordS_mAccessible_get` | `self` | argc=1 |
| `DboPathRecordS_mAccessible_set` | `self,mAccessible` | argc=1 |
| `DboPathRecordS_mFullPath_get` | `self` | argc=1 |
| `DboPathRecordS_mFullPath_set` | `self,mFullPath` | argc=1 |
| `DboPathRecordS_mReadOnly_get` | `self` | argc=1 |
| `DboPathRecordS_mReadOnly_set` | `self,mReadOnly` | argc=1 |
| `sClearPathHistory` | `` | zero-arg-ok |
| `sCmpCh` | `ch1,ch2` | argc=1 |
| `sComparePaths` | `s1,s2` | argc=1 |
| `sConvertToAbsolutePath` | `pPath,pFullPath` | argc=1 |
| `sDisableFileLookupNotifaction` | `` | zero-arg-ok |
| `sDumpToSessionLog` | `` | zero-arg-ok |
| `sExit` | `` | zero-arg-ok |
| `sFindAbsolutePath` | `path,baseDir` | argc=1 |
| `sFindFileDir` | `path` | argc=1 |
| `sFindRelativePath` | `path,baseDir` | argc=1 |
| `sForgetReadOnlyAttribute` | `` | zero-arg-ok |
| `sGetAllPaths` | `` | zero-arg-ok |
| `sGetFileStatus` | `pPath,pFileStatus` | argc=1 |
| `sGetFullPath` | `pPath` | argc=1 |
| `sGetLegacySaveAs` | `` | zero-arg-ok |
| `sGetPathLookupTimeout` | `` | zero-arg-ok |
| `sInit` | `` | zero-arg-ok |
| `sIsPathAbsolute` | `path` | argc=1 |
| `sIsReadOnly` | `pPath` | argc=1 |
| `sLookupPath` | `` | overloaded-C++ |
| `sNormalizePath` | `path` | argc=1 |
| `sNotifyFileLookup` | `pPath` | argc=1 |
| `sSetExitWaitTimeout` | `pTimeOut` | argc=1 |
| `sSetLegacySaveAs` | `bVal` | argc=1 |
| `sSetPathLookupTimeout` | `pTimeOut` | argc=1 |

Usage (object form): `$obj <method> <args...>`  /  global form: `DboPathMgr_<method> $obj <args...>`
