local towers = workspace.Towers
local mobs = workspace.Mobs

local function FindNearestTarget(tower)
	local maxDistance = 50
	local nearestTarget = nil

	for _, target in ipairs(mobs:GetChildren()) do
		local humanoid = target:FindFirstChild("Humanoid")
		local rootPart = target:FindFirstChild("HumanoidRootPart")

		if humanoid and rootPart and humanoid.Health > 0 then
			local distance = (rootPart.Position - tower:GetPivot().Position).Magnitude

			if distance < maxDistance then
				nearestTarget = target
				maxDistance = distance
			end
		end
	end

	return nearestTarget
end

while task.wait(1) do
	for _, tower in ipairs(towers:GetChildren()) do
		local target = FindNearestTarget(tower)

		if target then
			target.Humanoid:TakeDamage(25)
		end
	end
end
