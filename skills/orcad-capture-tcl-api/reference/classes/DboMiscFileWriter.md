# DboMiscFileWriter (20 methods)

| method | params | note |
| --- | --- | --- |
| `~delete` | `self` | argc=1 |
| `AddFileStream` | `` | overloaded-C++ |
| `DeleteFileStream` | `self,pStreamFileName` | argc=1 |
| `DumpFileAs` | `self,pStreamFileName,pFilePath` | argc=1 |
| `GetAllFileInfo` | `self` | argc=1 |
| `GetFileCreationTime` | `pFilepath` | argc=1 |
| `GetFileInfo` | `self,pStreamFileName,pFileInfo` | argc=1 |
| `GetFileList` | `self` | argc=1 |
| `GetFilesAsSet` | `` | overloaded-C++ |
| `GetFileStreamData` | `self,pStreamFileName` | argc=1 |
| `GetMiscStorageForRead` | `pRootStorage,pSubStorage` | argc=1 |
| `GetOrCreateMiscStorageForWrite` | `pRootStorage,pSubStorage` | argc=1 |
| `GetOrCreateMiscStorageForWriteAtLevel4` | `` | overloaded-C++ |
| `GetStreamInfoStringType` | `self,pStreamFileName,pAttrName` | argc=1 |
| `IsOKToOverWrite` | `self,streamName,pDstFilePath,pReplace` | argc=1 |
| `IsOKToPullIn` | `self,streamName,pDstFilePath,pReplace` | argc=1 |
| `IsThisUserStorageCreationAllowed` | `pStorageName` | argc=1 |
| `ReleaseStorage` | `self` | argc=1 |
| `UpdateFileStream` | `self,pStreamFileName` | argc=1 |
| `WasStorageOpenSuccessful` | `self` | argc=1 |

Usage (object form): `$obj <method> <args...>`  /  global form: `DboMiscFileWriter_<method> $obj <args...>`
