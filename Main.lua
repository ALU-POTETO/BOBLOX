local Players = game:GetService("Players")  
local UIS = game:GetService("UserInputService")  
local player = Players.LocalPlayer  
local character = player.Character or player.CharacterAdded:Wait()  
local humanoid = character:WaitForChild("Humanoid")

-- Create the GUI  
local screenGui = Instance.new("ScreenGui")  
screenGui.Parent = player.PlayerGui  
screenGui.Name = "ExploitGUI"

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
title.Parent = mainFrame

-- Speed toggle  
local speedToggle = Instance.new("TextButton")  
speedToggle.Size = UDim2.new(0.9, 0, 0, 30)  
speedToggle.Position = UDim2.new(0.05, 0, 0.2, 0)  
speedToggle.Text = "Speed: OFF"  
speedToggle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)  
speedToggle.TextColor3 = Color3.fromRGB(255, 255, 255)  
speedToggle.Parent = mainFrame

-- Speed slider  
local speedSlider = Instance.new("SliderLabel") -- You might need to adjust based on executor's available instances  
-- Let's make a simpler version: a text box for input  
local speedBox = Instance.new("TextBox")  
speedBox.Size = UDim2.new(0.4, 0, 0, 25)  
speedBox.Position = UDim2.new(0.55, 0, 0.2, 0)  
speedBox.Text = "100"  
speedBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)  
speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)  
speedBox.Parent = mainFrame

-- Jump toggle  
local jumpToggle = Instance.new("TextButton")  
jumpToggle.Size = UDim2.new(0.9, 0, 0, 30)  
jumpToggle.Position = UDim2.new(0.05, 0, 0.45, 0)  
jumpToggle.Text = "Jump: OFF"  
jumpToggle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)  
jumpToggle.TextColor3 = Color3.fromRGB(255, 255, 255)  
jumpToggle.Parent = mainFrame

-- Jump power box  
local jumpBox = Instance.new("TextBox")  
jumpBox.Size = UDim2.new(0.4, 0, 0, 25)  
jumpBox.Position = UDim2.new(0.55, 0, 0.45, 0)  
jumpBox.Text = "100"  
jumpBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)  
jumpBox.TextColor3 = Color3.fromRGB(255, 255, 255)  
jumpBox.Parent = mainFrame

-- Variables  
local speedEnabled = false  
local jumpEnabled = false  
local normalSpeed = 16  
local normalJump = 50

-- Speed toggle function  
speedToggle.MouseButton1Click:Connect(function()  
speedEnabled = not speedEnabled  
humanoid.WalkSpeed = speedEnabled and tonumber(speedBox.Text) or normalSpeed  
speedToggle.Text = speedEnabled and "Speed: ON" or "Speed: OFF"  
speedToggle.BackgroundColor3 = speedEnabled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(80, 80, 80)  
end)

-- Jump toggle function  
jumpToggle.MouseButton1Click:Connect(function()  
jumpEnabled = not jumpEnabled  
humanoid.JumpPower = jumpEnabled and tonumber(jumpBox.Text) or normalJump  
jumpToggle.Text = jumpEnabled and "Jump: ON" or "Jump: OFF"  
jumpToggle.BackgroundColor3 = jumpEnabled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(80, 80, 80)  
end)

-- Update values when text changes  
speedBox.FocusLost:Connect(function()  
if speedEnabled then  
humanoid.WalkSpeed = tonumber(speedBox.Text) or 100  
end  
end)

jumpBox.FocusLost:Connect(function()  
if jumpEnabled then  
humanoid.JumpPower = tonumber(jumpBox.Text) or 100  
end  
end)

-- Handle respawns  
player.CharacterAdded:Connect(function(newChar)  
character = newChar  
humanoid = character:WaitForChild("Humanoid")  
if speedEnabled then humanoid.WalkSpeed = tonumber(speedBox.Text) end  
if jumpEnabled then humanoid.JumpPower = tonumber(jumpBox.Text) end  
end)

print("GUI loaded! Check top-left corner.")  
