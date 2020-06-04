---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 54237.
--- DateTime: 2020/5/30 9:30
---
local ScreenBase = class("ScreenBase")

function ScreenBase:ctor(uiRes,uiName,data)
    self.uiRes = uiRes
    self.uiName = uiName
    self.panelRoot = nil
    self.uiCtrl = nil
    self.openOrder = 0 -- 界面打开顺序
    self.sortingLayer = 0 -- 界面层级
    self.data = data --界面打开的传入参数
    
    self:InitBtnListenerTabs()
    self:StartLoad()
end

function ScreenBase:StartLoad()
    ResourcesMgr.GetInstance():LoadAsset(self.uiRes, handler(self,self.PanelLoadComplete));
end

--资源加载完成
function ScreenBase:PanelLoadComplete(ao)
    self.panelRoot = Object.Instantiate(ao, UIMgr:GetUIRootTransform());
    --获取控件对象
    self.uiCtrl = self.panelRoot:GetComponent(typeof(UICtrlBase));
    --更新层级信息
    self:UpdateLayoutLevel()
    --调用加载成功方法
    self:OnLoadSuccess()
    --添加到控制层
    UIMgr:AddUI(self)
end

function ScreenBase:UpdateLayoutLevel()
    local camera = UIMgr:GetUICamera();
    local ctrlBase = self.uiCtrl
    if camera then
        ctrlBase.ctrlCanvas.worldCamera = camera;
    end

    ctrlBase.ctrlCanvas.pixelPerfect = true;
    ctrlBase.ctrlCanvas.overrideSorting = true;
    ctrlBase.ctrlCanvas.sortingLayerID = ctrlBase:GetScreenPriority();
    self.sortingLayer = ctrlBase:GetScreenPriority();
    ctrlBase.ctrlCanvas.sortingOrder = self.openOrder;
end

function ScreenBase:OnLoadSuccess()
    self:OnCreate()
    self.uiCtrl:AutoRelease(EventManager.ScreenResolutionEvt:Subscribe(handler(self,self.UIAdapt)))----注册适配监听事件
    if self.uiCtrl.mUseMask then
        MaskScreenManager:Show(self);
    end
end

function ScreenBase:GetPanelRoot()
    return self.panelRoot
end

function ScreenBase:GetCtrlBase()
    return self.uiCtrl
end

function ScreenBase:GetOpenOrder()
    return self.openOrder
end

function ScreenBase:GetSortingLayer()
    return self.sortingLayer
end

function ScreenBase:Close()
    self:UnBindListenerAction()
    self:UnBindAction()
    self:OnClose()
    UIMgr:RemoveUI(self.uiName)
end

function ScreenBase:Show()
    self:BindAction()
    self:OnShow()
end

--设置渲染顺序
function ScreenBase:SetOpenOrder(openOrder)
    self.openOrder = openOrder
    if self.uiCtrl and self.uiCtrl.ctrlCanvas then
        self.uiCtrl.ctrlCanvas.sortingOrder = openOrder;
    end
end

function ScreenBase:OnClickMaskArea()
    self:Close()
end

function ScreenBase:Dispose()
    self:OnDispose()
    GameObject.Destroy(self.panelRoot)
end
---------- 所有公开接口,请勿自行添加与修改 ---------
--公开复写接口,创建之后调用
function ScreenBase:OnCreate()
end
--公开复写接口，绑定事件
function ScreenBase:BindAction()
end
--公开复写接口,移除事件绑定
function ScreenBase:UnBindAction()
end
--公开复写接口,每次显示时调用
function ScreenBase:OnShow()
end
--公开复写接口,隐藏的时候调用
function ScreenBase:OnClose()
end
--公开复写接口,页面销毁
function ScreenBase:OnDispose()
end
--公开复写接口,ui分辨率适配
function ScreenBase:UIAdapt(width,height)
end

------------------复写事件，界面卸载时全部自动卸载事件，防止吊人漏卸---------------------
function ScreenBase:InitBtnListenerTabs()
    self.allOnClickObjs = {}
end

function ScreenBase:UnBindListenerAction()
    self:RemoveOnClickListener()
end

function ScreenBase:RemoveOnClickListener()
    for obj, _ in pairs(self.allOnClickObjs) do
        obj.onClick:RemoveAllListeners()
    end
    self.allOnClickObjs = nil
end

function ScreenBase:AddOnClickListener( obj, action)
    if obj then
        obj.onClick:AddListener(action)
        if not self.allOnClickObjs[obj] then
            self.allOnClickObjs[obj] = true
        end 
    end
end

return ScreenBase