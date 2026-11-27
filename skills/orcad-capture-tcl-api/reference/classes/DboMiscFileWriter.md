# DboMiscFileWriter (20 methods, official_calls(upper bound)=0)

| method | params | note | official | shared |
| --- | --- | --- | --- | --- |
| `~delete` | `self` | argc=1 | 0 | 151 |
| `AddFileStream` | `` | overloaded-C++ | 0 | 1 |
| `DeleteFileStream` | `self,pStreamFileName` | argc=1 | 0 | 1 |
| `DumpFileAs` | `self,pStreamFileName,pFilePath` | argc=1 | 0 | 1 |
| `GetAllFileInfo` | `self` | argc=1 | 0 | 1 |
| `GetFileCreationTime` | `pFilepath` | argc=1 | 0 | 1 |
| `GetFileInfo` | `self,pStreamFileName,pFileInfo` | argc=1 | 0 | 1 |
| `GetFileList` | `self` | argc=1 | 0 | 1 |
| `GetFilesAsSet` | `` | overloaded-C++ | 0 | 1 |
| `GetFileStreamData` | `self,pStreamFileName` | argc=1 | 0 | 1 |
| `GetMiscStorageForRead` | `pRootStorage,pSubStorage` | argc=1 | 0 | 1 |
| `GetOrCreateMiscStorageForWrite` | `pRootStorage,pSubStorage` | argc=1 | 0 | 1 |
| `GetOrCreateMiscStorageForWriteAtLevel4` | `` | overloaded-C++ | 0 | 1 |
| `GetStreamInfoStringType` | `self,pStreamFileName,pAttrName` | argc=1 | 0 | 1 |
| `IsOKToOverWrite` | `self,streamName,pDstFilePath,pReplace` | argc=1 | 0 | 1 |
| `IsOKToPullIn` | `self,streamName,pDstFilePath,pReplace` | argc=1 | 0 | 1 |
| `IsThisUserStorageCreationAllowed` | `pStorageName` | argc=1 | 0 | 1 |
| `ReleaseStorage` | `self` | argc=1 | 0 | 1 |
| `UpdateFileStream` | `self,pStreamFileName` | argc=1 | 0 | 1 |
| `WasStorageOpenSuccessful` | `self` | argc=1 | 0 | 1 |

Usage: `$obj <method> <args...>`  |  `DboMiscFileWriter_<method> $obj <args...>`
