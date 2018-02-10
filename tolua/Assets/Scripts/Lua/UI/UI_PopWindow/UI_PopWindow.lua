require("Class")
require("BaseWindow")

--UI_PopWindow继承于BaseWindow
UI_PopWindow = Class(BaseWindow)
local this = UI_PopWindow

function this:ctor(behaviour, path)
    self.path  = path
    self.windowType = 2 --弹出行界面

    self.base = BaseWindow.new(behaviour, self.path, self.windowType)


end

function this:Awake()
    -- body
    print(self.behaviour.name..".Awake ")
end 

function this:Start()

    print(self.behaviour.name..".Start ")

    local mainWindow = self.transform:Find("MainWindow")

    self.behaviour:AddClick(mainWindow.gameObject, function() 
        print("Click MainWindow")
        WindowManager:Open(UI_Main,"UI_Main")
    end)

    local dialog = self.transform:Find("Dialog")
    self.behaviour:AddClick(dialog.gameObject, function() 
        print("Click Dialog")        
        WindowManager:Open(UI_Dialog,"UI_Dialog")
    end)

    local close = self.transform:Find("Close")
    self.behaviour:AddClick(close.gameObject, function() 
        print("Click Close")        
       self:Close()
    end)
   
end

function this:OnEnter()
    if self.base then
        self.base:OnEnter()
    end
end

function this:OnPause()
    self.isPause = true
    
    if self.base then
        self.base:OnPause()
    end
end

function this:OnResume()
    self.isPause = false
    if self.base then
        self.base:OnResume()
    end
end

function this:OnExit()
    if self.base then
        self.base:OnExit()
    end
end
