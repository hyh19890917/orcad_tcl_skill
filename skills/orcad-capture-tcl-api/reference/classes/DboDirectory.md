# DboDirectory (21 methods, official_calls(upper bound)=20)

| method | params | note | official | shared |
| --- | --- | --- | --- | --- |
| `ClearModified` | `self,name` | argc=1 | 0 | 3 |
| `ClearObject` | `self,name` | argc=1 | 0 | 1 |
| `GetCreateTime` | `self,name,status` | argc=1 | 0 | 4 |
| `GetEntry` | `` | overloaded-C++ | 0 | 2 |
| `GetModifyTime` | `self,name,status` | argc=1 | 0 | 4 |
| `GetObject` | `self,name,status` | argc=1 | 0 | 2 |
| `GetPackageFromMemory` | `self,aName,status` | argc=1 | 0 | 2 |
| `GetSaveTime` | `self` | argc=1 | 0 | 1 |
| `GetTimeZone` | `` | zero-arg-ok | 0 | 1 |
| `GetTimeZoneOffset` | `` | zero-arg-ok | 0 | 1 |
| `IsAnyEntryModified` | `self` | argc=1 | 0 | 1 |
| `IsInMemory` | `self,name,status` | argc=1 | 0 | 1 |
| `IsModified` | `self,name` | argc=1 | 7 | 6 |
| `IsSaved` | `self,name` | argc=1 | 0 | 1 |
| `MarkModified` | `self,name` | argc=1 | 13 | 13 |
| `MarkSaved` | `self,name` | argc=1 | 0 | 1 |
| `MarkToBeDeleted` | `self,name` | argc=1 | 0 | 1 |
| `MarkToBeSaved` | `self,name` | argc=1 | 0 | 1 |
| `NewEntriesIter` | `self,status` | argc=1 | 0 | 1 |
| `NewObjectsIter` | `self,status` | argc=1 | 0 | 1 |
| `ReadPackageModifiedTime` | `self,pFile,pPackageName,lFileTime` | argc=1 | 0 | 1 |

Usage: `$obj <method> <args...>`  |  `DboDirectory_<method> $obj <args...>`
