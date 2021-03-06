require("PlayerSkillPlugin")
require("UnityClass")
require("UnityLayer")

local LookRotation = Quaternion.LookRotation
local Lerp = Quaternion.Lerp

PlayerSkillRotationPlugin = Class("PlayerSkillRotationPlugin",PlayerSkillPlugin)

function PlayerSkillRotationPlugin:ctor(name)

    self.mDuration = 0.2

    self.mImmediately = false

    self.mGo = nil

    self.mRotation = Quaternion.New(0,0,0,0)
end


function PlayerSkillRotationPlugin:InitWithConfig(configure)

    if configure == nil then return end

    self.mDuration = configure.duration or self.mDuration
    self.mImmediately = configure.immediately or self.mImmediately

end


function PlayerSkillRotationPlugin:OnEnter()

    self.mWantedRotation = nil
    if self.mGo == nil then
        self.mGo = self.machine.mPlayerCharacter.gameObject
    end
  
end

function PlayerSkillRotationPlugin:OnExecute()

    if self.mPlayerSkillState.mTargetDirection ~= Vector3.zero then

      
        if self.mWantedRotation == nil then
            self.mWantedRotation = LookRotation (self.mPlayerSkillState.mTargetDirection)
        end

        if self.mPlayerSkillState.mRunTime <= self.mDuration and self.mImmediately == false then
            
            local factor = self.mPlayerSkillState.mRunTime / self.mDuration

            
            self.mRotation= GetRotation(self.mGo,self.mRotation)

            self.mRotation = Lerp(self.mRotation, self.mWantedRotation, factor)

            SetRotation(self.mGo, self.mRotation)
        
        else
            SetRotation(self.mGo, self.mWantedRotation)
            
        end
    end
end


function PlayerSkillRotationPlugin:OnExit()
  
    self.mWantedRotation = nil

end