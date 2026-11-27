# DboDirectory (21 methods)

| method | params | note |
| --- | --- | --- |
| `ClearModified` | `self,name` | argc=1 |
| `ClearObject` | `self,name` | argc=1 |
| `GetCreateTime` | `self,name,status` | argc=1 |
| `GetEntry` | `` | overloaded-C++ |
| `GetModifyTime` | `self,name,status` | argc=1 |
| `GetObject` | `self,name,status` | argc=1 |
| `GetPackageFromMemory` | `self,aName,status` | argc=1 |
| `GetSaveTime` | `self` | argc=1 |
| `GetTimeZone` | `` | zero-arg-ok |
| `GetTimeZoneOffset` | `` | zero-arg-ok |
| `IsAnyEntryModified` | `self` | argc=1 |
| `IsInMemory` | `self,name,status` | argc=1 |
| `IsModified` | `self,name` | argc=1 |
| `IsSaved` | `self,name` | argc=1 |
| `MarkModified` | `self,name` | argc=1 |
| `MarkSaved` | `self,name` | argc=1 |
| `MarkToBeDeleted` | `self,name` | argc=1 |
| `MarkToBeSaved` | `self,name` | argc=1 |
| `NewEntriesIter` | `self,status` | argc=1 |
| `NewObjectsIter` | `self,status` | argc=1 |
| `ReadPackageModifiedTime` | `self,pFile,pPackageName,lFileTime` | argc=1 |

Usage (object form): `$obj <method> <args...>`  /  global form: `DboDirectory_<method> $obj <args...>`
