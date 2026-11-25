# Dbo 类与方法全表（Cadence Capture 17.4，从 orDb_Dll_Tcl64.dll 实测导出）

每个 C++ 成员在 Tcl 里注册为全局命令 `Dbo<类>_<方法>`；对象由其它方法返回后，再用同样的 `Dbo<类>_<方法>` 命令、以对象名接管第一个参数调用（见 SKILL.md 的"调用形态"）。

类总数：416；方法总数：3898

## DboAlias — 46 个成员

```text
GetBoundingBox  GetBundleOwnerPropName  GetBundleOwnerPropValue  GetColor  GetContainingLib  GetDisplayName  GetFont  GetId  GetLocation  GetName  GetObjectType  GetOwner  GetRotation  IsBoundingBoxDirty  IsBundleObject  IsFontDefault  m_nId_get  m_nId_set  RemoveBundleOwner  RemoveBundleProperties  SetBoundingBox  SetBoundingBoxDirty  SetBundleOwner  SetColor  SetDisplayName  SetFont  SetId  SetLocation  SetName  SetOwnerBoundingBoxDirty  SetPropertyToExtention  SetRotation  sGetColor  sGetFont  sGetLocationX  sGetLocationY  sGetName  sGetRotation  sSetColor  sSetFont  sSetLocationX  sSetLocationY  sSetName  sSetRotation  UpdateBundleOwner  ValidateNGName
```

## DboAliasData — 12 个成员

```text
AliasName_get  AliasName_set  Color_get  Color_set  FontName_get  FontName_set  FontSize_get  FontSize_set  Location_get  Location_set  Rotation_get  Rotation_set
```

## DboAnnotateControl — 4 个成员

```text
GetNumRange  GetPagePath  GetRangeAt  GetSchName
```

## DboAnnotateRange — 6 个成员

```text
GetLastIndex  GetRefdesPrefix  GetStartIndex  SetLastIndex  SetRefDesPrefix  SetStartIndex
```

## DboArc — 22 个成员

```text
GetBoundingBox  GetEnd  GetLineStyle  GetLineWidth  GetObjectType  GetStart  Move  SetBoundingBox  SetEnd  SetLineStyle  SetLineWidth  SetStart  sGetBoundingBoxBottom  sGetBoundingBoxLeft  sGetBoundingBoxRight  sGetBoundingBoxTop  sGetEndX  sGetEndY  sGetLineStyle  sGetLineWidth  sGetStartX  sGetStartY
```

## DboArcData — 10 个成员

```text
Bound_get  Bound_set  End_get  End_set  LineStyle_get  LineStyle_set  LineWidth_get  LineWidth_set  Start_get  Start_set
```

## DboBaseObject — 113 个成员

```text
AddLockingInfo  AddPropertyToPropertyBag  AddVariantProp  ClearVariantMap  CopyExtensions  Decrement  DeleteDBProp  DeleteDisplayProp  DeleteEffectiveProp  DeleteUserProp  DeleteUserProps  EffectiveNGMatch  EffectivePropNameMatch  EffectivePropsMatch  GetAttributeLockingInfo  GetBaseProp  GetBasePropNC  GetBitmask  GetBoundingBox  GetBundleOwner  GetBundleOwnerPropName  GetBundleOwnerPropValue  GetBundleTemplateMap  GetContainingLib  GetCurrentObject  GetDBProp  GetDBPropFromObject  GetDBPropNC  GetDBPropValue  GetDisplayProp  GetDisplayPropEx  GetDisplayPropsPermitted  GetEffectivePropStringValue  GetEffectivePropStringValueNC  GetEffectivePropValueChoices  GetEffectivePropValueExists  GetEffectivePropValueType  GetExtensionHandle  GetId  GetMask  GetName  GetNextNewVariantProp  GetNextState  GetObjectOccurrence  GetObjectOccurrences  GetObjectType  GetOpenDesigns  GetPaint  GetPrevState  GetPropertyBag  GetPropertyFromPropertyBag  GetRefCount  GetSemanticID  GetSemanticString  GetSession  GetTransactionCount  GetTypeString  GetUserEditAttributeOnProp  GetUserProp  GetUserPropNC  GetUserPropsCount  GetUserPropsPermitted  GetUserPropStringValue  GetUserPropStringValueNC  GetVariantProp  HasPropertyThatExists  Increment  IsBitmaskAllowed  IsBundleObject  isBundleTemplateExists  IsCurrent  IsEquivalent  IsObjLocked  IsOccModified  IsPropertyLockable  IsPropertyLockedForEditing  IsPtrDeleted  IsUpdated  IsVariantPropMapEmpty  MakeBundle  MarkModified  NewDBPropsIter  NewDisplayProp  NewDisplayPropsIter  NewEffectivePropsIter  NewUserProp  NewUserPropsIter  RemoveBundleProperties  RemovePropertiesFromPropertyBag  RemovePropertyBag  RemovePropsFromObject  ResetObject  sDoPatternMatch  SetBitmask  SetBundleOwner  SetCurrent  SetDBPropValue  SetEffectivePropStringValue  SetMask  SetName  SetNextState  SetObjectType  SetOccsModified  SetPaint  SetPrevState  SetPropStringValueWithEditTracking  SetTransactionCount  SetUserEditAttributeOnProp  SetUserPropStringValue  sGetDBProp  StatefulCreate  UnsetBitmask  UpdateBundleOwner
```

## DboBezier — 14 个成员

```text
GetCount  GetLineStyle  GetLineWidth  GetObjectType  Move  MovePoint  NewPoint  NewPointsIter  RemoveAllPoints  RemovePoint  SetLineStyle  SetLineWidth  sGetLineStyle  sGetLineWidth
```

## DboBezierPointsIter — 1 个成员

```text
Next
```

## DboBitMap — 20 个成员

```text
GetBitmapDimension  GetBoundingBox  GetDib  GetDibSize  GetLocation  GetObjectType  sDeleteCBitmapDIB  SetBitmapDimension  SetBoundingBox  SetLocation  sGetBase64ImageData  sGetBoundingBoxBottom  sGetBoundingBoxLeft  sGetBoundingBoxRight  sGetBoundingBoxTop  sGetCBitmapDIB  sGetDibFromBase64ImageData  sGetImageFromDboBitMap  sGetLocationX  sGetLocationY
```

## DboBitMapData — 6 个成员

```text
bmpFile_get  bmpFile_set  BoundingBox_get  BoundingBox_set  Location_get  Location_set
```

## DboBookMark — 3 个成员

```text
SetLocation  SetMirror  SetRotation
```

## DboBox — 22 个成员

```text
GetFillStyle  GetHatchStyle  GetLineStyle  GetLineWidth  GetLowerRight  GetObjectType  GetUpperLeft  Move  SetFillStyle  SetHatchStyle  SetLineStyle  SetLineWidth  SetLowerRight  SetUpperLeft  sGetBottom  sGetFillStyle  sGetHatchStyle  sGetLeft  sGetLineStyle  sGetLineWidth  sGetRight  sGetTop
```

## DboBoxData — 10 个成员

```text
Bound_get  Bound_set  FillStyle_get  FillStyle_set  HatchStyle_get  HatchStyle_set  LineStyle_get  LineStyle_set  LineWidth_get  LineWidth_set
```

## DboBundle — 30 个成员

```text
AddMember  CanBeMember  ChangeMsb  ClearEditMaps  DeleteBundleProperty  DeleteMember  DetachFromParent  GetBundleOwnerInformation  GetBundleProperty  GetBundlePropertyMap  GetBusOwnerName  GetContainingLib  GetMember  GetMemberIndex  GetNextMember  GetPosition  IsBundleMember  isDirty  isMemberAddable  IsMemberDeleted  IsMemberRenamed  isRecursiveAdd  MergeBundlePropertyMap  MoveUpDown  RenameMember  SetBundleOwnerInformation  SetBundleProperty  setDirty  SetMsb  StartMemberIter
```

## DboBundleBusMember — 7 个成员

```text
GetBaseName  GetDisplayName  GetLsb  GetMsb  GetName  GetWidth  IsBundleMember
```

## DboBundleMemberIter — 1 个成员

```text
Next
```

## DboBundleNetIter — 1 个成员

```text
Next
```

## DboBundleScalarMember — 1 个成员

```text
IsBundleMember
```

## DboBundleTemplateMap — 42 个成员

```text
AddBundleMember  AddBundleNet  AddBundleTemplate  BundleAlreadyThere  ClearEditMaps  CopyBundleDefToLib  DeleteBundleMember  ExportToDCF  GetAllUnNamedBundles  GetBundle  GetBundleMembers  GetBundleNet  GetBundleNets  GetBundleProperty  GetBundlePropertyMap  GetBundleTemplates  GetDisplayBundleName  GetInternalBundleName  GetMemerIndexFromUnnamedBundle  GetNameForUnNamedBundle  GetNextPort  GetPortIter  GetSubBundleName  GetTempName  GetUnnamedBundleOwnerObject  GetUnnamedBundleWidth  IsBundle  IsBundleMember  IsInstantiatedBundleMember  IsInternalProperty  isMemberAddable  LookUpNets  MarkModifiedDesign  MoveUpDown  NewBundleMemberIter  NewBundleNetIter  ReadOneBundle  RemoveBundleSafe  RenameBundleMember  SaveOneBundle  sGetMemberTypeIdGivenString  sGetMemberTypeStringGivenId
```

## DboBundleType — 9 个成员

```text
AddParent  GetBundleType  GetName  GetObjectType  GetParent  GetWidth  RemoveParent  SetAllParentDirty  SetName
```

## DboBus — 11 个成员

```text
CompareRanges  GetBaseName  GetBusWidth  GetMember  GetMemberPosition  IsBundleMember  IsEquivalentBusName  IsEquivalentBusNameWithBitsSwapped  NewBusMemberName  NewBusName  ValidBusName
```

## DboBusEntry — 25 个成员

```text
GetBoundingBox  GetColor  GetContainingLib  GetEndPoint  GetEndWire  GetEntryPoint  GetEntryWire  GetId  GetObjectType  GetOwner  GetUserData  IsBundle  IsBus  MarkModified  SetBoundingBox  SetColor  SetEndPoint  SetEntryPoint  SetId  SetUserData  sGetColor  sGetEndPointX  sGetEndPointY  sGetEntryPointX  sGetEntryPointY
```

## DboBusEntryData — 6 个成员

```text
Color_get  Color_set  End_get  End_set  Start_get  Start_set
```

## DboBusMemberNamesIter — 2 个成员

```text
NextBundleMemberName  NextMemberName
```

## DboCell — 9 个成员

```text
AddPart  FindPart  GetObjectType  GetPart  GetSemanticString  GetSize  IsEquivalent  NewPartNamesIter  NewPartsIter
```

## DboCellPartNamesIter — 1 个成员

```text
NextName
```

## DboCellPartsIter — 3 个成员

```text
GetKey  Next  NextPart
```

## DboColorRotMirror — 6 个成员

```text
GetColor  GetMirror  GetRotation  SetColor  SetMirror  SetRotation
```

## DboCommentText — 25 个成员

```text
GetAnchorPoint  GetBoundingBox  GetFont  GetFontId  GetHorizontalTextJustification  GetLocation  GetObjectType  GetText  IsFontDefault  Move  SetAnchorPoint  SetBoundingBox  SetFont  SetHorizontalTextJustification  SetLocation  SetRecalBoundingBox  SetText  sGetBoundingBoxBottom  sGetBoundingBoxLeft  sGetBoundingBoxRight  sGetBoundingBoxTop  sGetFont  sGetLocationX  sGetLocationY  sGetText
```

## DboConnectivityChangeIter — 4 个成员

```text
NextAddorModifiedDbObject  NextDeletedDbObject  NextFlatNetChange  NextPinChange
```

## DboConnectivityObjectsAtPointIter — 3 个成员

```text
GetKey  Next  NextObject
```

## DboCustomItemInstance — 9 个成员

```text
GetCookie  GetInterfaceID  GetOwningOccurrence  GetPluginName  GetType  SetCookie  SetInterfaceID  SetPluginName  SetType
```

## DboDBPropsIter — 2 个成员

```text
Next  NextDBProp
```

## DboDBQuery — 20 个成员

```text
GetPortOccFromCanonicalName  sClearPathHistory  sCreateCanonicalNameForCMObjects  sFindFlatNetFromCanonicalName  sGetAllFlatNetsOfDesign  sGetAllPartsOfDesign  sGetAllPinsOfDesign  sGetAllPinsOfFlatNet  sGetAllPinsOfPart  sGetAlternateNetName  sGetAlternatePartName  sGetAlternatePinName  sGetCurrentTime  sGetDesign  sGetFlatNetFromPortOcc  sGetFlatNetJSON  sGetLibraryFileMetadata  sGetObjectsFromJSON  sGetPinNumber  sGetPinPhysicalNameToPortOccMap
```

