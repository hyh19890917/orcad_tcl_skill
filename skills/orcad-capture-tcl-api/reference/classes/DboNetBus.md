# DboNetBus (12 methods, official_calls(upper bound)=104)

| method | params | note | official | shared |
| --- | --- | --- | --- | --- |
| `GetBundleOwner` | `self,BundleOwner` | argc=1 | 0 | 2 |
| `GetMember` | `self,nPos,status` | argc=1 | 1 | 5 |
| `GetObjectType` | `self` | argc=1 | 86 | 57 |
| `GetPosition` | `self,pNetMember` | argc=1 | 0 | 3 |
| `GetWidth` | `self,status` | argc=1 | 14 | 5 |
| `HasMember` | `self,pNet` | argc=1 | 1 | 1 |
| `IsBundle` | `self` | argc=1 | 0 | 4 |
| `IsBundleObject` | `self` | argc=1 | 2 | 10 |
| `IsExpanded` | `self` | argc=1 | 0 | 2 |
| `NewMembersIter` | `` | overloaded-C++ | 0 | 2 |
| `RemoveMember` | `self,nPos` | argc=1 | 0 | 1 |
| `SetIsBundle` | `self,isSetBundle` | argc=1 | 0 | 1 |

Usage: `$obj <method> <args...>`  |  `DboNetBus_<method> $obj <args...>`
