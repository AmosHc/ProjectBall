---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by huangchao05.
--- DateTime: 2020/6/1 14:50
---
local ThemeChooserUI = class("ThemeChooserUI",ScreenBase)

function ThemeChooserUI:OnCreate()
    self.ThemeChooserCfg = GameConfig.ThemeChooser
end

function ThemeChooserUI:BindAction()
    self:AddOnClickListener(self.uiCtrl.btnPrev,handler(self,self.OnPreviousPageClick))
    self:AddOnClickListener(self.uiCtrl.btnNext,handler(self,self.OnNextPageClick))
    self:AddOnClickListener(self.uiCtrl.btnJumpTheme,handler(self,self.OnOpenJumpTheme))
    self:AddOnClickListener(self.uiCtrl.btnClose,handler(self,self.Close))
end

function ThemeChooserUI:UnBindAction()
end

function ThemeChooserUI:OnShow()
    if not self.ThemeChooserCfg then
        return
    end
    self._Idx = 0
    self._MaxCount = #self.ThemeChooserCfg
    self:RefreshPage()
end


function ThemeChooserUI:OnPreviousPageClick()
    self._Idx = math.fmod(self._Idx - 1 , self._MaxCount )
    self:RefreshPage()
end

function ThemeChooserUI:OnNextPageClick()
    self._Idx = math.fmod(self._Idx + 1 , self._MaxCount )
    self:RefreshPage()
end

function ThemeChooserUI:OnOpenJumpTheme()
    UIMgr:OpenUI("SelectLevelUI",{titleName = self.uiCtrl.title.text , levels = self.levels} )
end

function ThemeChooserUI:RefreshPage()
    local idx = self._Idx + 1
    --self.uiCtrl.icon.url = self.ThemeChooserCfg[_Idx].icon
    self.uiCtrl.title.text = self.ThemeChooserCfg[idx].ThemeName
    self.levels = self.ThemeChooserCfg[idx].levels
    self.uiCtrl.btnPrevObj:SetActive( self._Idx ~= 0)
    self.uiCtrl.btnNextObj:SetActive( self._Idx ~= self._MaxCount - 1)
end

return ThemeChooserUI