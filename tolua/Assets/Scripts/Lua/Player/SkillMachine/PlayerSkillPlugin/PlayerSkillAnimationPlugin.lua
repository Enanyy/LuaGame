require("PlayerSkillPlugin")
require("UnityClass")



PlayerSkillAnimationPlugin = Class(PlayerSkillPlugin)

function PlayerSkillAnimationPlugin:ctor(name)
    
    self.mDone = false
    self.mAnimation = nil
    self.mAnimationClip = ""
end

function PlayerSkillAnimationPlugin:InitWithConfig(configure)

    if configure == nil then return end

    self.mAnimationClip = configure.animationClip
    self.mLoop = configure.loop

    local tmpPlayerCharacter = self.machine.mPlayerCharacter

    if tmpPlayerCharacter.mFashionBody then
        self.mAnimation = tmpPlayerCharacter.mFashionBody.transform:GetComponentInChildren(typeof(Animation))

    end

end

function PlayerSkillAnimationPlugin:OnEnter()
    
    self.mDone = false
    self:GetAnimationState()

    if self.mAnimationState == nil then
        print("mAnimationState = nil")
    end

    self:PlayAnimation()

end

function PlayerSkillAnimationPlugin:OnExecute()
          
    self:PlayAnimation()

end

function PlayerSkillAnimationPlugin:OnExit()
    if self.mPlayerSkillState then
        --print(self.mPlayerSkillState.name .. " time = "..self.mAnimationState.time .." length = "..self.mAnimationState.length .." runtime =" .. self.mPlayerSkillState.mRunTime.." speed ="..self.mAnimationState.speed)
    end
end

function PlayerSkillAnimationPlugin:OnPause()
      
    if self.mAnimationState then
        
        self.mAnimationState.speed = 0

     end
end

function PlayerSkillAnimationPlugin:OnResume()
    
    if  self.mAnimationState then
        
        self.mAnimationState.speed = self.mPlayerSkillState.mSpeed
   
    end
end

function PlayerSkillAnimationPlugin:PlayAnimation()

    if self.mAnimationState == nil then
        return 
    end


    self.mAnimationState.speed = self.mPlayerSkillState.mSpeed
  
    if self.mDone then
        if self.mAnimation:IsPlaying(self.mAnimationClip) == false then
            self.mAnimation:Play(self.mAnimationClip)
        end
        return

    end

    if self.mLoop then
        self.mAnimation.wrapMode =  WrapMode.Loop 
    else
        self.mAnimation.wrapMode = WrapMode.Default
    end
 
        
    if  self.mPlayerSkillState.mFadeLength > 0 then

        self.mAnimation:CrossFade(self.mAnimationClip, self.mPlayerSkillState.mFadeLength)
        
    else
        
        if self.mAnimationState then
            self.mAnimationState.time = self.mPlayerSkillState.mRunTime
        end
        self.mAnimation:Play(self.mAnimationClip)
    end
    self.mDone = true

    --print("PlayerSkillAnimationPlugin:PlayAnimation FadeLength ="..self.mPlayerSkillState.mFadeLength..","..self.mAnimationClip .." Done")

end

function PlayerSkillAnimationPlugin:GetAnimationState()
    
    if self.mAnimation == nil then
        return 
    end

   
    local it = self.mAnimation:GetEnumerator()
    while (it:MoveNext())
    do
        if it.Current.name == self.mAnimationClip then
           
            self.mAnimationState =  it.Current
            
            break
        end
    end
end