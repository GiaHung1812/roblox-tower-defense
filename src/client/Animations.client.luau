local function setAnimation(object, animName)
	local humanoid = object:WaitForChild("Humanoid")
	local animationsFolder = object:WaitForChild("Animations")
	if humanoid and animationsFolder then
		local animationObject = animationsFolder:WaitForChild(animName)
		if animationObject then
			local animator = humanoid:FindFirstChild("Animator") or Instance.new("Animator", humanoid)
			local animationTrack = animator:LoadAnimation(animationObject)
			return animationTrack
		end
	end
end

local function playAnimation(object, animName)
	local animationTrack = setAnimation(object, animName)
	if animationTrack then
		animationTrack:Play()
	else
		warn("Animation track does not exists")
		return
	end
end

workspace.Mobs.ChildAdded:Connect(function(object)
	playAnimation(object, "Walk")
end)

workspace.Towers.ChildAdded:Connect(function(object)
	playAnimation(object, "Idle")
end)
