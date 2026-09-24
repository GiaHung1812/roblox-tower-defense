local ServerStorage = game:GetService("ServerStorage")

local bindables = ServerStorage:WaitForChild("Bindables")
local gameOverEvent = bindables:WaitForChild("GameOver")

local base = require(script.Parent.Modules.Base)
local mob = require(script.Parent.Modules.Mob)
local tower = require(script.Parent.Modules.Tower)
local map = workspace.Grassland

local gameOver = false

base.Setup(workspace:WaitForChild("Base"), 500)

gameOverEvent.Event:Connect(function()
	gameOver = true
end)

for wave = 1, 10 do
	print("WAVE STARTING", wave)
	if wave <= 2 then
		mob.Spawn("Zombie", 3 * wave, map)
	elseif wave <= 4 then
		for i = 1, 5 do
			mob.Spawn("Zombie", wave, map)
			mob.Spawn("Noob", wave, map)
		end
	elseif wave <= 7 then
		for i = 1, 5 do
			mob.Spawn("Zombie", wave, map)
			mob.Spawn("Noob", wave, map)
			mob.Spawn("Mech", 2 * (wave * 0.5), map)
		end
	elseif wave <= 9 then
		mob.Spawn("Mech", 2 * wave, map)
		mob.Spawn("Noob", wave, map)
		for i = 1, 5 do
			mob.Spawn("Zombie", (wave * 0.5), map)
			mob.Spawn("Mech", (wave * 0.5), map)
		end
		mob.Spawn("Teddy", 1, map)
	elseif wave == 10 then
		mob.Spawn("Zombie", 100, map)
		for i = 1, 5 do
			mob.Spawn("Mech", 5, map)
			mob.Spawn("Teddy", 1, map)
			mob.Spawn("Zombie", 2, map)
		end
		mob.Spawn("Teddy", 10, map)
	end

	repeat
		task.wait(1)
	until #workspace.Mobs:GetChildren() == 0 or gameOver

	if gameOver then
		print("GAME OVER")
	end

	print("WAVE ENDED")
	task.wait(1)
end
