local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

--==================================================
-- CONFIG
--==================================================

local DEFAULT_WALKSPEED = 16
local DEFAULT_JUMPPOWER = 50

local speedEnabled = false
local jumpEnabled = false

--==================================================
-- GUI
--==================================================

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MovementTestGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.fromOffset(300, 210)
mainFrame.Position = UDim2.fromOffset(20, 20)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
title.Text = "Movement Test"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 17
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = title

--==================================================
-- SPEED
--==================================================

local speedToggle = Instance.new("TextButton")
speedToggle.Size = UDim2.fromOffset(125, 35)
speedToggle.Position = UDim2.fromOffset(15, 60)
speedToggle.BackgroundColor3 = Color3.fromRGB(65, 65, 72)
speedToggle.Text = "Speed: OFF"
speedToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
speedToggle.Font = Enum.Font.GothamMedium
speedToggle.TextSize = 14
speedToggle.Parent = mainFrame

local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 6)
speedCorner.Parent = speedToggle

local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.fromOffset(125, 35)
speedBox.Position = UDim2.fromOffset(160, 60)
speedBox.BackgroundColor3 = Color3.fromRGB(50, 50, 57)
speedBox.Text = "100"
speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBox.PlaceholderText = "WalkSpeed"
speedBox.ClearTextOnFocus = false
speedBox.Font = Enum.Font.Gotham
speedBox.TextSize = 14
speedBox.Parent = mainFrame

local speedBoxCorner = Instance.new("UICorner")
speedBoxCorner.CornerRadius = UDim.new(0, 6)
speedBoxCorner.Parent = speedBox

--==================================================
-- JUMP
--==================================================

local jumpToggle = Instance.new("TextButton")
jumpToggle.Size = UDim2.fromOffset(125, 35)
jumpToggle.Position = UDim2.fromOffset(15, 110)
jumpToggle.BackgroundColor3 = Color3.fromRGB(65, 65, 72)
jumpToggle.Text = "Jump: OFF"
jumpToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpToggle.Font = Enum.Font.GothamMedium
jumpToggle.TextSize = 14
jumpToggle.Parent = mainFrame

local jumpCorner = Instance.new("UICorner")
jumpCorner.CornerRadius = UDim.new(0, 6)
jumpCorner.Parent = jumpToggle

local jumpBox = Instance.new("TextBox")
jumpBox.Size = UDim2.fromOffset(125, 35)
jumpBox.Position = UDim2.fromOffset(160, 110)
jumpBox.BackgroundColor3 = Color3.fromRGB(50, 50, 57)
jumpBox.Text = "100"
jumpBox.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpBox.PlaceholderText = "JumpPower"
jumpBox.ClearTextOnFocus = false
jumpBox.Font = Enum.Font.Gotham
jumpBox.TextSize = 14
jumpBox.Parent = mainFrame

local jumpBoxCorner = Instance.new("UICorner")
jumpBoxCorner.CornerRadius = UDim.new(0, 6)
jumpBoxCorner.Parent = jumpBox

-- Status
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -30, 0, 30)
status.Position = UDim2.fromOffset(15, 160)
status.BackgroundTransparency = 1
status.Text = "Ready"
status.TextColor3 = Color3.fromRGB(180, 180, 180)
status.Font = Enum.Font.Gotham
status.TextSize = 13
status.Parent = mainFrame

--==================================================
-- HELPERS
--==================================================

local function getNumber(text, fallback)
	local value = tonumber(text)

	if value == nil then
		return fallback
	end

	return value
end

local function updateMovement()
	if not humanoid or humanoid.Parent == nil then
		return
	end

	if speedEnabled then
		humanoid.WalkSpeed =
			getNumber(speedBox.Text, DEFAULT_WALKSPEED)
	else
		humanoid.WalkSpeed = DEFAULT_WALKSPEED
	end

	if jumpEnabled then
		humanoid.JumpPower =
			getNumber(jumpBox.Text, DEFAULT_JUMPPOWER)
	else
		humanoid.JumpPower = DEFAULT_JUMPPOWER
	end
end

local function updateStatus()
	local speedText = speedEnabled and "Speed ON" or "Speed OFF"
	local jumpText = jumpEnabled and "Jump ON" or "Jump OFF"

	status.Text = speedText .. "  •  " .. jumpText
end

--==================================================
-- BUTTONS
--==================================================

speedToggle.MouseButton1Click:Connect(function()
	speedEnabled = not speedEnabled

	if speedEnabled then
		speedToggle.Text = "Speed: ON"
		speedToggle.BackgroundColor3 = Color3.fromRGB(0, 150, 80)
	else
		speedToggle.Text = "Speed: OFF"
		speedToggle.BackgroundColor3 = Color3.fromRGB(65, 65, 72)
	end

	updateMovement()
	updateStatus()
end)

jumpToggle.MouseButton1Click:Connect(function()
	jumpEnabled = not jumpEnabled

	if jumpEnabled then
		jumpToggle.Text = "Jump: ON"
		jumpToggle.BackgroundColor3 = Color3.fromRGB(0, 150, 80)
	else
		jumpToggle.Text = "Jump: OFF"
		jumpToggle.BackgroundColor3 = Color3.fromRGB(65, 65, 72)
	end

	updateMovement()
	updateStatus()
end)

--==================================================
-- INPUT
--==================================================

speedBox.FocusLost:Connect(function()
	if speedEnabled then
		updateMovement()
	end
end)

jumpBox.FocusLost:Connect(function()
	if jumpEnabled then
		updateMovement()
	end
end)

--==================================================
-- RESPAWN HANDLING
--==================================================

player.CharacterAdded:Connect(function(newCharacter)
	character = newCharacter
	humanoid = newCharacter:WaitForChild("Humanoid")

	task.wait(0.2)

	updateMovement()
end)

print("Movement Test GUI loaded successfully.")
