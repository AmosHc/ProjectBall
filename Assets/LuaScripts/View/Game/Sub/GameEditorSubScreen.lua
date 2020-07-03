---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 54237.
--- DateTime: 2020/7/3 13:29
---
local GameEditorSubScreen = class("GameEditorSubScreen",SubScreenBase)

function GameEditorSubScreen:Init()
    if not self.data then 
        return
    end
    --local levelCfg = self.data
    ResourcesMgr.GetInstance():LoadAsset(UI_RES_PREFIX.."Game/btnOrganItem", handler(self,self.InitEditorAgencyList))
end

function GameEditorSubScreen:InitEditorAgencyList(obj)
    if obj then
        CommonUtility:RefreshList(self.uiCtrl.rectListOrganEditor,obj,self.data.Agencys,self.ListItemRender)
    else
        log("prefab "..UI_RES_PREFIX.."Game/btnOrganItem 加载失败")
    end
end

function GameEditorSubScreen.ListItemRender(idx,item,AgencyID)
    log(AgencyID)
end

return GameEditorSubScreen