## DboDefinition — 4 个成员

```text
DBPropsList_get  DBPropsList_set  nNameID_get  nNameID_set
```

## DboDeletedObject — 3 个成员

```text
GetObjectType  GetParentObj  SetNextState
```

## DboDesign — 85 个成员

```text
AddInstOccToPackageInstOcc  AnnotateControlExists  AuditDBObserver  DesignHasExternalSchematics  DesignHasOccurrenceProperties  DesignHasReusedSchematics  EndDBBatchUpdate  GetCISDesign  GetCISNotStuffedString  GetContainingLib  GetDCFPath  GetDesignExtDataJson  GetDesignId  GetDesignLoadStateInCM  GetDesignModifiedTime  GetFlatNetfrmId  GetFlatNetfrmName  GetFlatNetNamefrmId  GetInstOccsOfCachedPackages  GetInstOccurrence  GetInstOccurrenceByName  GetInstOccurrenceByRef  GetModifiedFlatNets  GetNetOccurrence  GetNetOccurrenceByRef  GetObjectType  GetOccurrence  GetOffPageOccurrence  GetOffPageOccurrenceByRef  GetOpenCISDesign  GetPackageInstOcc  GetPageFromID  GetParentObj  GetPortOccurrence  GetPortOccurrenceByRef  GetPowerPinsVisible  GetRefDesMgr  GetRoot  GetRootName  GetRootOccurrence  GetRootSchematic  GetTitleBlockOccurrence  GetTitleBlockOccurrenceByRef  HasBoardNetlistGenerated  HasRootOccurrence  IsDesignCMDisabled  IsDesignCMEnabled  IsDesignInOccurrenceMode  IsDesignPartiallyCMEnabled  IsFlatDesign  isFlatNetsPresent  isHSObjectsExist  IsModified  IsPNNMActive  IsRemovePNNMSelected  IsRootOccurrenceExisting  LimitExceededNets  LimitExceededParts  MarkModified  NewCachesIter  NewConnectivityChangeIter  NewFlatNetsIter  NewGlobalsIter  NewOccurrencesIter  NewPackageInstOccurrenceIter  NewSchematicOccurrencesIter  OccurrencesExist  ParseDesignExtDataJson  RegisterAuditCBFn  RemoveInstOccFromPackageInstOcc  ResumeDBTracking  SetBoardNetListGenerated  SetCISNotStuffedString  SetConnectivityUpdateTracking  setDesignLoadStateInCM  SetIsPNNMActive  SetPowerPinsVisible  SetRemovePNNMSelected  SetRoot  sGetOpenPwdDialog  sGetPasswordFromUser  StartDBBatchUpdate  SubscribeForDBChange  SuspendDBTracking  UnsubscribeForDBChange
```

## DboDesignCachesIter — 3 个成员

```text
GetKey  Next  NextDesignCache
```

## DboDesignFlatNetsIter — 3 个成员

```text
GetKey  Next  NextFlatNet
```

## DboDesignGlobalsIter — 3 个成员

```text
GetKey  Next  NextGlobal
```

## DboDesignOccurrencesIter — 3 个成员

```text
GetKey  Next  NextOccurrence
```

## DboDesignPackageInstOccIter — 3 个成员

```text
GetKey  Next  NextPkgInstOcc
```

## DboDesignSchematicOccurrencesIter — 4 个成员

```text
GetKey  HasOccurrences  Next  NextSchematicOccurrence
```

## DboDesignUpdateOccurrenceBlockerManager — 1 个成员

```text
Release
```

## DboDevice — 30 个成员

```text
Cleanup  DeletePinNumber  DeletePinNumberAtPosition  GeneratePinNumber  GetCell  GetCellName  GetContainingLib  GetDesignator  GetIsShared  GetObjectType  GetOwner  GetParentObj  GetPinCount  GetPinNumber  GetPinPosition  GetPinSwapId  GetPosition  GetSemanticString  GetSize  IsEquivalent  MarkModified  NewPinNumber  NewPinNumbersIter  SetCell  SetDesignator  SetIsShared  SetPinNumber  SetPinSwapId  sGetDesignator  sGetSize
```

## DboDevicePinNumbersIter — 1 个成员

```text
NextNumber
```

## DboDirectory — 21 个成员

```text
ClearModified  ClearObject  GetCreateTime  GetEntry  GetModifyTime  GetObject  GetPackageFromMemory  GetSaveTime  GetTimeZone  GetTimeZoneOffset  IsAnyEntryModified  IsInMemory  IsModified  IsSaved  MarkModified  MarkSaved  MarkToBeDeleted  MarkToBeSaved  NewEntriesIter  NewObjectsIter  ReadPackageModifiedTime
```

## DboDirectoryEntriesIter — 1 个成员

```text
NextEntry
```

## DboDirectoryEntry — 4 个成员

```text
m_Name_get  m_Name_set  m_Rec_get  m_Rec_set
```

## DboDirectoryObjectsIter — 1 个成员

```text
NextObject
```

## DboDirectoryRec — 20 个成员

```text
bModified_get  bModified_set  bSaved_get  bSaved_set  bToBeDeleted_get  bToBeDeleted_set  bToBeSaved_get  bToBeSaved_set  nCreatedTime_get  nCreatedTime_set  nDBRelease_get  nDBRelease_set  nDBVersion_get  nDBVersion_set  nModifiedTime_get  nModifiedTime_set  nType_get  nType_set  pObject_get  pObject_set
```

## DboDisplayProp — 50 个成员

```text
GetActualValueString  GetAnchorPoint  GetBoundingBox  GetColor  GetContainingLib  GetDefaultFontType  GetDisplayType  GetFont  GetFontID  GetHorizontalTextJustification  GetId  GetLocation  GetName  GetObjectType  GetOwner  GetParentObj  GetRotation  GetValueString  GetValueStringForOccurrence  IsBoundingBoxDirty  IsFontDefault  MarkModified  SetAnchorPoint  SetBoundingBox  SetBoundingBoxDirty  SetColor  SetDisplayType  SetFont  SetHorizontalTextJustification  SetId  SetLocation  SetName  SetOwnerBoundingBoxDirty  SetRotation  SetValueString  sGetColor  sGetDisplayType  sGetFont  sGetLocationX  sGetLocationY  sGetName  sGetRotation  sGetValue  sSetColor  sSetDisplayType  sSetFont  sSetLocationX  sSetLocationY  sSetName  sSetRotation
```

## DboDisplayPropsIter — 3 个成员

```text
GetKey  Next  NextProp
```

## DboDrawnInst — 16 个成员

```text
ChangePinNamesIfPartOfBundle  DeleteEffectiveProp  DeletePinForBundle  DeletePortInst  GetDefiningSymbol  GetUnnamedNetgroupPortOrder  NewPortInstBus  NewPortInstScalar  NormalizeBundleBlock  NormalizeUnanamedBundleBlockIfAutoGenerated  PushUserPropertiesToNets  SetBoundingBox  SetEffectivePropStringValue  SetReference  StatefulCreate  SwapPortInstForBundle
```

## DboEffectivePropsIter — 1 个成员

```text
NextEffectiveProp
```

## DboEllipse — 20 个成员

```text
GetBoundingBox  GetFillStyle  GetHatchStyle  GetLineStyle  GetLineWidth  GetObjectType  Move  SetBoundingBox  SetFillStyle  SetHatchStyle  SetLineStyle  SetLineWidth  sGetBoundingBoxBottom  sGetBoundingBoxLeft  sGetBoundingBoxRight  sGetBoundingBoxTop  sGetFillStyle  sGetHatchStyle  sGetLineStyle  sGetLineWidth
```

## DboEllipseData — 10 个成员

```text
Bound_get  Bound_set  FillStyle_get  FillStyle_set  HatchStyle_get  HatchStyle_set  LineStyle_get  LineStyle_set  LineWidth_get  LineWidth_set
```

## DboERC — 10 个成员

```text
GetDetail  GetError  GetLocationString  GetSeverity  SetLocation  SetMirror  SetRotation  sGetDetail  sGetError  sGetSeverity
```

## DboExtBlobHandler — 6 个成员

```text
Construct  getType  getVersion  Serialize  setType  setVersion
```

## DboExtBlobHandlerExtMask — 2 个成员

```text
Construct  Serialize
```

## DboExtBlobHandlerImage — 2 个成员

```text
Construct  Serialize
```

## DboExtBlobHandlerLineStyle — 2 个成员

```text
Construct  Serialize
```

## DboExtBlobHandlerPassThru — 2 个成员

```text
Construct  Serialize
```

## DboExtBlobHandlerRegistry — 5 个成员

```text
GetPassThruHandler  LookupHandler  RegisterHandler  RemoveHandler  sGetInstance
```

## DboExtBlobNode — 33 个成员

```text
BlobNodeData_t  BlobNodeData_t_m_Bitmap_get  BlobNodeData_t_m_Bitmap_set  BlobNodeData_t_m_Id_get  BlobNodeData_t_m_Id_set  BlobNodeData_t_m_Seq_get  BlobNodeData_t_m_Seq_set  BlobNodeData_t_m_Stream_get  BlobNodeData_t_m_Stream_set  BlobNodeData_t_m_StreamSize_get  BlobNodeData_t_m_StreamSize_set  BlobNodeData_t_m_Type_get  BlobNodeData_t_m_Type_set  BlobNodeData_t_m_Version_get  BlobNodeData_t_m_Version_set  GetBitmap  GetId  GetNodeDataSize  GetSequence  GetStream  GetStreamSize  GetType  GetVersion  InitBlob  LoadNodeData  SetBitmap  SetId  SetSequence  SetStream  SetStreamSize  SetType  SetVersion  StoreNodeData
```

## DboExtBlobNodeExtMask — 3 个成员

```text
Init  LoadNodeData  StoreNodeData
```

## DboExtBlobNodeImage — 10 个成员

```text
GetImageStream  GetImageStreamSize  GetImageType  Init  LoadNodeData  SetImageStream  SetImageType  sImageTypeToName  sNameToImageType  StoreNodeData
```

## DboExtBlobNodePassThru — 6 个成员

```text
GetPassThruStream  GetPassThruStreamSize  Init  LoadNodeData  SetPassThruStream  StoreNodeData
```

## DboExtBlobNodePsp2Cap — 4 个成员

```text
GetData  LoadNodeData  SetData  StoreNodeData
```

## DboExtCentral — 8 个成员

```text
CopyExtensions  CreateBlobExtension  CreateExtension  GetBlobExtension  GetExtension  RegisterBlobHandler  SetExtension  sGetInstance
```

## DboExtension — 9 个成员

```text
Copy  GetDataHeaderSize  GetExtensionName  GetExtensionType  GetSignature  IsSignatureValid  IsValid  IsValidType  Store
```

## DboExtensionCreator — 1 个成员

```text
Create
```

## DboExtensionDataT — 8 个成员

```text
m_Data_get  m_Data_set  m_DataSize_get  m_DataSize_set  m_DataType_get  m_DataType_set  m_ExtensionType_get  m_ExtensionType_set
```

## DboExtensionFactory — 3 个成员

```text
CreateBlobExtension  CreateExtension  sGetInstance
```

## DboExtensionGeneric — 3 个成员

```text
Copy  sLoad  Store
```

## DboExtensionIter — 1 个成员

```text
NextExtension
```

## DboExtensionManager — 14 个成员

```text
AddExtension  CopyExtensions  CreateHandle  DeleteHandle  GetExtension  GetNumElements  IsEmpty  LoadExtensions  NewExtensionIter  RemoveAllExtensions  RemoveExtension  ReplaceExtension  sGetInstance  StoreExtensions
```

## DboExtensionMaskInfo — 10 个成员

```text
Copy  GetBitmask  GetMask  IsBitmaskAllowed  SetBitmask  SetMask  sGetExtension  sLoad  Store  UnsetBitmask
```

## DboExtnAttrLockPvt — 23 个成员

```text
Copy  GetLockInfo  GetLockMask  GetNext  GetNumNode  GetPropName  GetTrigger  IsAttributeLockingSupported  IsDeleteLocked  IsDisplayLocked  IsLocationLocked  IsPostTriggerSupported  IsPretriggerSupported  IsSystemLocked  IsValueLocked  ResetLock  SetLock  SetLockInfo  SetNext  SetTrigger  sGetExtension  sLoad  Store
```

