# DboBus (11 methods, official_calls(upper bound)=1)

| method | params | note | official | shared |
| --- | --- | --- | --- | --- |
| `CompareRanges` | `` | overloaded-C++ | 0 | 1 |
| `GetBaseName` | `BusName,BaseName` | argc=1 | 0 | 2 |
| `GetBusWidth` | `Busname` | argc=1 | 0 | 1 |
| `GetMember` | `` | overloaded-C++ | 1 | 5 |
| `GetMemberPosition` | `` | overloaded-C++ | 0 | 1 |
| `IsBundleMember` | `memberName,AliAsName,pWireBus` | argc=1 | 0 | 5 |
| `IsEquivalentBusName` | `Name1,Name2` | argc=1 | 0 | 1 |
| `IsEquivalentBusNameWithBitsSwapped` | `Name1,Name2` | argc=1 | 0 | 1 |
| `NewBusMemberName` | `BusName,BaseName,nLsb,nMsb,nIndex` | argc=1 | 0 | 1 |
| `NewBusName` | `BusName,BaseName,nLsb,nMsb` | argc=1 | 0 | 1 |
| `ValidBusName` | `BusName,BaseName,nLsb,nMsb` | argc=1 | 0 | 1 |

Usage: `$obj <method> <args...>`  |  `DboBus_<method> $obj <args...>`
