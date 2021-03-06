require("Class")
require("WindowPath")
require("UnityClass")
require("UnityLayer")

--全局的WindowManager对象，继承于BehaviourBase
WindowManager = Class("WindowManager",BehaviourBase).new()

--初始化函数
function  WindowManager:Initialize()
    --确保只被初始化一次
    if  self.initialized  == nil or self.initialized == false then
    
        self.initialized = true

        self.uiLayer = UnityLayer.UI              --UI显示层
        self.blurLayer = UnityLayer.Blur          --背景模糊层 Unity没有该层的话请创建

        local go = GameObject('WindowManager')     
        GameObject.DontDestroyOnLoad(go)

        local behaviour =  AddLuaBehaviour(go, self)
        
        local p = NGUITools.CreateUI(false)
        p.transform:SetParent(behaviour.transform)

        self.uiCamera = p:GetComponentInChildren(typeof(UICamera))
        local camera = self.uiCamera:GetComponent( typeof( Camera ))
        camera.clearFlags = CameraClearFlags.Depth
        camera.cullingMask =  UnityLayer.MakeMask(self.uiLayer)
       
        NGUITools.SetLayer(self.uiCamera.gameObject, self.uiLayer)
        camera.depth = 2


        self.uiRoot = p:GetComponent(typeof(UIRoot))
        self.uiRoot.scalingStyle = UIRoot.Scaling.Constrained
        
        local DESIGN_WIDTH = 1280
        local DESIGN_HEIGHT = 720

        self.uiRoot.manualHeight = DESIGN_HEIGHT
        self.uiRoot.manualWidth = DESIGN_WIDTH

        local tmpScreenAspectRatio = (Screen.width * 1.0) / Screen.height
        local tmpDesignAspectRatio = (DESIGN_WIDTH * 1.0) / DESIGN_HEIGHT
        if (tmpScreenAspectRatio * 100) < (tmpDesignAspectRatio * 100) then
        
            self.uiRoot.fitWidth = true
            self.uiRoot.fitHeight = false

        elseif (tmpScreenAspectRatio * 100) > (tmpDesignAspectRatio * 100) then
        
            self.uiRoot.fitWidth = false
            self.uiRoot.fitHeight = true
        end


        local blurGo = GameObject.Instantiate(self.uiCamera.gameObject)
        blurGo.name = "BlurCamera"
        blurGo.transform:SetParent(self.uiRoot.transform)
        Object.Destroy(blurGo:GetComponent(typeof(AudioListener)))

        self.blurCamera = blurGo:GetComponent(typeof(UICamera))  
        local camera = self.blurCamera:GetComponent(typeof(Camera))
        camera.clearFlags = CameraClearFlags.Depth 
        camera.cullingMask =  UnityLayer.MakeMask(self.blurLayer)       
      
        NGUITools.SetLayer(blurGo,  self.blurLayer)
        camera.depth = 1
        self.blurCamera.enabled = false

        self.blurEffect = blurGo:AddComponent(typeof(BlurEffect))        
        self.blurEffect.enabled = false

        --Window栈容器
        self.mWindowStack = Stack.new()             --lua栈
        self.mWidgetList = {}
    end

    return self
end

--是否可以点击
function  WindowManager:SetTouchable(touchable)
    if self.uiCamera then
        self.uiCamera.useTouch = touchable
        self.uiCamera.useMouse = touchable
    end
end

function WindowManager:Open(class, callback)

    self:SetTouchable(false)

    local name = class.GetType()

    local t = self:Get(name)

    if  t then
    
        local windowType = t.wondowType 

        if windowType == WindowType.Widget then

            self:Push(t, callback)

        else

            local stack = Stack.new()

            while (self.mWindowStack:Count() > 0)
            do
                local window = self.mWindowStack:Pop()
                if  window == t then
            
                    break
                else
            
                    stack:Push(window)
                end
            end

            while (stack:Count() > 0)
            do
                local window = stack:Pop()

                self:SetLayer(window)

                self.mWindowStack:Push(window)
            end
            self:Push(t, callback)
        end
    else
    
        local path = WindowPath:Get(name)

        if  path ~= nil then
        
            local tmpAssetBundleName = "assetbundle.unity3d"
            AssetManager:Load(tmpAssetBundleName, path, function (varGo)  
                if varGo then
                
                    local go = GameObject.Instantiate(varGo)

                    NGUITools.SetLayer(go,  self.uiLayer)

                    local tran = go.transform:Find(name)

                    tran:SetParent(self.uiRoot.transform)

                    GameObject.Destroy(go)

                    tran.localPosition = Vector3.zero
                    tran.localRotation = Quaternion.identity
                    tran.localScale = Vector3.one

                    local reference = AssetReference.new(tmpAssetBundleName, path)

                    local behaviour = AddLuaBehaviour(tran.gameObject, reference)

                    tran.gameObject:SetActive(true)

                 
                    t = class.new(path)

                    behaviour:AddLuaTable(name, t)

                    if  t.windowType == WindowType.Root then
                    
                        --查找看看是否已经有 root window
                        local window = self:Find(0)

                        if  window ~= nil then
                        
                            error("已经存在一个 windowType = 0 的界面，本界面将销毁.")
                            GameObject.Destroy(tran.gameObject)
                            self:SetTouchable(true)

                            return
                        end
                    end

                    t.path = path

                    t:OnEnter()

                    self:Push(t, callback)
                else
                    self:SetTouchable(true)
                end
            end)
            
        else
        
            self:SetTouchable(true);
        end
    end


end

