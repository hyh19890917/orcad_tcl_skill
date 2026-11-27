# DboUserProp (12 methods, official_calls(upper bound)=370)

| method | params | note | official | shared |
| --- | --- | --- | --- | --- |
| `DeleteValue` | `self` | argc=1 | 0 | 1 |
| `GetName` | `self,name` | argc=1 | 185 | 18 |
| `GetNext` | `self` | argc=1 | 0 | 2 |
| `GetOwner` | `self` | argc=1 | 69 | 19 |
| `GetStringValue` | `` | overloaded-C++ | 1 | 1 |
| `GetType` | `self,status` | argc=1 | 1 | 5 |
| `IsDeletable` | `` | overloaded-C++ | 0 | 1 |
| `IsEditable` | `self` | argc=1 | 0 | 1 |
| `SetName` | `self,name` | argc=1 | 66 | 17 |
| `SetStringValue` | `` | overloaded-C++ | 0 | 1 |
| `SetValue` | `` | overloaded-C++ | 48 | 2 |
| `ShadowSetStringValue` | `self,val` | argc=1 | 0 | 1 |

Usage: `$obj <method> <args...>`  |  `DboUserProp_<method> $obj <args...>`
