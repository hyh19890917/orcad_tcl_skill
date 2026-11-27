# DboExtnAttrLockPvt (24 methods)

| method | params | note |
| --- | --- | --- |
| `~delete` | `self` | argc=1 |
| `Copy` | `self` | argc=1 |
| `GetLockInfo` | `self,propName,lockMask,preTrigger,postTrigger` | argc=1 |
| `GetLockMask` | `self` | argc=1 |
| `GetNext` | `self` | argc=1 |
| `GetNumNode` | `self` | argc=1 |
| `GetPropName` | `self` | argc=1 |
| `GetTrigger` | `self,pre` | argc=1 |
| `IsAttributeLockingSupported` | `propName` | argc=1 |
| `IsDeleteLocked` | `self` | argc=1 |
| `IsDisplayLocked` | `self` | argc=1 |
| `IsLocationLocked` | `self` | argc=1 |
| `IsPostTriggerSupported` | `self` | argc=1 |
| `IsPretriggerSupported` | `self` | argc=1 |
| `IsSystemLocked` | `self` | argc=1 |
| `IsValueLocked` | `self` | argc=1 |
| `ResetLock` | `self,lockMask` | argc=1 |
| `SetLock` | `self,lockMask` | argc=1 |
| `SetLockInfo` | `self,propName,lockMask,preTrigger,postTrigger` | argc=1 |
| `SetNext` | `self,tmpNode` | argc=1 |
| `SetTrigger` | `self,triggerName,pre` | argc=1 |
| `sGetExtension` | `pHandle` | argc=1 |
| `sLoad` | `pExtensionData` | argc=1 |
| `Store` | `self,pExtensionData` | argc=1 |

Usage (object form): `$obj <method> <args...>`  /  global form: `DboExtnAttrLockPvt_<method> $obj <args...>`