## DboExtnPropertyBag — 10 个成员

```text
AddProperty  Copy  GetBagTypeString  GetPropertyBag  GetPropertyNameValueMap  GetPropertyTypeMap  GetPropertyValue  sGetExtension  sLoad  Store
```

## DboFill — 12 个成员

```text
GetFillStyle  GetHatchStyle  GetObjectType  GetStart  Move  SetFillStyle  SetHatchStyle  SetStart  sGetFillStyle  sGetHatchStyle  sGetStartX  sGetStartY
```

## DboFlatNet — 31 个成员

```text
ComputeName  DeleteEffectiveProp  GetAttributeLockingInfo  GetColor  GetContainingLib  GetEffectivePropStringValue  GetFlatNetCanonicalName  GetId  GetIsGlobal  GetIsPower  GetLineStyle  GetLineWidth  GetName  GetNameStrategy  GetObjectOccurrences  GetObjectType  GetOwner  GetParentObj  GetTopNet  NewEffectivePropsIter  NewNetOccurrencesIter  NewNetsIter  NewPortOccurrencesIter  NewWiresIter  SetEffectivePropStringValue  sGetColor  sGetId  sGetIsGlobal  sGetLineStyle  sGetLineWidth  sGetName
```

## DboFlatNetEffectivePropsIter — 1 个成员

```text
NextEffectiveProp
```

## DboFlatNetNetOccurrencesIter — 3 个成员

```text
GetKey  Next  NextNetOccurrence
```

## DboFlatNetNetsIter — 3 个成员

```text
GetKey  Next  NextNet
```

## DboFlatNetPortOccurrencesIter — 3 个成员

```text
GetKey  Next  NextPortOccurrence
```

## DboFlatNetWiresIter — 3 个成员

```text
GetKey  Next  NextWire
```

## DboFontAndRotation — 4 个成员

```text
GetFontID  GetRotation  SetFontID  SetRotation
```

## DboGlobal — 5 个成员

```text
GetGlobalSymbol  GetPinType  SetMirror  SetName  SetRotation
```

## DboGraphicArcInst — 18 个成员

```text
GetDboArc  Move  SetBoundingRect  SetEnd  SetLineStyle  SetLineWidth  SetStart  sGetBoundingBoxBottom  sGetBoundingBoxLeft  sGetBoundingBoxRight  sGetBoundingBoxTop  sGetEndX  sGetEndY  sGetLineStyle  sGetLineWidth  sGetStartX  sGetStartY  StatefulCreate
```

## DboGraphicBezierInst — 9 个成员

```text
GetDboBezier  Move  MovePoint  NewPoint  SetLineStyle  SetLineWidth  sGetLineStyle  sGetLineWidth  StatefulCreate
```

## DboGraphicBitMapInst — 7 个成员

```text
GetBoundingBox  GetDboBitMap  SetBoundingBox  sGetBottom  sGetLeft  sGetRight  sGetTop
```

## DboGraphicBoxInst — 17 个成员

```text
GetDboBox  Move  SetFillStyle  SetHatchStyle  SetLineStyle  SetLineWidth  SetLowerRight  SetUpperLeft  sGetBottom  sGetFillStyle  sGetHatchStyle  sGetLeft  sGetLineStyle  sGetLineWidth  sGetRight  sGetTop  StatefulCreate
```

## DboGraphicCommentTextInst — 14 个成员

```text
GetDboCommentText  Move  SetFont  SetLocation  SetText  sGetBoundingBoxBottom  sGetBoundingBoxLeft  sGetBoundingBoxRight  sGetBoundingBoxTop  sGetFont  sGetLocationX  sGetLocationY  sGetText  StatefulCreate
```

## DboGraphicEllipseInst — 16 个成员

```text
GetDboEllipse  Move  SetBoundingRect  SetFillStyle  SetHatchStyle  SetLineStyle  SetLineWidth  sGetBoundingBoxBottom  sGetBoundingBoxLeft  sGetBoundingBoxRight  sGetBoundingBoxTop  sGetFillStyle  sGetHatchStyle  sGetLineStyle  sGetLineWidth  StatefulCreate
```

## DboGraphicInstance — 48 个成员

```text
DeleteAllDisplayProps  DeleteUserProp  DeleteUserPropValue  Drag  GetBoundingBox  GetColor  GetContainingLib  GetDefiningGraphicObject  GetDisplayPropsPermitted  GetDispPropArray  GetEffectivePropStringValue  GetEffectivePropStringValueNC  GetGridLocation  GetId  GetLocation  GetMirror  GetName  GetObjectType  GetOffsetBoundingBox  GetOffsetGraphicPoint  GetOwner  GetParentObj  GetRotation  GetSourceDefinition  GetSourceLibName  GetUserData  MarkModified  Move  NewDisplayProp  NewDisplayPropsIter  NewEffectivePropsIter  NewUserProp  SetBoundingBox  SetColor  SetId  SetLocation  SetMirror  SetName  SetObjectType  SetRotation  SetUserData  SetUserPropStringValue  sGetColor  sGetLocationX  sGetLocationY  sGetMirror  sGetName  sGetRotation
```

## DboGraphicInstEffectivePropsIter — 1 个成员

```text
NextEffectiveProp
```

## DboGraphicLineInst — 13 个成员

```text
GetDboLine  Move  SetEnd  SetLineStyle  SetLineWidth  SetStart  sGetEndX  sGetEndY  sGetLineStyle  sGetLineWidth  sGetStartX  sGetStartY  StatefulCreate
```

## DboGraphicObject — 24 个成员

```text
Clear  DeleteVector  GetBoundingBox  GetColor  GetGraphicsArray  NewArc  NewBezier  NewBitMap  NewBox  NewCommentText  NewEllipse  NewFill  NewLine  NewOleEmbed  NewPolygon  NewPolyline  NewSymbolVector  NewVectorsIter  PinsAllowed  SetBoundingBox  SetColor  sGetColor  sGetName  sSetColor
```

## DboGraphicObjectVectorsIter — 1 个成员

```text
NextVector
```

## DboGraphicOleEmbedInst — 7 个成员

```text
GetBoundingBox  GetDboOleEmbed  SetBoundingBox  sGetBottom  sGetLeft  sGetRight  sGetTop
```

## DboGraphicPolygonInst — 13 个成员

```text
GetDboPolygon  Move  MovePoint  NewPoint  SetFillStyle  SetHatchStyle  SetLineStyle  SetLineWidth  sGetFillStyle  sGetHatchStyle  sGetLineStyle  sGetLineWidth  StatefulCreate
```

## DboGraphicPolylineInst — 9 个成员

```text
GetDboPolyline  Move  MovePoint  NewPoint  SetLineStyle  SetLineWidth  sGetLineStyle  sGetLineWidth  StatefulCreate
```

## DboGraphicSymbolVectorInst — 1 个成员

```text
GetDboSymbolVector
```

## DboInstanceDisplayPropsIter — 3 个成员

```text
GetKey  Next  NextProp
```

## DboInstData — 8 个成员

```text
bMirror_get  bMirror_set  Color_get  Color_set  Location_get  Location_set  Rotation_get  Rotation_set
```

## DboInstOccMapper — 4 个成员

```text
GetOccurrenceFromParent  GetOccurrences  GetOccurrencesAtPos  GetOccurrencesCount
```

## DboInstOccurrence — 88 个成员

```text
AddVariantProp  ApplyIds  CheckAndCorrectSubTreeOccurrences  ClearVariantMap  Copy  CopyOccData  DeleteDBProp  DeleteEffectiveProp  ExpandOccurrences  ExpandSubTreeOccurrences  FindInstance  FindPartInst  GetCanonicalName  GetCanonicalRefDes  GetCdsRefRangeMap  GetCellName  GetContents  GetDesignator  GetEffectivePropValueChoices  GetEffectivePropValueExists  GetEffectivePropValueType  GetFlatNet  GetHdlName  GetHierPathName  GetImplementationName  GetInstance  GetInstChildrenCount  GetInstOccurrence  GetInstOccurrenceByHierPath  GetInstOccurrenceByName  GetInstOccurrenceByRef  GetLibName  GetNetAndPortsValid  GetNetOccurrence  GetNextNewVariantProp  GetObjectType  GetOffPageOccurrence  GetPackageInstOcc  GetPartInst  GetPartInstId  GetPartInstNameForCanonicalPath  GetPartValue  GetPathName  GetPathNameNumber  GetPortOccurrence  GetPortOccurrenceFromPinNumber  GetPrefixReferenceRange  GetPropertyValuePrefixReferenceRange  GetReference  GetReferenceDesignator  GetReferenceRange  GetRefPathName  GetSchematic  GetTitleBlockOccurrence  GetVariantProp  GetViewStr  HasChildren  HasPropertyThatExists  IsNetlistIgnore  IsPartInstBelongToExternalDesign  IsPrimitive  IsPSpiceOnly  IsRecursive  IsVariantPropMapEmpty  NewChildrenIter  NewEffectivePropsIter  ProcessFlatNetForPartRename  SetDesignator  SetEffectivePropStringValue  SetEffectivePropStringValueForced  SetOnDiscardedPage  SetPackageInstOcc  SetPartInstId  SetPartValue  SetReference  SetReferenceRange  sGetContentsLibName  sGetContentsViewName  sGetContentsViewType  sGetDesignator  sGetId  sGetIsPrimitive  sGetName  sGetPartValue  sGetPathName  sGetReference  sGetReferenceDesignator  UpdateNetAndPorts
```

## DboInstOccurrenceEffectivePropsIter — 1 个成员

```text
NextEffectiveProp
```

## DboInvalidDeleteException — 1 个成员

```text
what
```

## DboInvalidPointerAccessException — 1 个成员

```text
what
```

## DboJsonUtils — 1 个成员

```text
GetPrefixReferenceRange
```

## DboLib — 325 个成员

