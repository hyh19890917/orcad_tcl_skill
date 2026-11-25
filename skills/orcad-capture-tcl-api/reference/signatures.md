# Dbo Tcl 命令签名（Cadence Capture 17.4，从 orDb_Dll_Tcl64.dll 实测导出）

获取方式：对每个命令做零参调用，解析宿主自己抛出的参数个数错误。参数名、顺序与 C++ 类型都来自原文本：

```text
% DboSymbolPin_NewDisplayProp
Wrong number of arguments :DboSymbolPin_NewDisplayProp self status CString& & CPoint DboValue::RotationT LOGFONT& & DboValue::ColorT  argument 1
```

标记：`(overloaded)` = C++ 多重载，需按用例试调；`(zero-arg-ok)` = 可零参调用。`~delete` 等价于对象形态的 `$obj -delete`。

两种等价调用形态（实测）：`$lib GetPackage $n $st` 与 `DboLib_GetPackage $lib $n $st`。

命令总数：3941

## DboAlias (46)

```text
GetBoundingBox                               self
GetBundleOwnerPropName                       self,propName,sourceLibName
GetBundleOwnerPropValue                      self,propName,sourceLibName
GetColor                                     self,status
GetContainingLib                             self
GetDisplayName                               self
GetFont                                      self,status
GetId                                        self,status
GetLocation                                  self,status
GetName                                      self,name
GetObjectType                                self
GetOwner                                     self
GetRotation                                  self,status
IsBoundingBoxDirty                           self
IsBundleObject                               self
IsFontDefault                                self,status
m_nId_get                                    self
m_nId_set                                    self,m_nId
RemoveBundleOwner                            self
RemoveBundleProperties                       self
SetBoundingBox                               self,boundingBox
SetBoundingBoxDirty                          self,bSetting
SetBundleOwner                               (overloaded)
SetColor                                     self,color
SetDisplayName                               self,pName
SetFont                                      self,font
SetId                                        self,newId
SetLocation                                  self,location
SetName                                      self,name
SetOwnerBoundingBoxDirty                     self,bSetting
SetPropertyToExtention                       self,bundleOwnerPropName,bundleOwnerPropValue
SetRotation                                  self,rotation
sGetColor                                    obj,status
sGetFont                                     obj,status
sGetLocationX                                obj,status
sGetLocationY                                obj,status
sGetName                                     obj,status
sGetRotation                                 obj,status
sSetColor                                    obj,color
sSetFont                                     obj,font
sSetLocationX                                obj,x
sSetLocationY                                obj,y
sSetName                                     obj,name
sSetRotation                                 obj,rotation
UpdateBundleOwner                            (overloaded)
ValidateNGName                               self,OldName,NewName,status
```

## DboAliasData (12)

```text
AliasName_get                                self
AliasName_set                                self,AliasName
Color_get                                    self
Color_set                                    self,Color
FontName_get                                 self
FontName_set                                 self,FontName
FontSize_get                                 self
FontSize_set                                 self,FontSize
Location_get                                 self
Location_set                                 self,Location
Rotation_get                                 self
Rotation_set                                 self,Rotation
```

## DboAnnotateControl (4)

```text
GetNumRange                                  self
GetPagePath                                  self
GetRangeAt                                   self,pos
GetSchName                                   self
```

## DboAnnotateRange (6)

```text
GetLastIndex                                 self
GetRefdesPrefix                              self
GetStartIndex                                self
SetLastIndex                                 self,lIndex
SetRefDesPrefix                              self,refdesprfx
SetStartIndex                                self,sIndex
```

## DboArc (22)

```text
GetBoundingBox                               self
GetEnd                                       self,status
GetLineStyle                                 self,status
GetLineWidth                                 self,status
GetObjectType                                self
GetStart                                     self,status
Move                                         self,ptOffset
SetBoundingBox                               self,box
SetEnd                                       self,point
SetLineStyle                                 self,style
SetLineWidth                                 self,width
SetStart                                     self,point
sGetBoundingBoxBottom                        obj,status
sGetBoundingBoxLeft                          obj,status
sGetBoundingBoxRight                         obj,status
sGetBoundingBoxTop                           obj,status
sGetEndX                                     obj,status
sGetEndY                                     obj,status
sGetLineStyle                                obj,status
sGetLineWidth                                obj,status
sGetStartX                                   obj,status
sGetStartY                                   obj,status
```

## DboArcData (10)

```text
Bound_get                                    self
Bound_set                                    self,Bound
End_get                                      self
End_set                                      self,End
LineStyle_get                                self
LineStyle_set                                self,LineStyle
LineWidth_get                                self
LineWidth_set                                self,LineWidth
Start_get                                    self
Start_set                                    self,Start
```

## DboBaseObject (113)

```text
AddLockingInfo                               self,propName,lLock,preTriggerName,postTrigerName
AddPropertyToPropertyBag                     self,BagType,pBagName,pName,pValue
AddVariantProp                               self,strName,strVal
ClearVariantMap                              (overloaded)
CopyExtensions                               self,srcExtn
Decrement                                    self
DeleteDBProp                                 self,name
DeleteDisplayProp                            self,DboDisplayProp,*
DeleteEffectiveProp                          self,name
DeleteUserProp                               self,name
DeleteUserProps                              self
EffectiveNGMatch                             (overloaded)
EffectivePropNameMatch                       (overloaded)
EffectivePropsMatch                          (overloaded)
GetAttributeLockingInfo                      self,propName,lLock,preTrigger,postTrigger
GetBaseProp                                  (overloaded)
GetBasePropNC                                self,name,status
GetBitmask                                   self,pBitmask
GetBoundingBox                               self
GetBundleOwner                               self
GetBundleOwnerPropName                       self,propName,sourceLibName
GetBundleOwnerPropValue                      self,propName,sourceLibName
GetBundleTemplateMap                         self
GetContainingLib                             self
GetCurrentObject                             self,nTransCount
GetDBProp                                    (overloaded)
GetDBPropFromObject                          self,strName,status
GetDBPropNC                                  self,name,status
GetDBPropValue                               (overloaded)
GetDisplayProp                               self,name,status
GetDisplayPropEx                             self,name,status
GetDisplayPropsPermitted                     self,status
GetEffectivePropStringValue                  (overloaded)
GetEffectivePropStringValueNC                self,name,value
GetEffectivePropValueChoices                 self,name,choices
GetEffectivePropValueExists                  self,name,bExists
GetEffectivePropValueType                    self,name,nType,bEditable,bDeletable
GetExtensionHandle                           self
GetId                                        self,status
GetMask                                      self
GetName                                      self,name
GetNextNewVariantProp                        self,strName,strVal,bNewFound
GetNextState                                 self
GetObjectOccurrence                          (overloaded)
GetObjectOccurrences                         (overloaded)
GetObjectType                                self
GetOpenDesigns                               self,designs,status
GetPaint                                     self
GetPrevState                                 self
GetPropertyBag                               self,BagType
GetPropertyFromPropertyBag                   self,BagType,bagName,propName,propValue
GetRefCount                                  self
GetSemanticID                                self
GetSemanticString                            self,str
GetSession                                   self,status
GetTransactionCount                          self
GetTypeString                                self,strType
GetUserEditAttributeOnProp                   self,propName
GetUserProp                                  (overloaded)
GetUserPropNC                                self,name,status
GetUserPropsCount                            self,status
GetUserPropsPermitted                        self,status
GetUserPropStringValue                       self,name,value
GetUserPropStringValueNC                     self,name,value
GetVariantProp                               self,strName,strVal
HasPropertyThatExists                        self,status
Increment                                    self
IsBitmaskAllowed                             self,pBitmask
IsBundleObject                               self
isBundleTemplateExists                       self
IsCurrent                                    self
IsEquivalent                                 self,pObj
IsObjLocked                                  self
IsOccModified                                self
IsPropertyLockable                           self,propName
IsPropertyLockedForEditing                   self,propName
IsPtrDeleted                                 pPtr
IsUpdated                                    self
IsVariantPropMapEmpty                        self
MakeBundle                                   self,sOwner,sSourceLib,flag
MarkModified                                 self
NewDBPropsIter                               self,status
NewDisplayProp                               self,status,CString&,CPoint,DboValue::RotationT,LOGFONT&,DboValue::ColorT
NewDisplayPropsIter                          self,status
NewEffectivePropsIter                        (overloaded)
NewUserProp                                  (overloaded)
NewUserPropsIter                             self,status
RemoveBundleProperties                       self
RemovePropertiesFromPropertyBag              self,BagType,bagName,propName
RemovePropertyBag                            self,BagType,bagName
RemovePropsFromObject                        self
ResetObject                                  self
sDoPatternMatch                              lpszPat,lpszSrc,bMatchCase
SetBitmask                                   self,pBitmask
SetBundleOwner                               (overloaded)
SetCurrent                                   self,bVal
SetDBPropValue                               (overloaded)
SetEffectivePropStringValue                  (overloaded)
SetMask                                      self,pMask
SetName                                      self,name
SetNextState                                 self,pObj
SetObjectType                                self,DboBaseObject::ObjectTypeT
SetOccsModified                              self,bMod
SetPaint                                     (overloaded)
SetPrevState                                 self,pObj
SetPropStringValueWithEditTracking           self,propName,newVal,flag
SetTransactionCount                          self,count
SetUserEditAttributeOnProp                   self,propName,flag
SetUserPropStringValue                       self,name,value
sGetDBProp                                   (overloaded)
StatefulCreate                               self
UnsetBitmask                                 self,pBitmask
UpdateBundleOwner                            (overloaded)
```

## DboBezier (14)

```text
GetCount                                     self,status
GetLineStyle                                 self,status
GetLineWidth                                 self,status
GetObjectType                                self
Move                                         self,ptOffset
MovePoint                                    self,position,ptOffset
NewPoint                                     (overloaded)
NewPointsIter                                self,status
RemoveAllPoints                              self
RemovePoint                                  self,nIndex
SetLineStyle                                 self,style
SetLineWidth                                 self,width
sGetLineStyle                                obj,status
sGetLineWidth                                obj,status
```

## DboBezierPointsIter (2)

```text
~delete                                      self
Next                                         self,returnPt
```

## DboBitMap (20)

```text
GetBitmapDimension                           self,status
GetBoundingBox                               self
GetDib                                       self,status
GetDibSize                                   self,status
GetLocation                                  self,status
GetObjectType                                self
sDeleteCBitmapDIB                            apByte
SetBitmapDimension                           self,nWidth,nHeight
SetBoundingBox                               self,box
SetLocation                                  self,point
sGetBase64ImageData                          pDboBitmap,pOutEncodedString,rStatus
sGetBoundingBoxBottom                        obj,status
sGetBoundingBoxLeft                          obj,status
sGetBoundingBoxRight                         obj,status
sGetBoundingBoxTop                           obj,status
sGetCBitmapDIB                               aBmpFileName,apBitMapDimension,apDIBSize
sGetDibFromBase64ImageData                   pEncodedString,pDib,pDibSize,bmDimension,rStatus
sGetImageFromDboBitMap                       pDboBitmap,pFilePath,rStatus
sGetLocationX                                obj,status
sGetLocationY                                obj,status
```

## DboBitMapData (6)

```text
bmpFile_get                                  self
bmpFile_set                                  self,bmpFile
BoundingBox_get                              self
BoundingBox_set                              self,BoundingBox
Location_get                                 self
Location_set                                 self,Location
```

## DboBookMark (3)

```text
SetLocation                                  self,location
SetMirror                                    self,mirror
SetRotation                                  self,rotation
```

## DboBox (22)

```text
GetFillStyle                                 self,status
GetHatchStyle                                self,status
GetLineStyle                                 self,status
GetLineWidth                                 self,status
GetLowerRight                                self,status
GetObjectType                                self
GetUpperLeft                                 self,status
Move                                         self,ptOffset
SetFillStyle                                 self,style
SetHatchStyle                                self,style
SetLineStyle                                 self,style
SetLineWidth                                 self,width
SetLowerRight                                self,point
SetUpperLeft                                 self,point
sGetBottom                                   obj,status
sGetFillStyle                                obj,status
sGetHatchStyle                               obj,status
sGetLeft                                     obj,status
sGetLineStyle                                obj,status
sGetLineWidth                                obj,status
sGetRight                                    obj,status
sGetTop                                      obj,status
```

## DboBoxData (10)

```text
Bound_get                                    self
Bound_set                                    self,Bound
FillStyle_get                                self
FillStyle_set                                self,FillStyle
HatchStyle_get                               self
HatchStyle_set                               self,HatchStyle
LineStyle_get                                self
LineStyle_set                                self,LineStyle
LineWidth_get                                self
LineWidth_set                                self,LineWidth
```

## DboBundle (31)

```text
~delete                                      self
AddMember                                    (overloaded)
CanBeMember                                  self,name,type
ChangeMsb                                    (overloaded)
ClearEditMaps                                self
DeleteBundleProperty                         self,PropName
DeleteMember                                 self,name
DetachFromParent                             self
GetBundleOwnerInformation                    self,pOwnerName,pSourceLibName
GetBundleProperty                            self,PropName
GetBundlePropertyMap                         self,PropertiesMap
GetBusOwnerName                              self,name
GetContainingLib                             self
GetMember                                    (overloaded)
GetMemberIndex                               self,name
GetNextMember                                self,pIter,name,type
GetPosition                                  self,memberName
IsBundleMember                               self
isDirty                                      self
isMemberAddable                              (overloaded)
IsMemberDeleted                              self,pMembername
IsMemberRenamed                              self,pMemberName,pNewName
isRecursiveAdd                               self,name
MergeBundlePropertyMap                       self,PropertiesMap
MoveUpDown                                   self,index,isUp
RenameMember                                 self,OldName,NewName
SetBundleOwnerInformation                    self,pSourceLibName
SetBundleProperty                            self,PropName,PropValue
setDirty                                     self,int
SetMsb                                       self,msb
StartMemberIter                              self,pIter
```

## DboBundleBusMember (8)

```text
~delete                                      self
GetBaseName                                  self,name
GetDisplayName                               self,name
GetLsb                                       self
GetMsb                                       self
GetName                                      self,name
GetWidth                                     self
IsBundleMember                               self
```

## DboBundleMemberIter (2)

```text
~delete                                      self
Next                                         self,name,type
```

## DboBundleNetIter (2)

```text
~delete                                      self
Next                                         self,name
```

## DboBundleScalarMember (2)

```text
~delete                                      self
IsBundleMember                               self
```

## DboBundleTemplateMap (43)

```text
~delete                                      self
AddBundleMember                              self,name,memberOfName,type,owner
AddBundleNet                                 self,name,type,owner
AddBundleTemplate                            self,name,owner,width,isNewBundleCreated
BundleAlreadyThere                           self,bundleName
ClearEditMaps                                self
CopyBundleDefToLib                           self,NGName,destLib
DeleteBundleMember                           self,name,memberOfName
ExportToDCF                                  pLib,fileName,FElockNF
GetAllUnNamedBundles                         (overloaded)
GetBundle                                    (overloaded)
GetBundleMembers                             self,name,bundleMemberArray
GetBundleNet                                 (overloaded)
GetBundleNets                                (overloaded)
GetBundleProperty                            self,BundleName,PropName
GetBundlePropertyMap                         self,BundleName,PropertiesMap
GetBundleTemplates                           (overloaded)
GetDisplayBundleName                         (overloaded)
GetInternalBundleName                        (overloaded)
GetMemerIndexFromUnnamedBundle               self,pObj,memberName
GetNameForUnNamedBundle                      self,index,pObj,bundleNetName,parentName
GetNextPort                                  self,nPos,Name
GetPortIter                                  self
GetSubBundleName                             (overloaded)
GetTempName                                  self,isTop,BundleName,bundleTempName
GetUnnamedBundleOwnerObject                  self,pObj,newIndex
GetUnnamedBundleWidth                        self,pObject,width
IsBundle                                     self,name
IsBundleMember                               (overloaded)
IsInstantiatedBundleMember                   self,bundleOwner,bundleName,memberName
IsInternalProperty                           propName
isMemberAddable                              (overloaded)
LookUpNets                                   self,name
MarkModifiedDesign                           self
MoveUpDown                                   self,BundleName,index,isUp
NewBundleMemberIter                          self,name
NewBundleNetIter                             (overloaded)
ReadOneBundle                                self,file,TemplateVersion
RemoveBundleSafe                             self,name,BundleSourceLibName
RenameBundleMember                           self,name,OldmemberOfName,NewMemberName
SaveOneBundle                                self,file,BundleName
sGetMemberTypeIdGivenString                  memberType
sGetMemberTypeStringGivenId                  id
```

## DboBundleType (10)

```text
~delete                                      self
AddParent                                    self,parent
GetBundleType                                self
GetName                                      self,name
GetObjectType                                self
GetParent                                    self
GetWidth                                     self
RemoveParent                                 self,parent
SetAllParentDirty                            self,parent
SetName                                      self,name
```

## DboBus (11)

```text
CompareRanges                                (overloaded)
GetBaseName                                  BusName,BaseName
GetBusWidth                                  Busname
GetMember                                    (overloaded)
GetMemberPosition                            (overloaded)
IsBundleMember                               memberName,AliAsName,pWireBus
IsEquivalentBusName                          Name1,Name2
IsEquivalentBusNameWithBitsSwapped           Name1,Name2
NewBusMemberName                             BusName,BaseName,nLsb,nMsb,nIndex
NewBusName                                   BusName,BaseName,nLsb,nMsb
ValidBusName                                 BusName,BaseName,nLsb,nMsb
```

## DboBusEntry (25)

```text
GetBoundingBox                               self
GetColor                                     self,status
GetContainingLib                             self
GetEndPoint                                  self,status
GetEndWire                                   self,status
GetEntryPoint                                self,status
GetEntryWire                                 self,status
GetId                                        self,status
GetObjectType                                self
GetOwner                                     self
GetUserData                                  self,status
IsBundle                                     self,status
IsBus                                        self,status
MarkModified                                 self
SetBoundingBox                               self,rect
SetColor                                     self,color
SetEndPoint                                  self,location
SetEntryPoint                                self,location
SetId                                        self,nId
SetUserData                                  self,pPtr
sGetColor                                    obj,status
sGetEndPointX                                obj,status
sGetEndPointY                                obj,status
sGetEntryPointX                              obj,status
sGetEntryPointY                              obj,status
```

## DboBusEntryData (6)

```text
Color_get                                    self
Color_set                                    self,Color
End_get                                      self
End_set                                      self,End
Start_get                                    self
Start_set                                    self,Start
```

## DboBusMemberNamesIter (3)

```text
~delete                                      self
NextBundleMemberName                         self,Name,parentName
NextMemberName                               self,Name
```

## DboCell (9)

```text
AddPart                                      self,part
FindPart                                     self,index,status
GetObjectType                                self
GetPart                                      self,name,status
GetSemanticString                            self,str
GetSize                                      self,status
IsEquivalent                                 self,pObj
NewPartNamesIter                             self,status
NewPartsIter                                 self,status
```

## DboCellPartNamesIter (2)

```text
~delete                                      self
NextName                                     self,NxtName
```

## DboCellPartsIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextPart                                     self,status
```

## DboColorRotMirror (6)

```text
GetColor                                     self
GetMirror                                    self
GetRotation                                  self
SetColor                                     self,nColor
SetMirror                                    self,bMirror
SetRotation                                  self,nRotation
```

## DboCommentText (25)

```text
GetAnchorPoint                               self
GetBoundingBox                               self
GetFont                                      self,status
GetFontId                                    self
GetHorizontalTextJustification               self
GetLocation                                  self,status
GetObjectType                                self
GetText                                      self,txt
IsFontDefault                                self,status
Move                                         self,ptOffset
SetAnchorPoint                               self,pAnchorPT
SetBoundingBox                               self,box
SetFont                                      self,font
SetHorizontalTextJustification               self,pHpos
SetLocation                                  self,point
SetRecalBoundingBox                          self
SetText                                      self,text
sGetBoundingBoxBottom                        obj,status
sGetBoundingBoxLeft                          obj,status
sGetBoundingBoxRight                         obj,status
sGetBoundingBoxTop                           obj,status
sGetFont                                     obj,status
sGetLocationX                                obj,status
sGetLocationY                                obj,status
sGetText                                     obj,status
```

## DboConnectivityChangeIter (5)

```text
~delete                                      self
NextAddorModifiedDbObject                    self,pUniqueKey,pObject
NextDeletedDbObject                          self,pUniqueKey,pObject
NextFlatNetChange                            self,pFlatNetName,pFlatNetCanonicalPath,pFlatNet,pState,pFlatNetNameAnother,pOtherFlatNetCanonicalPath,pFlatNetAnother
NextPinChange                                self,pPinCanonicalName,pPinNumber,pPartRef,pPartDesignator,pIsGlobal,pPinCategory,pState,pOtherPinCanonicalName,pOtherPinNumber,pOtherPartRef,pOtherPartDesignator,pOtherIsGlobal,pOtherPinCategory
```

## DboConnectivityObjectsAtPointIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextObject                                   self,status
```

