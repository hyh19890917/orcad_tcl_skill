# DboBundle (31 methods, official_calls(upper bound)=3)

| method | params | note | official | shared |
| --- | --- | --- | --- | --- |
| `~delete` | `self` | argc=1 | 0 | 151 |
| `AddMember` | `` | overloaded-C++ | 0 | 1 |
| `CanBeMember` | `self,name,type` | argc=1 | 0 | 1 |
| `ChangeMsb` | `` | overloaded-C++ | 0 | 1 |
| `ClearEditMaps` | `self` | argc=1 | 0 | 2 |
| `DeleteBundleProperty` | `self,PropName` | argc=1 | 0 | 1 |
| `DeleteMember` | `self,name` | argc=1 | 0 | 1 |
| `DetachFromParent` | `self` | argc=1 | 0 | 1 |
| `GetBundleOwnerInformation` | `self,pOwnerName,pSourceLibName` | argc=1 | 0 | 1 |
| `GetBundleProperty` | `self,PropName` | argc=1 | 0 | 2 |
| `GetBundlePropertyMap` | `self,PropertiesMap` | argc=1 | 0 | 2 |
| `GetBusOwnerName` | `self,name` | argc=1 | 0 | 1 |
| `GetContainingLib` | `self` | argc=1 | 2 | 20 |
| `GetMember` | `` | overloaded-C++ | 1 | 5 |
| `GetMemberIndex` | `self,name` | argc=1 | 0 | 1 |
| `GetNextMember` | `self,pIter,name,type` | argc=1 | 0 | 1 |
| `GetPosition` | `self,memberName` | argc=1 | 0 | 3 |
| `IsBundleMember` | `self` | argc=1 | 0 | 5 |
| `isDirty` | `self` | argc=1 | 0 | 1 |
| `isMemberAddable` | `` | overloaded-C++ | 0 | 2 |
| `IsMemberDeleted` | `self,pMembername` | argc=1 | 0 | 1 |
| `IsMemberRenamed` | `self,pMemberName,pNewName` | argc=1 | 0 | 1 |
| `isRecursiveAdd` | `self,name` | argc=1 | 0 | 1 |
| `MergeBundlePropertyMap` | `self,PropertiesMap` | argc=1 | 0 | 1 |
| `MoveUpDown` | `self,index,isUp` | argc=1 | 0 | 2 |
| `RenameMember` | `self,OldName,NewName` | argc=1 | 0 | 1 |
| `SetBundleOwnerInformation` | `self,pSourceLibName` | argc=1 | 0 | 1 |
| `SetBundleProperty` | `self,PropName,PropValue` | argc=1 | 0 | 1 |
| `setDirty` | `self,int` | argc=1 | 0 | 1 |
| `SetMsb` | `self,msb` | argc=1 | 0 | 1 |
| `StartMemberIter` | `self,pIter` | argc=1 | 0 | 1 |

Usage: `$obj <method> <args...>`  |  `DboBundle_<method> $obj <args...>`
