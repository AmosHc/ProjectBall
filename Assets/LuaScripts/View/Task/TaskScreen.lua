---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 54237.
--- DateTime: 2020/5/30 17:55
---

local TaskScreen = class("TaskScreen",ScreenBase)

function TaskScreen:BindAction()
    self.uiCtrl.btnClose.onClick:AddListener(handler(self,self.Close))
end

return TaskScreen