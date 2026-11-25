# 迭代器索引（17.4）

每个 `New*Iter` 返回一个迭代器对象；用该迭代器类的 `Next*` 方法取值，用同名 `delete_Dbo*Iter` 释放（不要用 `-delete`，部分版本无效或重复释放）。

| 迭代器类 | Next 方法 | 释放命令 |
| --- | --- | --- |
| DboBezierPointsIter |  | `delete_DboBezierPointsIter` |
| DboBundleMemberIter |  | `delete_DboBundleMemberIter` |
| DboBundleNetIter |  | `delete_DboBundleNetIter` |
| DboBusMemberNamesIter | NextBundleMemberName, NextMemberName | `delete_DboBusMemberNamesIter` |
| DboCellPartNamesIter | NextName | `delete_DboCellPartNamesIter` |
| DboCellPartsIter | NextPart | `delete_DboCellPartsIter` |
| DboConnectivityChangeIter | NextAddorModifiedDbObject, NextDeletedDbObject, NextFlatNetChange, NextPinChange | `delete_DboConnectivityChangeIter` |
| DboConnectivityObjectsAtPointIter | NextObject | `delete_DboConnectivityObjectsAtPointIter` |
| DboDBPropsIter | NextDBProp | `delete_DboDBPropsIter` |
| DboDesignCachesIter | NextDesignCache | `delete_DboDesignCachesIter` |
| DboDesignFlatNetsIter | NextFlatNet | `delete_DboDesignFlatNetsIter` |
| DboDesignGlobalsIter | NextGlobal | `delete_DboDesignGlobalsIter` |
| DboDesignOccurrencesIter | NextOccurrence | `delete_DboDesignOccurrencesIter` |
| DboDesignPackageInstOccIter | NextPkgInstOcc | `delete_DboDesignPackageInstOccIter` |
| DboDesignSchematicOccurrencesIter | NextSchematicOccurrence | `delete_DboDesignSchematicOccurrencesIter` |
| DboDevicePinNumbersIter | NextNumber | `delete_DboDevicePinNumbersIter` |
| DboDirectoryEntriesIter | NextEntry | `delete_DboDirectoryEntriesIter` |
| DboDirectoryObjectsIter | NextObject | `delete_DboDirectoryObjectsIter` |
| DboDisplayPropsIter | NextProp | `delete_DboDisplayPropsIter` |
| DboEffectivePropsIter | NextEffectiveProp | `delete_DboEffectivePropsIter` |
| DboExtensionIter | NextExtension | `delete_DboExtensionIter` |
| DboFlatNetEffectivePropsIter | NextEffectiveProp | `delete_DboFlatNetEffectivePropsIter` |
| DboFlatNetNetOccurrencesIter | NextNetOccurrence | `delete_DboFlatNetNetOccurrencesIter` |
| DboFlatNetNetsIter | NextNet | `delete_DboFlatNetNetsIter` |
| DboFlatNetPortOccurrencesIter | NextPortOccurrence | `delete_DboFlatNetPortOccurrencesIter` |
| DboFlatNetWiresIter | NextWire | `delete_DboFlatNetWiresIter` |
| DboGraphicInstEffectivePropsIter | NextEffectiveProp | `delete_DboGraphicInstEffectivePropsIter` |
| DboGraphicObjectVectorsIter | NextVector | `delete_DboGraphicObjectVectorsIter` |
| DboInstanceDisplayPropsIter | NextProp | `delete_DboInstanceDisplayPropsIter` |
| DboInstOccurrenceEffectivePropsIter | NextEffectiveProp | `delete_DboInstOccurrenceEffectivePropsIter` |
| DboLibCachesIter | NextCachedObject | `delete_DboLibCachesIter` |
| DboLibCellNamesIter | NextName | `delete_DboLibCellNamesIter` |
| DboLibCellsIter | NextCell | `delete_DboLibCellsIter` |
| DboLibChangedObjectsIter | NextObject | `delete_DboLibChangedObjectsIter` |
| DboLibExportBlockNamesIter | NextName | `delete_DboLibExportBlockNamesIter` |
| DboLibExportBlocksIter | NextExportBlock | `delete_DboLibExportBlocksIter` |
| DboLibGraphicNamesIter | NextName | `delete_DboLibGraphicNamesIter` |
| DboLibGraphicsIter | NextGraphicObject | `delete_DboLibGraphicsIter` |
| DboLibPackageAliasesIter | NextAlias | `delete_DboLibPackageAliasesIter` |
| DboLibPackageNamesIter | NextName | `delete_DboLibPackageNamesIter` |
| DboLibPackagesIter | NextPackage | `delete_DboLibPackagesIter` |
| DboLibPartNamesIter | NextName | `delete_DboLibPartNamesIter` |
| DboLibPartPinsIter | NextPin | `delete_DboLibPartPinsIter` |
| DboLibPartsIter | NextPart | `delete_DboLibPartsIter` |
| DboLibSymbolNamesIter | NextName | `delete_DboLibSymbolNamesIter` |
| DboLibSymbolsIter | NextSymbol | `delete_DboLibSymbolsIter` |
| DboLibUnusedCacheEntriesIter | NextUnusedEntry | `delete_DboLibUnusedCacheEntriesIter` |
| DboLibViewNamesIter | NextName | `delete_DboLibViewNamesIter` |
| DboLibViewsIter | NextView | `delete_DboLibViewsIter` |
| DboMiscFileWriter |  | `delete_DboMiscFileWriter` |
| DboModifiedFlatNetsIter | NextId | `delete_DboModifiedFlatNetsIter` |
| DboNetAliasesIter | NextAlias | `delete_DboNetAliasesIter` |
| DboNetBusEntriesIter | NextBusEntry | `delete_DboNetBusEntriesIter` |
| DboNetBusMembersIter | NextMember | `delete_DboNetBusMembersIter` |
| DboNetEffectivePropsIter | NextEffectiveProp | `delete_DboNetEffectivePropsIter` |
| DboNetGlobalsIter | NextGlobal | `delete_DboNetGlobalsIter` |
| DboNetOccurrenceEffectivePropsIter | NextEffectiveProp | `delete_DboNetOccurrenceEffectivePropsIter` |
| DboNetOffPageConnectorsIter | NextOffPageConnector | `delete_DboNetOffPageConnectorsIter` |
| DboNetPortInstsIter | NextPortInst | `delete_DboNetPortInstsIter` |
| DboNetPortsIter | NextPort | `delete_DboNetPortsIter` |
| DboNetWiresIter | NextWire | `delete_DboNetWiresIter` |
| DboOccurrenceChildrenIter | NextOccurrence | `delete_DboOccurrenceChildrenIter` |
| DboOffPageConnectorOccurrenceEffectivePropsIter | NextEffectiveProp | `delete_DboOffPageConnectorOccurrenceEffectivePropsIter` |
| DboPackageAliasesIter | NextAlias | `delete_DboPackageAliasesIter` |
| DboPackageDevicesIter | NextDevice | `delete_DboPackageDevicesIter` |
| DboPackageInstOccurrencesIter | NextInstOccurrence | `delete_DboPackageInstOccurrencesIter` |
| DboPackageNamesIter | NextName | `delete_DboPackageNamesIter` |
| DboPackagePartsIter | NextPart | `delete_DboPackagePartsIter` |
| DboPackageReferencedPartInstIter | NextPartInst | `delete_DboPackageReferencedPartInstIter` |
| DboPageBookMarksIter | NextBookMark | `delete_DboPageBookMarksIter` |
| DboPageBusEntriesIter | NextBusEntry | `delete_DboPageBusEntriesIter` |
| DboPageCommentGraphicsIter | NextCommentGraphic | `delete_DboPageCommentGraphicsIter` |
| DboPageCustomItemsListIter | NextCustomItem | `delete_DboPageCustomItemsListIter` |
| DboPageEditsIter | NextEdit | `delete_DboPageEditsIter` |
| DboPageERCsIter | NextERC | `delete_DboPageERCsIter` |
| DboPageFindGraphicInstIter | NextGraphicInstance | `delete_DboPageFindGraphicInstIter` |
| DboPageGlobalsIter | NextGlobal | `delete_DboPageGlobalsIter` |
| DboPageNetsIter | NextNet | `delete_DboPageNetsIter` |
| DboPageObjectsAtPointIter | NextObject | `delete_DboPageObjectsAtPointIter` |
| DboPageOffPageConnectorsIter | NextOffPageConnector | `delete_DboPageOffPageConnectorsIter` |
| DboPagePartInstsIter | NextPartInst | `delete_DboPagePartInstsIter` |
| DboPagePortsIter | NextPort | `delete_DboPagePortsIter` |
| DboPageTitleBlocksIter | NextTitleBlock | `delete_DboPageTitleBlocksIter` |
| DboPageWiresIter | NextWire | `delete_DboPageWiresIter` |
| DboPartInstPinsIter | NextPin | `delete_DboPartInstPinsIter` |
| DboPolygonPointsIter |  | `delete_DboPolygonPointsIter` |
| DboPolylinePointsIter |  | `delete_DboPolylinePointsIter` |
| DboPortInstDisplayPropsIter | NextProp, NextPropEx | `delete_DboPortInstDisplayPropsIter` |
| DboPortInstEffectivePropsIter | NextEffectiveProp | `delete_DboPortInstEffectivePropsIter` |
| DboPortOccurrenceEffectivePropsIter | NextEffectiveProp | `delete_DboPortOccurrenceEffectivePropsIter` |
| DboSchematicChangedPagesIter | NextPage | `delete_DboSchematicChangedPagesIter` |
| DboSchematicGlobalsIter | NextGlobal | `delete_DboSchematicGlobalsIter` |
| DboSchematicInstsIter | NextInst | `delete_DboSchematicInstsIter` |
| DboSchematicNetBusMembersIter | NextMember | `delete_DboSchematicNetBusMembersIter` |
| DboSchematicNetEffectivePropsIter | NextEffectiveProp | `delete_DboSchematicNetEffectivePropsIter` |
| DboSchematicNetGlobalsIter | NextGlobal | `delete_DboSchematicNetGlobalsIter` |
| DboSchematicNetNetsIter | NextNet | `delete_DboSchematicNetNetsIter` |
| DboSchematicNetOffPageConnectorsIter | NextOffPageConnector | `delete_DboSchematicNetOffPageConnectorsIter` |
| DboSchematicNetPortInstsIter | NextPortInst | `delete_DboSchematicNetPortInstsIter` |
| DboSchematicNetPortsIter | NextPort | `delete_DboSchematicNetPortsIter` |
| DboSchematicNetsIter | NextNet | `delete_DboSchematicNetsIter` |
| DboSchematicNetWiresIter | NextWire | `delete_DboSchematicNetWiresIter` |
| DboSchematicOffPageConnectorsIter | NextOffPageConnector | `delete_DboSchematicOffPageConnectorsIter` |
| DboSchematicOptimizerParametersIter | NextOptimizerParameter | `delete_DboSchematicOptimizerParametersIter` |
| DboSchematicPageNamesIter | NextName | `delete_DboSchematicPageNamesIter` |
| DboSchematicPagesIter | NextPage | `delete_DboSchematicPagesIter` |
| DboSchematicPortsIter | NextPort | `delete_DboSchematicPortsIter` |
| DboSessionDesignsIter | NextDesign | `delete_DboSessionDesignsIter` |
| DboSessionLibsIter | NextLib | `delete_DboSessionLibsIter` |
| DboSymbolDisplayPropsIter | NextProp | `delete_DboSymbolDisplayPropsIter` |
| DboSymbolPinDisplayPropsIter | NextProp, NextPropEx | `delete_DboSymbolPinDisplayPropsIter` |
| DboSymbolPinsIter | NextPin | `delete_DboSymbolPinsIter` |
| DboSymbolVectorVectorsIter | NextVector | `delete_DboSymbolVectorVectorsIter` |
| DboTitleBlockOccurrenceEffectivePropsIter | NextEffectiveProp | `delete_DboTitleBlockOccurrenceEffectivePropsIter` |
| DboUserPropsIter | NextUserProp | `delete_DboUserPropsIter` |
| DboValidValuesIter | NextValue | `delete_DboValidValuesIter` |
| DboWireAliasesIter | NextAlias | `delete_DboWireAliasesIter` |
| DboWireBusEntriesIter | NextBusEntry | `delete_DboWireBusEntriesIter` |
| DboWireConnectedWiresIter | NextWire | `delete_DboWireConnectedWiresIter` |
| DboWireDisplayPropsIter | NextProp | `delete_DboWireDisplayPropsIter` |
| DboWireGlobalsIter | NextGlobal | `delete_DboWireGlobalsIter` |
| DboWireJunctionsIter | NextJunction | `delete_DboWireJunctionsIter` |
| DboWireOffPageConnectorsIter | NextOffPageConnector | `delete_DboWireOffPageConnectorsIter` |
| DboWirePortInstsIter | NextPortInst | `delete_DboWirePortInstsIter` |
| DboWirePortsIter | NextPort | `delete_DboWirePortsIter` |
| DboWiresAtPointIter | NextWire | `delete_DboWiresAtPointIter` |
| DboWiresInAreaIter | NextWire | `delete_DboWiresInAreaIter` |
