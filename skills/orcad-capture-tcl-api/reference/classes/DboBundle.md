# DboBundle (31 methods)

| method | params | note |
| --- | --- | --- |
| `~delete` | `self` | argc=1 |
| `AddMember` | `` | overloaded-C++ |
| `CanBeMember` | `self,name,type` | argc=1 |
| `ChangeMsb` | `` | overloaded-C++ |
| `ClearEditMaps` | `self` | argc=1 |
| `DeleteBundleProperty` | `self,PropName` | argc=1 |
| `DeleteMember` | `self,name` | argc=1 |
| `DetachFromParent` | `self` | argc=1 |
| `GetBundleOwnerInformation` | `self,pOwnerName,pSourceLibName` | argc=1 |
| `GetBundleProperty` | `self,PropName` | argc=1 |
| `GetBundlePropertyMap` | `self,PropertiesMap` | argc=1 |
| `GetBusOwnerName` | `self,name` | argc=1 |
| `GetContainingLib` | `self` | argc=1 |
| `GetMember` | `` | overloaded-C++ |
| `GetMemberIndex` | `self,name` | argc=1 |
| `GetNextMember` | `self,pIter,name,type` | argc=1 |
| `GetPosition` | `self,memberName` | argc=1 |
| `IsBundleMember` | `self` | argc=1 |
| `isDirty` | `self` | argc=1 |
| `isMemberAddable` | `` | overloaded-C++ |
| `IsMemberDeleted` | `self,pMembername` | argc=1 |
| `IsMemberRenamed` | `self,pMemberName,pNewName` | argc=1 |
| `isRecursiveAdd` | `self,name` | argc=1 |
| `MergeBundlePropertyMap` | `self,PropertiesMap` | argc=1 |
| `MoveUpDown` | `self,index,isUp` | argc=1 |
| `RenameMember` | `self,OldName,NewName` | argc=1 |
| `SetBundleOwnerInformation` | `self,pSourceLibName` | argc=1 |
| `SetBundleProperty` | `self,PropName,PropValue` | argc=1 |
| `setDirty` | `self,int` | argc=1 |
| `SetMsb` | `self,msb` | argc=1 |
| `StartMemberIter` | `self,pIter` | argc=1 |

Usage (object form): `$obj <method> <args...>`  /  global form: `DboBundle_<method> $obj <args...>`
