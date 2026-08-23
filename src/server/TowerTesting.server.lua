local tower = workspace.Tower
local mobs = workspace.Mobs

local function FindNearestTarget()
	local maxDistance = 50
	local nearestTarget = nil

	for i, target in ipairs(mobs:GetChildren()) do
		local distance = (target.HumanoidRootPart:GetPivot().Position - tower:GetPivot().Position).Magnitude
		print(target.Name, distance)
		if distance < maxDistance then
			print(target.Name, "is the nearest target found so far")
			nearestTarget = target
			maxDistance = distance
		end
	end

	return nearestTarget
end

while true do
	local target = FindNearestTarget()
	if target then
		target.Humanoid:TakeDamage(25)
	end

	task.wait(1)
end
