require("Class")
require("BehaviourBase")

local GameObject = UnityEngine.GameObject
local BoxCollider = UnityEngine.BoxCollider

BaseWindow = Class(BehaciourBase)

function BaseWindow:ctor(behaviour, path, wondowType)
   self.behaviour = behaviour
   self.gameObject = behaviour.gameObject
   self.transform = behaviour.transform
   self.panel = self.transform:GetComponent(typeof(UIPanel))

   self.path = path
   --window类型
   --0、一直处于栈底的 只能有唯一的，比如游戏主界面
   --1、一般的,会隐藏上一个窗口
   --2、弹出框，不隐藏上一个窗口
   self.wondowType = wondowType  
   self.isPause = false

end 

function BaseWindow:OnEnter()

        local go = GameObject("Mask")
        go.transform:SetParent(self.transform)
        go.transform:SetAsFirstSibling()
        go.transform.localPosition = Vector3.zero
        go.transform.localScale = Vector3.one
        go.transform.localRotation = Quaternion.identity

        self.mask = go

        local box = go:AddComponent(typeof(BoxCollider))
        box.center = Vector3.zero

        local widget = go:AddComponent(typeof(UIWidget))
        widget.depth = -1

        local root = WindowManager.uiRoot

        widget.width = root.manualWidth
        widget.height = root.manualHeight
        widget.autoResizeBoxCollider = true
        widget:SetAnchor(gameObject,0,0,0,0)
      
        widget:ResizeCollider()

        
  
end

function BaseWindow:OnPause()
    self.isPause = true

    if self.panel == nil then
        self.panel = self.transform:GetComponent(typeof(UIPanel))
    end
    if self.panel then
        self.panel.alpha = 0
    end
end


function BaseWindow:OnResume()
    self.isPause = false

    if self.panel == nil then
        self.panel = self.transform:GetComponent(typeof(UIPanel))
    end
    if self.panel then
        self.panel.alpha = 1
    end

    self.transform:SetAsLastSibling()
    WindowManager:SetBlur()
    
end

function BaseWindow:OnExit()
    if self.gameObject then
        GameObject.Destroy(self.gameObject)
    end
    WindowManager:SetBlur()
end

function BaseWindow:Close()
    WindowManager:Close()
end