## DboCustomItemInstance (9)

```text
GetCookie                                    self
GetInterfaceID                               self
GetOwningOccurrence                          self
GetPluginName                                self
GetType                                      self
SetCookie                                    self,nCookie
SetInterfaceID                               self,idInterfaceID
SetPluginName                                self,strPluginName
SetType                                      self,nType
```

## DboDBPropsIter (3)

```text
~delete                                      self
Next                                         self,status
NextDBProp                                   self,status
```

## DboDBQuery (20)

```text
GetPortOccFromCanonicalName                  (overloaded)
sClearPathHistory                            pPath
sCreateCanonicalNameForCMObjects             (overloaded)
sFindFlatNetFromCanonicalName                (overloaded)
sGetAllFlatNetsOfDesign                      (overloaded)
sGetAllPartsOfDesign                         (overloaded)
sGetAllPinsOfDesign                          (overloaded)
sGetAllPinsOfFlatNet                         (overloaded)
sGetAllPinsOfPart                            (overloaded)
sGetAlternateNetName                         pFlatnet
sGetAlternatePartName                        pPartOcc
sGetAlternatePinName                         pPartOcc,pPortOcc
sGetCurrentTime                              (zero-arg-ok)
sGetDesign                                   pDesignName
sGetFlatNetFromPortOcc                       DboPortOccurrence,*
sGetFlatNetJSON                              aFlatNetCName,aFlatNetPhysicalName
sGetLibraryFileMetadata                      apSession,apLibPathArr,aJSON
sGetObjectsFromJSON                          pObjectsJSON,pTitle,pObjects
sGetPinNumber                                aPortOcc,aPinNumber
sGetPinPhysicalNameToPortOccMap              (overloaded)
```

## DboDefinition (4)

```text
DBPropsList_get                              self
DBPropsList_set                              self,DBPropsList
nNameID_get                                  self
nNameID_set                                  self,nNameID
```

## DboDeletedObject (4)

```text
~delete                                      self
GetObjectType                                self
GetParentObj                                 self
SetNextState                                 self,pObj
```

## DboDesign (85)

```text
AddInstOccToPackageInstOcc                   self,pInstOcc
AnnotateControlExists                        self
AuditDBObserver                              (overloaded)
DesignHasExternalSchematics                  self
DesignHasOccurrenceProperties                self,status
DesignHasReusedSchematics                    self
EndDBBatchUpdate                             self
GetCISDesign                                 self,DboState&
GetCISNotStuffedString                       self
GetContainingLib                             self
GetDCFPath                                   self
GetDesignExtDataJson                         self
GetDesignId                                  (overloaded)
GetDesignLoadStateInCM                       self
GetDesignModifiedTime                        self
GetFlatNetfrmId                              self,int
GetFlatNetfrmName                            self,pFlatNetName
GetFlatNetNamefrmId                          self,int
GetInstOccsOfCachedPackages                  self,pListCachedPackages,pMapPackageVsInstOcc
GetInstOccurrence                            (overloaded)
GetInstOccurrenceByName                      self,pathname,chSeparator,status
GetInstOccurrenceByRef                       self,pathname,chSeparator,bPhysical,status
GetModifiedFlatNets                          self
GetNetOccurrence                             (overloaded)
GetNetOccurrenceByRef                        self,pathname,chSeparator,bPhysical,status
GetObjectType                                self
GetOccurrence                                self,id,status
GetOffPageOccurrence                         self,id,status
GetOffPageOccurrenceByRef                    self,pathname,chSeparator,bPhysical,status
GetOpenCISDesign                             self
GetPackageInstOcc                            self,pReference,status
GetPageFromID                                self,nPageID
GetParentObj                                 self
GetPortOccurrence                            (overloaded)
GetPortOccurrenceByRef                       self,pathname,chSeparator,bPhysical,status
GetPowerPinsVisible                          self,DboState&
GetRefDesMgr                                 self
GetRoot                                      self,status
GetRootName                                  self,rootName
GetRootOccurrence                            self,status
GetRootSchematic                             self,status
GetTitleBlockOccurrence                      self,id,status
GetTitleBlockOccurrenceByRef                 self,pathname,chSeparator,bPhysical,status
HasBoardNetlistGenerated                     self
HasRootOccurrence                            self
IsDesignCMDisabled                           self
IsDesignCMEnabled                            self
IsDesignInOccurrenceMode                     self,status
IsDesignPartiallyCMEnabled                   self
IsFlatDesign                                 self,status
isFlatNetsPresent                            self
isHSObjectsExist                             self
IsModified                                   self,status
IsPNNMActive                                 self
IsRemovePNNMSelected                         self
IsRootOccurrenceExisting                     self
LimitExceededNets                            self
LimitExceededParts                           self
MarkModified                                 self,pOccurrence
NewCachesIter                                (overloaded)
NewConnectivityChangeIter                    self,status
NewFlatNetsIter                              (overloaded)
NewGlobalsIter                               (overloaded)
NewOccurrencesIter                           self,status
NewPackageInstOccurrenceIter                 self,pReference,status
NewSchematicOccurrencesIter                  (overloaded)
OccurrencesExist                             self,pObj,status
ParseDesignExtDataJson                       pJson,pinstallMode,pstrLic,pstrVersion,pstrISR
RegisterAuditCBFn                            self,pName,pCallbackFn
RemoveInstOccFromPackageInstOcc              self,pInstOcc
ResumeDBTracking                             (overloaded)
SetBoardNetListGenerated                     self,flag
SetCISNotStuffedString                       self,strNotStuff
SetConnectivityUpdateTracking                (overloaded)
setDesignLoadStateInCM                       self,pState
SetIsPNNMActive                              self,pm_PNNMActive
SetPowerPinsVisible                          self,bPowerPinsVisible
SetRemovePNNMSelected                        self,pm_RemovePNNM
SetRoot                                      self,view
sGetOpenPwdDialog                            (overloaded)
sGetPasswordFromUser                         password,title
StartDBBatchUpdate                           self
SubscribeForDBChange                         (overloaded)
SuspendDBTracking                            self
UnsubscribeForDBChange                       (overloaded)
```

## DboDesignCachesIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextDesignCache                              self,status
```

## DboDesignFlatNetsIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextFlatNet                                  self,status
```

## DboDesignGlobalsIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextGlobal                                   self,status
```

## DboDesignOccurrencesIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextOccurrence                               self,status
```

## DboDesignPackageInstOccIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextPkgInstOcc                               self,status
```

## DboDesignSchematicOccurrencesIter (5)

```text
~delete                                      self
GetKey                                       self,pObject
HasOccurrences                               self
Next                                         self,status
NextSchematicOccurrence                      self,status
```

## DboDesignUpdateOccurrenceBlockerManager (1)

```text
Release                                      (overloaded)
```

## DboDevice (30)

```text
Cleanup                                      self
DeletePinNumber                              self,position
DeletePinNumberAtPosition                    self,position
GeneratePinNumber                            self,position,UniqueName
GetCell                                      self,status
GetCellName                                  self,name
GetContainingLib                             self
GetDesignator                                self,designator
GetIsShared                                  self,position,status
GetObjectType                                self
GetOwner                                     self
GetParentObj                                 self
GetPinCount                                  self,status
GetPinNumber                                 self,position,PinNumber
GetPinPosition                               self,pinNumber,status
GetPinSwapId                                 self,position,status
GetPosition                                  self,status
GetSemanticString                            self,str
GetSize                                      self,status
IsEquivalent                                 self,pObj
MarkModified                                 self
NewPinNumber                                 (overloaded)
NewPinNumbersIter                            self
SetCell                                      self,cell
SetDesignator                                self,name
SetIsShared                                  self,position,isShared
SetPinNumber                                 self,position,pinNumber
SetPinSwapId                                 self,position,nSwapId
sGetDesignator                               obj,status
sGetSize                                     obj,status
```

## DboDevicePinNumbersIter (2)

```text
~delete                                      self
NextNumber                                   self,pinNumber
```

## DboDirectory (21)

```text
ClearModified                                self,name
ClearObject                                  self,name
GetCreateTime                                self,name,status
GetEntry                                     (overloaded)
GetModifyTime                                self,name,status
GetObject                                    self,name,status
GetPackageFromMemory                         self,aName,status
GetSaveTime                                  self
GetTimeZone                                  (zero-arg-ok)
GetTimeZoneOffset                            (zero-arg-ok)
IsAnyEntryModified                           self
IsInMemory                                   self,name,status
IsModified                                   self,name
IsSaved                                      self,name
MarkModified                                 self,name
MarkSaved                                    self,name
MarkToBeDeleted                              self,name
MarkToBeSaved                                self,name
NewEntriesIter                               self,status
NewObjectsIter                               self,status
ReadPackageModifiedTime                      self,pFile,pPackageName,lFileTime
```

## DboDirectoryEntriesIter (2)

```text
~delete                                      self
NextEntry                                    self,status
```

## DboDirectoryEntry (4)

```text
m_Name_get                                   self
m_Name_set                                   self,m_Name
m_Rec_get                                    self
m_Rec_set                                    self,m_Rec
```

## DboDirectoryObjectsIter (2)

```text
~delete                                      self
NextObject                                   self,status
```

## DboDirectoryRec (20)

```text
bModified_get                                self
bModified_set                                self,bModified
bSaved_get                                   self
bSaved_set                                   self,bSaved
bToBeDeleted_get                             self
bToBeDeleted_set                             self,bToBeDeleted
bToBeSaved_get                               self
bToBeSaved_set                               self,bToBeSaved
nCreatedTime_get                             self
nCreatedTime_set                             self,nCreatedTime
nDBRelease_get                               self
nDBRelease_set                               self,nDBRelease
nDBVersion_get                               self
nDBVersion_set                               self,nDBVersion
nModifiedTime_get                            self
nModifiedTime_set                            self,nModifiedTime
nType_get                                    self
nType_set                                    self,nType
pObject_get                                  self
pObject_set                                  self,pObject
```

## DboDisplayProp (50)

```text
GetActualValueString                         self,pBaseObject,value
GetAnchorPoint                               self
GetBoundingBox                               self
GetColor                                     self,status
GetContainingLib                             self
GetDefaultFontType                           (overloaded)
GetDisplayType                               self,status
GetFont                                      self,dbFontType,logfont
GetFontID                                    self
GetHorizontalTextJustification               self
GetId                                        (overloaded)
GetLocation                                  self,status
GetName                                      self,name
GetObjectType                                self
GetOwner                                     self
GetParentObj                                 self
GetRotation                                  self,status
GetValueString                               (overloaded)
GetValueStringForOccurrence                  self,DWID,value
IsBoundingBoxDirty                           self
IsFontDefault                                self,DboState&
MarkModified                                 self
SetAnchorPoint                               self,pAnchorPT
SetBoundingBox                               self,rect
SetBoundingBoxDirty                          self,bSetting
SetColor                                     self,color
SetDisplayType                               self,type
SetFont                                      self,font
SetHorizontalTextJustification               self,pHpos
SetId                                        self,newId
SetLocation                                  self,location
SetName                                      self,name
SetOwnerBoundingBoxDirty                     self,bSetting
SetRotation                                  self,rotation
SetValueString                               (overloaded)
sGetColor                                    obj,status
sGetDisplayType                              obj,status
sGetFont                                     obj,status
sGetLocationX                                obj,status
sGetLocationY                                obj,status
sGetName                                     obj,status
sGetRotation                                 obj,status
sGetValue                                    obj,status
sSetColor                                    obj,color
sSetDisplayType                              obj,displayType
sSetFont                                     obj,font
sSetLocationX                                obj,x
sSetLocationY                                obj,y
sSetName                                     obj,name
sSetRotation                                 obj,rotation
```

## DboDisplayPropsIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextProp                                     self,status
```

## DboDrawnInst (16)

```text
ChangePinNamesIfPartOfBundle                 self,bundleName,Prefix
DeleteEffectiveProp                          self,name
DeletePinForBundle                           self,deletePinstList
DeletePortInst                               (overloaded)
GetDefiningSymbol                            self,status
GetUnnamedNetgroupPortOrder                  self,pPortOrder
NewPortInstBus                               (overloaded)
NewPortInstScalar                            (overloaded)
NormalizeBundleBlock                         self
NormalizeUnanamedBundleBlockIfAutoGenerated  self
PushUserPropertiesToNets                     self
SetBoundingBox                               self,box
SetEffectivePropStringValue                  (overloaded)
SetReference                                 (overloaded)
StatefulCreate                               self
SwapPortInstForBundle                        self,status,newPinVec
```

## DboEffectivePropsIter (2)

```text
~delete                                      self
NextEffectiveProp                            (overloaded)
```

## DboEllipse (20)

```text
GetBoundingBox                               self
GetFillStyle                                 self,status
GetHatchStyle                                self,status
GetLineStyle                                 self,status
GetLineWidth                                 self,status
GetObjectType                                self
Move                                         self,ptOffset
SetBoundingBox                               self,box
SetFillStyle                                 self,style
SetHatchStyle                                self,style
SetLineStyle                                 self,style
SetLineWidth                                 self,width
sGetBoundingBoxBottom                        obj,status
sGetBoundingBoxLeft                          obj,status
sGetBoundingBoxRight                         obj,status
sGetBoundingBoxTop                           obj,status
sGetFillStyle                                obj,status
sGetHatchStyle                               obj,status
sGetLineStyle                                obj,status
sGetLineWidth                                obj,status
```

## DboEllipseData (10)

```text
Bound_get                                    self
Bound_set                                    self,Bound
FillStyle_get                                self
FillStyle_set                                self,FillStyle
HatchStyle_get                               self
HatchStyle_set                               self,HatchStyle
LineStyle_get                                self
LineStyle_set                                self,LineStyle
LineWidth_get                                self
LineWidth_set                                self,LineWidth
```

## DboERC (10)

```text
GetDetail                                    self,detail
GetError                                     self,error
GetLocationString                            self,location
GetSeverity                                  self,status
SetLocation                                  self,location
SetMirror                                    self,mirror
SetRotation                                  self,rotation
sGetDetail                                   obj,status
sGetError                                    obj,status
sGetSeverity                                 obj,status
```

## DboExtBlobHandler (7)

```text
~delete                                      self
Construct                                    (overloaded)
getType                                      self
getVersion                                   self
Serialize                                    self,pNode
setType                                      self,pType
setVersion                                   self,pVersion
```

## DboExtBlobHandlerExtMask (3)

```text
~delete                                      self
Construct                                    (overloaded)
Serialize                                    self,pNode
```

## DboExtBlobHandlerImage (3)

```text
~delete                                      self
Construct                                    (overloaded)
Serialize                                    self,pNode
```

## DboExtBlobHandlerLineStyle (3)

```text
~delete                                      self
Construct                                    (overloaded)
Serialize                                    self,pNode
```

## DboExtBlobHandlerPassThru (3)

```text
~delete                                      self
Construct                                    (overloaded)
Serialize                                    self,pNode
```

## DboExtBlobHandlerRegistry (5)

```text
GetPassThruHandler                           self
LookupHandler                                self,pType,pVersion
RegisterHandler                              self,pType,pVersion,pHandler
RemoveHandler                                self,pType,pVersion
sGetInstance                                 (zero-arg-ok)
```

## DboExtBlobNode (34)

```text
~delete                                      self
BlobNodeData_t                               (n/a)
BlobNodeData_t_m_Bitmap_get                  self
BlobNodeData_t_m_Bitmap_set                  self,m_Bitmap
BlobNodeData_t_m_Id_get                      self
BlobNodeData_t_m_Id_set                      self,m_Id
BlobNodeData_t_m_Seq_get                     self
BlobNodeData_t_m_Seq_set                     self,m_Seq
BlobNodeData_t_m_Stream_get                  self
BlobNodeData_t_m_Stream_set                  self,m_Stream
BlobNodeData_t_m_StreamSize_get              self
BlobNodeData_t_m_StreamSize_set              self,m_StreamSize
BlobNodeData_t_m_Type_get                    self
BlobNodeData_t_m_Type_set                    self,m_Type
BlobNodeData_t_m_Version_get                 self
BlobNodeData_t_m_Version_set                 self,m_Version
GetBitmap                                    self
GetId                                        self
GetNodeDataSize                              self
GetSequence                                  self
GetStream                                    self
GetStreamSize                                self
GetType                                      self
GetVersion                                   self
InitBlob                                     self,pBlobNode
LoadNodeData                                 self,pNodeData
SetBitmap                                    self,pBitmap
SetId                                        self,pId
SetSequence                                  self,pSeq
SetStream                                    self,pStream
SetStreamSize                                self,pSize
SetType                                      self,pType
SetVersion                                   self,pVersion
StoreNodeData                                self,pBuffer
```

## DboExtBlobNodeExtMask (4)

```text
~delete                                      self
Init                                         self
LoadNodeData                                 self,pNodeData
StoreNodeData                                self,pBuffer
```

## DboExtBlobNodeImage (11)

```text
~delete                                      self
GetImageStream                               self
GetImageStreamSize                           self
GetImageType                                 self
Init                                         self
LoadNodeData                                 self,pNodeData
SetImageStream                               self,pStream,pSize
SetImageType                                 self,pType
sImageTypeToName                             pType
sNameToImageType                             pTypeExt
StoreNodeData                                self,pBuffer
```

## DboExtBlobNodePassThru (7)

```text
~delete                                      self
GetPassThruStream                            self
GetPassThruStreamSize                        self
Init                                         self
LoadNodeData                                 self,pNodeData
SetPassThruStream                            self,pStream,pSize
StoreNodeData                                self,pBuffer
```

## DboExtBlobNodePsp2Cap (5)

```text
~delete                                      self
GetData                                      self
LoadNodeData                                 self,pNodeData
SetData                                      self,pPspiceData
StoreNodeData                                self,pBuffer
```

## DboExtCentral (8)

```text
CopyExtensions                               self,pSource,pDest
CreateBlobExtension                          self,pObject,pType,pSubType,pVersion
CreateExtension                              self,pObject,pType
GetBlobExtension                             self,pObject,pSubType,pVersion
GetExtension                                 self,pObject,pType
RegisterBlobHandler                          self,pType,pVersion,pHandler
SetExtension                                 self,pObject,pExtension
sGetInstance                                 (zero-arg-ok)
```

## DboExtension (10)

```text
~delete                                      self
Copy                                         self
GetDataHeaderSize                            (zero-arg-ok)
GetExtensionName                             self
GetExtensionType                             (overloaded)
GetSignature                                 (zero-arg-ok)
IsSignatureValid                             pSignature
IsValid                                      self
IsValidType                                  pExtension
Store                                        self,pExtensionData
```

## DboExtensionCreator (1)

```text
Create                                       (overloaded)
```

## DboExtensionDataT (8)

```text
m_Data_get                                   self
m_Data_set                                   self,m_Data
m_DataSize_get                               self
m_DataSize_set                               self,m_DataSize
m_DataType_get                               self
m_DataType_set                               self,m_DataType
m_ExtensionType_get                          self
m_ExtensionType_set                          self,m_ExtensionType
```

## DboExtensionFactory (3)

```text
CreateBlobExtension                          self,pObject,pType,pSubType,pVersion
CreateExtension                              self,pObject,pType
sGetInstance                                 (zero-arg-ok)
```

## DboExtensionGeneric (4)

```text
~delete                                      self
Copy                                         self
sLoad                                        pExtensionData
Store                                        self,pExtensionData
```

## DboExtensionIter (2)

```text
~delete                                      self
NextExtension                                self,status
```

## DboExtensionManager (14)

