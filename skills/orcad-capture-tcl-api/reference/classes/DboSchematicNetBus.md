# DboSchematicNetBus (4 methods, official_calls(upper bound)=101)

| method | params | note | official | shared |
| --- | --- | --- | --- | --- |
| `GetMember` | `self,nPos,status` | argc=1 | 1 | 5 |
| `GetObjectType` | `self` | argc=1 | 86 | 57 |
| `GetWidth` | `self,status` | argc=1 | 14 | 5 |
| `NewMembersIter` | `` | overloaded-C++ | 0 | 2 |

Usage: `$obj <method> <args...>`  |  `DboSchematicNetBus_<method> $obj <args...>`
