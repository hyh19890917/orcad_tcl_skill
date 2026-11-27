# DboExtnAttrLockPvt (24 methods, official_calls(upper bound)=39)

| method | params | note | official | shared |
| --- | --- | --- | --- | --- |
| `~delete` | `self` | argc=1 | 0 | 151 |
| `Copy` | `self` | argc=1 | 38 | 8 |
| `GetLockInfo` | `self,propName,lockMask,preTrigger,postTrigger` | argc=1 | 0 | 1 |
| `GetLockMask` | `self` | argc=1 | 0 | 1 |
| `GetNext` | `self` | argc=1 | 0 | 2 |
| `GetNumNode` | `self` | argc=1 | 0 | 1 |
| `GetPropName` | `self` | argc=1 | 0 | 1 |
| `GetTrigger` | `self,pre` | argc=1 | 0 | 1 |
| `IsAttributeLockingSupported` | `propName` | argc=1 | 0 | 1 |
| `IsDeleteLocked` | `self` | argc=1 | 0 | 1 |
| `IsDisplayLocked` | `self` | argc=1 | 0 | 1 |
| `IsLocationLocked` | `self` | argc=1 | 0 | 1 |
| `IsPostTriggerSupported` | `self` | argc=1 | 0 | 1 |
| `IsPretriggerSupported` | `self` | argc=1 | 0 | 1 |
| `IsSystemLocked` | `self` | argc=1 | 0 | 1 |
| `IsValueLocked` | `self` | argc=1 | 0 | 1 |
| `ResetLock` | `self,lockMask` | argc=1 | 0 | 1 |
| `SetLock` | `self,lockMask` | argc=1 | 0 | 1 |
| `SetLockInfo` | `self,propName,lockMask,preTrigger,postTrigger` | argc=1 | 0 | 1 |
| `SetNext` | `self,tmpNode` | argc=1 | 0 | 1 |
| `SetTrigger` | `self,triggerName,pre` | argc=1 | 0 | 1 |
| `sGetExtension` | `pHandle` | argc=1 | 0 | 3 |
| `sLoad` | `pExtensionData` | argc=1 | 0 | 4 |
| `Store` | `self,pExtensionData` | argc=1 | 1 | 5 |

Usage: `$obj <method> <args...>`  |  `DboExtnAttrLockPvt_<method> $obj <args...>`
