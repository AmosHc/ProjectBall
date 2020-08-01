local UIBase = class("UIBase")

------------------基本事件封装，界面卸载时全部自动卸载事件，防止漏卸---------------------
function UIBase:InitBtnListenerTabs()
    self.allOnClickObjs = {}
    self.allOnValueChangedObjs = {}
end

function UIBase:UnBindListenerAction()
    self:RemoveAllOnClickListener()
    self:RemoveAllOnValueChangedListener()
end

function UIBase:AddOnClickListener( obj, action)
    if obj then
        obj.onClick:AddListener(action)
        if not self.allOnClickObjs[obj] then
            self.allOnClickObjs[obj] = true
        end
    end
end

function UIBase:RemoveAllOnClickListener()
    for obj, _ in pairs(self.allOnClickObjs) do
        obj.onClick:RemoveAllListeners()
    end
    self.allOnClickObjs = nil
end

function UIBase:AddOnValueChangedListener( obj, action)
    if obj then
        obj.onValueChanged:AddListener(action)
        if not self.allOnValueChangedObjs[obj] then
            self.allOnValueChangedObjs[obj] = true
        end
    end
end

function UIBase:RemoveAllOnValueChangedListener()
    for obj, _ in pairs(self.allOnValueChangedObjs) do
        obj.onValueChanged:RemoveAllListeners()
    end
    self.allOnValueChangedObjs = nil
end

return UIBase