local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PhysicsService = game:GetService("PhysicsService")
local ServerStorage = game:GetService("ServerStorage")

local shared = ReplicatedStorage:WaitForChild("Shared")
local events = shared:WaitForChild("Events")
local spawnTowerEvent = events:WaitForChild("SpawnTower")
local towers = shared:WaitForChild("Towers")
local tower = {}

function tower.Spawn(player, name, cframe)
	local towerExists = towers:FindFirstChild(name)

	if towerExists then
		local newTower = towerExists:Clone()
		newTower.HumanoidRootPart.CFrame = cframe
		newTower.Parent = workspace.Towers
		newTower.HumanoidRootPart:SetNetworkOwner(nil)

		for i, object in ipairs(newTower:GetDescendants()) do
			if object:IsA("BasePart") then
				object.CollisionGroup = "Tower"
			end
		end
	else
		warn("Requested tower does not exist:", name)
	end
end

spawnTowerEvent.OnServerEvent:Connect(tower.Spawn)

return tower