```text
AddExtension                                 self,pHandle,pExtension
CopyExtensions                               self,pDest,pSource
CreateHandle                                 (overloaded)
DeleteHandle                                 self,pHandle
GetExtension                                 self,pHandle,pExtensionType
GetNumElements                               self,pHandle
IsEmpty                                      self,pHandle
LoadExtensions                               self,pBufferSize,pBuffer
NewExtensionIter                             self,pHandle,status
RemoveAllExtensions                          self,pHandle
RemoveExtension                              (overloaded)
ReplaceExtension                             self,pHandle,pNewExtension
sGetInstance                                 (zero-arg-ok)
StoreExtensions                              self,pHandle,pBufferSize,pBuffer
```

## DboExtensionMaskInfo (11)

```text
~delete                                      self
Copy                                         self
GetBitmask                                   self,pBitmask
GetMask                                      self
IsBitmaskAllowed                             pBitmask,pType
SetBitmask                                   self,pBitmask,pType
SetMask                                      self,pMask
sGetExtension                                pHandle
sLoad                                        pExtensionData
Store                                        self,pExtensionData
UnsetBitmask                                 self,pBitmask,pType
```

## DboExtnAttrLockPvt (24)

```text
~delete                                      self
Copy                                         self
GetLockInfo                                  self,propName,lockMask,preTrigger,postTrigger
GetLockMask                                  self
GetNext                                      self
GetNumNode                                   self
GetPropName                                  self
GetTrigger                                   self,pre
IsAttributeLockingSupported                  propName
IsDeleteLocked                               self
IsDisplayLocked                              self
IsLocationLocked                             self
IsPostTriggerSupported                       self
IsPretriggerSupported                        self
IsSystemLocked                               self
IsValueLocked                                self
ResetLock                                    self,lockMask
SetLock                                      self,lockMask
SetLockInfo                                  self,propName,lockMask,preTrigger,postTrigger
SetNext                                      self,tmpNode
SetTrigger                                   self,triggerName,pre
sGetExtension                                pHandle
sLoad                                        pExtensionData
Store                                        self,pExtensionData
```

## DboExtnPropertyBag (10)

```text
AddProperty                                  self,BagType,pBagName,pPropName,pPropValue
Copy                                         self
GetBagTypeString                             self,bagType
GetPropertyBag                               self,BagType
GetPropertyNameValueMap                      self,BagType,aBagName,lPropertyNameValue
GetPropertyTypeMap                           self
GetPropertyValue                             self,BagType,aBagName,PropName,PropValue
sGetExtension                                pHandle
sLoad                                        pExtensionData
Store                                        self,pExtensionData
```

## DboFill (12)

```text
GetFillStyle                                 self,status
GetHatchStyle                                self,status
GetObjectType                                self
GetStart                                     self,status
Move                                         self,ptOffset
SetFillStyle                                 self,style
SetHatchStyle                                self,style
SetStart                                     self,point
sGetFillStyle                                obj,status
sGetHatchStyle                               obj,status
sGetStartX                                   obj,status
sGetStartY                                   obj,status
```

## DboFlatNet (31)

```text
ComputeName                                  (overloaded)
DeleteEffectiveProp                          self,name
GetAttributeLockingInfo                      self,propName,lLock,preTrigger,postTrigger
GetColor                                     self,status
GetContainingLib                             self
GetEffectivePropStringValue                  (overloaded)
GetFlatNetCanonicalName                      (overloaded)
GetId                                        self,status
GetIsGlobal                                  self,status
GetIsPower                                   self,aStatus
GetLineStyle                                 self,status
GetLineWidth                                 self,status
GetName                                      self,Name
GetNameStrategy                              self
GetObjectOccurrences                         (overloaded)
GetObjectType                                self
GetOwner                                     self
GetParentObj                                 self
GetTopNet                                    self,status
NewEffectivePropsIter                        (overloaded)
NewNetOccurrencesIter                        self
NewNetsIter                                  (overloaded)
NewPortOccurrencesIter                       (overloaded)
NewWiresIter                                 (overloaded)
SetEffectivePropStringValue                  (overloaded)
sGetColor                                    obj,status
sGetId                                       obj,status
sGetIsGlobal                                 obj,status
sGetLineStyle                                obj,status
sGetLineWidth                                obj,status
sGetName                                     obj,status
```

## DboFlatNetEffectivePropsIter (2)

```text
~delete                                      self
NextEffectiveProp                            (overloaded)
```

## DboFlatNetNetOccurrencesIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextNetOccurrence                            self,status
```

## DboFlatNetNetsIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextNet                                      self,status
```

## DboFlatNetPortOccurrencesIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextPortOccurrence                           self,status
```

## DboFlatNetWiresIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextWire                                     self,status
```

## DboFontAndRotation (4)

```text
GetFontID                                    self
GetRotation                                  self
SetFontID                                    self,nFontID
SetRotation                                  self,nRotation
```

## DboGlobal (5)

```text
GetGlobalSymbol                              self,status
GetPinType                                   self,status
SetMirror                                    self,mirror
SetName                                      self,name
SetRotation                                  self,rotation
```

## DboGraphicArcInst (18)

```text
GetDboArc                                    self
Move                                         self,offset
SetBoundingRect                              self,rect
SetEnd                                       self,point
SetLineStyle                                 self,style
SetLineWidth                                 self,width
SetStart                                     self,point
sGetBoundingBoxBottom                        obj,status
sGetBoundingBoxLeft                          obj,status
sGetBoundingBoxRight                         obj,status
sGetBoundingBoxTop                           obj,status
sGetEndX                                     obj,status
sGetEndY                                     obj,status
sGetLineStyle                                obj,status
sGetLineWidth                                obj,status
sGetStartX                                   obj,status
sGetStartY                                   obj,status
StatefulCreate                               self
```

## DboGraphicBezierInst (9)

```text
GetDboBezier                                 self
Move                                         self,offset
MovePoint                                    self,nPoint,offset
NewPoint                                     (overloaded)
SetLineStyle                                 self,style
SetLineWidth                                 self,width
sGetLineStyle                                obj,status
sGetLineWidth                                obj,status
StatefulCreate                               self
```

## DboGraphicBitMapInst (7)

```text
GetBoundingBox                               self
GetDboBitMap                                 self
SetBoundingBox                               self,rect
sGetBottom                                   obj,status
sGetLeft                                     obj,status
sGetRight                                    obj,status
sGetTop                                      obj,status
```

## DboGraphicBoxInst (17)

```text
GetDboBox                                    self
Move                                         self,offset
SetFillStyle                                 self,style
SetHatchStyle                                self,style
SetLineStyle                                 self,style
SetLineWidth                                 self,width
SetLowerRight                                self,point
SetUpperLeft                                 self,point
sGetBottom                                   obj,status
sGetFillStyle                                obj,status
sGetHatchStyle                               obj,status
sGetLeft                                     obj,status
sGetLineStyle                                obj,status
sGetLineWidth                                obj,status
sGetRight                                    obj,status
sGetTop                                      obj,status
StatefulCreate                               self
```

## DboGraphicCommentTextInst (14)

```text
GetDboCommentText                            self
Move                                         self,offset
SetFont                                      self,rLF
SetLocation                                  self,pt
SetText                                      self,rText
sGetBoundingBoxBottom                        obj,status
sGetBoundingBoxLeft                          obj,status
sGetBoundingBoxRight                         obj,status
sGetBoundingBoxTop                           obj,status
sGetFont                                     obj,status
sGetLocationX                                obj,status
sGetLocationY                                obj,status
sGetText                                     obj,status
StatefulCreate                               self
```

## DboGraphicEllipseInst (16)

```text
GetDboEllipse                                self
Move                                         self,offset
SetBoundingRect                              self,rect
SetFillStyle                                 self,style
SetHatchStyle                                self,style
SetLineStyle                                 self,style
SetLineWidth                                 self,width
sGetBoundingBoxBottom                        obj,status
sGetBoundingBoxLeft                          obj,status
sGetBoundingBoxRight                         obj,status
sGetBoundingBoxTop                           obj,status
sGetFillStyle                                obj,status
sGetHatchStyle                               obj,status
sGetLineStyle                                obj,status
sGetLineWidth                                obj,status
StatefulCreate                               self
```

## DboGraphicInstance (48)

```text
DeleteAllDisplayProps                        self
DeleteUserProp                               self,name
DeleteUserPropValue                          self,name
Drag                                         self,offset
GetBoundingBox                               self
GetColor                                     self,status
GetContainingLib                             self
GetDefiningGraphicObject                     self,status
GetDisplayPropsPermitted                     self,status
GetDispPropArray                             self
GetEffectivePropStringValue                  (overloaded)
GetEffectivePropStringValueNC                self,name,value
GetGridLocation                              self,gridValue
GetId                                        self,status
GetLocation                                  self,status
GetMirror                                    self,status
GetName                                      self,name
GetObjectType                                self
GetOffsetBoundingBox                         self,status
GetOffsetGraphicPoint                        self,definingPoint
GetOwner                                     self
GetParentObj                                 self
GetRotation                                  self,status
GetSourceDefinition                          self,status
GetSourceLibName                             self,name
GetUserData                                  self,status
MarkModified                                 self
Move                                         self,offset
NewDisplayProp                               (overloaded)
NewDisplayPropsIter                          self,status
NewEffectivePropsIter                        (overloaded)
NewUserProp                                  (overloaded)
SetBoundingBox                               self,boundingBox
SetColor                                     self,color
SetId                                        (overloaded)
SetLocation                                  self,location
SetMirror                                    self,mirror
SetName                                      self,name
SetObjectType                                self,nType
SetRotation                                  self,rotation
SetUserData                                  self,pPtr
SetUserPropStringValue                       self,name,value
sGetColor                                    obj,status
sGetLocationX                                obj,status
sGetLocationY                                obj,status
sGetMirror                                   obj,status
sGetName                                     obj,status
sGetRotation                                 obj,status
```

## DboGraphicInstEffectivePropsIter (2)

```text
~delete                                      self
NextEffectiveProp                            (overloaded)
```

## DboGraphicLineInst (13)

```text
GetDboLine                                   self
Move                                         self,offset
SetEnd                                       self,point
SetLineStyle                                 self,style
SetLineWidth                                 self,width
SetStart                                     self,point
sGetEndX                                     obj,status
sGetEndY                                     obj,status
sGetLineStyle                                obj,status
sGetLineWidth                                obj,status
sGetStartX                                   obj,status
sGetStartY                                   obj,status
StatefulCreate                               self
```

## DboGraphicObject (24)

```text
Clear                                        self
DeleteVector                                 self,pVector
GetBoundingBox                               self
GetColor                                     self,status
GetGraphicsArray                             self
NewArc                                       (overloaded)
NewBezier                                    (overloaded)
NewBitMap                                    self,status,BoundingBox,location,bmDimension,dwSize,lpDib
NewBox                                       (overloaded)
NewCommentText                               self,status,text,rectBound,location,font
NewEllipse                                   (overloaded)
NewFill                                      (overloaded)
NewLine                                      (overloaded)
NewOleEmbed                                  self,status,BoundingBox,location,bmDimension,dwSize,lpByte
NewPolygon                                   (overloaded)
NewPolyline                                  (overloaded)
NewSymbolVector                              self,status,location
NewVectorsIter                               self,status,mode
PinsAllowed                                  self,status
SetBoundingBox                               self,box
SetColor                                     self,color
sGetColor                                    obj,status
sGetName                                     obj,status
sSetColor                                    obj,color
```

## DboGraphicObjectVectorsIter (2)

```text
~delete                                      self
NextVector                                   self,status
```

## DboGraphicOleEmbedInst (7)

```text
GetBoundingBox                               self
GetDboOleEmbed                               self
SetBoundingBox                               self,rect
sGetBottom                                   obj,status
sGetLeft                                     obj,status
sGetRight                                    obj,status
sGetTop                                      obj,status
```

## DboGraphicPolygonInst (13)

```text
GetDboPolygon                                self
Move                                         self,offset
MovePoint                                    self,nPoint,offset
NewPoint                                     (overloaded)
SetFillStyle                                 self,style
SetHatchStyle                                self,style
SetLineStyle                                 self,style
SetLineWidth                                 self,width
sGetFillStyle                                obj,status
sGetHatchStyle                               obj,status
sGetLineStyle                                obj,status
sGetLineWidth                                obj,status
StatefulCreate                               self
```

## DboGraphicPolylineInst (9)

```text
GetDboPolyline                               self
Move                                         self,offset
MovePoint                                    self,nPoint,offset
NewPoint                                     (overloaded)
SetLineStyle                                 self,style
SetLineWidth                                 self,width
sGetLineStyle                                obj,status
sGetLineWidth                                obj,status
StatefulCreate                               self
```

## DboGraphicSymbolVectorInst (1)

```text
GetDboSymbolVector                           self
```

## DboInstanceDisplayPropsIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextProp                                     self,status
```

## DboInstData (8)

```text
bMirror_get                                  self
bMirror_set                                  self,bMirror
Color_get                                    self
Color_set                                    self,Color
Location_get                                 self
Location_set                                 self,Location
Rotation_get                                 self
Rotation_set                                 self,Rotation
```

## DboInstOccMapper (4)

```text
GetOccurrenceFromParent                      self,pParent
GetOccurrences                               self
GetOccurrencesAtPos                          self,pos
GetOccurrencesCount                          self
```

## DboInstOccurrence (88)

```text
AddVariantProp                               self,strName,strVal
ApplyIds                                     self
CheckAndCorrectSubTreeOccurrences            self,pGetMapperObjects
ClearVariantMap                              (overloaded)
Copy                                         self,pSource
CopyOccData                                  (overloaded)
DeleteDBProp                                 self,name
DeleteEffectiveProp                          self,name
ExpandOccurrences                            (overloaded)
ExpandSubTreeOccurrences                     self
FindInstance                                 self,status
FindPartInst                                 self,status
GetCanonicalName                             (overloaded)
GetCanonicalRefDes                           self
GetCdsRefRangeMap                            self
GetCellName                                  self,bVHDL
GetContents                                  self,status
GetDesignator                                self,designator
GetEffectivePropValueChoices                 self,name,choices
GetEffectivePropValueExists                  self,name,bExists
GetEffectivePropValueType                    self,name,nType,bEditable,bDeletable
GetFlatNet                                   self,pDboSchematicNet,pStatus
GetHdlName                                   (overloaded)
GetHierPathName                              (overloaded)
GetImplementationName                        (overloaded)
GetInstance                                  self,status
GetInstChildrenCount                         self,status
GetInstOccurrence                            (overloaded)
GetInstOccurrenceByHierPath                  self,name,status
GetInstOccurrenceByName                      self,Name,status
GetInstOccurrenceByRef                       self,Name,bPhysical,status
GetLibName                                   self,bVHDL
GetNetAndPortsValid                          self,status
GetNetOccurrence                             (overloaded)
GetNextNewVariantProp                        self,strName,strVal,bNewFound
GetObjectType                                self
GetOffPageOccurrence                         (overloaded)
GetPackageInstOcc                            self
GetPartInst                                  self,status
GetPartInstId                                self,status
GetPartInstNameForCanonicalPath              self,name
GetPartValue                                 self,value
GetPathName                                  (overloaded)
GetPathNameNumber                            (overloaded)
GetPortOccurrence                            (overloaded)
GetPortOccurrenceFromPinNumber               self,nPinNumber
GetPrefixReferenceRange                      (overloaded)
GetPropertyValuePrefixReferenceRange         self,pPrefix,pRangeList,pProperty,pValue,pStatus
GetReference                                 self,ref
GetReferenceDesignator                       self,refDes
GetReferenceRange                            self
GetRefPathName                               (overloaded)
GetSchematic                                 self,status
GetTitleBlockOccurrence                      (overloaded)
GetVariantProp                               self,strName,strVal
GetViewStr                                   self,bVHDL
HasChildren                                  self,status
HasPropertyThatExists                        self,status
IsNetlistIgnore                              self
IsPartInstBelongToExternalDesign             self
IsPrimitive                                  self,status
IsPSpiceOnly                                 self
IsRecursive                                  self,status
IsVariantPropMapEmpty                        self
NewChildrenIter                              (overloaded)
NewEffectivePropsIter                        (overloaded)
ProcessFlatNetForPartRename                  self
SetDesignator                                self,designator
SetEffectivePropStringValue                  (overloaded)
SetEffectivePropStringValueForced            (overloaded)
SetOnDiscardedPage                           (overloaded)
SetPackageInstOcc                            self,pPkgInstOcc
SetPartInstId                                self,nPartInstId
SetPartValue                                 self,value
SetReference                                 self,reference
SetReferenceRange                            self,pRefRangeValue
sGetContentsLibName                          obj,status
sGetContentsViewName                         obj,status
sGetContentsViewType                         obj,status
sGetDesignator                               obj,status
sGetId                                       obj,status
sGetIsPrimitive                              obj,status
sGetName                                     obj,status
sGetPartValue                                obj,status
sGetPathName                                 obj,status
sGetReference                                obj,status
sGetReferenceDesignator                      obj,status
UpdateNetAndPorts                            self
```

## DboInstOccurrenceEffectivePropsIter (2)

```text
~delete                                      self
NextEffectiveProp                            (overloaded)
```

## DboInvalidDeleteException (1)

```text
what                                         self
```

## DboInvalidPointerAccessException (1)

```text
what                                         self
```

## DboJsonUtils (1)

```text
GetPrefixReferenceRange                      (overloaded)
```

## DboLib (325)

```text
AbortTransactions                            self
AddStringToStringTable                       self,str,status
CacheIsOutOfDate                             (overloaded)
ChangePassword                               self,pPassword
CleanupCache                                 self
ClearModified                                (overloaded)
ClearModifiedAll                             self,pDboPackage
ClearPackageAll                              self,DboPackage,*
ClearSaveFlag                                self,pPackage
ClearUpRevDialogBit                          self
ComparePackageTimeFromDisk                   self,aLibName,aPackageName,lPackageModFileTime
ConvertRequired                              self
CopyCacheFromFile                            self,pLibFile,status
CopyCell                                     self,cell,newName,status
CopyGraphicObject                            self,graphic,newName,status
CopyGraphicObjectFromFile                    (overloaded)
CopyLibObject                                self,LibObje,newName,status
CopyObjectFromFile                           (overloaded)
CopyPackage                                  self,pPackage,newName,status
CopyPackageAll                               self,pPackage,newName,status
CopyPackageAllToCache                        self,source,SourceLibName,SourcePackageName,status
CopyPart                                     self,part,newName,status
CopySymbol                                   self,symbol,newName,status
CopySymbolFromFile                           (overloaded)
CopyView                                     self,view,newName,status
CorrectCacheEntry                            self
DeleteCell                                   self,cell
DeleteGraphicObject                          self,graphic
DeleteLibObject                              self,libObj
DeleteLibStoragePtr                          self
DeletePackage                                (overloaded)
DeletePackageAlias                           (overloaded)
DeletePackageAll                             self,pPackage
DeletePart                                   self,part
DeleteSymbol                                 self,symbol
DeleteView                                   self,view
DumpDirectoryInfo                            self,pName
ExplicitlyAddCellDirName                     self,cellDir
ExplicitlyAddPackageDirName                  self,packageName
ExplicitlyAddPartDirName                     self,partDir
ExplicitlyRemoveAliasName                    self,AliasNameToBeRemoved
ExplicitlyRemoveCellDirName                  self,CellNameToBeRemoved
ExplicitlyRemoveExportBlockDirName           self,SymbolNameToBeRemoved
ExplicitlyRemoveGraphicDirName               self,SymbolNameToBeRemoved
ExplicitlyRemovePackageDirName               self,PackageNameToBeRemoved
ExplicitlyRemovePartDirName                  self,PackageNameToBeRemoved
ExplicitlyRemovePartsDirName                 self,PartNameToBeRemoved
ExplicitlyRemoveSymbolDirName                self,SymbolNameToBeRemoved
ExplicitlyRemoveViewDirName                  self,PackageNameToBeRemoved
FixupMismatchedLibPartLookupNames            self
GetBitFlag                                   self
GetBookMarkSymbol                            self,Name,status
GetBundleDef                                 (overloaded)
GetBundleTemplateMap                         self
GetBundleTemplateMapForObject                self,pObject
GetCachedCell                                self,SourceLibName,SourceCellName
GetCachedGraphicObject                       self,SourceLibName,SourceGraphicName,type
GetCachedPackage                             self,SourceLibName,SourcePackageName
GetCachedPart                                self,SourceLibName,SourcePartName
GetCachedSymbol                              self,SourceLibName,SourceSymbolName,type
GetCachedTime                                self,nType,SourceLibName,objName,status
GetCell                                      self,name,status
GetCellCreateTime                            self,cell,status
GetCellModifyTime                            self,cell,status
GetContainingLib                             self
GetCreateTime                                (overloaded)
GetDataFormatVersion                         self,strVersion
GetDataRelease                               self
GetDataVersion                               self
GetDefaultDrawnInstIsPrimitive               self,status
GetDefaultFont                               self,nFontType,status
GetDefaultHorizontalLabelCount               self
GetDefaultHorizontalLabelIsAscending         self
GetDefaultHorizontalLabelIsChar              self
GetDefaultHorizontalLabelWidth               self
GetDefaultIsANSIGridRefs                     self
GetDefaultIsBorderDisplayed                  self
GetDefaultIsBorderPrinted                    self
GetDefaultIsGridRefDisplayed                 self
GetDefaultIsGridRefPrinted                   self
GetDefaultIsMetric                           self
GetDefaultIsTitleBlockDisplayed              self
GetDefaultIsTitleBlockPrinted                self
GetDefaultPageRec                            self,status
GetDefaultPinToPin                           self
GetDefaultPlacedInstIsPrimitive              self,status
GetDefaultVerticalLabelCount                 self
GetDefaultVerticalLabelIsAscending           self
GetDefaultVerticalLabelIsChar                self
GetDefaultVerticalLabelWidth                 self
GetDirectoryEntryTimeZone                    self,Name,nType,status
GetDirectoryEntryTimeZoneValue               self,DboDirectoryEntry,*
GetEffectivePropValueChoices                 self,name,choices
GetERCSymbol                                 self,Name,status
GetExportBlock                               self,name,status
GetExportBlockCreateTime                     self,exportBlock,status
GetExportBlockModifyTime                     self,exportBlock,status
GetExternalView                              self,Name,status
GetFont                                      self,nFontId
GetFontId                                    self,font
GetGlobalSymbol                              self,Name,status
GetGraphicObject                             self,name,status
GetGraphicObjectCreateTime                   self,graphic,status
GetGraphicObjectModifyTime                   self,graphic,status
GetIndexForString                            self,str,status
GetLibStoragePtr                             self
GetModifiedPackages                          pLibName,aOpenPackages,aModifiedPackages
GetModifiedTime                              self,objName,nType,status
GetModifiedTimeInUTC                         self,Name,nType,status
GetModifyTime                                (overloaded)
GetName                                      self,name
GetObjectType                                self
GetOffPageSymbol                             self,Name,status
GetOldName                                   self,name
GetOrStorageStream                           designName,storageName,std::vector<,std::string,>&,std::vector<,std::string,>&
GetOwner                                     self
GetPackage                                   self,name,status
GetPackageCreateTime                         self,pPackage,status
GetPackageFromMemory                         self,aName,status
GetPackageModifiedTime                       self,apPackageName,aFileTime
GetPackageModifyTime                         self,pPackage,status
GetPackageTimeZone                           self,apPackageName,TimeZone
GetParentObj                                 self
GetPart                                      self,name,status
GetPartCreateTime                            self,part,status
GetPartFieldMapping                          self,nNum,field
GetPartModifyTime                            self,part,status
GetPinShapeSymbol                            self,name,status
GetPortSymbol                                self,Name,status
GetSaveAsRelease                             self
GetSaveAsVersion                             self
GetSchematic                                 self,Name,status
GetSourceLibName                             self,objName,pCachedObj,libName
GetSourceTimeZone                            self,DboDirectoryEntry,*,aFileTimeToTimeT
GetStringPtrFromIndex                        self,nIndex,status
GetSymbol                                    self,name,status
GetSymbolCreateTime                          self,symbol,status
GetSymbolModifyTime                          self,symbol,status
GetSymbolTimeZone                            self,aSymbolName,TimeZone
GetTempPackageName                           self,pszFormatString,name
GetTempViewName                              self,pszFormatString,name
GetTitleBlockSymbol                          self,name,status
GetUpdatedPackage                            self,name,status
GetUserStorage                               self,name,status
GetView                                      self,name,status
GetViewCreateTime                            self,view,status
GetViewModifyTime                            self,view,status
IsAutoBackupOn                               self
IsAutoSaving                                 self
IsBitSet                                     self,bit
isBundleTemplateExists                       self
IsBundleUsed                                 (overloaded)
IsCacheTimeSameAsSource                      self,nType,SourceLibName,SourceName,status
IsCheckOn                                    self
IsCorrectOn                                  self
IsLibModifiedOnDisk                          self
IsModified                                   self,status
IsModifiedSinceAutoSave                      self,status
IsModifiedSinceLastAutoBackup                self,status
IsObjectModified                             self,pObj,status
IsOccRetainAndRemapMode                      self
IsPackageInMemory                            self,name,status
IsPasswordProtected                          self
IsPersistent                                 (overloaded)
IsRemoveBundleSelected                       self
IsSymbolInMemory                             self,name,status
IsUnnamedBundle                              (overloaded)
IsUpRevDialogBitSet                          self
LibTitle                                     (zero-arg-ok)
LimitExceeded                                self
MarkModified                                 (overloaded)
NewBookMarkSymbol                            self,name,status
NewCachedCell                                self,pPackageName,pLibName,status
NewCachedPackage                             self,pPackageName,pLibName,status
NewCachedPart                                self,pPackageName,pLibName,status
NewCachedSymbol                              self,pSymbolName,pLibName,pObjectType,status
NewCachesIter                                (overloaded)
NewCell                                      self,name,status
NewCellNamesIter                             self,status
NewCellsIter                                 self,status
NewChangedObjectsIter                        self,status
NewERCSymbol                                 self,name,status
NewExportBlockNamesIter                      self,status
NewExportBlocksIter                          self,status
NewExternalView                              self,name,type,FileName,status
NewGlobalSymbol                              self,name,status
NewGraphicNamesIter                          self,status
NewGraphicObject                             self,name,status
NewGraphicObjectsIter                        self,status
NewOffPageSymbol                             self,name,status
NewPackage                                   self,name,status
NewPackageAlias                              self,pPackage,alias
NewPackageAliasesIter                        self,name,status
NewPackageNamesIter                          (overloaded)
NewPackagesIter                              self,status
NewPart                                      self,name,status
NewPartNamesIter                             self,status
NewPartsIter                                 self,status
NewPinShapeSymbol                            self,name,status
NewPortSymbol                                self,name,status
NewSchematic                                 self,name,status
NewSymbolNamesIter                           self,status
NewSymbolsIter                               (overloaded)
NewTitleBlockSymbol                          self,name,status
NewUntitledName                              self,name
NewUnusedCacheEntriesIter                    self,status
NewViewNamesIter                             self,status
NewViewsIter                                 (overloaded)
OnChangeBundleDefinition                     self
PackageExists                                self,name,status
ReadForExistenceOfBundleMapData              (overloaded)
ReadPackage                                  self,aPackageName,DboPackage,*&,aCellDir,aPartDir
RefreshPackageDirectory                      self
RegenerateMissingCell                        self,pDev,strLibName,cellName,status
RemoveBundles                                self
RemoveCell                                   self,cell
RemoveGraphicObject                          self,graphic
RemoveOrStorageStream                        designName,storageName,std::vector<,std::string,>&
RemovePackage                                self,pPackage
RemovePart                                   self,part
RemovePassword                               self
RemoveSymbol                                 self,symbol
RemoveView                                   self,view
RenameObject                                 self,pObj,newName
RenameOrStorageStream                        designName,storageName,streamName
ReplaceCache                                 (overloaded)
ReplaceSourceLibName                         self,objName,pCachedObj,libName,newLibName
SaveAsRequired                               self,nRelease,nVersion
SaveBookMarkSymbol                           self,pSymbol
SaveCell                                     self,cell
SaveERCSymbol                                self,pSymbol
SaveExternalView                             self,view
SaveGlobalSymbol                             self,global
SaveGraphicObject                            self,graphic
SaveObject                                   self,pObj
SaveOffPageSymbol                            self,offpage
SavePackage                                  self,pPackage
SavePackageAll                               self,pPackage
SavePart                                     self,part
SavePinShapeSymbol                           self,pinShape
SavePortSymbol                               self,port
SaveSchematic                                self,schematic
SaveSymbol                                   self,symbol
SaveTitleBlockSymbol                         self,titleblock
SaveView                                     self,view
sEquivalentNames                             name1,name2,status
SetBit                                       self,bit,bOn
SetCheckFlag                                 self,pCheck
SetCorrectFlag                               self,pCorrect
SetDataRelease                               self,pRelease
SetDataVersion                               self,pVersion
SetDefaultDrawnInstIsPrimitive               self,bVal
SetDefaultFont                               self,nFontTYpe,font
SetDefaultHorizontalLabelCount               self,pHorizontalLabelCount
SetDefaultHorizontalLabelIsAscending         self,pHorizontalLabelIsAscending
SetDefaultHorizontalLabelIsChar              self,pHorizontalLabelIsChar
SetDefaultHorizontalLabelWidth               self,pHorizontalLabelWidth
SetDefaultIsANSIGridRefs                     self,pANSIGridRefs
SetDefaultIsBorderDisplayed                  self,pBorderDisplayed
SetDefaultIsBorderPrinted                    self,pBorderPrinted
SetDefaultIsGridRefDisplayed                 self,pGridRefDisplayed
SetDefaultIsGridRefPrinted                   self,pGridRefPrinted
SetDefaultIsMetric                           self,pIsMetric
SetDefaultIsTitleBlockDisplayed              self,pTitleBlockDisplayed
SetDefaultIsTitleBlockPrinted                self,pTitleBlockPrinted
SetDefaultPinToPin                           self,pPinToPin
SetDefaultPlacedInstIsPrimitive              self,bVal
SetDefaultVerticalLabelCount                 self,pVerticalLabelCount
SetDefaultVerticalLabelIsAscending           self,pVerticalLabelIsAscending
SetDefaultVerticalLabelIsChar                self,pVerticalLabelIsChar
SetDefaultVerticalLabelWidth                 self,pVerticalLabelWidth
SetFont                                      self,font
SetIsAutoBackupOn                            (overloaded)
SetIsAutoSaving                              (overloaded)
SetIsBundleSaveInProgress                    (overloaded)
SetLibStoragePtr                             self,pShareStorage
SetPartFieldMapping                          self,nNum,str
SetPassword                                  self,pPassword
SetUpRevDialogBit                            self
sGetCreateTime                               obj,status
sGetDefaultAliasFont                         obj,status
sGetDefaultBookMarkFont                      obj,status
sGetDefaultBorderFont                        obj,status
sGetDefaultCommentFont                       obj,status
sGetDefaultDrawnInstIsPrimitive              obj,status
sGetDefaultDrawnInstNameFont                 obj,status
sGetDefaultERCFont                           obj,status
sGetDefaultGraphicObjectFont                 obj,status
sGetDefaultNetNameFont                       obj,status
sGetDefaultNoConnectFont                     obj,status
sGetDefaultOffPageConnectorFont              obj,status
sGetDefaultOptimizerFont                     obj,status
sGetDefaultParameterFont                     obj,status
sGetDefaultPartReferenceFont                 obj,status
sGetDefaultPartValueFont                     obj,status
sGetDefaultPinNameFont                       obj,status
sGetDefaultPinNumberFont                     obj,status
sGetDefaultPlacedInstIsPrimitive             obj,status
sGetDefaultPortFont                          obj,status
sGetDefaultPowerFont                         obj,status
sGetDefaultPropertyFont                      obj,status
sGetDefaultPSpiceABMSymbolFont               obj,status
sGetDefaultPSpiceSimulationDirectiveSymbolFont obj,status
sGetDefaultPSpiceSourceSymbolFont            obj,status
sGetDefaultStimulusSymbolFont                obj,status
sGetDefaultTitleBlockFont                    obj,status
sGetModifyTime                               obj,status
sGetName                                     obj,status
sGetNormalizedName                           (overloaded)
sGetNormalizedObjectName                     name,NormalizedName
sGetTempName                                 (overloaded)
sGetTimeFormat                               obj,status
sGetUnNormalizedObjectName                   normalizeName,name
SizeOfLibTitle                               (zero-arg-ok)
SkipGraphicObjectOnFile                      (overloaded)
SkipObjectOnFile                             self,pFile,status
SkipSymbolOnFile                             (overloaded)
sSetTimeFormat                               obj,format
sSplitName                                   pszName,BaseName,Uniquifier,Extension
strgStatus_get                               self
strgStatus_set                               self,strgStatus
SymbolExists                                 self,name,status
TimeToString                                 self,time
TopologicalOrderingOfBundlesUsed             self,SourceLibName,pTopologicalOrder
UpdateCache                                  (overloaded)
```

## DboLibCachesIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextCachedObject                             self,status
```

## DboLibCellNamesIter (2)

```text
~delete                                      self
NextName                                     self,name
```

## DboLibCellsIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextCell                                     self,status
```

## DboLibChangedObjectsIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextObject                                   self,status
```

## DboLibExportBlockNamesIter (2)

```text
~delete                                      self
NextName                                     self,name
```

## DboLibExportBlocksIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextExportBlock                              self,status
```

## DboLibGraphicNamesIter (2)

```text
~delete                                      self
NextName                                     (overloaded)
```

## DboLibGraphicsIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextGraphicObject                            self,status
```

## DboLibObject (19)

```text
GetContainingLib                             self
GetCreateTime                                self,status
GetModifyTime                                self,status
GetName                                      self,name
GetObjectType                                self
GetOwner                                     self
GetParentObj                                 self
GetSemanticString                            self,str
GetSourceLibName                             self,name
IsCachedCopy                                 self
IsEquivalent                                 self,pObj
IsModified                                   self,status
IsOutOfDate                                  self,status
IsPersistent                                 self,status
MarkModified                                 self
SetName                                      self,name
SetObjectType                                self,nType
SetSourceLibName                             self,name
sGetName                                     obj,status
```

## DboLibPackageAliasesIter (2)

```text
~delete                                      self
NextAlias                                    self,name
```

## DboLibPackageNamesIter (2)

```text
~delete                                      self
NextName                                     self,name
```

## DboLibPackagesIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextPackage                                  self,status
```

## DboLibPart (38)

```text
GetCellPtr                                   self
GetContents                                  self,status
GetContentsLibName                           self,name
GetContentsViewName                          self,name
GetContentsViewType                          self,status
GetPackagePtr                                self
GetPartValue                                 self,value
GetPin                                       (overloaded)
GetPinNamesAreRotated                        self,status
GetPinNamesAreVisible                        self,status
GetPinNumbersAreVisible                      self,status
GetReference                                 self,name
GetReferenceDesignator                       self,refDes
GetSemanticString                            self,str
GetSuffix                                    self
IsEquivalent                                 self,pObj
MarkModified                                 self
NewLPinsIter                                 (overloaded)
SetCellPtr                                   self,pCell
SetContentsLibName                           self,libName
SetContentsViewName                          self,viewName
SetContentsViewType                          self,viewType
SetPackagePtr                                self,pPkg
SetPartValue                                 self,name
SetPinNamesAreRotated                        self,bVal
SetPinNamesAreVisible                        self,bVal
SetPinNumbersAreVisible                      self,bVal
SetReference                                 self,name
sGetContentsLibName                          obj,status
sGetContentsViewName                         obj,status
sGetContentsViewType                         obj,status
sGetPartValue                                obj,status
sGetPinCount                                 obj,status
sGetPinNamesAreRotated                       obj,status
sGetPinNamesAreVisible                       obj,status
sGetPinNumbersAreVisible                     obj,status
sGetReference                                obj,status
sGetReferenceDesignator                      obj,status
```

## DboLibPartNamesIter (2)

```text
~delete                                      self
NextName                                     self,name
```

## DboLibPartPinsIter (2)

```text
~delete                                      self
NextPin                                      self,status
```

## DboLibPartsIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextPart                                     self,status
```

## DboLibSymbolNamesIter (2)

```text
~delete                                      self
NextName                                     (overloaded)
```

## DboLibSymbolsIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextSymbol                                   self,status
```

## DboLibUnusedCacheEntriesIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextUnusedEntry                              self,status
```

## DboLibViewNamesIter (2)

```text
~delete                                      self
NextName                                     self,name
```

## DboLibViewsIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextView                                     self,status
```

## DboLine (16)

```text
GetEnd                                       self,status
GetLineStyle                                 self,status
GetLineWidth                                 self,status
GetObjectType                                self
GetStart                                     self,status
Move                                         self,ptOffset
SetEnd                                       self,point
SetLineStyle                                 self,style
SetLineWidth                                 self,width
SetStart                                     self,point
sGetEndX                                     obj,status
sGetEndY                                     obj,status
sGetLineStyle                                obj,status
sGetLineWidth                                obj,status
sGetStartX                                   obj,status
sGetStartY                                   obj,status
```

## DboLineData (8)

```text
End_get                                      self
End_set                                      self,End
LineStyle_get                                self
LineStyle_set                                self,LineStyle
LineWidth_get                                self
LineWidth_set                                self,LineWidth
Start_get                                    self
Start_set                                    self,Start
```

## DboMiscFileWriter (20)

```text
~delete                                      self
AddFileStream                                (overloaded)
DeleteFileStream                             self,pStreamFileName
DumpFileAs                                   self,pStreamFileName,pFilePath
GetAllFileInfo                               self
GetFileCreationTime                          pFilepath
GetFileInfo                                  self,pStreamFileName,pFileInfo
GetFileList                                  self
GetFilesAsSet                                (overloaded)
GetFileStreamData                            self,pStreamFileName
GetMiscStorageForRead                        pRootStorage,pSubStorage
GetOrCreateMiscStorageForWrite               pRootStorage,pSubStorage
GetOrCreateMiscStorageForWriteAtLevel4       (overloaded)
GetStreamInfoStringType                      self,pStreamFileName,pAttrName
IsOKToOverWrite                              self,streamName,pDstFilePath,pReplace
IsOKToPullIn                                 self,streamName,pDstFilePath,pReplace
IsThisUserStorageCreationAllowed             pStorageName
ReleaseStorage                               self
UpdateFileStream                             self,pStreamFileName
WasStorageOpenSuccessful                     self
```

## DboModifiedFlatNetsIter (2)

```text
~delete                                      self
NextId                                       self,pFlatNetId,pFlatNetStatus
```

## DboNet (52)

```text
AssertValid                                  self
ComputeNetName                               self,name
DeleteEffectiveProp                          self,name
DeleteUserProp                               self,name
EffectivePropsMatch                          (overloaded)
GetAttributeLockingInfo                      self,propName,lLock,preTrigger,postTrigger
GetColor                                     self,status
GetContainingLib                             self
GetEffectiveColorValue                       self,dbColor,dbLineStyle,dbLineWidth,pParentSchematicOcc
GetEffectivePropStringValue                  (overloaded)
GetEffectivePropValueExists                  self,name,bExists
GetEffectivePropValueType                    self,name,nType,bEditable,bDeletable
GetId                                        self,status
GetLineStyle                                 self,status
GetLineWidth                                 self,status
GetName                                      self,name
GetNetName                                   self,name
GetObjectCount                               self
GetObjectOccurrence                          self,pParentSchematicOcc
GetObjectType                                self
GetOwner                                     self
GetParentObj                                 self
GetSchematicNet                              self
GetUserProp                                  self,name,status
HasBundleConnection                          self
HasNonNGOverrider                            self
HasWireSCALARs                               self
IsBundle                                     self
IsBundleObject                               self
IsBusMember                                  self,pBus,status
IsEmpty                                      self
NewBusEntriesIter                            self,status
NewEffectivePropsIter                        (overloaded)
NewGlobalsIter                               self,status
NewNetAliasesIter                            self,status
NewOffPageConnectorsIter                     (overloaded)
NewPortInstsIter                             (overloaded)
NewPortsIter                                 (overloaded)
NewUserProp                                  self,name,value,status
NewWiresIter                                 (overloaded)
SetColor                                     self,color
SetEffectiveColorValue                       self,dbColor,dbLineStyle,dbLineWidth,pParentSchematicOcc
SetEffectivePropStringValue                  (overloaded)
SetLineStyle                                 self,linestyle
SetLineWidth                                 self,linewidth
SetName                                      self,Name
SetNonNGOverrider                            self,flag
SetSchematicNet                              self,pSchNet
sGetId                                       obj,status
sGetName                                     obj,status
sGetNetName                                  obj,status
ValidateName                                 self,Name
```

## DboNetAliasesIter (2)

```text
~delete                                      self
NextAlias                                    self,nxtAlias
```

## DboNetBus (12)

```text
GetBundleOwner                               self,BundleOwner
GetMember                                    self,nPos,status
GetObjectType                                self
GetPosition                                  self,pNetMember
GetWidth                                     self,status
HasMember                                    self,pNet
IsBundle                                     self
IsBundleObject                               self
IsExpanded                                   self
NewMembersIter                               (overloaded)
RemoveMember                                 self,nPos
SetIsBundle                                  self,isSetBundle
```

## DboNetBusEntriesIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextBusEntry                                 self,status
```

## DboNetBusMembersIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextMember                                   self,status
```

## DboNetEffectivePropsIter (2)

```text
~delete                                      self
NextEffectiveProp                            (overloaded)
```

## DboNetGlobalsIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextGlobal                                   self,status
```

## DboNetOccurrence (21)

```text
DeleteEffectiveProp                          self,name
EffectivePropsMatch                          (overloaded)
GetAttributeLockingInfo                      self,propName,lLock,preTrigger,postTrigger
GetCanonicalName                             (overloaded)
GetDeletedNet                                self,status
GetEffectivePropValueExists                  self,name,bExists
GetFlatNet                                   self,status
GetInstance                                  self,status
GetNet                                       self,status
GetNetName                                   self,name
GetObjectType                                self
GetPathName                                  (overloaded)
GetRefPathName                               (overloaded)
GetSchematic                                 self,status
GetSchematicNetId                            self,status
NewEffectivePropsIter                        (overloaded)
SetEffectivePropStringValue                  (overloaded)
SetSchematicNetId                            self,newNetId
sGetId                                       obj,status
sGetNetName                                  obj,status
sGetPathName                                 obj,status
```

## DboNetOccurrenceEffectivePropsIter (2)

```text
~delete                                      self
NextEffectiveProp                            (overloaded)
```

## DboNetOffPageConnectorsIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextOffPageConnector                         self,status
```

## DboNetPortInstsIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextPortInst                                 self,status
```

## DboNetPortsIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextPort                                     self,status
```

## DboNetScalar (2)

```text
GetBundleOwnerForBus                         self
GetObjectType                                self
```

## DboNetSymbol (3)

```text
GetPin                                       self,status
NewSymbolPinBus                              (overloaded)
NewSymbolPinScalar                           (overloaded)
```

## DboNetSymbolInstance (24)

```text
Disconnect                                   self
GetBoundingBox                               self
GetHotSpot                                   self,status
GetNet                                       self,status
GetOccBasedOnOccId                           self,occId
GetOffsetHotSpot                             self,status
GetSourceLibName                             self,name
GetSourceSymbolName                          self,name
GetSymbol                                    self,status
GetWire                                      self,status
IsBoundingBoxDirty                           self
IsBus                                        self,status
Move                                         self,offset
SetBoundingBox                               self,boundingBox
SetBoundingBoxDirty                          self,bSetting
SetLocation                                  self,location
SetMirror                                    self,mirror
SetRotation                                  self,rotation
sGenerateBundleObjectName                    obj
sGetHotSpotX                                 obj,status
sGetHotSpotY                                 obj,status
sGetNetName                                  obj,status
sGetSourceLibName                            obj,status
sGetSourceSymbolName                         obj,status
```

## DboNetWiresIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextWire                                     self,status
```

## DboNullPointerException (1)

```text
what                                         self
```

## DboObjectLocationStruct (7)

```text
getObject                                    self
pLocation_get                                self
pLocation_set                                self,pLocation
pNumRows_get                                 self
pNumRows_set                                 self,pNumRows
pObject_get                                  self
pObject_set                                  self,pObject
```

## DboOccurrence (30)

```text
CopyOccData                                  (overloaded)
DeleteUserProp                               self,name
DeleteUserPropValue                          self,name
GetBackannotatedStringValue                  self,name,value
GetBackannotation                            self,name,status
GetCanonicalName                             self,bVHDL
GetContainingLib                             self
GetDepth                                     self,status
GetDesignTransactionCount                    self
GetEffectivePropStringValue                  (overloaded)
GetEffectivePropStringValueNC                self,name,value
GetEffectivePropValueType                    self,name,nType,bEditable,bDeletable
GetId                                        self,status
GetIdPathName                                (overloaded)
GetInstance                                  self,status
GetObjectType                                self
GetOccProp                                   self,name,status
GetOwner                                     self
GetParent                                    self
GetParentObj                                 self
GetPathName                                  (overloaded)
GetRefPathName                               (overloaded)
GetSchematic                                 self,status
HasPropertyThatExists                        self,status
IsRootOccurrence                             self,status
MakeVHDL                                     self,conName
NewOccurrenceEdit                            self
NewUserProp                                  (overloaded)
SetDesignTransactionCount                    self,nCount
SetUserPropStringValue                       self,name,value
```

## DboOccurrenceChildrenIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextOccurrence                               self,status
```

## DboOffPageConnector (6)

```text
GetObjectOccurrence                          self,pParentSchematicOcc
GetObjectOccurrences                         (overloaded)
GetOccBasedOnOccId                           self,occId
SetMirror                                    self,mirror
SetName                                      self,name
SetRotation                                  self,rotation
```

## DboOffPageConnectorOccurrence (22)

```text
DeleteEffectiveProp                          self,name
GetEffectivePropValueExists                  self,name,bExists
GetEffectivePropValueType                    self,name,nType,bEditable,bDeletable
GetId                                        self,status
GetInstance                                  self,status
GetName                                      self,name
GetObjectType                                self
GetOffPageConnectorId                        self,status
GetPathName                                  (overloaded)
GetRefPathName                               (overloaded)
GetSchematic                                 self,status
GetSchematicPath                             self,name
NewEffectivePropsIter                        (overloaded)
SetEffectivePropStringValue                  (overloaded)
SetEffectivePropStringValueForIref           self,name,value
SetId                                        self,nId
SetOccName                                   self,name
SetOffPageConnectorId                        self,nOffPageId
sGetId                                       obj,status
sGetName                                     obj,status
sGetPathName                                 obj,status
sGetSchematicPath                            obj,status
```

## DboOffPageConnectorOccurrenceEffectivePropsIter (2)

```text
~delete                                      self
NextEffectiveProp                            (overloaded)
```

## DboOleEmbed (16)

```text
GetBitmapDimension                           self,status
GetBoundingBox                               self
GetByte                                      self,status
GetDibSize                                   self,status
GetLocation                                  self,status
GetObjectType                                self
SetBitmapDimension                           self,nWidth,nHeight
SetBoundingBox                               self,box
SetByte                                      self,pByte
SetLocation                                  self,point
sGetBoundingBoxBottom                        obj,status
sGetBoundingBoxLeft                          obj,status
sGetBoundingBoxRight                         obj,status
sGetBoundingBoxTop                           obj,status
sGetLocationX                                obj,status
sGetLocationY                                obj,status
```

## DboPackage (34)

```text
AddAlias                                     self,alias
AddPartInst                                  self,pPartInst
Cleanup                                      self
DeleteDevice                                 self,position
GetBundleTemplateMap                         self
GetDesignator                                self,designator
GetDevice                                    (overloaded)
GetExternalModifiedFlag                      self
GetObjectType                                self
GetPCBFootprint                              self,footprint
GetPCBLib                                    self,lib
GetReferenceTemplate                         self,csRefTmpl
GetSemanticString                            self,str
GetSize                                      self,status
isBundleTemplateExists                       self
IsEquivalent                                 self,pObj
IsHomogeneous                                self,status
NewAliasesIter                               self,status
NewDevice                                    self,designator,position,cell,status
NewDevicesIter                               self,status
NewPartsIter                                 self,status
RemovePartInst                               self,pPartInst
ReplaceSchematicNameInReferencedPartInstList self,pOldName,pNewName
SetDesignator                                self,designator
SetEffectivePropStringValue                  (overloaded)
SetExternalModifiedFlag                      self,aFlag
SetName                                      self,name
SetPCBFootprint                              self,footprint
SetPCBLib                                    self,libName
SetReferenceTemplate                         self,csRefTmpl
sGetPCBFootprint                             obj,status
sGetPCBLib                                   obj,status
sGetReferenceTemplate                        obj,status
sGetSize                                     obj,status
```

## DboPackageAliasesIter (3)

```text
~delete                                      self
Next                                         self,nxt
NextAlias                                    self,nxt
```

## DboPackageDevicesIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextDevice                                   self,status
```

## DboPackageInstOccurrencesIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextInstOccurrence                           self,status
```

## DboPackageNamesIter (2)

```text
~delete                                      self
NextName                                     self,name
```

## DboPackagePartsIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextPart                                     self,status
```

## DboPackageReferencedPartInstIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextPartInst                                 self,status
```

## DboPage (265)

```text
AddJunctionToWire                            self,location,status
ClearUndoRedoData                            self
ClearUndoRedoInfo                            self,bRedo
CloseLog                                     self
Copy                                         self,source
CopyFromFile                                 (overloaded)
CopyToFile                                   self,pFile
CreateLog                                    self
DeleteBookMark                               (overloaded)
DeleteBusEntry                               (overloaded)
DeleteCommentGraphic                         (overloaded)
DeleteCustomItemInst                         self,pCustomItemInst
DeleteDeletedObject                          self,pObject
DeleteERC                                    (overloaded)
DeleteGlobal                                 (overloaded)
DeleteJunction                               self,location
DeleteLabelState                             self,label
DeleteOffPageConnector                       (overloaded)
DeletePartInst                               (overloaded)
DeletePort                                   (overloaded)
DeleteTitleBlock                             (overloaded)
DeleteWire                                   (overloaded)
DumpObjectMap                                self,bRedo
GetANSIGridRefs                              self,status
GetBookMarksList                             self
GetBorderDisplayed                           self,status
GetBorderPrinted                             self,status
GetBusEntriesList                            self
GetBusEntry                                  self,location,status
GetBusEntryCount                             self,status
GetColor                                     self,status
GetCommentGraphicCount                       self,status
GetCommentGraphicsList                       self
GetConnection                                self,location
GetConnectionCount                           self,location,status
GetContainingLib                             self
GetCreateTime                                self,status
GetCustomItemsList                           self
GetDocUnits                                  (overloaded)
GetDocUnitsPerInch                           self
GetERCsList                                  self
GetFirstWireEndPoint                         self,location,status
GetGlobalCount                               self,status
GetGlobalsList                               self
GetGraphicInst                               (overloaded)
GetGridRefDisplayed                          self,status
GetGridRefPrinted                            self,status
GetHorizontalLabelCount                      self,status
GetHorizontalLabelIsAscending                self,status
GetHorizontalLabelIsChar                     self,status
GetHorizontalLabelIsVisible                  self,status
GetHorizontalLabelWidth                      self,status
GetHorizontalSeparatorLineStyle              self,status
GetHorizontalSeparatorLineWidth              self,status
GetInnerBorderIsVisible                      self,status
GetInnerBorderLineStyle                      self,status
GetInnerBorderLineWidth                      self,status
GetInnerBorderMargin                         self,status
GetIsMetric                                  self
GetLabelArray                                self,label
GetLabelColor                                self,status
GetLabelFont                                 self,font
GetLabelState                                self,label
GetLastTransactionNumber                     self
GetModifyTime                                self,status
GetName                                      self,name
GetNet                                       (overloaded)
GetObjectType                                self
GetOffPageConnectorCount                     self,status
GetOffPageConnectorFromID                    self,nID
GetOffPageConnectorsList                     self
GetOuterBorderIsVisible                      self,status
GetOuterBorderLineStyle                      self,status
GetOuterBorderLineWidth                      self,status
GetOuterBorderMargin                         self,status
GetOwner                                     self
GetPageHeight                                self
GetPageNumber                                self,status
GetPageSizeInfo                              self,nPageWidth,nPageHeight,nPinToPin,bIsMetric
GetPageWidth                                 self
GetParentObj                                 self
GetPartInst                                  (overloaded)
GetPartInstCount                             (overloaded)
GetPartInstFromSch                           self,name,status
GetPartInstList                              self
GetPhysicalGranularity                       self
GetPinToPin                                  self
GetPinToPinScaleFactor                       self
GetPort                                      self,name,status
GetPortCount                                 self,status
GetPortInst                                  self,location,status
GetPortsList                                 self
GetSize                                      self,status
GetSizeName                                  self,size
GetTitleBlock                                self,id,status
GetTitleBlockDisplayed                       self,status
GetTitleBlockPrinted                         self,status
GetTitleBlocksList                           self
GetTransactionCount                          self
GetUnNamedBundleList                         self,UnNamedBundleList
GetUserStorage                               self,name,status
GetVerticalLabelCount                        self,status
GetVerticalLabelIsAscending                  self,status
GetVerticalLabelIsChar                       self,status
GetVerticalLabelIsVisible                    self,status
GetVerticalLabelWidth                        self,status
GetVerticalSeparatorLineStyle                self,status
GetVerticalSeparatorLineWidth                self,status
GetWire                                      (overloaded)
GetWireAtJunction                            self,location,status
GetWireCount                                 self,status
GetWiresList                                 self
Import                                       self,pBlock
InitUndoRedoData                             self
IsConnectionPoint                            self,location,status
IsLocked                                     self,status
IsModified                                   self,status
IsPersistent                                 self,status
IsTransactionInProgress                      self
IsValidNetName                               csNetName
m_nRedo_get                                  self
m_nRedo_set                                  self,m_nRedo
m_nUndo_get                                  self
m_nUndo_set                                  self,m_nUndo
m_pCmdList_get                               self
m_pCmdList_set                               self,m_pCmdList
m_pFile_get                                  self
m_pFile_set                                  self,m_pFile
m_pObjMapRedo_get                            self
m_pObjMapRedo_set                            self,m_pObjMapRedo
m_pObjMapUndo_get                            self
m_pObjMapUndo_set                            self,m_pObjMapUndo
m_pRedoList_get                              self
m_pRedoList_set                              self,m_pRedoList
m_pTempObjMapRedo_get                        self
m_pTempObjMapRedo_set                        self,m_pTempObjMapRedo
m_pTempObjMapUndo_get                        self
m_pTempObjMapUndo_set                        self,m_pTempObjMapUndo
MarkModified                                 self
NewBookMark                                  (overloaded)
NewBookMarksIter                             self,status
NewBusEntriesIter                            self,status
NewBusEntry                                  (overloaded)
NewCommentGraphic                            (overloaded)
NewCommentGraphicsIter                       self,status
NewConnectivityObjectsAtPointIter            self,location,status
NewCustomItemInstance                        self,pDefiningObj,nType,idInterfaceID,strPluginName,nCookie,nDefColorIdx,pSchOcc
NewCustomItemsListIter                       self,status
NewDeletedObject                             self
NewDrawnInst                                 (overloaded)
NewEditsIter                                 (overloaded)
NewERC                                       (overloaded)
NewERCsIter                                  self,status
NewGlobal                                    (overloaded)
NewGlobalsIter                               self,status
NewGraphicArcInst                            (overloaded)
NewGraphicBezierInst                         (overloaded)
NewGraphicBitMapInst                         (overloaded)
NewGraphicBitMapInstFromDib                  self,status,pBase64BmpData,pBBox,pLocation,pDbId
NewGraphicBoxInst                            (overloaded)
NewGraphicCommentTextInst                    (overloaded)
NewGraphicEllipseInst                        (overloaded)
NewGraphicLineInst                           (overloaded)
NewGraphicOleEmbedInst                       (overloaded)
NewGraphicPolygonInst                        (overloaded)
NewGraphicPolylineInst                       (overloaded)
NewGraphicSymbolVectorInst                   self,status,location,rotation
NewNetBus                                    (overloaded)
NewNetScalar                                 self
NewObjectsAtPointIter                        self,location,status
NewOffPageConnector                          (overloaded)
NewOffPageConnectorsIter                     (overloaded)
NewPartInstsIter                             self,status
NewPlacedInst                                (overloaded)
NewPlacedInstVer                             (overloaded)
NewPort                                      (overloaded)
NewPortsIter                                 (overloaded)
NewTitleBlock                                (overloaded)
NewTitleBlocksIter                           self,status
NewWireBus                                   (overloaded)
NewWiresAtPointIter                          self,pt,status
NewWireScalar                                (overloaded)
NewWiresInAreaIter                           self,area,status
NewWiresIter                                 (overloaded)
NotifyChangingInstId                         self,oldId,inst
NotifyChangingInstName                       self,oldname,inst
PartAlreadyExistsWithName                    UniqueNm
PointOnHotSpot                               self,location
ReplaceGraphicInst                           (overloaded)
ReplaceInst                                  (overloaded)
RestorePrevState                             self,bRedo
SetANSIGridRefs                              self,bVal
SetBorderDisplayed                           self,bVal
SetBorderPrinted                             self,bVal
SetColor                                     self,color
SetGridRefDisplayed                          self,bVal
SetGridRefPrinted                            self,bVal
SetHorizontalLabelCount                      self,count
SetHorizontalLabelIsAscending                self,bval
SetHorizontalLabelIsChar                     self,bval
SetHorizontalLabelIsVisible                  self,bval
SetHorizontalLabelWidth                      self,nWidth
SetHorizontalSeparatorLineStyle              self,lineStyle
SetHorizontalSeparatorLineWidth              self,lineWidth
SetInnerBorderIsVisible                      self,bval
SetInnerBorderLineStyle                      self,lineStyle
SetInnerBorderLineWidth                      self,lineWidth
SetInnerBorderMargin                         self,location
SetIsMetric                                  self,bIsMetric
SetLabelColor                                self,color
SetLabelFont                                 self,font
SetLabelState                                self,label
SetOuterBorderIsVisible                      self,bval
SetOuterBorderLineStyle                      self,lineStyle
SetOuterBorderLineWidth                      self,lineWidth
SetOuterBorderMargin                         self,location
SetPageHeight                                self,nPageHeight
SetPageSizeInfo                              self,nPageWidth,nPageHeight,nPinToPin,bIsMetric
SetPageWidth                                 self,nPageWidth
SetPinToPin                                  self,nPinToPin
SetSize                                      self,size
SetSizeName                                  self,name
SetTitleBlockDisplayed                       self,bVal
SetTitleBlockPrinted                         self,bVal
SetVerticalLabelCount                        self,count
SetVerticalLabelIsAscending                  self,bval
SetVerticalLabelIsChar                       self,bval
SetVerticalLabelIsVisible                    self,bval
SetVerticalLabelWidth                        self,nWidth
SetVerticalSeparatorLineStyle                self,lineStyle
SetVerticalSeparatorLineWidth                self,lineWidth
sGetColor                                    obj,status
sGetCreateTime                               obj,status
sGetHorizontalLabelCount                     obj,status
sGetHorizontalLabelIsAscending               obj,status
sGetHorizontalLabelIsChar                    obj,status
sGetHorizontalLabelIsVisible                 obj,status
sGetHorizontalSeparatorLineStyle             obj,status
sGetHorizontalSeparatorLineWidth             obj,status
sGetInnerBorderIsVisible                     obj,status
sGetInnerBorderLineStyle                     obj,status
sGetInnerBorderLineWidth                     obj,status
sGetInnerBorderMarginX                       obj,status
sGetInnerBorderMarginY                       obj,status
sGetLabelColor                               obj,status
sGetModifyTime                               obj,status
sGetName                                     obj,status
sGetOuterBorderIsVisible                     obj,status
sGetOuterBorderLineStyle                     obj,status
sGetOuterBorderLineWidth                     obj,status
sGetOuterBorderMarginX                       obj,status
sGetOuterBorderMarginY                       obj,status
sGetPageNumber                               obj,status
sGetSizeName                                 obj,status
sGetSizeX                                    obj,status
sGetSizeY                                    obj,status
sGetVerticalLabelCount                       obj,status
sGetVerticalLabelIsAscending                 obj,status
sGetVerticalLabelIsChar                      obj,status
sGetVerticalLabelIsVisible                   obj,status
sGetVerticalSeparatorLineStyle               obj,status
sGetVerticalSeparatorLineWidth               obj,status
StartTransaction                             (overloaded)
UpdatePageState                              self
UpdateRedoState                              self
```

## DboPageBookMarksIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextBookMark                                 self,status
```

## DboPageBusEntriesIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextBusEntry                                 self,status
```

## DboPageCommentGraphicsIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextCommentGraphic                           self,status
```

## DboPageCustomItemsListIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextCustomItem                               self,status
```

## DboPageEditsIter (2)

```text
~delete                                      self
NextEdit                                     self,pChangedObjectPtr,pUserDataPtr
```

## DboPageERCsIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextERC                                      self,status
```

## DboPageFindGraphicInstIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextGraphicInstance                          self,status
```

## DboPageGlobalsIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextGlobal                                   self,status
```

## DboPageNetsIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextNet                                      self,status
```

## DboPageObjectsAtPointIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextObject                                   self,status
```

## DboPageOffPageConnectorsIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextOffPageConnector                         self,status
```

## DboPagePartInstsIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextPartInst                                 self,status
```

## DboPagePortsIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextPort                                     self,status
```

## DboPageStructOcc (6)

```text
getPage                                      self
getPageOcc                                   self
pageOcc_get                                  self
pageOcc_set                                  self,pageOcc
pPage_get                                    self
pPage_set                                    self,pPage
```

## DboPageTitleBlocksIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextTitleBlock                               self,status
```

## DboPageTransaction (7)

```text
ClearTransactionHistory                      self
DumpTransactionVector                        self
InitAutoTransactions                         self
InitiateInternalTransaction                  self
PlaceUndoMarker                              self,pCheckForDuplicate
RegisterSchDocCommand                        self
TerminatePage                                self
```

## DboPageWiresIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextWire                                     self,status
```

## DboPartInst (79)

```text
AddVariantProp                               self,strName,strVal
ClearVariantMap                              (overloaded)
Connect                                      self
CountPinsWithName                            self,PinName
Disconnect                                   self
FindPinByPinName                             self,PinName,status
GetBundleEntryPinName                        self,entryPinName
GetBundleEntryPortInst                       self
GetContents                                  self,status
GetContentsLibName                           self,name
GetContentsViewName                          self,name
GetContentsViewType                          self,status
GetDefiningPart                              self,status
GetIsPrimitive                               self,status
GetIsPrimitiveProp                           self,status
GetNextNewVariantProp                        self,strName,strVal,bNewFound
GetObjectOccurrence                          self,pParentSchematicOcc
GetObjectOccurrences                         (overloaded)
GetOccAutoRefMode                            self
GetPartValue                                 self,value
GetPin                                       self,nPosition,status
GetPinByBasePinName                          self,PinBaseName,nType,status
GetPinByHotSpot                              self,hotSpot,status
GetPinByID                                   self,pPinID
GetPinByPinName                              self,PinName,status
GetPinByPinNumber                            self,PinNumber,status
GetPinCount                                  self,status
GetPinNamesAreRotated                        self,status
GetPinNamesAreVisible                        self,status
GetPinNumbersAreVisible                      self,status
GetPinOrderedByLocation                      self,nPosition,status
GetPowerPinsAreVisible                       self,status
GetReference                                 self,Ref
GetReferenceDesignator                       self,RefDes
GetVariantProp                               self,strName,strVal
HasBundleOwner                               (overloaded)
HasMultiplePinsWithName                      self,PinName
IsBoundingBoxDirty                           self
IsExternalDesignPart                         self
IsNetlistIgnore                              self,status
IsOptimizerTemplate                          self,status
IsPrimitive                                  self,status
IsPropOverridenOnAnyOcc                      self,pPropName
IsPropOverridenOnAnyOccInDesign              self,pPropName,pDsn
IsPSpiceOnly                                 self,status
IsVariantPropMapEmpty                        self
Move                                         self,offset
NewPinsIter                                  (overloaded)
PositionAllDisplayProp                       pPage,pInst
PositionDisplayProp                          pPage,pProp
ProcessRefDesDelete                          self
ProcessRefDesModify                          self
ResetAllDisplayPropertiesFontToDefault       self
SetBoundingBoxDirty                          self,bSetting
SetContentsLibName                           (overloaded)
SetContentsViewName                          (overloaded)
SetContentsViewNameWithoutChangingOccurrences self,newName,isForSchematicRename
SetContentsViewType                          (overloaded)
SetContentViewTypeWithoutChangingOccurrences self,pType
SetCurrent                                   self,bVal
SetId                                        (overloaded)
SetIsPrimitiveProp                           self,prim
SetLocation                                  self,location
SetMirror                                    self,mirror
SetName                                      self,newName
SetOccAutoRefMode                            self,pMode
SetOccsModified                              self,bVal
SetPartValue                                 self,name
SetPowerPinsAreVisible                       self,bVal
SetReference                                 self,name
SetRotation                                  self,rotation
sGetContentsLibName                          obj,status
sGetContentsViewName                         obj,status
sGetContentsViewType                         obj,status
sGetIsPrimitive                              obj,status
sGetPartValue                                obj,status
sGetPinCount                                 obj,status
sGetPowerPinsAreVisible                      obj,status
sGetReference                                obj,status
```

## DboPartInstPinsIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextPin                                      self,status
```

## DboPartTextData (18)

```text
BoundingBox_get                              self
BoundingBox_set                              self,BoundingBox
FaceName_get                                 self
FaceName_set                                 self,FaceName
Italic_get                                   self
Italic_set                                   self,Italic
Location_get                                 self
Location_set                                 self,Location
nPtSize_get                                  self
nPtSize_set                                  self,nPtSize
Rotation_get                                 self
Rotation_set                                 self,Rotation
Text_get                                     self
Text_set                                     self,Text
Underline_get                                self
Underline_set                                self,Underline
Weight_get                                   self
Weight_set                                   self,Weight
```

## DboPathMgr (43)

```text
DboFileEncryptionData                        (n/a)
DboFileEncryptionData_mbEncrypted_get        self
DboFileEncryptionData_mbEncrypted_set        self,mbEncrypted
DboFileEncryptionData_mFileName_get          self
DboFileEncryptionData_mFileName_set          self,mFileName
DboFileEncryptionData_mPassword_get          self
DboFileEncryptionData_mPassword_set          self,mPassword
DboFileEncryptionData_mRefCount_get          self
DboFileEncryptionData_mRefCount_set          self,mRefCount
DboFileEncryptionData_mState_get             self
DboFileEncryptionData_mState_set             self,mState
DboPathRecordS                               (n/a)
DboPathRecordS_mAccessible_get               self
DboPathRecordS_mAccessible_set               self,mAccessible
DboPathRecordS_mFullPath_get                 self
DboPathRecordS_mFullPath_set                 self,mFullPath
DboPathRecordS_mReadOnly_get                 self
DboPathRecordS_mReadOnly_set                 self,mReadOnly
sClearPathHistory                            (zero-arg-ok)
sCmpCh                                       ch1,ch2
sComparePaths                                s1,s2
sConvertToAbsolutePath                       pPath,pFullPath
sDisableFileLookupNotifaction                (zero-arg-ok)
sDumpToSessionLog                            (zero-arg-ok)
sExit                                        (zero-arg-ok)
sFindAbsolutePath                            path,baseDir
sFindFileDir                                 path
sFindRelativePath                            path,baseDir
sForgetReadOnlyAttribute                     (zero-arg-ok)
sGetAllPaths                                 (zero-arg-ok)
sGetFileStatus                               pPath,pFileStatus
sGetFullPath                                 pPath
sGetLegacySaveAs                             (zero-arg-ok)
sGetPathLookupTimeout                        (zero-arg-ok)
sInit                                        (zero-arg-ok)
sIsPathAbsolute                              path
sIsReadOnly                                  pPath
sLookupPath                                  (overloaded)
sNormalizePath                               path
sNotifyFileLookup                            pPath
sSetExitWaitTimeout                          pTimeOut
sSetLegacySaveAs                             bVal
sSetPathLookupTimeout                        pTimeOut
```

## DboPinData (10)

```text
Connect_get                                  self
Connect_set                                  self,Connect
Name_get                                     self
Name_set                                     self,Name
PinStyle_get                                 self
PinStyle_set                                 self,PinStyle
PinType_get                                  self
PinType_set                                  self,PinType
Start_get                                    self
Start_set                                    self,Start
```

## DboPinShapeSymbol (2)

```text
GetPinType                                   self,status
SetPinType                                   self,type
```

## DboPkgInstOcc (9)

```text
~delete                                      self
AddInstOcc                                   self,pInstOcc
GetInstOccCount                              self
GetObjectType                                self
GetOwner                                     self
GetParentObj                                 self
GetReference                                 self
NewPkgInstOccIter                            self,status
RemoveInstOcc                                self,pInstOcc
```

## DboPlacedInst (36)

```text
CheckAndResetDisplayProperty                 self,pOldInst
GetDevice                                    self,status
GetDeviceDesignator                          self,designator
GetEffectivePropValueChoices                 self,name,choices
GetEffectivePropValueType                    self,name,nType,bEditable,bDeletable
GetGraphicName                               self,status
GetPackage                                   self,status
GetPart                                      self,status
GetPartValue                                 self,value
GetPCBFootprint                              self,footprint
GetPCBLib                                    self,lib
GetReferenceDesignator                       self,RefDes
GetSourceDevice                              self,status
GetSourceDeviceDesignator                    self,designator
GetSourceDevicePosition                      self,status
GetSourceLibName                             self,libName
GetSourcePackage                             self,status
GetSourcePackageName                         self,name
GetSourcePart                                self,status
GetSourcePartName                            self,name
IsOptimizerTemplate                          self,status
NewCachedPinShapeSymbol                      self,pOwningLib,pPin
SetDeviceDesignator                          self,designator
SetGraphic                                   self,graphic
SetPCBFootprint                              self,name
SetPCBLib                                    self,libname
sGetPCBFootprint                             obj,status
sGetPCBLib                                   obj,status
sGetReferenceDesignator                      pObj,status
sGetSourceDeviceDesignator                   obj,status
sGetSourceLibName                            obj,status
sGetSourcePackageName                        obj,status
sGetSourcePartName                           obj,status
StatefulCreate                               self
Update                                       self
UpdateOpProp                                 self
```

## DboPointerException (1)

```text
what                                         self
```

## DboPolygon (20)

```text
GetCount                                     self,status
GetFillStyle                                 self,status
GetHatchStyle                                self,status
GetLineStyle                                 self,status
GetLineWidth                                 self,status
GetObjectType                                self
Move                                         self,ptOffset
MovePoint                                    self,position,ptOffset
NewPoint                                     (overloaded)
NewPointsIter                                self,status
RemoveAllPoints                              self
RemovePoint                                  self,nIndex
SetFillStyle                                 self,style
SetHatchStyle                                self,style
SetLineStyle                                 self,style
SetLineWidth                                 self,width
sGetFillStyle                                obj,status
sGetHatchStyle                               obj,status
sGetLineStyle                                obj,status
sGetLineWidth                                obj,status
```

## DboPolygonData (12)

```text
arrayPoints_get                              self
arrayPoints_set                              self,arrayPoints
FillStyle_get                                self
FillStyle_set                                self,FillStyle
HatchStyle_get                               self
HatchStyle_set                               self,HatchStyle
LineStyle_get                                self
LineStyle_set                                self,LineStyle
LineWidth_get                                self
LineWidth_set                                self,LineWidth
nNbrPoints_get                               self
nNbrPoints_set                               self,nNbrPoints
```

## DboPolygonPointsIter (2)

```text
~delete                                      self
Next                                         self,returnPt
```

## DboPolyline (14)

```text
GetCount                                     self,status
GetLineStyle                                 self,status
GetLineWidth                                 self,status
GetObjectType                                self
Move                                         self,ptOffset
MovePoint                                    self,position,ptOffset
NewPoint                                     (overloaded)
NewPointsIter                                self,status
RemoveAllPoints                              self
RemovePoint                                  self,nIndex
SetLineStyle                                 self,style
SetLineWidth                                 self,width
sGetLineStyle                                obj,status
sGetLineWidth                                obj,status
```

## DboPolylineData (8)

```text
arrayPoints_get                              self
arrayPoints_set                              self,arrayPoints
LineStyle_get                                self
LineStyle_set                                self,LineStyle
LineWidth_get                                self
LineWidth_set                                self,LineWidth
nNbrPoints_get                               self
nNbrPoints_set                               self,nNbrPoints
```

## DboPolylinePointsIter (2)

```text
~delete                                      self
Next                                         self,returnPt
```

## DboPort (10)

```text
GetObjectOccurrence                          self,pParentSchematicOcc
GetObjectOccurrences                         (overloaded)
GetPinType                                   self,status
GetPortSymbol                                self,status
IsBundleObject                               self
SetMirror                                    self,mirror
SetName                                      self,name
SetPinType                                   self,pinType
SetRotation                                  self,rotation
sGetPinType                                  obj,status
```

## DboPortBusMemberOccurrence (7)

```text
GetMemberName                                self,name
GetObjectType                                self
GetPathName                                  (overloaded)
GetPort                                      self,status
GetPortInst                                  self,status
GetRefPathName                               (overloaded)
sGetMemberName                               obj,status
```

## DboPortInst (81)

```text
DeleteUserProp                               self,name
DeleteUserPropValue                          self,name
GetCachedPinShapePtr                         self
GetContainingLib                             self
GetDefiningPin                               self,status
GetDisplayPropsPermitted                     self,status
GetDispPropArray                             self
GetEffectivePropStringValue                  (overloaded)
GetEffectivePropValueType                    self,name,nType,bEditable,bDeletable
GetHotSpot                                   self,status
GetId                                        (overloaded)
GetIsClock                                   self,status
GetIsDot                                     self,status
GetIsGlobal                                  self,status
GetIsLeftPointing                            self,status
GetIsLong                                    self,status
GetIsNetStyle                                self,status
GetIsNoConnect                               self,status
GetIsNumberVisible                           self,status
GetIsRightPointing                           self,status
GetIsShared                                  self,status
GetIsUserDefinedShape                        self,status
GetIsVisible                                 self,status
GetNet                                       self,status
GetObjectOccurrence                          self,pParentSchematicOcc
GetObjectOccurrences                         (overloaded)
GetObjectType                                self
GetOffsetHotSpot                             self,status
GetOffsetStartPoint                          self,status
GetOwner                                     self
GetParentObj                                 self
GetPinName                                   self,name
GetPinNumber                                 self,number
GetPinPosition                               self,status
GetPinSwapId                                 self,status
GetPinType                                   self,status
GetStartPoint                                self,status
GetWire                                      self,status
IsBundleObject                               self
IsBundlePin                                  (overloaded)
NewDisplayProp                               (overloaded)
NewDisplayPropsIter                          self,status
NewEffectivePropsIter                        (overloaded)
NewUserProp                                  (overloaded)
SetCachedPinShapePtr                         self,pPinShape
SetHotSpot                                   self,point
SetId                                        (overloaded)
SetIsClock                                   self,bval
SetIsDot                                     self,bval
SetIsGlobal                                  self,val
SetIsLeftPointing                            self,bval
SetIsLong                                    self,bval
SetIsNetStyle                                self,val
SetIsNoConnect                               self,val
SetIsRightPointing                           self,bval
SetIsVisible                                 self,val
SetPinName                                   self,name
SetPinNumber                                 self,name
SetPinType                                   self,type
SetStartPoint                                self,point
SetUserPropStringValue                       self,name,value
sGetHotSpotX                                 obj,status
sGetHotSpotY                                 obj,status
sGetIsClock                                  obj,status
sGetIsDot                                    obj,status
sGetIsGlobal                                 obj,status
sGetIsLeftPointing                           obj,status
sGetIsLong                                   obj,status
sGetIsNetStyle                               obj,status
sGetIsNoConnect                              obj,status
sGetIsRightPointing                          obj,status
sGetIsShared                                 obj,status
sGetIsVisible                                obj,status
sGetNetName                                  obj,status
sGetPinName                                  obj,status
sGetPinNumber                                obj,status
sGetPinPosition                              obj,status
sGetPinSwapId                                obj,status
sGetPinType                                  obj,status
sGetStartPointX                              obj,status
sGetStartPointY                              obj,status
```

## DboPortInstBus (5)

```text
CopyUnnamedNegroupInfo                       self,pObj
GetMember                                    self,nPos,status
GetObjectType                                self
GetWidth                                     self,status
NewUserProp                                  (overloaded)
```

## DboPortInstBusMember (61)

```text
DeleteDisplayProp                            self,pProp
DeleteUserProp                               self,name
DeleteUserPropValue                          self,name
GetContainingBus                             self,status
GetEffectivePropStringValue                  (overloaded)
GetHotSpot                                   self,status
GetIsClock                                   self,status
GetIsDot                                     self,status
GetIsGlobal                                  self,status
GetIsLeftPointing                            self,status
GetIsLong                                    self,status
GetIsNetStyle                                self,status
GetIsNoConnect                               self,status
GetIsRightPointing                           self,status
GetIsShared                                  self,status
GetIsVisible                                 self,status
GetNet                                       self,status
GetObjectType                                self
GetOffsetHotSpot                             self,status
GetOffsetStartPoint                          self,status
GetPinName                                   self,name
GetPinNumber                                 self,number
GetPinPosition                               self,status
GetPinType                                   self,status
GetStartPoint                                self,status
NewDisplayProp                               (overloaded)
NewEffectivePropsIter                        (overloaded)
NewUserProp                                  (overloaded)
SetHotSpot                                   self,point
SetIsClock                                   self,bval
SetIsDot                                     self,bval
SetIsGlobal                                  self,val
SetIsLeftPointing                            self,bval
SetIsLong                                    self,bval
SetIsNetStyle                                self,val
SetIsNoConnect                               self,val
SetIsRightPointing                           self,bval
SetIsVisible                                 self,val
SetPinName                                   self,CString&
SetPinNumber                                 self,CString&
SetPinType                                   self,type
SetStartPoint                                self,point
SetUserPropStringValue                       self,name,value
sGetHotSpotX                                 obj,status
sGetHotSpotY                                 obj,status
sGetIsClock                                  obj,status
sGetIsDot                                    obj,status
sGetIsGlobal                                 obj,status
sGetIsLeftPointing                           obj,status
sGetIsLong                                   obj,status
sGetIsNetStyle                               obj,status
sGetIsNoConnect                              obj,status
sGetIsRightPointing                          obj,status
sGetIsShared                                 obj,status
sGetIsVisible                                obj,status
sGetPinName                                  obj,status
sGetPinNumber                                obj,status
sGetPinPosition                              obj,status
sGetPinType                                  obj,status
sGetStartPointX                              obj,status
sGetStartPointY                              obj,status
```