function WindowManager:Push(t, callback)

    if t ~= nil then
        
        local windowType = t.windowType

        if windowType == WindowType.Widget then

            local exist = false
            for i,v in ipairs(self.mWidgetList) do
                if v == t or v.path == t.path then
                    exist = true
                    break
                end
            end

            if exist == false then
                table.insert( self.mWidgetList, t )
            end
        else

            if self.mWindowStack:Count() > 0 then

                --打开Root 关闭其他的
                if  t.windowType == WindowType.Root then
                
                    while (self.mWindowStack:Count() > 0)
                    do
                        local window =self.mWindowStack:Pop()

                        if window then
                        
                            if window ~= t then
                            
                                window:OnExit()
                            end
                        end
                    end
                
                elseif t.windowType == WindowType.Pop then
                
                    --Pop类型的不需要暂停上一个窗口
                
                else
                
                    --暂停上一个界面
                    local window = self.mWindowStack:Peek()

                    if window and window.isPause == false then
                    
                        window:OnPause()
                    end
                end
        
            end
            
            self.mWindowStack:Push(t)

        end

        self:SetLayer(t)

        t:OnResume()
    end

    self:SetTouchable(true)

    if callback ~= nil then
        callback(t)
    end
end

---
---根据WindowPath中注册的路径查找
---
function WindowManager:Get(name)

    local path = WindowPath:Get(name)

    if path then
        for i,v in ipairs(self.mWindowStack.items) do
     
            if v.path == path then
                return v
            end
        end
    end

    for i,v in ipairs(self.mWidgetList) do
        
        if v.path  == path then
            return v
        end

    end
    return nil
end

--
--返回查找到的第一个windowType的窗口
--
function WindowManager:Find(windowType)
    if self.mWindowStack == nil then
        return nil
    end

    for i,v in ipairs(self.mWindowStack.items) do
     
        if v.windowType == windowType then
            return v
        end
    end

    for i,v in ipairs(self.mWidgetList) do
        
        if v.windowType == windowType then
            return v
        end

    end

    return nil
end

function WindowManager:SetLayer(window)

    if window then

        if window.depth ~= nil then
            --可以在界面构造函数中设置depth
            window.panel.depth = window.depth

        else
            if self.mWindowStack:Count() > 0 then

                local  top = self.mWindowStack:Peek()

                window.panel.depth = top.panel.depth + 50

            else 
                window.panel.depth = 100
            end
        end
    end
end

function WindowManager:Close(t)

    local windowType = t.windowType

    if windowType == WindowType.Widget then
        
        for i,v in ipairs(self.mWidgetList) do
            if v.path == t.path or v == t then
                table.remove( self.mWidgetList, i )
                break
            end
        end

        t:OnExit()
      
    else

        if self.mWindowStack == nil then
            return
        end

        if self.mWindowStack:Count() > 0 then

            self:SetTouchable(false)

            local window = self.mWindowStack:Pop()

            --主界面不关闭
            if window and window.windowType ~= WindowType.Root then 
                window:OnExit()
            end 

            if self.mWindowStack:Count() > 0 then
                window = self.mWindowStack:Peek()
                --显示栈顶窗口
                if window and window.isPause then
                    window:OnResume()
                end
            end

            self:SetTouchable(true)
        end
    end
end

-- <summary>
-- 暂停所有窗口
-- </summary>
function WindowManager:Hide()

    for i,v in ipairs(self.mWindowStack.items) do
        if v.isPause == false then
        
            v:OnPause()
        end
    end


    for i,v in ipairs(self.mWidgetList) do
        v:OnPause()
    end
end

-- <summary>
-- 显示栈顶的窗口
-- </summary>
function WindowManager:Show()

   if self.mWindowStack:Count() > 0 then
    
        local window = self.mWindowStack:Pop()
        if window  then

           
            --弹出类型
            if window.windowType == WindowType.Pop then

                local stack = Stack.new()

                while ( self.mWindowStack:Count() > 0)
                do
                    local w = self.mWindowStack:Peek()
                    if w.windowType ~= WindowType.Pop then
                        w:OnResume()
                        break
                    else
                        w = self.mWindowStack:Pop()
                        w:OnResume()
                        stack:Push(w)
                    end
                
                end
   
                while (stack:Count() > 0)
                do
                    self.mWindowStack:Push(stack:Pop())
                end

            end
            
            self.mWindowStack:Push(window)
            if window.isPause then
                window:OnResume()
            end
        end
    end

    for i,v in ipairs(self.mWidgetList) do
        v:OnResume()
    end
end

function WindowManager:CloseAll()

    if self.mWindowStack ~= nil then
        
        while( self.mWindowStack:Count() > 0)
        do
            local window =  self.mWindowStack:Pop()
    
            if window then
            
                window:OnExit()
            end
        end
    
        self.mWindowStack:Clear()
    end

    if self.mWidgetList then 
        for i,v in ipairs(self.mWidgetList) do
            v:OnExit()
        end
    end
    self.mWidgetList = {}
end

function WindowManager:SetBlur()

    if self.mWindowStack == nil then
        return 
    end

    if self.mWindowStack:Count() > 0 then
    
        local w = self.mWindowStack:Pop()
        NGUITools.SetLayer(w.gameObject,  self.uiLayer)

        if self.mWindowStack:Count() > 0 then
        
            local b = self.mWindowStack:Peek()
            NGUITools.SetLayer(b.gameObject,  self.blurLayer)
        end

        self.mWindowStack:Push(w)
    end
    self.blurEffect.enabled = self.mWindowStack:Count() > 1
    
    if Camera.main then 
        local blurEffect = Camera.main:GetComponent(typeof(BlurEffect))
        if blurEffect == nil then blurEffect = Camera.main.gameObject:AddComponent(typeof(BlurEffect)) end

        blurEffect.enabled = self.blurEffect.enabled
    end
end
