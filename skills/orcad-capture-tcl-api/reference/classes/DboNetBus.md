# DboNetBus (12 methods)

| method | params | note |
| --- | --- | --- |
| `GetBundleOwner` | `self,BundleOwner` | argc=1 |
| `GetMember` | `self,nPos,status` | argc=1 |
| `GetObjectType` | `self` | argc=1 |
| `GetPosition` | `self,pNetMember` | argc=1 |
| `GetWidth` | `self,status` | argc=1 |
| `HasMember` | `self,pNet` | argc=1 |
| `IsBundle` | `self` | argc=1 |
| `IsBundleObject` | `self` | argc=1 |
| `IsExpanded` | `self` | argc=1 |
| `NewMembersIter` | `` | overloaded-C++ |
| `RemoveMember` | `self,nPos` | argc=1 |
| `SetIsBundle` | `self,isSetBundle` | argc=1 |

Usage (object form): `$obj <method> <args...>`  /  global form: `DboNetBus_<method> $obj <args...>`