```text
AbortTransactions  AddStringToStringTable  CacheIsOutOfDate  ChangePassword  CleanupCache  ClearModified  ClearModifiedAll  ClearPackageAll  ClearSaveFlag  ClearUpRevDialogBit  ComparePackageTimeFromDisk  ConvertRequired  CopyCacheFromFile  CopyCell  CopyGraphicObject  CopyGraphicObjectFromFile  CopyLibObject  CopyObjectFromFile  CopyPackage  CopyPackageAll  CopyPackageAllToCache  CopyPart  CopySymbol  CopySymbolFromFile  CopyView  CorrectCacheEntry  DeleteCell  DeleteGraphicObject  DeleteLibObject  DeleteLibStoragePtr  DeletePackage  DeletePackageAlias  DeletePackageAll  DeletePart  DeleteSymbol  DeleteView  DumpDirectoryInfo  ExplicitlyAddCellDirName  ExplicitlyAddPackageDirName  ExplicitlyAddPartDirName  ExplicitlyRemoveAliasName  ExplicitlyRemoveCellDirName  ExplicitlyRemoveExportBlockDirName  ExplicitlyRemoveGraphicDirName  ExplicitlyRemovePackageDirName  ExplicitlyRemovePartDirName  ExplicitlyRemovePartsDirName  ExplicitlyRemoveSymbolDirName  ExplicitlyRemoveViewDirName  FixupMismatchedLibPartLookupNames  GetBitFlag  GetBookMarkSymbol  GetBundleDef  GetBundleTemplateMap  GetBundleTemplateMapForObject  GetCachedCell  GetCachedGraphicObject  GetCachedPackage  GetCachedPart  GetCachedSymbol  GetCachedTime  GetCell  GetCellCreateTime  GetCellModifyTime  GetContainingLib  GetCreateTime  GetDataFormatVersion  GetDataRelease  GetDataVersion  GetDefaultDrawnInstIsPrimitive  GetDefaultFont  GetDefaultHorizontalLabelCount  GetDefaultHorizontalLabelIsAscending  GetDefaultHorizontalLabelIsChar  GetDefaultHorizontalLabelWidth  GetDefaultIsANSIGridRefs  GetDefaultIsBorderDisplayed  GetDefaultIsBorderPrinted  GetDefaultIsGridRefDisplayed  GetDefaultIsGridRefPrinted  GetDefaultIsMetric  GetDefaultIsTitleBlockDisplayed  GetDefaultIsTitleBlockPrinted  GetDefaultPageRec  GetDefaultPinToPin  GetDefaultPlacedInstIsPrimitive  GetDefaultVerticalLabelCount  GetDefaultVerticalLabelIsAscending  GetDefaultVerticalLabelIsChar  GetDefaultVerticalLabelWidth  GetDirectoryEntryTimeZone  GetDirectoryEntryTimeZoneValue  GetEffectivePropValueChoices  GetERCSymbol  GetExportBlock  GetExportBlockCreateTime  GetExportBlockModifyTime  GetExternalView  GetFont  GetFontId  GetGlobalSymbol  GetGraphicObject  GetGraphicObjectCreateTime  GetGraphicObjectModifyTime  GetIndexForString  GetLibStoragePtr  GetModifiedPackages  GetModifiedTime  GetModifiedTimeInUTC  GetModifyTime  GetName  GetObjectType  GetOffPageSymbol  GetOldName  GetOrStorageStream  GetOwner  GetPackage  GetPackageCreateTime  GetPackageFromMemory  GetPackageModifiedTime  GetPackageModifyTime  GetPackageTimeZone  GetParentObj  GetPart  GetPartCreateTime  GetPartFieldMapping  GetPartModifyTime  GetPinShapeSymbol  GetPortSymbol  GetSaveAsRelease  GetSaveAsVersion  GetSchematic  GetSourceLibName  GetSourceTimeZone  GetStringPtrFromIndex  GetSymbol  GetSymbolCreateTime  GetSymbolModifyTime  GetSymbolTimeZone  GetTempPackageName  GetTempViewName  GetTitleBlockSymbol  GetUpdatedPackage  GetUserStorage  GetView  GetViewCreateTime  GetViewModifyTime  IsAutoBackupOn  IsAutoSaving  IsBitSet  isBundleTemplateExists  IsBundleUsed  IsCacheTimeSameAsSource  IsCheckOn  IsCorrectOn  IsLibModifiedOnDisk  IsModified  IsModifiedSinceAutoSave  IsModifiedSinceLastAutoBackup  IsObjectModified  IsOccRetainAndRemapMode  IsPackageInMemory  IsPasswordProtected  IsPersistent  IsRemoveBundleSelected  IsSymbolInMemory  IsUnnamedBundle  IsUpRevDialogBitSet  LibTitle  LimitExceeded  MarkModified  NewBookMarkSymbol  NewCachedCell  NewCachedPackage  NewCachedPart  NewCachedSymbol  NewCachesIter  NewCell  NewCellNamesIter  NewCellsIter  NewChangedObjectsIter  NewERCSymbol  NewExportBlockNamesIter  NewExportBlocksIter  NewExternalView  NewGlobalSymbol  NewGraphicNamesIter  NewGraphicObject  NewGraphicObjectsIter  NewOffPageSymbol  NewPackage  NewPackageAlias  NewPackageAliasesIter  NewPackageNamesIter  NewPackagesIter  NewPart  NewPartNamesIter  NewPartsIter  NewPinShapeSymbol  NewPortSymbol  NewSchematic  NewSymbolNamesIter  NewSymbolsIter  NewTitleBlockSymbol  NewUntitledName  NewUnusedCacheEntriesIter  NewViewNamesIter  NewViewsIter  OnChangeBundleDefinition  PackageExists  ReadForExistenceOfBundleMapData  ReadPackage  RefreshPackageDirectory  RegenerateMissingCell  RemoveBundles  RemoveCell  RemoveGraphicObject  RemoveOrStorageStream  RemovePackage  RemovePart  RemovePassword  RemoveSymbol  RemoveView  RenameObject  RenameOrStorageStream  ReplaceCache  ReplaceSourceLibName  SaveAsRequired  SaveBookMarkSymbol  SaveCell  SaveERCSymbol  SaveExternalView  SaveGlobalSymbol  SaveGraphicObject  SaveObject  SaveOffPageSymbol  SavePackage  SavePackageAll  SavePart  SavePinShapeSymbol  SavePortSymbol  SaveSchematic  SaveSymbol  SaveTitleBlockSymbol  SaveView  sEquivalentNames  SetBit  SetCheckFlag  SetCorrectFlag  SetDataRelease  SetDataVersion  SetDefaultDrawnInstIsPrimitive  SetDefaultFont  SetDefaultHorizontalLabelCount  SetDefaultHorizontalLabelIsAscending  SetDefaultHorizontalLabelIsChar  SetDefaultHorizontalLabelWidth  SetDefaultIsANSIGridRefs  SetDefaultIsBorderDisplayed  SetDefaultIsBorderPrinted  SetDefaultIsGridRefDisplayed  SetDefaultIsGridRefPrinted  SetDefaultIsMetric  SetDefaultIsTitleBlockDisplayed  SetDefaultIsTitleBlockPrinted  SetDefaultPinToPin  SetDefaultPlacedInstIsPrimitive  SetDefaultVerticalLabelCount  SetDefaultVerticalLabelIsAscending  SetDefaultVerticalLabelIsChar  SetDefaultVerticalLabelWidth  SetFont  SetIsAutoBackupOn  SetIsAutoSaving  SetIsBundleSaveInProgress  SetLibStoragePtr  SetPartFieldMapping  SetPassword  SetUpRevDialogBit  sGetCreateTime  sGetDefaultAliasFont  sGetDefaultBookMarkFont  sGetDefaultBorderFont  sGetDefaultCommentFont  sGetDefaultDrawnInstIsPrimitive  sGetDefaultDrawnInstNameFont  sGetDefaultERCFont  sGetDefaultGraphicObjectFont  sGetDefaultNetNameFont  sGetDefaultNoConnectFont  sGetDefaultOffPageConnectorFont  sGetDefaultOptimizerFont  sGetDefaultParameterFont  sGetDefaultPartReferenceFont  sGetDefaultPartValueFont  sGetDefaultPinNameFont  sGetDefaultPinNumberFont  sGetDefaultPlacedInstIsPrimitive  sGetDefaultPortFont  sGetDefaultPowerFont  sGetDefaultPropertyFont  sGetDefaultPSpiceABMSymbolFont  sGetDefaultPSpiceSimulationDirectiveSymbolFont  sGetDefaultPSpiceSourceSymbolFont  sGetDefaultStimulusSymbolFont  sGetDefaultTitleBlockFont  sGetModifyTime  sGetName  sGetNormalizedName  sGetNormalizedObjectName  sGetTempName  sGetTimeFormat  sGetUnNormalizedObjectName  SizeOfLibTitle  SkipGraphicObjectOnFile  SkipObjectOnFile  SkipSymbolOnFile  sSetTimeFormat  sSplitName  strgStatus_get  strgStatus_set  SymbolExists  TimeToString  TopologicalOrderingOfBundlesUsed  UpdateCache
```

## DboLibCachesIter — 3 个成员

```text
GetKey  Next  NextCachedObject
```

## DboLibCellNamesIter — 1 个成员

```text
NextName
```

## DboLibCellsIter — 3 个成员

```text
GetKey  Next  NextCell
```

## DboLibChangedObjectsIter — 3 个成员

```text
GetKey  Next  NextObject
```

## DboLibExportBlockNamesIter — 1 个成员

```text
NextName
```

## DboLibExportBlocksIter — 3 个成员

```text
GetKey  Next  NextExportBlock
```

## DboLibGraphicNamesIter — 1 个成员

```text
NextName
```

## DboLibGraphicsIter — 3 个成员

```text
GetKey  Next  NextGraphicObject
```

## DboLibObject — 19 个成员

```text
GetContainingLib  GetCreateTime  GetModifyTime  GetName  GetObjectType  GetOwner  GetParentObj  GetSemanticString  GetSourceLibName  IsCachedCopy  IsEquivalent  IsModified  IsOutOfDate  IsPersistent  MarkModified  SetName  SetObjectType  SetSourceLibName  sGetName
```

## DboLibPackageAliasesIter — 1 个成员

```text
NextAlias
```

## DboLibPackageNamesIter — 1 个成员

```text
NextName
```

## DboLibPackagesIter — 3 个成员

```text
GetKey  Next  NextPackage
```

## DboLibPart — 38 个成员

```text
GetCellPtr  GetContents  GetContentsLibName  GetContentsViewName  GetContentsViewType  GetPackagePtr  GetPartValue  GetPin  GetPinNamesAreRotated  GetPinNamesAreVisible  GetPinNumbersAreVisible  GetReference  GetReferenceDesignator  GetSemanticString  GetSuffix  IsEquivalent  MarkModified  NewLPinsIter  SetCellPtr  SetContentsLibName  SetContentsViewName  SetContentsViewType  SetPackagePtr  SetPartValue  SetPinNamesAreRotated  SetPinNamesAreVisible  SetPinNumbersAreVisible  SetReference  sGetContentsLibName  sGetContentsViewName  sGetContentsViewType  sGetPartValue  sGetPinCount  sGetPinNamesAreRotated  sGetPinNamesAreVisible  sGetPinNumbersAreVisible  sGetReference  sGetReferenceDesignator
```

## DboLibPartNamesIter — 1 个成员

```text
NextName
```

## DboLibPartPinsIter — 1 个成员

```text
NextPin
```

## DboLibPartsIter — 3 个成员

```text
GetKey  Next  NextPart
```

## DboLibSymbolNamesIter — 1 个成员

```text
NextName
```

## DboLibSymbolsIter — 3 个成员

```text
GetKey  Next  NextSymbol
```

## DboLibUnusedCacheEntriesIter — 3 个成员

```text
GetKey  Next  NextUnusedEntry
```

## DboLibViewNamesIter — 1 个成员

```text
NextName
```

## DboLibViewsIter — 3 个成员

```text
GetKey  Next  NextView
```

## DboLine — 16 个成员

```text
GetEnd  GetLineStyle  GetLineWidth  GetObjectType  GetStart  Move  SetEnd  SetLineStyle  SetLineWidth  SetStart  sGetEndX  sGetEndY  sGetLineStyle  sGetLineWidth  sGetStartX  sGetStartY
```

## DboLineData — 8 个成员

```text
End_get  End_set  LineStyle_get  LineStyle_set  LineWidth_get  LineWidth_set  Start_get  Start_set
```

## DboMiscFileWriter — 19 个成员

```text
AddFileStream  DeleteFileStream  DumpFileAs  GetAllFileInfo  GetFileCreationTime  GetFileInfo  GetFileList  GetFilesAsSet  GetFileStreamData  GetMiscStorageForRead  GetOrCreateMiscStorageForWrite  GetOrCreateMiscStorageForWriteAtLevel4  GetStreamInfoStringType  IsOKToOverWrite  IsOKToPullIn  IsThisUserStorageCreationAllowed  ReleaseStorage  UpdateFileStream  WasStorageOpenSuccessful
```

## DboModifiedFlatNetsIter — 1 个成员

```text
NextId
```

## DboNet — 52 个成员

```text
AssertValid  ComputeNetName  DeleteEffectiveProp  DeleteUserProp  EffectivePropsMatch  GetAttributeLockingInfo  GetColor  GetContainingLib  GetEffectiveColorValue  GetEffectivePropStringValue  GetEffectivePropValueExists  GetEffectivePropValueType  GetId  GetLineStyle  GetLineWidth  GetName  GetNetName  GetObjectCount  GetObjectOccurrence  GetObjectType  GetOwner  GetParentObj  GetSchematicNet  GetUserProp  HasBundleConnection  HasNonNGOverrider  HasWireSCALARs  IsBundle  IsBundleObject  IsBusMember  IsEmpty  NewBusEntriesIter  NewEffectivePropsIter  NewGlobalsIter  NewNetAliasesIter  NewOffPageConnectorsIter  NewPortInstsIter  NewPortsIter  NewUserProp  NewWiresIter  SetColor  SetEffectiveColorValue  SetEffectivePropStringValue  SetLineStyle  SetLineWidth  SetName  SetNonNGOverrider  SetSchematicNet  sGetId  sGetName  sGetNetName  ValidateName
```

## DboNetAliasesIter — 1 个成员

```text
NextAlias
```

## DboNetBus — 12 个成员

```text
GetBundleOwner  GetMember  GetObjectType  GetPosition  GetWidth  HasMember  IsBundle  IsBundleObject  IsExpanded  NewMembersIter  RemoveMember  SetIsBundle
```

## DboNetBusEntriesIter — 3 个成员

```text
GetKey  Next  NextBusEntry
```

## DboNetBusMembersIter — 3 个成员

```text
GetKey  Next  NextMember
```

## DboNetEffectivePropsIter — 1 个成员

```text
NextEffectiveProp
```

## DboNetGlobalsIter — 3 个成员

```text
GetKey  Next  NextGlobal
```

## DboNetOccurrence — 21 个成员

```text
DeleteEffectiveProp  EffectivePropsMatch  GetAttributeLockingInfo  GetCanonicalName  GetDeletedNet  GetEffectivePropValueExists  GetFlatNet  GetInstance  GetNet  GetNetName  GetObjectType  GetPathName  GetRefPathName  GetSchematic  GetSchematicNetId  NewEffectivePropsIter  SetEffectivePropStringValue  SetSchematicNetId  sGetId  sGetNetName  sGetPathName
```

