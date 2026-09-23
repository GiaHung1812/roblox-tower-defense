local ReplicatedStorage = game:GetService("ReplicatedStorage")

local shared = ReplicatedStorage:WaitForChild("Shared")
local events = shared:WaitForChild("Events")
local spawnTowerEvent = events:WaitForChild("SpawnTower")
local animateTowerEvent = events:WaitForChild("AnimateTower")
local towers = shared:WaitForChild("Towers")
local tower = {}

local function FindNearestTarget(newTower)
	local maxDistance = 20
	local nearestTarget = nil

	for _, target in ipairs(workspace.Mobs:GetChildren()) do
		local humanoid = target:FindFirstChild("Humanoid")
		local rootPart = target:FindFirstChild("HumanoidRootPart")
		if humanoid and rootPart and humanoid.Health > 0 then
			local distance = (rootPart.Position - newTower:GetPivot().Position).Magnitude
			if distance < maxDistance then
				nearestTarget = target
				maxDistance = distance
			end
		end
	end

	return nearestTarget
end
function tower.Attack(newTower)
	while newTower.Parent do
		local target = FindNearestTarget(newTower)
		if target and target:FindFirstChild("Humanoid") and target.Humanoid.Health > 0 then
			local targetCFrame = CFrame.lookAt(newTower.HumanoidRootPart.Position, target.HumanoidRootPart.Position)
			newTower.HumanoidRootPart.BodyGyro.CFrame = targetCFrame

			animateTowerEvent:FireAllClients(newTower, "Attack")
			target.Humanoid:TakeDamage(25)
		end

		task.wait(1)
	end
end

function tower.Spawn(player, name, cframe)
	local towerExists = towers:FindFirstChild(name)

	if towerExists then
		local newTower = towerExists:Clone()
		newTower.HumanoidRootPart.CFrame = cframe
		newTower.Parent = workspace.Towers
		newTower.HumanoidRootPart:SetNetworkOwner(nil)

		local bodyGyro = Instance.new("BodyGyro")
		bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
		bodyGyro.D = 0
		bodyGyro.CFrame = newTower.HumanoidRootPart.CFrame
		bodyGyro.Parent = newTower.HumanoidRootPart

		for i, object in ipairs(newTower:GetDescendants()) do
			if object:IsA("BasePart") then
				object.CollisionGroup = "Tower"
			end
		end
		task.spawn(tower.Attack, newTower)
	else
		warn("Requested tower does not exist:", name)
	end
end

spawnTowerEvent.OnServerEvent:Connect(tower.Spawn)

return tower
