local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local camera = workspace.CurrentCamera
local item = nil

local function MouseRaycast()
	local MousePosition = UserInputService:GetMouseLocation()
	--print(MousePosition)

	local mouseRay = camera:ViewportPointToRay(MousePosition.X, MousePosition.Y)
	--print(mouseRay)

	local raycastResult = workspace:Raycast(mouseRay.Origin, mouseRay.Direction * 1000)
	--print(raycastResult)

	return raycastResult
end

UserInputService.InputBegan:Connect(function(input, processed)
	if processed then
		return
	end

	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		if item:IsA("BasePart") then
			item.Color = Color3.new(1, 0, 0)
		end
	end
end)

RunService.RenderStepped:Connect(function()
	local result = MouseRaycast()
	if result and result.Instance then
		item = result.Instance
	end
end)