## DboNetOccurrenceEffectivePropsIter — 1 个成员

```text
NextEffectiveProp
```

## DboNetOffPageConnectorsIter — 3 个成员

```text
GetKey  Next  NextOffPageConnector
```

## DboNetPortInstsIter — 3 个成员

```text
GetKey  Next  NextPortInst
```

## DboNetPortsIter — 3 个成员

```text
GetKey  Next  NextPort
```

## DboNetScalar — 2 个成员

```text
GetBundleOwnerForBus  GetObjectType
```

## DboNetSymbol — 3 个成员

```text
GetPin  NewSymbolPinBus  NewSymbolPinScalar
```

## DboNetSymbolInstance — 24 个成员

```text
Disconnect  GetBoundingBox  GetHotSpot  GetNet  GetOccBasedOnOccId  GetOffsetHotSpot  GetSourceLibName  GetSourceSymbolName  GetSymbol  GetWire  IsBoundingBoxDirty  IsBus  Move  SetBoundingBox  SetBoundingBoxDirty  SetLocation  SetMirror  SetRotation  sGenerateBundleObjectName  sGetHotSpotX  sGetHotSpotY  sGetNetName  sGetSourceLibName  sGetSourceSymbolName
```

## DboNetWiresIter — 3 个成员

```text
GetKey  Next  NextWire
```

## DboNullPointerException — 1 个成员

```text
what
```

## DboObjectLocationStruct — 7 个成员

```text
getObject  pLocation_get  pLocation_set  pNumRows_get  pNumRows_set  pObject_get  pObject_set
```

## DboOccurrence — 30 个成员

```text
CopyOccData  DeleteUserProp  DeleteUserPropValue  GetBackannotatedStringValue  GetBackannotation  GetCanonicalName  GetContainingLib  GetDepth  GetDesignTransactionCount  GetEffectivePropStringValue  GetEffectivePropStringValueNC  GetEffectivePropValueType  GetId  GetIdPathName  GetInstance  GetObjectType  GetOccProp  GetOwner  GetParent  GetParentObj  GetPathName  GetRefPathName  GetSchematic  HasPropertyThatExists  IsRootOccurrence  MakeVHDL  NewOccurrenceEdit  NewUserProp  SetDesignTransactionCount  SetUserPropStringValue
```

## DboOccurrenceChildrenIter — 3 个成员

```text
GetKey  Next  NextOccurrence
```

## DboOffPageConnector — 6 个成员

```text
GetObjectOccurrence  GetObjectOccurrences  GetOccBasedOnOccId  SetMirror  SetName  SetRotation
```

## DboOffPageConnectorOccurrence — 22 个成员

```text
DeleteEffectiveProp  GetEffectivePropValueExists  GetEffectivePropValueType  GetId  GetInstance  GetName  GetObjectType  GetOffPageConnectorId  GetPathName  GetRefPathName  GetSchematic  GetSchematicPath  NewEffectivePropsIter  SetEffectivePropStringValue  SetEffectivePropStringValueForIref  SetId  SetOccName  SetOffPageConnectorId  sGetId  sGetName  sGetPathName  sGetSchematicPath
```

## DboOffPageConnectorOccurrenceEffectivePropsIter — 1 个成员

```text
NextEffectiveProp
```

## DboOleEmbed — 16 个成员

```text
GetBitmapDimension  GetBoundingBox  GetByte  GetDibSize  GetLocation  GetObjectType  SetBitmapDimension  SetBoundingBox  SetByte  SetLocation  sGetBoundingBoxBottom  sGetBoundingBoxLeft  sGetBoundingBoxRight  sGetBoundingBoxTop  sGetLocationX  sGetLocationY
```

## DboPackage — 34 个成员

```text
AddAlias  AddPartInst  Cleanup  DeleteDevice  GetBundleTemplateMap  GetDesignator  GetDevice  GetExternalModifiedFlag  GetObjectType  GetPCBFootprint  GetPCBLib  GetReferenceTemplate  GetSemanticString  GetSize  isBundleTemplateExists  IsEquivalent  IsHomogeneous  NewAliasesIter  NewDevice  NewDevicesIter  NewPartsIter  RemovePartInst  ReplaceSchematicNameInReferencedPartInstList  SetDesignator  SetEffectivePropStringValue  SetExternalModifiedFlag  SetName  SetPCBFootprint  SetPCBLib  SetReferenceTemplate  sGetPCBFootprint  sGetPCBLib  sGetReferenceTemplate  sGetSize
```

## DboPackageAliasesIter — 2 个成员

```text
Next  NextAlias
```

## DboPackageDevicesIter — 3 个成员

```text
GetKey  Next  NextDevice
```

## DboPackageInstOccurrencesIter — 3 个成员

```text
GetKey  Next  NextInstOccurrence
```

## DboPackageNamesIter — 1 个成员

```text
NextName
```

## DboPackagePartsIter — 3 个成员

```text
GetKey  Next  NextPart
```

## DboPackageReferencedPartInstIter — 3 个成员

```text
GetKey  Next  NextPartInst
```

## DboPage — 265 个成员

```text
AddJunctionToWire  ClearUndoRedoData  ClearUndoRedoInfo  CloseLog  Copy  CopyFromFile  CopyToFile  CreateLog  DeleteBookMark  DeleteBusEntry  DeleteCommentGraphic  DeleteCustomItemInst  DeleteDeletedObject  DeleteERC  DeleteGlobal  DeleteJunction  DeleteLabelState  DeleteOffPageConnector  DeletePartInst  DeletePort  DeleteTitleBlock  DeleteWire  DumpObjectMap  GetANSIGridRefs  GetBookMarksList  GetBorderDisplayed  GetBorderPrinted  GetBusEntriesList  GetBusEntry  GetBusEntryCount  GetColor  GetCommentGraphicCount  GetCommentGraphicsList  GetConnection  GetConnectionCount  GetContainingLib  GetCreateTime  GetCustomItemsList  GetDocUnits  GetDocUnitsPerInch  GetERCsList  GetFirstWireEndPoint  GetGlobalCount  GetGlobalsList  GetGraphicInst  GetGridRefDisplayed  GetGridRefPrinted  GetHorizontalLabelCount  GetHorizontalLabelIsAscending  GetHorizontalLabelIsChar  GetHorizontalLabelIsVisible  GetHorizontalLabelWidth  GetHorizontalSeparatorLineStyle  GetHorizontalSeparatorLineWidth  GetInnerBorderIsVisible  GetInnerBorderLineStyle  GetInnerBorderLineWidth  GetInnerBorderMargin  GetIsMetric  GetLabelArray  GetLabelColor  GetLabelFont  GetLabelState  GetLastTransactionNumber  GetModifyTime  GetName  GetNet  GetObjectType  GetOffPageConnectorCount  GetOffPageConnectorFromID  GetOffPageConnectorsList  GetOuterBorderIsVisible  GetOuterBorderLineStyle  GetOuterBorderLineWidth  GetOuterBorderMargin  GetOwner  GetPageHeight  GetPageNumber  GetPageSizeInfo  GetPageWidth  GetParentObj  GetPartInst  GetPartInstCount  GetPartInstFromSch  GetPartInstList  GetPhysicalGranularity  GetPinToPin  GetPinToPinScaleFactor  GetPort  GetPortCount  GetPortInst  GetPortsList  GetSize  GetSizeName  GetTitleBlock  GetTitleBlockDisplayed  GetTitleBlockPrinted  GetTitleBlocksList  GetTransactionCount  GetUnNamedBundleList  GetUserStorage  GetVerticalLabelCount  GetVerticalLabelIsAscending  GetVerticalLabelIsChar  GetVerticalLabelIsVisible  GetVerticalLabelWidth  GetVerticalSeparatorLineStyle  GetVerticalSeparatorLineWidth  GetWire  GetWireAtJunction  GetWireCount  GetWiresList  Import  InitUndoRedoData  IsConnectionPoint  IsLocked  IsModified  IsPersistent  IsTransactionInProgress  IsValidNetName  m_nRedo_get  m_nRedo_set  m_nUndo_get  m_nUndo_set  m_pCmdList_get  m_pCmdList_set  m_pFile_get  m_pFile_set  m_pObjMapRedo_get  m_pObjMapRedo_set  m_pObjMapUndo_get  m_pObjMapUndo_set  m_pRedoList_get  m_pRedoList_set  m_pTempObjMapRedo_get  m_pTempObjMapRedo_set  m_pTempObjMapUndo_get  m_pTempObjMapUndo_set  MarkModified  NewBookMark  NewBookMarksIter  NewBusEntriesIter  NewBusEntry  NewCommentGraphic  NewCommentGraphicsIter  NewConnectivityObjectsAtPointIter  NewCustomItemInstance  NewCustomItemsListIter  NewDeletedObject  NewDrawnInst  NewEditsIter  NewERC  NewERCsIter  NewGlobal  NewGlobalsIter  NewGraphicArcInst  NewGraphicBezierInst  NewGraphicBitMapInst  NewGraphicBitMapInstFromDib  NewGraphicBoxInst  NewGraphicCommentTextInst  NewGraphicEllipseInst  NewGraphicLineInst  NewGraphicOleEmbedInst  NewGraphicPolygonInst  NewGraphicPolylineInst  NewGraphicSymbolVectorInst  NewNetBus  NewNetScalar  NewObjectsAtPointIter  NewOffPageConnector  NewOffPageConnectorsIter  NewPartInstsIter  NewPlacedInst  NewPlacedInstVer  NewPort  NewPortsIter  NewTitleBlock  NewTitleBlocksIter  NewWireBus  NewWiresAtPointIter  NewWireScalar  NewWiresInAreaIter  NewWiresIter  NotifyChangingInstId  NotifyChangingInstName  PartAlreadyExistsWithName  PointOnHotSpot  ReplaceGraphicInst  ReplaceInst  RestorePrevState  SetANSIGridRefs  SetBorderDisplayed  SetBorderPrinted  SetColor  SetGridRefDisplayed  SetGridRefPrinted  SetHorizontalLabelCount  SetHorizontalLabelIsAscending  SetHorizontalLabelIsChar  SetHorizontalLabelIsVisible  SetHorizontalLabelWidth  SetHorizontalSeparatorLineStyle  SetHorizontalSeparatorLineWidth  SetInnerBorderIsVisible  SetInnerBorderLineStyle  SetInnerBorderLineWidth  SetInnerBorderMargin  SetIsMetric  SetLabelColor  SetLabelFont  SetLabelState  SetOuterBorderIsVisible  SetOuterBorderLineStyle  SetOuterBorderLineWidth  SetOuterBorderMargin  SetPageHeight  SetPageSizeInfo  SetPageWidth  SetPinToPin  SetSize  SetSizeName  SetTitleBlockDisplayed  SetTitleBlockPrinted  SetVerticalLabelCount  SetVerticalLabelIsAscending  SetVerticalLabelIsChar  SetVerticalLabelIsVisible  SetVerticalLabelWidth  SetVerticalSeparatorLineStyle  SetVerticalSeparatorLineWidth  sGetColor  sGetCreateTime  sGetHorizontalLabelCount  sGetHorizontalLabelIsAscending  sGetHorizontalLabelIsChar  sGetHorizontalLabelIsVisible  sGetHorizontalSeparatorLineStyle  sGetHorizontalSeparatorLineWidth  sGetInnerBorderIsVisible  sGetInnerBorderLineStyle  sGetInnerBorderLineWidth  sGetInnerBorderMarginX  sGetInnerBorderMarginY  sGetLabelColor  sGetModifyTime  sGetName  sGetOuterBorderIsVisible  sGetOuterBorderLineStyle  sGetOuterBorderLineWidth  sGetOuterBorderMarginX  sGetOuterBorderMarginY  sGetPageNumber  sGetSizeName  sGetSizeX  sGetSizeY  sGetVerticalLabelCount  sGetVerticalLabelIsAscending  sGetVerticalLabelIsChar  sGetVerticalLabelIsVisible  sGetVerticalSeparatorLineStyle  sGetVerticalSeparatorLineWidth  StartTransaction  UpdatePageState  UpdateRedoState
```

## DboPageBookMarksIter — 3 个成员

```text
GetKey  Next  NextBookMark
```

## DboPageBusEntriesIter — 3 个成员

```text
GetKey  Next  NextBusEntry
```

## DboPageCommentGraphicsIter — 3 个成员

```text
GetKey  Next  NextCommentGraphic
```

## DboPageCustomItemsListIter — 3 个成员

