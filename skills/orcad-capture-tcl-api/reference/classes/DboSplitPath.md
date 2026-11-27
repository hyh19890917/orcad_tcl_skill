# DboSplitPath (6 methods, official_calls(upper bound)=20)

| method | params | note | official | shared |
| --- | --- | --- | --- | --- |
| `GetDir` | `self` | argc=1 | 0 | 1 |
| `GetDrive` | `self` | argc=1 | 0 | 1 |
| `GetExt` | `self` | argc=1 | 0 | 1 |
| `GetFileName` | `self` | argc=1 | 1 | 1 |
| `GetFileTitle` | `self` | argc=1 | 0 | 1 |
| `GetPath` | `self` | argc=1 | 19 | 1 |

Usage: `$obj <method> <args...>`  |  `DboSplitPath_<method> $obj <args...>`
