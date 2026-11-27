# DboPathMgr (43 methods, official_calls(upper bound)=0)

| method | params | note | official | shared |
| --- | --- | --- | --- | --- |
| `DboFileEncryptionData` | `` | No constructor available. | 0 | 1 |
| `DboFileEncryptionData_mbEncrypted_get` | `self` | argc=1 | 0 | 1 |
| `DboFileEncryptionData_mbEncrypted_set` | `self,mbEncrypted` | argc=1 | 0 | 1 |
| `DboFileEncryptionData_mFileName_get` | `self` | argc=1 | 0 | 1 |
| `DboFileEncryptionData_mFileName_set` | `self,mFileName` | argc=1 | 0 | 1 |
| `DboFileEncryptionData_mPassword_get` | `self` | argc=1 | 0 | 1 |
| `DboFileEncryptionData_mPassword_set` | `self,mPassword` | argc=1 | 0 | 1 |
| `DboFileEncryptionData_mRefCount_get` | `self` | argc=1 | 0 | 1 |
| `DboFileEncryptionData_mRefCount_set` | `self,mRefCount` | argc=1 | 0 | 1 |
| `DboFileEncryptionData_mState_get` | `self` | argc=1 | 0 | 1 |
| `DboFileEncryptionData_mState_set` | `self,mState` | argc=1 | 0 | 1 |
| `DboPathRecordS` | `` | No constructor available. | 0 | 1 |
| `DboPathRecordS_mAccessible_get` | `self` | argc=1 | 0 | 1 |
| `DboPathRecordS_mAccessible_set` | `self,mAccessible` | argc=1 | 0 | 1 |
| `DboPathRecordS_mFullPath_get` | `self` | argc=1 | 0 | 1 |
| `DboPathRecordS_mFullPath_set` | `self,mFullPath` | argc=1 | 0 | 1 |
| `DboPathRecordS_mReadOnly_get` | `self` | argc=1 | 0 | 1 |
| `DboPathRecordS_mReadOnly_set` | `self,mReadOnly` | argc=1 | 0 | 1 |
| `sClearPathHistory` | `` | zero-arg-ok | 0 | 2 |
| `sCmpCh` | `ch1,ch2` | argc=1 | 0 | 1 |
| `sComparePaths` | `s1,s2` | argc=1 | 0 | 1 |
| `sConvertToAbsolutePath` | `pPath,pFullPath` | argc=1 | 0 | 1 |
| `sDisableFileLookupNotifaction` | `` | zero-arg-ok | 0 | 1 |
| `sDumpToSessionLog` | `` | zero-arg-ok | 0 | 1 |
| `sExit` | `` | zero-arg-ok | 0 | 1 |
| `sFindAbsolutePath` | `path,baseDir` | argc=1 | 0 | 1 |
| `sFindFileDir` | `path` | argc=1 | 0 | 1 |
| `sFindRelativePath` | `path,baseDir` | argc=1 | 0 | 1 |
| `sForgetReadOnlyAttribute` | `` | zero-arg-ok | 0 | 1 |
| `sGetAllPaths` | `` | zero-arg-ok | 0 | 1 |
| `sGetFileStatus` | `pPath,pFileStatus` | argc=1 | 0 | 1 |
| `sGetFullPath` | `pPath` | argc=1 | 0 | 1 |
| `sGetLegacySaveAs` | `` | zero-arg-ok | 0 | 1 |
| `sGetPathLookupTimeout` | `` | zero-arg-ok | 0 | 1 |
| `sInit` | `` | zero-arg-ok | 0 | 1 |
| `sIsPathAbsolute` | `path` | argc=1 | 0 | 1 |
| `sIsReadOnly` | `pPath` | argc=1 | 0 | 1 |
| `sLookupPath` | `` | overloaded-C++ | 0 | 1 |
| `sNormalizePath` | `path` | argc=1 | 0 | 1 |
| `sNotifyFileLookup` | `pPath` | argc=1 | 0 | 1 |
| `sSetExitWaitTimeout` | `pTimeOut` | argc=1 | 0 | 1 |
| `sSetLegacySaveAs` | `bVal` | argc=1 | 0 | 1 |
| `sSetPathLookupTimeout` | `pTimeOut` | argc=1 | 0 | 1 |

Usage: `$obj <method> <args...>`  |  `DboPathMgr_<method> $obj <args...>`