```text
GetKey  Next  NextCustomItem
```

## DboPageEditsIter — 1 个成员

```text
NextEdit
```

## DboPageERCsIter — 3 个成员

```text
GetKey  Next  NextERC
```

## DboPageFindGraphicInstIter — 3 个成员

```text
GetKey  Next  NextGraphicInstance
```

## DboPageGlobalsIter — 3 个成员

```text
GetKey  Next  NextGlobal
```

## DboPageNetsIter — 3 个成员

```text
GetKey  Next  NextNet
```

## DboPageObjectsAtPointIter — 3 个成员

```text
GetKey  Next  NextObject
```

## DboPageOffPageConnectorsIter — 3 个成员

```text
GetKey  Next  NextOffPageConnector
```

## DboPagePartInstsIter — 3 个成员

```text
GetKey  Next  NextPartInst
```

## DboPagePortsIter — 3 个成员

```text
GetKey  Next  NextPort
```

## DboPageStructOcc — 6 个成员

```text
getPage  getPageOcc  pageOcc_get  pageOcc_set  pPage_get  pPage_set
```

## DboPageTitleBlocksIter — 3 个成员

```text
GetKey  Next  NextTitleBlock
```

## DboPageTransaction — 7 个成员

```text
ClearTransactionHistory  DumpTransactionVector  InitAutoTransactions  InitiateInternalTransaction  PlaceUndoMarker  RegisterSchDocCommand  TerminatePage
```

## DboPageWiresIter — 3 个成员

```text
GetKey  Next  NextWire
```

## DboPartInst — 79 个成员

```text
AddVariantProp  ClearVariantMap  Connect  CountPinsWithName  Disconnect  FindPinByPinName  GetBundleEntryPinName  GetBundleEntryPortInst  GetContents  GetContentsLibName  GetContentsViewName  GetContentsViewType  GetDefiningPart  GetIsPrimitive  GetIsPrimitiveProp  GetNextNewVariantProp  GetObjectOccurrence  GetObjectOccurrences  GetOccAutoRefMode  GetPartValue  GetPin  GetPinByBasePinName  GetPinByHotSpot  GetPinByID  GetPinByPinName  GetPinByPinNumber  GetPinCount  GetPinNamesAreRotated  GetPinNamesAreVisible  GetPinNumbersAreVisible  GetPinOrderedByLocation  GetPowerPinsAreVisible  GetReference  GetReferenceDesignator  GetVariantProp  HasBundleOwner  HasMultiplePinsWithName  IsBoundingBoxDirty  IsExternalDesignPart  IsNetlistIgnore  IsOptimizerTemplate  IsPrimitive  IsPropOverridenOnAnyOcc  IsPropOverridenOnAnyOccInDesign  IsPSpiceOnly  IsVariantPropMapEmpty  Move  NewPinsIter  PositionAllDisplayProp  PositionDisplayProp  ProcessRefDesDelete  ProcessRefDesModify  ResetAllDisplayPropertiesFontToDefault  SetBoundingBoxDirty  SetContentsLibName  SetContentsViewName  SetContentsViewNameWithoutChangingOccurrences  SetContentsViewType  SetContentViewTypeWithoutChangingOccurrences  SetCurrent  SetId  SetIsPrimitiveProp  SetLocation  SetMirror  SetName  SetOccAutoRefMode  SetOccsModified  SetPartValue  SetPowerPinsAreVisible  SetReference  SetRotation  sGetContentsLibName  sGetContentsViewName  sGetContentsViewType  sGetIsPrimitive  sGetPartValue  sGetPinCount  sGetPowerPinsAreVisible  sGetReference
```

## DboPartInstPinsIter — 3 个成员

```text
GetKey  Next  NextPin
```

## DboPartTextData — 18 个成员

```text
BoundingBox_get  BoundingBox_set  FaceName_get  FaceName_set  Italic_get  Italic_set  Location_get  Location_set  nPtSize_get  nPtSize_set  Rotation_get  Rotation_set  Text_get  Text_set  Underline_get  Underline_set  Weight_get  Weight_set
```

## DboPathMgr — 43 个成员

```text
DboFileEncryptionData  DboFileEncryptionData_mbEncrypted_get  DboFileEncryptionData_mbEncrypted_set  DboFileEncryptionData_mFileName_get  DboFileEncryptionData_mFileName_set  DboFileEncryptionData_mPassword_get  DboFileEncryptionData_mPassword_set  DboFileEncryptionData_mRefCount_get  DboFileEncryptionData_mRefCount_set  DboFileEncryptionData_mState_get  DboFileEncryptionData_mState_set  DboPathRecordS  DboPathRecordS_mAccessible_get  DboPathRecordS_mAccessible_set  DboPathRecordS_mFullPath_get  DboPathRecordS_mFullPath_set  DboPathRecordS_mReadOnly_get  DboPathRecordS_mReadOnly_set  sClearPathHistory  sCmpCh  sComparePaths  sConvertToAbsolutePath  sDisableFileLookupNotifaction  sDumpToSessionLog  sExit  sFindAbsolutePath  sFindFileDir  sFindRelativePath  sForgetReadOnlyAttribute  sGetAllPaths  sGetFileStatus  sGetFullPath  sGetLegacySaveAs  sGetPathLookupTimeout  sInit  sIsPathAbsolute  sIsReadOnly  sLookupPath  sNormalizePath  sNotifyFileLookup  sSetExitWaitTimeout  sSetLegacySaveAs  sSetPathLookupTimeout
```

## DboPinData — 10 个成员

```text
Connect_get  Connect_set  Name_get  Name_set  PinStyle_get  PinStyle_set  PinType_get  PinType_set  Start_get  Start_set
```

## DboPinShapeSymbol — 2 个成员

```text
GetPinType  SetPinType
```

## DboPkgInstOcc — 8 个成员

```text
AddInstOcc  GetInstOccCount  GetObjectType  GetOwner  GetParentObj  GetReference  NewPkgInstOccIter  RemoveInstOcc
```

## DboPlacedInst — 36 个成员

```text
CheckAndResetDisplayProperty  GetDevice  GetDeviceDesignator  GetEffectivePropValueChoices  GetEffectivePropValueType  GetGraphicName  GetPackage  GetPart  GetPartValue  GetPCBFootprint  GetPCBLib  GetReferenceDesignator  GetSourceDevice  GetSourceDeviceDesignator  GetSourceDevicePosition  GetSourceLibName  GetSourcePackage  GetSourcePackageName  GetSourcePart  GetSourcePartName  IsOptimizerTemplate  NewCachedPinShapeSymbol  SetDeviceDesignator  SetGraphic  SetPCBFootprint  SetPCBLib  sGetPCBFootprint  sGetPCBLib  sGetReferenceDesignator  sGetSourceDeviceDesignator  sGetSourceLibName  sGetSourcePackageName  sGetSourcePartName  StatefulCreate  Update  UpdateOpProp
```

## DboPointerException — 1 个成员

```text
what
```

## DboPolygon — 20 个成员

```text
GetCount  GetFillStyle  GetHatchStyle  GetLineStyle  GetLineWidth  GetObjectType  Move  MovePoint  NewPoint  NewPointsIter  RemoveAllPoints  RemovePoint  SetFillStyle  SetHatchStyle  SetLineStyle  SetLineWidth  sGetFillStyle  sGetHatchStyle  sGetLineStyle  sGetLineWidth
```

## DboPolygonData — 12 个成员

```text
arrayPoints_get  arrayPoints_set  FillStyle_get  FillStyle_set  HatchStyle_get  HatchStyle_set  LineStyle_get  LineStyle_set  LineWidth_get  LineWidth_set  nNbrPoints_get  nNbrPoints_set
```

## DboPolygonPointsIter — 1 个成员

```text
Next
```

## DboPolyline — 14 个成员

```text
GetCount  GetLineStyle  GetLineWidth  GetObjectType  Move  MovePoint  NewPoint  NewPointsIter  RemoveAllPoints  RemovePoint  SetLineStyle  SetLineWidth  sGetLineStyle  sGetLineWidth
```

## DboPolylineData — 8 个成员

```text
arrayPoints_get  arrayPoints_set  LineStyle_get  LineStyle_set  LineWidth_get  LineWidth_set  nNbrPoints_get  nNbrPoints_set
```

## DboPolylinePointsIter — 1 个成员

```text
Next
```

## DboPort — 10 个成员

```text
GetObjectOccurrence  GetObjectOccurrences  GetPinType  GetPortSymbol  IsBundleObject  SetMirror  SetName  SetPinType  SetRotation  sGetPinType
```

## DboPortBusMemberOccurrence — 7 个成员

```text
GetMemberName  GetObjectType  GetPathName  GetPort  GetPortInst  GetRefPathName  sGetMemberName
```

## DboPortInst — 81 个成员

```text
DeleteUserProp  DeleteUserPropValue  GetCachedPinShapePtr  GetContainingLib  GetDefiningPin  GetDisplayPropsPermitted  GetDispPropArray  GetEffectivePropStringValue  GetEffectivePropValueType  GetHotSpot  GetId  GetIsClock  GetIsDot  GetIsGlobal  GetIsLeftPointing  GetIsLong  GetIsNetStyle  GetIsNoConnect  GetIsNumberVisible  GetIsRightPointing  GetIsShared  GetIsUserDefinedShape  GetIsVisible  GetNet  GetObjectOccurrence  GetObjectOccurrences  GetObjectType  GetOffsetHotSpot  GetOffsetStartPoint  GetOwner  GetParentObj  GetPinName  GetPinNumber  GetPinPosition  GetPinSwapId  GetPinType  GetStartPoint  GetWire  IsBundleObject  IsBundlePin  NewDisplayProp  NewDisplayPropsIter  NewEffectivePropsIter  NewUserProp  SetCachedPinShapePtr  SetHotSpot  SetId  SetIsClock  SetIsDot  SetIsGlobal  SetIsLeftPointing  SetIsLong  SetIsNetStyle  SetIsNoConnect  SetIsRightPointing  SetIsVisible  SetPinName  SetPinNumber  SetPinType  SetStartPoint  SetUserPropStringValue  sGetHotSpotX  sGetHotSpotY  sGetIsClock  sGetIsDot  sGetIsGlobal  sGetIsLeftPointing  sGetIsLong  sGetIsNetStyle  sGetIsNoConnect  sGetIsRightPointing  sGetIsShared  sGetIsVisible  sGetNetName  sGetPinName  sGetPinNumber  sGetPinPosition  sGetPinSwapId  sGetPinType  sGetStartPointX  sGetStartPointY
```

## DboPortInstBus — 5 个成员

```text
CopyUnnamedNegroupInfo  GetMember  GetObjectType  GetWidth  NewUserProp
```

## DboPortInstBusMember — 61 个成员

```text
DeleteDisplayProp  DeleteUserProp  DeleteUserPropValue  GetContainingBus  GetEffectivePropStringValue  GetHotSpot  GetIsClock  GetIsDot  GetIsGlobal  GetIsLeftPointing  GetIsLong  GetIsNetStyle  GetIsNoConnect  GetIsRightPointing  GetIsShared  GetIsVisible  GetNet  GetObjectType  GetOffsetHotSpot  GetOffsetStartPoint  GetPinName  GetPinNumber  GetPinPosition  GetPinType  GetStartPoint  NewDisplayProp  NewEffectivePropsIter  NewUserProp  SetHotSpot  SetIsClock  SetIsDot  SetIsGlobal  SetIsLeftPointing  SetIsLong  SetIsNetStyle  SetIsNoConnect  SetIsRightPointing  SetIsVisible  SetPinName  SetPinNumber  SetPinType  SetStartPoint  SetUserPropStringValue  sGetHotSpotX  sGetHotSpotY  sGetIsClock  sGetIsDot  sGetIsGlobal  sGetIsLeftPointing  sGetIsLong  sGetIsNetStyle  sGetIsNoConnect  sGetIsRightPointing  sGetIsShared  sGetIsVisible  sGetPinName  sGetPinNumber  sGetPinPosition  sGetPinType  sGetStartPointX  sGetStartPointY
```

## DboPortInstDisplayPropsIter — 4 个成员

```text
GetKey  Next  NextProp  NextPropEx
```

## DboPortInstEffectivePropsIter — 1 个成员

```text
NextEffectiveProp
```

## DboPortInstScalar — 1 个成员

```text
GetObjectType
```

## DboPortOccurrence — 33 个成员

