# DboBus (11 methods)

| method | params | note |
| --- | --- | --- |
| `CompareRanges` | `` | overloaded-C++ |
| `GetBaseName` | `BusName,BaseName` | argc=1 |
| `GetBusWidth` | `Busname` | argc=1 |
| `GetMember` | `` | overloaded-C++ |
| `GetMemberPosition` | `` | overloaded-C++ |
| `IsBundleMember` | `memberName,AliAsName,pWireBus` | argc=1 |
| `IsEquivalentBusName` | `Name1,Name2` | argc=1 |
| `IsEquivalentBusNameWithBitsSwapped` | `Name1,Name2` | argc=1 |
| `NewBusMemberName` | `BusName,BaseName,nLsb,nMsb,nIndex` | argc=1 |
| `NewBusName` | `BusName,BaseName,nLsb,nMsb` | argc=1 |
| `ValidBusName` | `BusName,BaseName,nLsb,nMsb` | argc=1 |

Usage (object form): `$obj <method> <args...>`  /  global form: `DboBus_<method> $obj <args...>`
