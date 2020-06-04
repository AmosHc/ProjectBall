---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by huangchao05.
--- DateTime: 2020/6/1 12:30
---
local MainMenuUI = class("MainMenuUI",ScreenBase)

function MainMenuUI:BindAction()
    self:AddOnClickListener(self.uiCtrl.btnThemeChooser,handler(self,self.OnOpenThemeChooserClick))
    self:AddOnClickListener(self.uiCtrl.btnCreativeWorkshop,handler(self,self.OnOpenCreativeWorkshopClick))
    self:AddOnClickListener(self.uiCtrl.btnSetting,handler(self,self.OnOpenSettingClick))
end

function MainMenuUI:OnOpenThemeChooserClick()
    UIMgr:OpenUI("ThemeChooserUI")
end

function MainMenuUI:OnOpenSettingClick()
    log("--跳设置")
end

function MainMenuUI:OnOpenCreativeWorkshopClick()
    log("跳创意工坊")
end

return MainMenuUI