```text
DeleteEffectiveProp  FindInstance  GetCanonicalName  GetCanonicalNameBasedOnPinPos  GetCanonicalNameWithChipsInfo  GetEffectivePropValueExists  GetEffectivePropValueType  GetFlatNet  GetId  GetInstance  GetName  GetObjectType  GetPathName  GetPathNameNumber  GetPinName  GetPinNumber  GetPort  GetPortInst  GetPortInstPinID  GetRefPathName  GetSchematic  GetSchematicPortName  IsOrphanPort  MorphPortOccurrence  NewEffectivePropsIter  ProcessFlatNetForPortOccurrence  SetEffectivePropStringValue  SetEffectivePropStringValueForIref  SetId  SetPortInstPinID  SetSchematicPortName  sGetId  sGetPathName
```

## DboPortOccurrenceEffectivePropsIter — 1 个成员

```text
NextEffectiveProp
```

## DboPortSymbol — 2 个成员

```text
GetPinType  SetPinType
```

## DboPrimitiveAndVisiblePowerPins — 6 个成员

```text
GetPrimitive  GetViewType  GetVisiblePowerPins  SetPrimitive  SetViewType  SetVisiblePowerPins
```

## DboRefDesAnnotate — 13 个成员

```text
Annotate  AnnotateIncremental  AnnotateUnconditional  GetDesign  m_pDboDesign_get  m_pDboDesign_set  m_RefDesQueryHandler_get  m_RefDesQueryHandler_set  mRefDesRTData_get  mRefDesRTData_set  ResetPartReference  SetDesign  SetRTData
```

## DboRefDesLog — 4 个成员

```text
GetLogType  GetMessage  SetLogType  SetMessage
```

## DboRefDesManager — 10 个成员

```text
AddInstOccToPending  AssignRefDesToPendingInstOccs  ClearPendingInstOccs  GetInstanceRefDesMap  GetOccRefDesMap  IsDesignLevelAutoReferenceEnabled  ProcessObjectDelete  ProcessRefDesModify  RefreshInstanceRefDesMap  RefreshOccRefDesMap
```

## DboRefDesMap — 5 个成员

```text
AddRefDesEntry  ClearMap  GetRefNumMap  RemoveEntry  SetAllDirty
```

## DboRefDesQueryHandler — 5 个成员

```text
AssignRefDesToList  GetNextRefDes  GetQueryOptions  SetQueryMap  SetQueryOptions
```

## DboRefDesRTData — 6 个成员

```text
GetCombinedPropWarningCount  GetDboState  GetQueryOption  GetRefDesLogList  IncrementCombinedPropWarningCount  setQueryOption
```

## DboRefDesUtils — 22 个成员

```text
AddAnnotationLog  BuildRefNumRange  ClearAnnotationLog  DoAdvancedAnnotation  DumpLogToSessionLog  FilterPageList  GetDesignatorNumber  GetDesignatorString  GetPagesAsPerPagesInTitleBlockOrder  GetPagesAsPerPMOrder  GetPagesForPropertyValue  GetPagesFromJSON  GetPagesInOrder  GetPagesInOrderForProperty  GetPartsOnPages  GetPowerPinsKeyString  GetReference  GetUniquePagesList  NewListIter  NewPartsIter  ResetReference  SplitPartReference
```

## DboSchematic — 94 个成员

```text
BuildIDMap  CanAssignRefDes  CanThisPinBeAddedToUnnamedNetgroup  CheckSchematicSymbolInstContainersAndUpdateConnectivity  ClearModified  ClearNextReferences  Copy  CreateSchNetAndContainerMapping  DeleteAllOptimizerParameter  DeleteOptimizerParameter  DeletePage  DoActualSchematicExpansion  DumpPageDirectoryInfo  Expand  ExpandMinimal  FilterSchematicNetsForPage  FindUnnamedNetgroupByName  GetDefaultPageName  GetDeletedNet  GetGlobal  GetId  GetLowestPageNumberFromDboNets  GetNet  GetNextDeviceAndPartToBePlaced  GetNextReference  GetNextReferenceEx  GetNextReferenceOld  GetObjectContainer  GetObjectType  GetOccUndoStack  GetOffPageConnector  GetOffPageConnectorForOcc  GetOpenReferringDesigns  GetOpStartWithCurrenV  GetOptFileName  GetOptimizerParameter  GetOptimizerTemplate  GetPage  GetPageCount  GetPageFromID  GetPageNumber  GetPartInst  GetPort  GetPortIgnoreWidth  GetRegisteredObject  GetSchematicAtID  GetSchematicID  GetTitleBlock  GetUnNamedBundleList  GetUnnamedNetGroupOwnerObject  GetUserStorage  IsExpanded  IsModified  IsOccsModified  IsOptimizerTemplateExist  IsOptimizerUseCurrentValue  IsPageInMemory  IsPageModified  IsPagePersistent  MarkModified  MarkSchematicNetForDeletion  NewChangedPagesIter  NewGlobalsIter  NewInstsIter  NewNetsIter  NewOccUndoStackEntryIter  NewOffPageConnectorsIter  NewOptimizerParametersIter  NewPage  NewPageNamesIter  NewPagesIter  NewPortsIter  PageExists  ReadAllPages  ReleaseCollectedPageIDs  ReleaseID  RemoveOptimizerParameter  RemovePage  RemoveSchematicNetAndRebuildFromPageNets  Rename  ResolveBaseNameConflict  RestoreOptimizerParameter  SavePage  sDeleteTempShadowPage  SetMinId  SetNextReference  SetOccsModified  SetOpStartWithCurrenV  SetPageNumber  sGetName  UpdateFlatNetsOfAllInstantiatingDesigns  UpdateNextReference  UpdateUnnamedNetgroupRegistry  UpdateUnnamedNetSymbols
```

## DboSchematicChangedPagesIter — 3 个成员

```text
GetKey  Next  NextPage
```

## DboSchematicGlobal — 3 个成员

```text
GetObjectType  GetPinType  IsPower
```

## DboSchematicGlobalsIter — 3 个成员

```text
GetKey  Next  NextGlobal
```

## DboSchematicInstsIter — 3 个成员

```text
GetKey  Next  NextInst
```

## DboSchematicNet — 44 个成员

```text
AddBusNet  ComputeNetName  DeleteEffectiveProp  EffectivePropsMatch  GetAttributeLockingInfo  GetBusNets  GetColor  GetContainingLib  GetEffectivePropStringValue  GetEffectivePropValueChoices  GetEffectivePropValueExists  GetEffectivePropValueType  GetId  GetLineStyle  GetLineWidth  GetLocalNetName  GetName  GetObjectOccurrence  GetObjectOccurrences  GetObjectType  GetOwner  GetParentObj  GetSchNetNameForOldPspiceConnectivity  HasBundleConnection  HasNonNGOverrider  IsBundleObject  IsBusMember  IsGlobal  NewEffectivePropsIter  NewGlobalsIter  NewNetsIter  NewOffPageConnectorsIter  NewPortInstsIter  NewPortsIter  NewWiresIter  RemoveBusNet  ResolveComputedNameConflict  SetColor  SetEffectivePropStringValue  SetLineStyle  SetLineWidth  SetName  sGetId  sGetName
```

## DboSchematicNetBus — 4 个成员

```text
GetMember  GetObjectType  GetWidth  NewMembersIter
```

## DboSchematicNetBusMembersIter — 3 个成员

```text
GetKey  Next  NextMember
```

## DboSchematicNetEffectivePropsIter — 1 个成员

```text
NextEffectiveProp
```

## DboSchematicNetGlobalsIter — 3 个成员

```text
GetKey  Next  NextGlobal
```

## DboSchematicNetNetsIter — 3 个成员

```text
GetKey  Next  NextNet
```

## DboSchematicNetOffPageConnectorsIter — 3 个成员

```text
GetKey  Next  NextOffPageConnector
```

## DboSchematicNetPortInstsIter — 3 个成员

```text
GetKey  Next  NextPortInst
```

## DboSchematicNetPortsIter — 3 个成员

```text
GetKey  Next  NextPort
```

## DboSchematicNetScalar — 1 个成员

```text
GetObjectType
```

## DboSchematicNetsIter — 3 个成员

```text
GetKey  Next  NextNet
```

## DboSchematicNetWiresIter — 3 个成员

```text
GetKey  Next  NextWire
```

## DboSchematicOffPageConnector — 1 个成员

```text
GetObjectType
```

## DboSchematicOffPageConnectorsIter — 3 个成员

```text
GetKey  Next  NextOffPageConnector
```

## DboSchematicOptimizerParametersIter — 3 个成员

```text
GetKey  Next  NextOptimizerParameter
```

## DboSchematicPageNamesIter — 1 个成员

```text
NextName
```

## DboSchematicPagesIter — 3 个成员

```text
GetKey  Next  NextPage
```

## DboSchematicPort — 2 个成员

```text
GetObjectType  GetPinType
```

## DboSchematicPortsIter — 3 个成员

```text
GetKey  Next  NextPort
```

## DboSchematicSymbolInst — 24 个成员

```text
GetContainingLib  GetEntry  GetIsBus  GetName  GetNet  GetNetId  GetObjectType  GetOwner  GetParentObj  GetSize  IsBundleObject  m_bIsBus_get  m_bIsBus_set  m_Name_get  m_Name_set  m_pInstArray_get  m_pInstArray_set  m_pNet_get  m_pNet_set  m_pOwner_get  m_pOwner_set  SetIsBus  sGetName  sGetNetId
```

## DboSession — 46 个成员

```text
CallTclAttributeTrigger  CopyLibAll  CreateDesign  CreateLib  FindExternalDesignsToBeRemoved  GetActiveDesign  GetDataRelease  GetDataReleaseForDBObject  GetDataVersion  GetDataVersionForDBObject  GetDesign  GetDesignAndSchematics  GetDesignDataVersion  GetFlatNetNamingStrategy  GetIndexForString  GetInterfaceVersion  GetLib  GetLibAndSchematics  GetObjectFromUniqueStr  GetOccByCanonicalName  GetOpenDesign  GetOpenDesigns  GetOpenLib  GetStringPtrFromIndex  GetUniqueStringFromObject  IsBitSet  IsDesignPersistent  IsEditingDisabledInSession  IsFlatNetModificationRegistrationActive  IsLibPersistent  IsObjLocked  m_StringTable_get  m_StringTable_set  m_StrTableArray_get  m_StrTableArray_set  MarkAllLibForSave  NewDesignsIter  NewLibsIter  RemoveDesign  RemoveLib  SaveDesign  SaveDesignAs  SaveLib  SaveLibAs  SetBit  SetFlatNetNamingStrategy
```

## DboSessionDesignsIter — 3 个成员

```text
GetKey  Next  NextDesign
```

## DboSessionLibsIter — 3 个成员

```text
GetKey  Next  NextLib
```

## DboShadowPage — 1 个成员

```text
GetObjectType
```

## DboSplitPath — 6 个成员

```text
GetDir  GetDrive  GetExt  GetFileName  GetFileTitle  GetPath
```

## DboState — 28 个成员

```text
AssignVoltageOnDCNets  ClearDesignUndoRedo  Code  CrossProbeNetCMToNet  DispPropBoundingBox  Failed  GetBackAnnotationData  GetExtendedText  GetLicenseString  GetOptionString  GetOrCADCMTierFlag  IsCMProp  IsPspLicChekedout  m_SCode_get  m_SCode_set  Message  OK  OpenPasswordDialog  RemoveFilesFromActivePM  RunBackAnnotation  RunFrontToBackTool  SaveDesign  Severity  sIsObjectBelongsToMasterSession  sIsTimeProfilingON  Succeeded  WriteToSessionLog  WriteToStatusBar
```

## DboSymbol — 22 个成员

```text
Clear  DeleteDisplayProp  DeleteSymbolPin  DeleteSymbolPinAtPosition  GetDisplayPropsPermitted  GetDispPropArray  GetPinCount  GetPinPosition  GetSemanticString  GetSize  GetSymbolPin  IsEquivalent  MarkModified  NewDisplayProp  NewDisplayPropsIter  NewGraphicBitMapInstFromDib  NewPinsIter  NewSymbolPinBus  NewSymbolPinScalar  PinsAllowed  RemoveSymbolPinFromPosition  RemoveSymbolPins
```

## DboSymbolDisplayPropsIter — 3 个成员

```text
GetKey  Next  NextProp
```

## DboSymbolPin — 62 个成员