## DboPortInstDisplayPropsIter (5)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextProp                                     self,status
NextPropEx                                   self,status
```

## DboPortInstEffectivePropsIter (2)

```text
~delete                                      self
NextEffectiveProp                            (overloaded)
```

## DboPortInstScalar (1)

```text
GetObjectType                                self
```

## DboPortOccurrence (33)

```text
DeleteEffectiveProp                          self,name
FindInstance                                 self,status
GetCanonicalName                             self,bVHDL
GetCanonicalNameBasedOnPinPos                self,bVHDL
GetCanonicalNameWithChipsInfo                self,bVHDL
GetEffectivePropValueExists                  self,name,bExists
GetEffectivePropValueType                    self,name,nType,bEditable,bDeletable
GetFlatNet                                   self
GetId                                        self,status
GetInstance                                  self,status
GetName                                      self,name
GetObjectType                                self
GetPathName                                  (overloaded)
GetPathNameNumber                            (overloaded)
GetPinName                                   self,name
GetPinNumber                                 self,number
GetPort                                      self,status
GetPortInst                                  self,status
GetPortInstPinID                             self
GetRefPathName                               (overloaded)
GetSchematic                                 self,status
GetSchematicPortName                         self
IsOrphanPort                                 self
MorphPortOccurrence                          (overloaded)
NewEffectivePropsIter                        (overloaded)
ProcessFlatNetForPortOccurrence              self
SetEffectivePropStringValue                  (overloaded)
SetEffectivePropStringValueForIref           self,name,value
SetId                                        self,nId
SetPortInstPinID                             self,nPinID
SetSchematicPortName                         self,pSchematicPortName
sGetId                                       obj,status
sGetPathName                                 obj,status
```

## DboPortOccurrenceEffectivePropsIter (2)

```text
~delete                                      self
NextEffectiveProp                            (overloaded)
```

## DboPortSymbol (2)

```text
GetPinType                                   self,status
SetPinType                                   self,type
```

## DboPrimitiveAndVisiblePowerPins (6)

```text
GetPrimitive                                 self
GetViewType                                  self
GetVisiblePowerPins                          self
SetPrimitive                                 self,nPrimitive
SetViewType                                  self,nViewType
SetVisiblePowerPins                          self,bVisiblePowerPins
```

## DboRefDesAnnotate (13)

```text
Annotate                                     (overloaded)
AnnotateIncremental                          self
AnnotateUnconditional                        self
GetDesign                                    self
m_pDboDesign_get                             self
m_pDboDesign_set                             self,m_pDboDesign
m_RefDesQueryHandler_get                     self
m_RefDesQueryHandler_set                     self,m_RefDesQueryHandler
mRefDesRTData_get                            self
mRefDesRTData_set                            self,mRefDesRTData
ResetPartReference                           self,pObjectList
SetDesign                                    self,pDesign
SetRTData                                    self,pRefDesRTData
```

## DboRefDesLog (4)

```text
GetLogType                                   self
GetMessage                                   self
SetLogType                                   self,pLogType
SetMessage                                   self,pMessage
```

## DboRefDesManager (11)

```text
~delete                                      self
AddInstOccToPending                          self,pInstOcc
AssignRefDesToPendingInstOccs                self
ClearPendingInstOccs                         self
GetInstanceRefDesMap                         self
GetOccRefDesMap                              self
IsDesignLevelAutoReferenceEnabled            (zero-arg-ok)
ProcessObjectDelete                          self,pDboBaseObj
ProcessRefDesModify                          self,pDboBaseObj
RefreshInstanceRefDesMap                     self
RefreshOccRefDesMap                          (overloaded)
```

## DboRefDesMap (5)

```text
AddRefDesEntry                               (overloaded)
ClearMap                                     self
GetRefNumMap                                 (overloaded)
RemoveEntry                                  self,pDboBaseObj
SetAllDirty                                  self
```

## DboRefDesQueryHandler (5)

```text
AssignRefDesToList                           (overloaded)
GetNextRefDes                                (overloaded)
GetQueryOptions                              self
SetQueryMap                                  self,pQueryMap
SetQueryOptions                              self,pQueryOptions
```

## DboRefDesRTData (6)

```text
GetCombinedPropWarningCount                  self
GetDboState                                  self
GetQueryOption                               self
GetRefDesLogList                             self
IncrementCombinedPropWarningCount            self
setQueryOption                               self,pQueryOption
```

## DboRefDesUtils (22)

```text
AddAnnotationLog                             (overloaded)
BuildRefNumRange                             (overloaded)
ClearAnnotationLog                           (zero-arg-ok)
DoAdvancedAnnotation                         (overloaded)
DumpLogToSessionLog                          (zero-arg-ok)
FilterPageList                               (overloaded)
GetDesignatorNumber                          (overloaded)
GetDesignatorString                          (overloaded)
GetPagesAsPerPagesInTitleBlockOrder          (overloaded)
GetPagesAsPerPMOrder                         (overloaded)
GetPagesForPropertyValue                     (overloaded)
GetPagesFromJSON                             (overloaded)
GetPagesInOrder                              (overloaded)
GetPagesInOrderForProperty                   (overloaded)
GetPartsOnPages                              (overloaded)
GetPowerPinsKeyString                        (overloaded)
GetReference                                 (overloaded)
GetUniquePagesList                           (overloaded)
NewListIter                                  (overloaded)
NewPartsIter                                 (overloaded)
ResetReference                               (overloaded)
SplitPartReference                           (overloaded)
```

## DboSchematic (94)

```text
BuildIDMap                                   self
CanAssignRefDes                              self,pPartInst,pRef,pDes
CanThisPinBeAddedToUnnamedNetgroup           self,pinName
CheckSchematicSymbolInstContainersAndUpdateConnectivity self,pPage,pNewDboNetsMap,pDeletedSourcesMap,pAvailableSourcesMap
ClearModified                                self,pPage
ClearNextReferences                          self
Copy                                         self,source
CreateSchNetAndContainerMapping              (overloaded)
DeleteAllOptimizerParameter                  self
DeleteOptimizerParameter                     self,name
DeletePage                                   self,pPage
DoActualSchematicExpansion                   self,pPage,pReferredSchNetsMap,pNewDboNetsMap,pDeletedSourcesMap,pAvailableSourcesMap,pAvailableOccurrencesMap,pDeletedOccurrencesMap,pRecreatePage
DumpPageDirectoryInfo                        self
Expand                                       self
ExpandMinimal                                (overloaded)
FilterSchematicNetsForPage                   (overloaded)
FindUnnamedNetgroupByName                    self,name
GetDefaultPageName                           self
GetDeletedNet                                self,nId,status
GetGlobal                                    self,name,status
GetId                                        self
GetLowestPageNumberFromDboNets               self,pSchNet
GetNet                                       (overloaded)
GetNextDeviceAndPartToBePlaced               self,pSchOcc,aPackage,aSourceName,aPartValue,aPackageRef,aDeviceDesignator,aIsNormal,aDevice,aLibPart
GetNextReference                             (overloaded)
GetNextReferenceEx                           self,pSchOcc,newPartVal,sourcePkgName,strReferencePrefix,suffixStr,wPart,bIncrementNext
GetNextReferenceOld                          (overloaded)
GetObjectContainer                           self,pObject
GetObjectType                                self
GetOccUndoStack                              (overloaded)
GetOffPageConnector                          self,name,status
GetOffPageConnectorForOcc                    self,nID
GetOpenReferringDesigns                      self,designs,status
GetOpStartWithCurrenV                        self,status
GetOptFileName                               self
GetOptimizerParameter                        self,name,st
GetOptimizerTemplate                         self
GetPage                                      (overloaded)
GetPageCount                                 self,status
GetPageFromID                                self,nPageID,status
GetPageNumber                                self,name,status
GetPartInst                                  (overloaded)
GetPort                                      self,name,status
GetPortIgnoreWidth                           self,Name,status
GetRegisteredObject                          self,nID
GetSchematicAtID                             nSchematicID
GetSchematicID                               self
GetTitleBlock                                self,nId,status
GetUnNamedBundleList                         self,UnNamedBundleList
GetUnnamedNetGroupOwnerObject                self,pUnnamedBundleOwner
GetUserStorage                               self,name,status
IsExpanded                                   self
IsModified                                   self,status
IsOccsModified                               self
IsOptimizerTemplateExist                     self
IsOptimizerUseCurrentValue                   self
IsPageInMemory                               self,name,status
IsPageModified                               self,pPage
IsPagePersistent                             (overloaded)
MarkModified                                 (overloaded)
MarkSchematicNetForDeletion                  self,pSchematicNet
NewChangedPagesIter                          self,status
NewGlobalsIter                               self,status
NewInstsIter                                 self,status
NewNetsIter                                  (overloaded)
NewOccUndoStackEntryIter                     (overloaded)
NewOffPageConnectorsIter                     (overloaded)
NewOptimizerParametersIter                   self,st
NewPage                                      (overloaded)
NewPageNamesIter                             self,status
NewPagesIter                                 self,status
NewPortsIter                                 (overloaded)
PageExists                                   self,name,status
ReadAllPages                                 self
ReleaseCollectedPageIDs                      self,pPageIDList
ReleaseID                                    self,nID
RemoveOptimizerParameter                     self,name
RemovePage                                   self,pPage
RemoveSchematicNetAndRebuildFromPageNets     self,lSchNet,pNewDboNetsMap
Rename                                       self,pObj,newName
ResolveBaseNameConflict                      self,pSchNet1,pSchNet2
RestoreOptimizerParameter                    self
SavePage                                     (overloaded)
sDeleteTempShadowPage                        pPage
SetMinId                                     self,p_nId
SetNextReference                             self,strReferencePrefix,nNextReference
SetOccsModified                              (overloaded)
SetOpStartWithCurrenV                        self,bVal
SetPageNumber                                self,pPage,pageNumber
sGetName                                     obj,status
UpdateFlatNetsOfAllInstantiatingDesigns      self
UpdateNextReference                          self,strReference
UpdateUnnamedNetgroupRegistry                self,pNetgrp
UpdateUnnamedNetSymbols                      self,bOwnerName,bEntryPinName,newBOwner,pInitatingPage
```

## DboSchematicChangedPagesIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextPage                                     self,status
```

## DboSchematicGlobal (3)

```text
GetObjectType                                self
GetPinType                                   self,status
IsPower                                      self,status
```

## DboSchematicGlobalsIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextGlobal                                   self,status
```

## DboSchematicInstsIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextInst                                     self,status
```

## DboSchematicNet (44)

```text
AddBusNet                                    self,pBusNet
ComputeNetName                               self,name
DeleteEffectiveProp                          self,name
EffectivePropsMatch                          (overloaded)
GetAttributeLockingInfo                      self,propName,lLock,preTrigger,postTrigger
GetBusNets                                   self
GetColor                                     self,status
GetContainingLib                             self
GetEffectivePropStringValue                  (overloaded)
GetEffectivePropValueChoices                 self,name,choices
GetEffectivePropValueExists                  self,name,bExists
GetEffectivePropValueType                    self,name,nType,bEditable,bDeletable
GetId                                        self,status
GetLineStyle                                 self,status
GetLineWidth                                 self,status
GetLocalNetName                              self,name
GetName                                      self,name
GetObjectOccurrence                          self,pParentSchematicOcc
GetObjectOccurrences                         (overloaded)
GetObjectType                                self
GetOwner                                     self
GetParentObj                                 self
GetSchNetNameForOldPspiceConnectivity        self,pEffectiveNetName
HasBundleConnection                          self
HasNonNGOverrider                            self
IsBundleObject                               self
IsBusMember                                  self,pBusNet,status
IsGlobal                                     self,status
NewEffectivePropsIter                        (overloaded)
NewGlobalsIter                               self,status
NewNetsIter                                  (overloaded)
NewOffPageConnectorsIter                     self,status
NewPortInstsIter                             (overloaded)
NewPortsIter                                 (overloaded)
NewWiresIter                                 (overloaded)
RemoveBusNet                                 self,pBusNet
ResolveComputedNameConflict                  self,pName
SetColor                                     self,color
SetEffectivePropStringValue                  (overloaded)
SetLineStyle                                 self,linestyle
SetLineWidth                                 self,linewidth
SetName                                      self,Name
sGetId                                       obj,status
sGetName                                     obj,status
```

## DboSchematicNetBus (4)

```text
GetMember                                    self,nPos,status
GetObjectType                                self
GetWidth                                     self,status
NewMembersIter                               (overloaded)
```

## DboSchematicNetBusMembersIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextMember                                   self,status
```

## DboSchematicNetEffectivePropsIter (2)

```text
~delete                                      self
NextEffectiveProp                            (overloaded)
```

## DboSchematicNetGlobalsIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextGlobal                                   self,status
```

## DboSchematicNetNetsIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextNet                                      self,status
```

## DboSchematicNetOffPageConnectorsIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextOffPageConnector                         self,status
```

## DboSchematicNetPortInstsIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextPortInst                                 self,status
```

## DboSchematicNetPortsIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextPort                                     self,status
```

## DboSchematicNetScalar (1)

```text
GetObjectType                                self
```

## DboSchematicNetsIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextNet                                      self,status
```

## DboSchematicNetWiresIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextWire                                     self,status
```

## DboSchematicOffPageConnector (1)

```text
GetObjectType                                self
```

## DboSchematicOffPageConnectorsIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextOffPageConnector                         self,status
```

## DboSchematicOptimizerParametersIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextOptimizerParameter                       self,status
```

## DboSchematicPageNamesIter (2)

```text
~delete                                      self
NextName                                     self,status
```

## DboSchematicPagesIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextPage                                     self,status
```

## DboSchematicPort (2)

```text
GetObjectType                                self
GetPinType                                   self,status
```

## DboSchematicPortsIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextPort                                     self,status
```

## DboSchematicSymbolInst (24)

```text
GetContainingLib                             self
GetEntry                                     self,pos,status
GetIsBus                                     self,status
GetName                                      self,name
GetNet                                       self,status
GetNetId                                     self,status
GetObjectType                                self
GetOwner                                     self
GetParentObj                                 self
GetSize                                      self,status
IsBundleObject                               self
m_bIsBus_get                                 self
m_bIsBus_set                                 self,m_bIsBus
m_Name_get                                   self
m_Name_set                                   self,m_Name
m_pInstArray_get                             self
m_pInstArray_set                             self,m_pInstArray
m_pNet_get                                   self
m_pNet_set                                   self,m_pNet
m_pOwner_get                                 self
m_pOwner_set                                 self,m_pOwner
SetIsBus                                     self,bVal
sGetName                                     obj,status
sGetNetId                                    obj,status
```

## DboSession (47)

```text
~delete                                      self
CallTclAttributeTrigger                      pObj,triggerName,propName,propVal
CopyLibAll                                   self,lib,name
CreateDesign                                 (overloaded)
CreateLib                                    self,Name,status
FindExternalDesignsToBeRemoved               self,pDsn,pDesList
GetActiveDesign                              self
GetDataRelease                               self
GetDataReleaseForDBObject                    self,pObj
GetDataVersion                               self
GetDataVersionForDBObject                    self,pObj
GetDesign                                    self,Name,status
GetDesignAndSchematics                       self,Name,status
GetDesignDataVersion                         self
GetFlatNetNamingStrategy                     self
GetIndexForString                            self,str,status
GetInterfaceVersion                          self
GetLib                                       self,Name,status
GetLibAndSchematics                          self,Name,status
GetObjectFromUniqueStr                       self,pUniqueStr
GetOccByCanonicalName                        (overloaded)
GetOpenDesign                                self,Name,status
GetOpenDesigns                               self,designs,status
GetOpenLib                                   self,Name,status
GetStringPtrFromIndex                        self,nIndex,status
GetUniqueStringFromObject                    self,pDboBaseObj
IsBitSet                                     self,bit
IsDesignPersistent                           self,design,status
IsEditingDisabledInSession                   self
IsFlatNetModificationRegistrationActive      self
IsLibPersistent                              self,lib,status
IsObjLocked                                  self
m_StringTable_get                            self
m_StringTable_set                            self,m_StringTable
m_StrTableArray_get                          self
m_StrTableArray_set                          self,m_StrTableArray
MarkAllLibForSave                            self,lib
NewDesignsIter                               self,status
NewLibsIter                                  self,status
RemoveDesign                                 self,design
RemoveLib                                    self,lib
SaveDesign                                   self,design
SaveDesignAs                                 (overloaded)
SaveLib                                      self,lib
SaveLibAs                                    (overloaded)
SetBit                                       self,bit,bOn
SetFlatNetNamingStrategy                     self,pStrategy
```

## DboSessionDesignsIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextDesign                                   self,status
```

## DboSessionLibsIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextLib                                      self,status
```

## DboShadowPage (1)

```text
GetObjectType                                self
```

## DboSplitPath (6)

```text
GetDir                                       self
GetDrive                                     self
GetExt                                       self
GetFileName                                  self
GetFileTitle                                 self
GetPath                                      self
```

## DboState (29)

```text
~delete                                      self
AssignVoltageOnDCNets                        pDesign
ClearDesignUndoRedo                          pDesignName
Code                                         self
CrossProbeNetCMToNet                         pFlatnet,pSelect
DispPropBoundingBox                          pDispProp,pViewOccurrence
Failed                                       self
GetBackAnnotationData                        pDesignName,pNetlistDir,pBoardFile,pAllegroCfgFile,pOutputFile
GetExtendedText                              self
GetLicenseString                             (zero-arg-ok)
GetOptionString                              lOptionName,defaultValue
GetOrCADCMTierFlag                           (zero-arg-ok)
IsCMProp                                     pName,pPropType,pPropCategory
IsPspLicChekedout                            (zero-arg-ok)
m_SCode_get                                  self
m_SCode_set                                  self,m_SCode
Message                                      self,msg
OK                                           self
OpenPasswordDialog                           pTitle,pDesignName,pSetPassword
RemoveFilesFromActivePM                      pFolderName,pFileNameVec
RunBackAnnotation                            pDesignName,pNetlistDir,pBoardFile,pAllegroCfgFile,pOutputFile,pRunGenfeed
RunFrontToBackTool                           pDesignName,pNetlistDir,pBoardFile,pAllegroCfgFile,pOutputDir
SaveDesign                                   pDesign
Severity                                     self
sIsObjectBelongsToMasterSession              pObject
sIsTimeProfilingON                           (zero-arg-ok)
Succeeded                                    self
WriteToSessionLog                            str
WriteToStatusBar                             str
```

## DboSymbol (22)

```text
Clear                                        self
DeleteDisplayProp                            self,pProp
DeleteSymbolPin                              self,nPos
DeleteSymbolPinAtPosition                    self,nPos
GetDisplayPropsPermitted                     self,status
GetDispPropArray                             self
GetPinCount                                  (overloaded)
GetPinPosition                               self,pPin,status
GetSemanticString                            self,str
GetSize                                      self,status
GetSymbolPin                                 (overloaded)
IsEquivalent                                 self,pObj
MarkModified                                 self
NewDisplayProp                               (overloaded)
NewDisplayPropsIter                          self,status
NewGraphicBitMapInstFromDib                  self,mStatus,pBase64BmpData,pBBox,pLocation
NewPinsIter                                  (overloaded)
NewSymbolPinBus                              (overloaded)
NewSymbolPinScalar                           (overloaded)
PinsAllowed                                  self,status
RemoveSymbolPinFromPosition                  self,nPos
RemoveSymbolPins                             self
```

## DboSymbolDisplayPropsIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextProp                                     self,status
```

## DboSymbolPin (62)

```text
GetContainingLib                             self
GetDisplayPropsPermitted                     self,status
GetDispPropArray                             self
GetHotSpot                                   self,status
GetIsClock                                   self,status
GetIsDot                                     self,status
GetIsGlobal                                  self,status
GetIsLeftPointing                            self,status
GetIsLong                                    self,status
GetIsNetStyle                                self,status
GetIsNoConnect                               self,status
GetIsNumberVisible                           self,status
GetIsRightPointing                           self,status
GetIsUserDefinedShape                        self,status
GetIsVisible                                 self,status
GetName                                      self,name
GetObjectType                                self
GetOwner                                     self
GetParentObj                                 self
GetPinName                                   self,name
GetPinPosition                               self,status
GetPinType                                   self,status
GetSemanticString                            self,str
GetStartPoint                                self,status
InsertAtPinPosition                          self,nPos
IsEquivalent                                 self,pObj
NewDisplayProp                               self,status,name,location,rotation,font,color
NewDisplayPropsIter                          self,status
SetHotSpot                                   self,point
SetIsClock                                   self,bval
SetIsDot                                     self,bval
SetIsGlobal                                  self,val
SetIsLeftPointing                            self,bval
SetIsLong                                    self,bval
SetIsNetStyle                                self,bval
SetIsNoConnect                               self,bval
SetIsNumberVisible                           self,val
SetIsRightPointing                           self,bval
SetIsUserDefinedShape                        self,bval
SetIsVisible                                 self,val
SetName                                      self,name
SetPinName                                   self,name
SetPinPosition                               self,nPos
SetPinType                                   self,type
SetStartPoint                                self,point
sGetHotSpotX                                 obj,status
sGetHotSpotY                                 obj,status
sGetIsClock                                  obj,status
sGetIsDot                                    obj,status
sGetIsGlobal                                 obj,status
sGetIsLeftPointing                           obj,status
sGetIsLong                                   obj,status
sGetIsNetStyle                               obj,status
sGetIsNoConnect                              obj,status
sGetIsNumberVisible                          obj,status
sGetIsRightPointing                          obj,status
sGetIsVisible                                obj,status
sGetPinName                                  obj,status
sGetPinPosition                              obj,status
sGetPinType                                  obj,status
sGetStartPointX                              obj,status
sGetStartPointY                              obj,status
```

## DboSymbolPinBus (2)

```text
GetObjectType                                self
SetPinName                                   self,name
```

## DboSymbolPinDisplayPropsIter (5)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextProp                                     self,status
NextPropEx                                   self,status
```

## DboSymbolPinScalar (1)

```text
GetObjectType                                self
```

## DboSymbolPinsIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextPin                                      self,status
```

## DboSymbolVector (14)

```text
GetLocation                                  self,status
GetName                                      self,name
GetObjectType                                self
NewArc                                       (overloaded)
NewBox                                       (overloaded)
NewCommentText                               self,status,text,rectBound,location,font
NewEllipse                                   (overloaded)
NewLine                                      (overloaded)
NewPolygon                                   (overloaded)
NewPolyline                                  (overloaded)
NewVectorsIter                               (overloaded)
SetLocation                                  self,point
sGetLocationX                                obj,status
sGetLocationY                                obj,status
```

## DboSymbolVectorVectorsIter (2)

```text
~delete                                      self
NextVector                                   self,status
```

## DboTclBom (3)

```text
GetBOMJSON                                   pDesign,pInputJSON
GetBOMJSON1                                  pDesign,pInputJSON
GetBOMOptionsJSON                            pDesign
```

## DboTclHelper (90)

```text
CleanOrCADRegistry                           key
DesignDiffAndDump                            (overloaded)
ReRegisterOrCADPlugins                       (zero-arg-ok)
sAddToStringMap                              aMap,aMapKey,aMapValue
sCastPtr                                     pName,pFrom,pTo
sCheckIsWritable                             nativePath,mode
sCheckNativeIsExec                           path
sCloseCFile                                  aFile
sCreateSession                               (zero-arg-ok)
sDeleteBool                                  pBool
sDeleteCPoint                                pPoint
sDeleteCRect                                 pRect
sDeleteCSize                                 pObj
sDeleteCString                               pStr
sDeleteCStringSet                            std::set<,CString,>,*
sDeleteDboValue                              pObj
sDeleteDboValueType                          pObj
sDeleteInt                                   pInt
sDeleteLOGFONT                               pObj
sDeleteSession                               pSession
sDeleteStdStr                                pStr
sDeleteStringMap                             std::map<,std::string,std::string,>,*
sDeleteULong                                 pObj
SetLiteMode                                  (zero-arg-ok)
SetRegionalSetting                           aDecimalSeperator,aThousandSeperator,aDigitGroupingFormat,aDigitAfterDecimal
SetTimeZone                                  lValue,aTimeZoneName
sEvalPage                                    pPage
sFindInCStringSet                            pCStringSet,pStrToFind
sGetBase64BitmapForOle                       pOleEmbedInst,pOutEncodedString
sGetBase64DataOfOle                          pOleEmbedInst,pOutEncodedString
sGetBool                                     pVal
sGetCFile                                    aFileName,aFileMode
sGetConstCharPtr                             (overloaded)
sGetConstCharPtrFromVector                   pVector,index
sGetCPointX                                  CPoint&
sGetCPointY                                  CPoint&
sGetCRectBottomRight                         CRect&
sGetCRectTopLeft                             CRect&
sGetCSizeX                                   rSize
sGetCSizeY                                   rSize
sGetDboObjectInProcess                       (zero-arg-ok)
sGetEnv                                      pEnv
sGetInt                                      pVal
sGetLFCharSet                                rLOGFONT
sGetLFClipPrecision                          rLOGFONT
sGetLFEscapement                             rLOGFONT
sGetLFHeight                                 rLOGFONT
sGetLFItalic                                 rLOGFONT
sGetLFName                                   rLOGFONT,rFaceName
sGetLFOrientation                            rLOGFONT
sGetLFOutPrecision                           rLOGFONT
sGetLFPitchAndFamily                         rLOGFONT
sGetLFQuality                                rLOGFONT
sGetLFStrikeOut                              rLOGFONT
sGetLFUnderline                              rLOGFONT
sGetLFWeight                                 rLOGFONT
sGetLFWidth                                  rLOGFONT
sGetStringMap                                (zero-arg-ok)
sGetStringMapData                            aMap,aVectorStr
sGetTclList                                  self,pList
sGetULong                                    pVal
sGetValueFromStringMap                       aMap,aMapKey,aKeyValue
sGetVectorSize                               pVector
sInsertToCStringSet                          pCStringSet,pStrToInsert
sLockProperty                                pObj,propName,lockFlag,preTrigger,postTrigger
sMakeBitmap                                  pBitMapStruct,pGrObj,pPage,pRotation,status
sMakeBitMapData                              BoundingBox,Location,bmpFile
sMakeBool                                    (overloaded)
sMakeCPoint                                  (zero-arg-ok)
sMakeCRect                                   (zero-arg-ok)
sMakeCSize                                   (zero-arg-ok)
sMakeCString                                 (zero-arg-ok)
sMakeCStringAppOwned                         (zero-arg-ok)
sMakeCStringSet                              (zero-arg-ok)
sMakeDboValue                                (zero-arg-ok)
sMakeDboValueType                            (zero-arg-ok)
sMakeInt                                     (zero-arg-ok)
sMakeIntAppOwned                             (zero-arg-ok)
sMakeLOGFONT                                 (zero-arg-ok)
sMakeStdStr                                  (overloaded)
sMakeStdVector                               (zero-arg-ok)
sMakeULong                                   (zero-arg-ok)
sPushBackToVector                            pVector,char,const,*
sReleaseAllCreatedPtrs                       (zero-arg-ok)
sRemoveFromVector                            pVector,index
sSetCString                                  pStr,pVal
sSetDboObjectInProcess                       pObject
sSetDboSessionKey                            pSessionKey
sSetEnv                                      pEnv,pValue
sSetServerMode                               pLiscense
```

## DboTclUtilHelper (1)

```text
GetNextIndex                                 self
```

## DboTclUtils (23)

```text
ConvertDBObjectToSWIGId                      pInterp,pBase,rID
CreateJSONForProperties                      pProps,pDefProps,pObjType,pAppName
EvalTCLCommand                               pCommand,commandResult
GetComponentsAndCountInJSON                  (overloaded)
GetDesignFlatNetNameInJSON                   pDsn
GetDesignHierarchyInJSON                     (overloaded)
GetDesignHierarchyInJSONWithoutPages         (overloaded)
GetOptionStringCmdVal                        optionName,defaultValue
GetPropertyBlockHierachy                     pDesign,pProperty
GetReferenceFromID                           pDesign,pId
GetReferencePrefix                           cstrRef
GetTclInterpreter                            (zero-arg-ok)
sApplyFeatureName                            pDesign,pRefSet,pPropNameValJSON,pTransferToDesignMapJSON
sFindSimilarPartBasedOnProp                  pDesign,pstrPartInfoJSON,pstrPropNameJSON,pPropToRead,prStrJSONProp
sGetActiveDesignComponents                   pDesign,pDsnCompPartPropList,pPartsToIgnoreWithPropNameVal,pPropToIgnore,pStrJSONActDsnComp
sGetDesignPartGroupByMatchProp               pDesign,pPropToMatch,pPropToRead,pPartsToIgnoreWithPropNameVal,prStrJSON
sGetDesignPartGroupByOccJSON                 pDesign,pPropToRead,pPartsToIgnoreWithPropNameVal,prStrJSON
sGetDesignPartPropertyJSON                   pDesign,pPropToIgnoreSet,prStrJSONProp
sGetETOEURL                                  pPart,pPackageName,pPartID
sGetPartRefAllOccOfParts                     pDesign,pOccId,pPropToRead,prStrJSONProp
sGetSelectedPartPropertyJSON                 pDesign,pOccID,pPropToIgnoreSet,prStrJSONProp
sGetTIPartsData                              pDesign,pTIVersion,pModelLibVersion,pOSVersion,pForumURL,pPartsURL
sSetInterpAndGetPkgVersion                   pInterp
```

## DboTitleBlock (59)

```text
AddVariantProp                               self,strName,strVal
ClearVariantMap                              (overloaded)
GetBoundingBox                               self
GetDesignCreateDate                          self,status
GetDesignCreateTime                          self,time
GetDesignFileName                            self,name
GetDesignModifyDate                          self,status
GetDesignModifyTime                          self,time
GetDesignName                                self,name
GetEffectivePropValueChoices                 self,name,choices
GetKeepInLowerRightCorner                    self,DboState&
GetNextNewVariantProp                        self,strName,strVal,bNewFound
GetObjectOccurrence                          self,pParentSchematicOcc
GetObjectOccurrences                         (overloaded)
GetPageCount                                 self,status
GetPageCreateDate                            self,status
GetPageCreateTime                            self,time
GetPageModifyDate                            self,status
GetPageModifyTime                            self,time
GetPageName                                  self,name
GetPageNumber                                self,status
GetPageSize                                  self,size
GetSchematicCreateDate                       self,status
GetSchematicCreateTime                       self,time
GetSchematicModifyDate                       self,status
GetSchematicModifyTime                       self,time
GetSchematicName                             self,name
GetSourceLibName                             self,name
GetSourceSymbolName                          self,name
GetSymbol                                    self,status
GetVariantProp                               self,strName,strVal
IsBoundingBoxDirty                           self
IsVariantPropMapEmpty                        self
SetBoundingBox                               self,boundingBox
SetBoundingBoxDirty                          self,bSetting
SetKeepInLowerRightCorner                    self,bLR
SetPageCount                                 self,nPageCount
SetPageNumber                                self,nPageNumber
sGetDesignCreateDate                         obj,status
sGetDesignCreateTime                         obj,status
sGetDesignFileName                           obj,status
sGetDesignModifyDate                         obj,status
sGetDesignModifyTime                         obj,status
sGetDesignName                               obj,status
sGetPageCount                                obj,status
sGetPageCreateDate                           obj,status
sGetPageCreateTime                           obj,status
sGetPageModifyDate                           obj,status
sGetPageModifyTime                           obj,status
sGetPageName                                 obj,status
sGetPageNumber                               obj,status
sGetPageSize                                 obj,status
sGetSchematicCreateDate                      obj,status
sGetSchematicCreateTime                      obj,status
sGetSchematicModifyDate                      obj,status
sGetSchematicModifyTime                      obj,status
sGetSchematicName                            obj,status
sGetSourceLibName                            obj,status
sGetSourceSymbolName                         obj,status
```

## DboTitleBlockOccurrence (22)

```text
AddVariantProp                               self,strName,strVal
ClearVariantMap                              (overloaded)
DeleteEffectiveProp                          self,name
FindInstance                                 self,status
GetInstance                                  self,status
GetNextNewVariantProp                        self,strName,strVal,bNewFound
GetObjectType                                self
GetPathName                                  (overloaded)
GetRefPathName                               (overloaded)
GetSchematic                                 self,status
GetSchematicPath                             self,name
GetTitleBlock                                self,status
GetTitleBlockId                              self,status
GetVariantProp                               self,strName,strVal
IsVariantPropMapEmpty                        self
NewEffectivePropsIter                        (overloaded)
SetEffectivePropStringValue                  (overloaded)
SetTitleBlock                                self,pTitleBlock
SetTitleBlockId                              self,nTitleBlockId
sGetId                                       obj,status
sGetPathName                                 obj,status
sGetSchematicPath                            obj,status
```

## DboTitleBlockOccurrenceEffectivePropsIter (2)

```text
~delete                                      self
NextEffectiveProp                            (overloaded)
```

## DboTitleBlockSymbol (7)

```text
NewSymbolPinBus                              (overloaded)
NewSymbolPinScalar                           (overloaded)
sGetPageCount                                obj,status
sGetPageCreateDate                           obj,status
sGetPageModifyDate                           obj,status
sGetPageNumber                               obj,status
sGetPageSize                                 obj,status
```

## DboUserProp (12)

```text
DeleteValue                                  self
GetName                                      self,name
GetNext                                      self
GetOwner                                     self
GetStringValue                               (overloaded)
GetType                                      self,status
IsDeletable                                  (overloaded)
IsEditable                                   self
SetName                                      self,name
SetStringValue                               (overloaded)
SetValue                                     (overloaded)
ShadowSetStringValue                         self,val
```

## DboUserPropsIter (3)

```text
~delete                                      self
Next                                         self,status
NextUserProp                                 self,status
```

## DboValidValuesIter (1)

```text
NextValue                                    (overloaded)
```

## DboValue (56)

```text
~delete                                      self
GetBool                                      self,status
GetColor                                     self,status
GetCountValidValues                          type,status
GetEnumeration                               self,status
GetFont                                      self,logfont
GetInt                                       self,status
GetLogicalType                               self,status
GetLogicalTypeName                           type,Type
GetLong                                      self,status
GetPhysicalType                              type,status
GetString                                    self,Value
GetTime                                      self,status
GetType                                      self,status
m_nType_get                                  self
m_nType_set                                  self,m_nType
NewValidValuesIter                           type,status
SetBOOL                                      self,val
SetColor                                     self,color
SetDisplayType                               self,displayType
SetFilePath                                  self,val
SetFillStyle                                 self,fillStyle
SetHatchStyle                                self,hatchStyle
SetInt                                       self,val
SetLineStyle                                 self,lineStyle
SetLineWidth                                 self,lineWidth
SetLong                                      self,val
SetPinType                                   self,pinType
SetPrimitiveType                             self,primitiveType
SetRotation                                  self,rotation
SetString                                    self,val
SetTime                                      self,val
SetValue                                     self,val
SetViewType                                  self,viewType
sGetEnumeration                              vType,strVal,status
sGetValue                                    vType,enumValue,status
u                                            (n/a)
u_get                                        self
u_m_bVal_get                                 self
u_m_bVal_set                                 self,m_bVal
u_m_lpszVal_get                              self
u_m_lpszVal_set                              self,m_lpszVal
u_m_lVal_get                                 self
u_m_lVal_set                                 self,m_lVal
u_m_nVal_get                                 self
u_m_nVal_set                                 self,m_nVal
u_m_pFontVal_get                             self
u_m_pFontVal_set                             self,m_pFontVal
u_m_tVal_get                                 self
u_m_tVal_set                                 self,m_tVal
u_s                                          (n/a)
u_s_get                                      self
u_s_m_nEnumType_get                          self
u_s_m_nEnumType_set                          self,m_nEnumType
u_s_m_nEnumVal_get                           self
u_s_m_nEnumVal_set                           self,m_nEnumVal
```

## DboVector (4)

```text
GetContainingLib                             self
GetObjectType                                self
GetOwner                                     self
GetParentObj                                 self
```

## DboView (15)

```text
ClearCMData                                  self
DecrefCount                                  self
GetCMData                                    self
GetDCFPath                                   self
GetDesignLoadStateInCM                       self
GetRefCount                                  self
IncRefCount                                  self
IsDesignCMDisabled                           self
IsDesignCMEnabled                            self
IsDesignPartiallyCMEnabled                   self
SetCMData                                    self,pCMDataObj
setDesignLoadStateInCM                       self,pState
sGetCreateTime                               obj,status
sGetModifyTime                               obj,status
sGetName                                     obj,status
```

## DboWire (80)

```text
AreConnectionsAbuttingAtPoint                self,pLocation,rStatus
CleanupQuad                                  self
ClearCreatedByDB                             self
ConnectInitialization                        self,StartPoint,EndPoint
DeleteAlias                                  self,pAlias
DeleteJunction                               self,location
DeletePoints                                 self
DeleteUserProp                               self,name
DeleteUserPropValue                          self,name
GetBoundingBox                               (overloaded)
GetBundleOwnerPropName                       self,propName,sourceLibName
GetBundleOwnerPropNameFromAlias              self,BundleOwnerPropName,libName
GetColor                                     self,status
GetConnection                                self,nPosition,status
GetContainingLib                             self
GetCreatedByDB                               self,status
GetDisplayPropsPermitted                     self,status
GetDispPropArray                             self
GetEnd                                       self,status
GetEndPoint                                  self,status
GetId                                        self,status
GetLinesIntersect                            Start1,End1,Start2,End2,Intersection
GetLineStyle                                 self,status
GetLineWidth                                 self,status
GetNet                                       self,status
GetNetAliasArray                             self
GetNetName                                   self,name
GetObjectOccurrence                          self,pParentSchematicOcc
GetOwner                                     self
GetParentObj                                 self
GetPoint                                     self,position,status
GetPointCount                                self,status
GetPointPosition                             self,point,status
GetStart                                     self,status
GetStartPoint                                self,status
GetUserData                                  self,status
IsBoundingBoxDirty                           self
IsBundleObject                               self
IsGlobal                                     self,status
IsHorizontal                                 self,status
IsNonOrthogonal                              self,status
IsVertical                                   self,status
IsZeroLen                                    self,status
JunctionOnWire                               self,point
LineIntersectsRect                           rect,LineStart,LineEnd
LinesIntersect                               Start1,End1,Start2,End2
MovePoint                                    self,position,offset
NewAlias                                     (overloaded)
NewAliasesIter                               self,status
NewBusEntriesIter                            self,status
NewConnectedWiresIter                        self,status
NewConnection                                (overloaded)
NewDisplayProp                               (overloaded)
NewDisplayPropsIter                          self,status
NewGlobalsIter                               self,status
NewJunction                                  self,location
NewJunctionsIter                             self,status
NewName                                      self,name,location,font,rotation,color
NewOffPageConnectorsIter                     self,status
NewPoint                                     (overloaded)
NewPortInstsIter                             self,status,mode
NewPortsIter                                 self,status,mode
NewUserProp                                  (overloaded)
PointIsJunction                              self,point,status
PointOnLine                                  point,LineStart,LineEnd
PointOnWire                                  self,point
RemoveExtraJunctions                         self
SetBoundingBox                               self,rect
SetBoundingBoxDirty                          self,bSetting
SetColor                                     self,color
SetDuplicateId                               self,newId
SetId                                        self,newId
SetLineStyle                                 self,linestyle
SetLineWidth                                 self,linewidth
SetPoint                                     self,position,location
SetUserData                                  self,pPtr
SetUserPropStringValue                       self,name,value
sGetColor                                    obj,status
sGetNetName                                  obj,status
SyncNetGroupAliases                          self
```

## DboWireAliasesIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextAlias                                    self,status
```

## DboWireBus (5)

```text
GetObjectType                                self
IsBundleObject                               self
NewAlias                                     (overloaded)
NormalizeBundleWire                          self
SetName                                      self,name
```

## DboWireBusEntriesIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextBusEntry                                 self,status
```

## DboWireConnectedWiresIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextWire                                     self,status
```

## DboWireData (10)

```text
Color_get                                    self
Color_set                                    self,Color
End_get                                      self
End_set                                      self,End
nJctnEnd_get                                 self
nJctnEnd_set                                 self,nJctnEnd
nJctnStart_get                               self
nJctnStart_set                               self,nJctnStart
Start_get                                    self
Start_set                                    self,Start
```

## DboWireDisplayPropsIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextProp                                     self,status
```

## DboWireGlobalsIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextGlobal                                   self,status
```

## DboWireJunctionsIter (2)

```text
~delete                                      self
NextJunction                                 self,status
```

## DboWireOffPageConnectorsIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextOffPageConnector                         self,status
```

## DboWirePortInstsIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextPortInst                                 self,status
```

## DboWirePortsIter (4)

```text
~delete                                      self
GetKey                                       self,pObject
Next                                         self,status
NextPort                                     self,status
```

## DboWiresAtPointIter (2)

```text
~delete                                      self
NextWire                                     self,status
```

## DboWireScalar (3)

```text
DeleteAlias                                  self,pAlias
GetObjectType                                self
SetName                                      self,name
```

## DboWiresInAreaIter (2)

```text
~delete                                      self
NextWire                                     self,status
```

## XMATIC (18)

```text
AddPropertyInTcl                             pPropertyName,pPropertyValue
CAP2EDIF                                     pCapPathIn,pEdifPathOut,pCfgPath
DSN2XML                                      (overloaded)
EDIF2CAP                                     pEdifPathIn,pCapPathOut,pCfgPath
ExportDesignInXML                            aDsn,aXML
ExportNetGroupXML                            pDsnPathIn,pXmlPathOut,pXsdPath,pLogFilePath
GetCacheLib                                  (overloaded)
GetDboSessionFromXML                         (overloaded)
GetDesignXml                                 (overloaded)
GetLibXml                                    (overloaded)
GetPackageXml                                (overloaded)
GetPageXml                                   aPage,aXML
GetSymbolXml                                 (overloaded)
OLB2XML                                      (overloaded)
SavePageXML                                  aCacheLibXMLFilePath,aDesignXMLFilePath,aDesignPath,aStatus
sSaveNewPartInLib                            pLib,pPartInfo
XML2DSN                                      (overloaded)
XML2OLB                                      (overloaded)
```

