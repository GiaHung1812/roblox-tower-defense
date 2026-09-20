local PhysicsService = game:GetService("PhysicsService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local towers = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Towers")
local events = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Events")
local spawnTowerEvent = events:WaitForChild("SpawnTower")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local gameGui = playerGui:WaitForChild("GameGui")
local gui = gameGui:WaitForChild("Spawn")
local camera = workspace.CurrentCamera

local towerToSpawn = nil
local canPlace = false
local rotation = 0

local function MouseRaycast(exclude)
	local MousePosition = UserInputService:GetMouseLocation()
	local mouseRay = camera:ViewportPointToRay(MousePosition.X, MousePosition.Y)

	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = { exclude }

	local raycastResult = workspace:Raycast(mouseRay.Origin, mouseRay.Direction * 1000, raycastParams)

	return raycastResult
end

local function RemovePlaceholderTowe()
	if towerToSpawn then
		towerToSpawn:Destroy()
		towerToSpawn = nil
		rotation = 0
	end
end
local function AddPlaceholderTower(name)
	local towerExists = towers:FindFirstChild(name)
	local towerFolder = workspace:FindFirstChild("Towers")
	if towerExists and towerFolder then
		RemovePlaceholderTowe()
		towerToSpawn = towerExists:Clone()
		towerToSpawn.Parent = towerFolder
		towerToSpawn.PrimaryPart = towerToSpawn.PrimaryPart or towerToSpawn:FindFirstChildWhichIsA("BasePart", true)

		for _, object in ipairs(towerToSpawn:GetDescendants()) do
			if object:IsA("BasePart") then
				object.CollisionGroup = "Tower"
				object.Material = Enum.Material.ForceField
			end
		end
	end
end

local function ColorPlaceHolderTower(color)
	for _, object in ipairs(towerToSpawn:GetDescendants()) do
		if object:IsA("BasePart") then
			object.Color = color
		end
	end
end

gui.Activated:Connect(function()
	AddPlaceholderTower("Slinger")
end)

UserInputService.InputBegan:Connect(function(input, processed)
	if processed then
		return
	end

	if towerToSpawn then
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			if canPlace then
				spawnTowerEvent:FireServer(towerToSpawn.Name, towerToSpawn.PrimaryPart.CFrame)
				RemovePlaceholderTowe()
			end
		elseif input.KeyCode == Enum.KeyCode.R then
			rotation += 90
		end
	end
end)

RunService.RenderStepped:Connect(function()
	if towerToSpawn then
		local result = MouseRaycast(towerToSpawn)
		if result and result.Instance and towerToSpawn.PrimaryPart then
			if result.Instance.Parent.Name == "TowerArea" then
				canPlace = true
				ColorPlaceHolderTower(Color3.new(0, 1, 0))
			else
				canPlace = false
				ColorPlaceHolderTower(Color3.new(1, 0, 0))
			end
			local x = result.Position.X
			local y = result.Position.Y + towerToSpawn.Humanoid.HipHeight + (towerToSpawn.PrimaryPart.Size.Y / 2)
			local z = result.Position.Z

			local cframe = CFrame.new(x, y, z) * CFrame.Angles(0, math.rad(rotation), 0)
			towerToSpawn:SetPrimaryPartCFrame(cframe)
		end
	end
end)