```text
GetContainingLib  GetDisplayPropsPermitted  GetDispPropArray  GetHotSpot  GetIsClock  GetIsDot  GetIsGlobal  GetIsLeftPointing  GetIsLong  GetIsNetStyle  GetIsNoConnect  GetIsNumberVisible  GetIsRightPointing  GetIsUserDefinedShape  GetIsVisible  GetName  GetObjectType  GetOwner  GetParentObj  GetPinName  GetPinPosition  GetPinType  GetSemanticString  GetStartPoint  InsertAtPinPosition  IsEquivalent  NewDisplayProp  NewDisplayPropsIter  SetHotSpot  SetIsClock  SetIsDot  SetIsGlobal  SetIsLeftPointing  SetIsLong  SetIsNetStyle  SetIsNoConnect  SetIsNumberVisible  SetIsRightPointing  SetIsUserDefinedShape  SetIsVisible  SetName  SetPinName  SetPinPosition  SetPinType  SetStartPoint  sGetHotSpotX  sGetHotSpotY  sGetIsClock  sGetIsDot  sGetIsGlobal  sGetIsLeftPointing  sGetIsLong  sGetIsNetStyle  sGetIsNoConnect  sGetIsNumberVisible  sGetIsRightPointing  sGetIsVisible  sGetPinName  sGetPinPosition  sGetPinType  sGetStartPointX  sGetStartPointY
```

## DboSymbolPinBus — 2 个成员

```text
GetObjectType  SetPinName
```

## DboSymbolPinDisplayPropsIter — 4 个成员

```text
GetKey  Next  NextProp  NextPropEx
```

## DboSymbolPinScalar — 1 个成员

```text
GetObjectType
```

## DboSymbolPinsIter — 3 个成员

```text
GetKey  Next  NextPin
```

## DboSymbolVector — 14 个成员

```text
GetLocation  GetName  GetObjectType  NewArc  NewBox  NewCommentText  NewEllipse  NewLine  NewPolygon  NewPolyline  NewVectorsIter  SetLocation  sGetLocationX  sGetLocationY
```

## DboSymbolVectorVectorsIter — 1 个成员

```text
NextVector
```

## DboTclBom — 3 个成员

```text
GetBOMJSON  GetBOMJSON1  GetBOMOptionsJSON
```

## DboTclHelper — 90 个成员

```text
CleanOrCADRegistry  DesignDiffAndDump  ReRegisterOrCADPlugins  sAddToStringMap  sCastPtr  sCheckIsWritable  sCheckNativeIsExec  sCloseCFile  sCreateSession  sDeleteBool  sDeleteCPoint  sDeleteCRect  sDeleteCSize  sDeleteCString  sDeleteCStringSet  sDeleteDboValue  sDeleteDboValueType  sDeleteInt  sDeleteLOGFONT  sDeleteSession  sDeleteStdStr  sDeleteStringMap  sDeleteULong  SetLiteMode  SetRegionalSetting  SetTimeZone  sEvalPage  sFindInCStringSet  sGetBase64BitmapForOle  sGetBase64DataOfOle  sGetBool  sGetCFile  sGetConstCharPtr  sGetConstCharPtrFromVector  sGetCPointX  sGetCPointY  sGetCRectBottomRight  sGetCRectTopLeft  sGetCSizeX  sGetCSizeY  sGetDboObjectInProcess  sGetEnv  sGetInt  sGetLFCharSet  sGetLFClipPrecision  sGetLFEscapement  sGetLFHeight  sGetLFItalic  sGetLFName  sGetLFOrientation  sGetLFOutPrecision  sGetLFPitchAndFamily  sGetLFQuality  sGetLFStrikeOut  sGetLFUnderline  sGetLFWeight  sGetLFWidth  sGetStringMap  sGetStringMapData  sGetTclList  sGetULong  sGetValueFromStringMap  sGetVectorSize  sInsertToCStringSet  sLockProperty  sMakeBitmap  sMakeBitMapData  sMakeBool  sMakeCPoint  sMakeCRect  sMakeCSize  sMakeCString  sMakeCStringAppOwned  sMakeCStringSet  sMakeDboValue  sMakeDboValueType  sMakeInt  sMakeIntAppOwned  sMakeLOGFONT  sMakeStdStr  sMakeStdVector  sMakeULong  sPushBackToVector  sReleaseAllCreatedPtrs  sRemoveFromVector  sSetCString  sSetDboObjectInProcess  sSetDboSessionKey  sSetEnv  sSetServerMode
```

## DboTclUtilHelper — 1 个成员

```text
GetNextIndex
```

## DboTclUtils — 23 个成员

```text
ConvertDBObjectToSWIGId  CreateJSONForProperties  EvalTCLCommand  GetComponentsAndCountInJSON  GetDesignFlatNetNameInJSON  GetDesignHierarchyInJSON  GetDesignHierarchyInJSONWithoutPages  GetOptionStringCmdVal  GetPropertyBlockHierachy  GetReferenceFromID  GetReferencePrefix  GetTclInterpreter  sApplyFeatureName  sFindSimilarPartBasedOnProp  sGetActiveDesignComponents  sGetDesignPartGroupByMatchProp  sGetDesignPartGroupByOccJSON  sGetDesignPartPropertyJSON  sGetETOEURL  sGetPartRefAllOccOfParts  sGetSelectedPartPropertyJSON  sGetTIPartsData  sSetInterpAndGetPkgVersion
```

## DboTitleBlock — 59 个成员

```text
AddVariantProp  ClearVariantMap  GetBoundingBox  GetDesignCreateDate  GetDesignCreateTime  GetDesignFileName  GetDesignModifyDate  GetDesignModifyTime  GetDesignName  GetEffectivePropValueChoices  GetKeepInLowerRightCorner  GetNextNewVariantProp  GetObjectOccurrence  GetObjectOccurrences  GetPageCount  GetPageCreateDate  GetPageCreateTime  GetPageModifyDate  GetPageModifyTime  GetPageName  GetPageNumber  GetPageSize  GetSchematicCreateDate  GetSchematicCreateTime  GetSchematicModifyDate  GetSchematicModifyTime  GetSchematicName  GetSourceLibName  GetSourceSymbolName  GetSymbol  GetVariantProp  IsBoundingBoxDirty  IsVariantPropMapEmpty  SetBoundingBox  SetBoundingBoxDirty  SetKeepInLowerRightCorner  SetPageCount  SetPageNumber  sGetDesignCreateDate  sGetDesignCreateTime  sGetDesignFileName  sGetDesignModifyDate  sGetDesignModifyTime  sGetDesignName  sGetPageCount  sGetPageCreateDate  sGetPageCreateTime  sGetPageModifyDate  sGetPageModifyTime  sGetPageName  sGetPageNumber  sGetPageSize  sGetSchematicCreateDate  sGetSchematicCreateTime  sGetSchematicModifyDate  sGetSchematicModifyTime  sGetSchematicName  sGetSourceLibName  sGetSourceSymbolName
```

## DboTitleBlockOccurrence — 22 个成员

```text
AddVariantProp  ClearVariantMap  DeleteEffectiveProp  FindInstance  GetInstance  GetNextNewVariantProp  GetObjectType  GetPathName  GetRefPathName  GetSchematic  GetSchematicPath  GetTitleBlock  GetTitleBlockId  GetVariantProp  IsVariantPropMapEmpty  NewEffectivePropsIter  SetEffectivePropStringValue  SetTitleBlock  SetTitleBlockId  sGetId  sGetPathName  sGetSchematicPath
```

## DboTitleBlockOccurrenceEffectivePropsIter — 1 个成员

```text
NextEffectiveProp
```

## DboTitleBlockSymbol — 7 个成员

```text
NewSymbolPinBus  NewSymbolPinScalar  sGetPageCount  sGetPageCreateDate  sGetPageModifyDate  sGetPageNumber  sGetPageSize
```

## DboUserProp — 12 个成员

```text
DeleteValue  GetName  GetNext  GetOwner  GetStringValue  GetType  IsDeletable  IsEditable  SetName  SetStringValue  SetValue  ShadowSetStringValue
```

## DboUserPropsIter — 2 个成员

```text
Next  NextUserProp
```

## DboValidValuesIter — 1 个成员

```text
NextValue
```

## DboValue — 55 个成员

```text
GetBool  GetColor  GetCountValidValues  GetEnumeration  GetFont  GetInt  GetLogicalType  GetLogicalTypeName  GetLong  GetPhysicalType  GetString  GetTime  GetType  m_nType_get  m_nType_set  NewValidValuesIter  SetBOOL  SetColor  SetDisplayType  SetFilePath  SetFillStyle  SetHatchStyle  SetInt  SetLineStyle  SetLineWidth  SetLong  SetPinType  SetPrimitiveType  SetRotation  SetString  SetTime  SetValue  SetViewType  sGetEnumeration  sGetValue  u  u_get  u_m_bVal_get  u_m_bVal_set  u_m_lpszVal_get  u_m_lpszVal_set  u_m_lVal_get  u_m_lVal_set  u_m_nVal_get  u_m_nVal_set  u_m_pFontVal_get  u_m_pFontVal_set  u_m_tVal_get  u_m_tVal_set  u_s  u_s_get  u_s_m_nEnumType_get  u_s_m_nEnumType_set  u_s_m_nEnumVal_get  u_s_m_nEnumVal_set
```

## DboVector — 4 个成员

```text
GetContainingLib  GetObjectType  GetOwner  GetParentObj
```

## DboView — 15 个成员

```text
ClearCMData  DecrefCount  GetCMData  GetDCFPath  GetDesignLoadStateInCM  GetRefCount  IncRefCount  IsDesignCMDisabled  IsDesignCMEnabled  IsDesignPartiallyCMEnabled  SetCMData  setDesignLoadStateInCM  sGetCreateTime  sGetModifyTime  sGetName
```

## DboWire — 80 个成员

```text
AreConnectionsAbuttingAtPoint  CleanupQuad  ClearCreatedByDB  ConnectInitialization  DeleteAlias  DeleteJunction  DeletePoints  DeleteUserProp  DeleteUserPropValue  GetBoundingBox  GetBundleOwnerPropName  GetBundleOwnerPropNameFromAlias  GetColor  GetConnection  GetContainingLib  GetCreatedByDB  GetDisplayPropsPermitted  GetDispPropArray  GetEnd  GetEndPoint  GetId  GetLinesIntersect  GetLineStyle  GetLineWidth  GetNet  GetNetAliasArray  GetNetName  GetObjectOccurrence  GetOwner  GetParentObj  GetPoint  GetPointCount  GetPointPosition  GetStart  GetStartPoint  GetUserData  IsBoundingBoxDirty  IsBundleObject  IsGlobal  IsHorizontal  IsNonOrthogonal  IsVertical  IsZeroLen  JunctionOnWire  LineIntersectsRect  LinesIntersect  MovePoint  NewAlias  NewAliasesIter  NewBusEntriesIter  NewConnectedWiresIter  NewConnection  NewDisplayProp  NewDisplayPropsIter  NewGlobalsIter  NewJunction  NewJunctionsIter  NewName  NewOffPageConnectorsIter  NewPoint  NewPortInstsIter  NewPortsIter  NewUserProp  PointIsJunction  PointOnLine  PointOnWire  RemoveExtraJunctions  SetBoundingBox  SetBoundingBoxDirty  SetColor  SetDuplicateId  SetId  SetLineStyle  SetLineWidth  SetPoint  SetUserData  SetUserPropStringValue  sGetColor  sGetNetName  SyncNetGroupAliases
```

## DboWireAliasesIter — 3 个成员

```text
GetKey  Next  NextAlias
```

## DboWireBus — 5 个成员

```text
GetObjectType  IsBundleObject  NewAlias  NormalizeBundleWire  SetName
```

## DboWireBusEntriesIter — 3 个成员

```text
GetKey  Next  NextBusEntry
```

## DboWireConnectedWiresIter — 3 个成员

```text
GetKey  Next  NextWire
```

## DboWireData — 10 个成员

```text
Color_get  Color_set  End_get  End_set  nJctnEnd_get  nJctnEnd_set  nJctnStart_get  nJctnStart_set  Start_get  Start_set
```

## DboWireDisplayPropsIter — 3 个成员

```text
GetKey  Next  NextProp
```

## DboWireGlobalsIter — 3 个成员

```text
GetKey  Next  NextGlobal
```

## DboWireJunctionsIter — 1 个成员

```text
NextJunction
```

## DboWireOffPageConnectorsIter — 3 个成员

```text
GetKey  Next  NextOffPageConnector
```

## DboWirePortInstsIter — 3 个成员

```text
GetKey  Next  NextPortInst
```

## DboWirePortsIter — 3 个成员

```text
GetKey  Next  NextPort
```

## DboWiresAtPointIter — 1 个成员

```text
NextWire
```

## DboWireScalar — 3 个成员

```text
DeleteAlias  GetObjectType  SetName
```

## DboWiresInAreaIter — 1 个成员

```text
NextWire
```

