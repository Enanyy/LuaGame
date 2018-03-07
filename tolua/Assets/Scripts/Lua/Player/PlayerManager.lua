require("Class")
require("PlayerInfo")
require("PlayerCharacter")
require("SmoothFollow")
require("PlayerInput")
require("UnityClass")
require("UnityLayer")


PlayerManager = Class(BehaviourBase).new()

--初始化函数
function  PlayerManager:Initialize()

     --确保只被初始化一次
    if  self.initialized  == nil or self.initialized == false then
    
        self.initialized = true
        local go = GameObject('PlayerManager')     
        GameObject.DontDestroyOnLoad(go)

        local behaviour = go:AddComponent(typeof(LuaBehaviour))  
        behaviour:Init(self)
        self:Init(behaviour)

        self.mPlayerCharacterList = {}           --人物列表

    end

    return self
end

function  PlayerManager:CreatePlayerCharacter(varGuid,  varPlayerInfo, varCallback)
    
        local layer = UnityLayer.Player
    
		local go =  GameObject (tostring(varGuid))
        NGUITools.SetLayer(go, layer)
      
        Helper.SetParent(go, self.transform)   
        Helper.SetLocalPosition(go, 0, 0, 0)
        Helper.SetLocalRotation(go, 0, 0 , 0, 0)
        Helper.SetScale(go, 1, 1, 1)

        local behaviour = go:AddComponent(typeof(LuaBehaviour))
        local tmpPlayerCharacter = PlayerCharacter.new()

        behaviour:Init(tmpPlayerCharacter)
        tmpPlayerCharacter:Init(behaviour)

		tmpPlayerCharacter:CreatePlayerCharacter (varGuid, varPlayerInfo, function()

            if varGuid == 0 then
                local camera = GameObject("MainCamera")
                GameObject.DontDestroyOnLoad(camera)
                camera.tag = "MainCamera"
                self.mCamera = camera:AddComponent(typeof(Camera))
                self.mCamera.depth = 0

                self.mSmoothFollow = SmoothFollow.new()
                self.mSmoothFollow.target = tmpPlayerCharacter.gameObject
               
                self.mSmoothFollow.distance =3
                self.mSmoothFollow.height = 12
                self.mSmoothFollow.rotation = Vector3.New(76,0,0)

                local behaviour = camera:AddComponent(typeof(LuaBehaviour))
                behaviour:Init(self.mSmoothFollow)
                self.mSmoothFollow:Init(behaviour)

                self.mCamera.cullingMask = UnityLayer.MakeMask( UnityLayer.Default, layer)
                NGUITools.SetLayer(camera, UnityLayer.Default)

              
                --输入控制
                self.mPlayerInput = PlayerInput.new(tmpPlayerCharacter,self.mCamera)
            end
		

			if varCallback ~= nil then

				varCallback (tmpPlayerCharacter)

            end
        end)

        local tmpFlag, tmpHit = NavMesh.SamplePosition(varPlayerInfo.position, nil, 10, NavMesh.AllAreas)
        if tmpFlag then
            
            Helper.SetPosition(go,tmpHit.position.x, tmpHit.position.y, tmpHit.position.z)
        end
     
        Helper.SetRotation(go, varPlayerInfo.direction.x, varPlayerInfo.direction.y, varPlayerInfo.direction.z)

        table.insert( self.mPlayerCharacterList, tmpPlayerCharacter )
       
        print(self:Count())
       
end


function PlayerManager:Update()

    if self.mPlayerCharacterList then

        for i,v in ipairs(self.mPlayerCharacterList) do

            v:Update()
        end

    end

    if self.mPlayerInput then
        self.mPlayerInput:Update()
    end
end

function PlayerManager:GetPlayerCharacter(varGuid)

    if self.mPlayerCharacterList then

       for i,v in ipairs(self.mPlayerCharacterList) do
            if v.mGuid == varGuid then

                return v

            end
       end

    end

    return nil
end

function PlayerManager:RemovePlayerCharacter(varGuid)
    
    local list = {}
    if self.mPlayerCharacterList then

        for i,v in ipairs(self.mPlayerCharacterList) do
            
            if v.mGuid == varGuid then

                table.insert( list, v)

                table.remove( self.mPlayerCharacterList, i )

                break

            end

        end

    end

    for i,v in ipairs(list) do

        if v then
            local current = v.mSkillMachine:GetCurrentState()
            if current ~= nil then
                current:OnExit()
            end

            v.mEffectMachine:Clear()

            GameObject.Destroy(v.gameObject) 
        end
    end
end

--遍历mPlayerCharacterList, func返回true跳出遍历
function PlayerManager:Foreach(func)

    if func == nil then return end

    if self.mPlayerCharacterList then
        for i,v in ipairs(self.mPlayerCharacterList) do
           
            if func(v) then
                return 
            end
        end
    end
end

function PlayerManager:Count()
    
    if self.mPlayerCharacterList then
        return table.getn(self.mPlayerCharacterList)
    end

    return 0
end