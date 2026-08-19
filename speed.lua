-- Create a new RemoteEvent named "SpeedUp"
local speedUpEvent = Instance.new("RemoteEvent")
speedUpEvent.Name = "SpeedUp"
speedUpEvent.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Script to handle speed boost
local speedBoost = function(player)
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    
    -- Increase walk speed (adjust value as needed)
    humanoid.WalkSpeed = 200
    
    -- Optional: Add visual effects
    local speedEffect = Instance.new("ParticleEmitter")
    speedEffect.Texture = "rbxassetid://15467382" -- Replace with your particle texture ID
    speedEffect.Speed = NumberRange.new(5, 10)
    speedEffect.Rate = 100
    speedEffect.Lifetime = NumberRange.new(0.1, 0.2)
    speedEffect.Color = ColorSequence.new(Color3.fromRGB(255, 255, 0)) -- Yellow color
    speedEffect.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.5), NumberSequenceKeypoint.new(1, 0)})
    speedEffect:Emit(100)
end

-- Bind the event to the speedBoost function
speedUpEvent.OnServerEvent:Connect(speedBoost)

-- Optional: Add UI button to trigger the speed boost
local button = Instance.new("TextButton")
button.Text = "Speed Boost"
button.Size = UDim2.new(0, 100, 0, 40)
button.Position = UDim2.new(0, 10, 0, 10)
button.BackgroundColor3 = Color3.fromRGB(255, 255, 0) -- Yellow background
button.TextColor3 = Color3.fromRGB(0, 0, 0) -- Black text
button.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui").ScreenGui

button.MouseButton1Click:Connect(function()
    speedUpEvent:FireServer(game.Players.LocalPlayer)
end)
