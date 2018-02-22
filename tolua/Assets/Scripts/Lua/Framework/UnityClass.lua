


--应用System、Unity的类
Application = UnityEngine.Application
---检查当前Unity版本
function UnityVersionNewer(v)
    if v == nil then return false end

    local version = Application.unityVersion

    local mainVersion = string.sub( version, 1, 1 )
    local childVersion = string.sub(version, 3, 3 )

    local mainVersion1 = string.sub (v, 1, 1)
    local childVersion1 = string.sub(v, 3, 3)

    if tonumber(mainVersion) > tonumber(mainVersion1) then
        return true
    elseif tonumber(mainVersion) == tonumber(mainVersion1) then
        
        return tonumber(childVersion) > tonumber(childVersion1)
        
    end
    
    return false
end


GameObject = UnityEngine.GameObject
Object = UnityEngine.Object
BoxCollider = UnityEngine.BoxCollider
Camera = UnityEngine.Camera
CameraClearFlags = UnityEngine.CameraClearFlags
AudioListener = UnityEngine.AudioListener

SceneManager = UnityEngine.SceneManagement.SceneManager

if UnityVersionNewer("5.6") then

NavMesh = UnityEngine.AI.NavMesh    -- Unity5.6
NavMeshHit = UnityEngine.AI.NavMeshHit --Unity5.6
NavMeshAgent = UnityEngine.AI.NavMeshAgent  -- Unity5.6
NavMeshPathStatus =UnityEngine.AI.NavMeshPathStatus  -- Unity5.6

else

NavMesh = UnityEngine.NavMesh    
NavMeshHit = UnityEngine.NavMeshHit
NavMeshAgent = UnityEngine.NavMeshAgent
NavMeshPathStatus =UnityEngine.NavMeshPathStatus  -- Unity5.3

end
--引用UnityEngine.Time
Time = UnityEngine.Time

--Unity中的AssetBundle类
AssetBundle = UnityEngine.AssetBundle

Animation = UnityEngine.Animation
AnimationState = UnityEngine.AnimationState
WrapMode = UnityEngine.WrapMode
Screen = UnityEngine.Screen

Input = UnityEngine.Input
Physics = UnityEngine.Physics
LayerMask = UnityEngine.LayerMask
KeyCode = UnityEngine.KeyCode
--System Class
Queue = System.Collections.Queue
Stack  = System.Collections.Stack

