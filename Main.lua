```lua
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Settings
local normalSpeed = 16
local normalJump = 50

local speedEnabled = false
local jumpEnabled = false

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MovementTestGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Main frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 180)
mainFrame.Position = UDim2.new(0, 20, 0, 20)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Movement Controls"
title.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = mainFrame

-- Speed toggle
local speedToggle = Instance.new("TextButton")
speedToggle.Size = UDim2.new(0.45, 0, 0, 30)
speedToggle.Position = UDim2.new(0.05, 0, 0.2, 0)
speedToggle.Text = "Speed: OFF"
speedToggle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
speedToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
speedToggle.Parent = mainFrame

-- Speed input
local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0.4, 0, 0, 25)
speedBox.Position = UDim2.new(0.55, 0, 0.2, 0)
speedBox.Text = "100"
speedBox.PlaceholderText = "Speed"
speedBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBox.ClearTextOnFocus = false
speedBox.Parent = mainFrame

-- Jump toggle
local jumpToggle = Instance.new("TextButton")
jumpToggle.Size = UDim2.new(0.45, 0, 0, 30)
jumpToggle.Position = UDim2.new(0.05, 0, 0.45, 0)
jumpToggle.Text = "Jump: OFF"
jumpToggle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
jumpToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpToggle.Parent = mainFrame

-- Jump input
local jumpBox = Instance.new("TextBox")
jumpBox.Size = UDim2.new(0.4, 0, 0, 25)
jumpBox.Position = UDim2.new(0.55, 0, 0.45, 0)
jumpBox.Text = "100"
jumpBox.PlaceholderText = "Jump Power"
jumpBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
jumpBox.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpBox.ClearTextOnFocus = false
jumpBox.Parent = mainFrame

-- Helper function
local function getNumber(text, fallback)
	local number = tonumber(text)

	if number then
		return number
	end

	return fallback
end

-- Apply current settings to humanoid
local function updateMovement()
	if not humanoid then
		return
	end

	if speedEnabled then
		humanoid.WalkSpeed = getNumber(speedBox.Text, normalSpeed)
	else
		humanoid.WalkSpeed = normalSpeed
	end

	if jumpEnabled then
		humanoid.JumpPower = getNumber(jumpBox.Text, normalJump)
	else
		humanoid.JumpPower = normalJump
	end
end

-- Speed toggle
speedToggle.MouseButton1Click:Connect(function()
	speedEnabled = not speedEnabled

	speedToggle.Text = speedEnabled and "Speed: ON" or "Speed: OFF"

	speedToggle.BackgroundColor3 =
		speedEnabled
		and Color3.fromRGB(0, 170, 0)
		or Color3.fromRGB(80, 80, 80)

	updateMovement()
end)

-- Jump toggle
jumpToggle.MouseButton1Click:Connect(function()
	jumpEnabled = not jumpEnabled

	jumpToggle.Text = jumpEnabled and "Jump: ON" or "Jump: OFF"

	jumpToggle.BackgroundColor3 =
		jumpEnabled
		and Color3.fromRGB(0, 170, 0)
		or Color3.fromRGB(80, 80, 80)

	updateMovement()
end)

-- Speed value changed
speedBox.FocusLost:Connect(function()
	if speedEnabled then
		updateMovement()
	end
end)

-- Jump value changed
jumpBox.FocusLost:Connect(function()
	if jumpEnabled then
		updateMovement()
	end
end)

-- Handle respawns
player.CharacterAdded:Connect(function(newCharacter)
	character = newCharacter
	humanoid = character:WaitForChild("Humanoid")

	task.wait(0.2)

	updateMovement()
end)

print("Movement test GUI loaded!")
```
