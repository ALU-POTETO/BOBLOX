local Players = game:GetService("Players")  
local UserInputService = game:GetService("UserInputService")  
local Workspace = game:GetService("Workspace")  
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

--==================================================  
-- CONFIG  
--==================================================

local TOGGLE_KEY = Enum.KeyCode.F  
local SCAN_INTERVAL = той же 0.5  
local GROUP_RADIUS = 15 -- How far to group enemies  
local TWEEN_SPEED = 0.8 -- Seconds to reach target (slower = less sus)  
local ATTACK_DELAY = 0.3

--==================================================  
-- STATE  
--==================================================

local farming = false  
local farmThread = nil  
local currentTween = nil

local character  
local humanoid  
local rootPart

--==================================================  
-- CHARACTER HANDLING  
--==================================================

local function updateCharacter(newCharacter)  
character = newCharacter  
humanoid = character:WaitForChild("Humanoid", 5)  
rootPart = character:WaitForChild("HumanoidRootPart", 5)  
end

updateCharacter(player.Character or player.CharacterAdded:Wait())  
player.CharacterAdded:Connect(updateCharacter)

--==================================================  
-- UTILITIES  
--==================================================

local function getClosestNPCs(maxDistance)  
if not rootPart then return {} end  
local enemiesFolder = Workspace:FindFirstChild("Enemies")  
if not enemiesFolder then return {} end

local npcs = {}  
for _, npc in ipairs(enemiesFolder:GetChildren()) do  
local npcHumanoid = npc:FindFirstChildOfClass("Humanoid")  
local npcRoot = npc:FindFirstChild("HumanoidRootPart")  
if npcHumanoid and npcRoot and npcHumanoid.Health > 0 then  
local distance = (rootPart.Position - npcRoot.Position).Magnitude  
if distance <= maxDistance then  
table.insert(npcs, {npc = npc, distance = distance})  
end  
end  
end

-- Sort by distance  
table.sort(npcs, function(a, b) return a.distance < b.distance end)  
return npcs  
end

local function getGroupCenter(npcs)  
if #npcs == 0 then return nil end  
local total = Vector3.new(0, 0,53 0)  
for _, data in ipairs(npcs) do  
local root = data.npc:FindFirstChild("HumanoidRootPart")  
if root then  
total = total + root.Position  
end  
end  
return total / #npcs  
end

--==================================================  
-- MOVEMENT WITH TWEEN  
--==================================================

local function moveToPosition(position)  
if not rootPart or not humanoid then return end  
	  
if currentTween then  
currentTween:Cancel()  
currentTween = nil  
end  
	  
-- Create a smooth tween  
local goal = {}  
goal.CFrame = CFrame.new(position) * CFrame.new(0, 5, -3) -- Stand slightly back  
	  
currentTween = TweenService:Create(  
rootPart,  
TweenInfo.new(TWEEN_SPEED, Enum.EasingStyle.Sine),  
goal  
)  
	  
currentTween:Play()  
currentTween.Completed:Connect(function()  
currentTween = nil  
end)  
end

--==================================================  
-- ATTACK SYSTEM  
--==================================================

local function attackCluster(npcs)  
if not farming then return end  
	  
-- First, find center and move there  
local center = getGroupCenter(npcs)  
if not center then return end  
	  
moveToPosition(center)  
	  
-- Wait for arrival  
task.wait(TWEEN_SPEED + 0.1)  
	  
-- Attack all enemies in cluster  
for _, data in ipairs(npcs) do  
if not farming then break end  
local npc = data.npc  
local npcHumanoid = npc:FindFirstChildOfClass("Humanoid")  
		  
if npcHumanoid and npcHumanoid.Health > 0 then  
-- Face the enemy  
if rootPart then  
rootPart.CFrame = CFrame.lookAt(rootPart.Position, npc.HumanoidRootPart.Position)  
end  
			  
-- Execute attack (using executor's function)  
if typeof(mouse1click) == "function" then  
mouse1click()  
end  
			  
task.wait(ATTACK_DELAY)  
end  
end  
end

--==================================================  
-- MAIN FARM LOOP  
--==================================================

local function farmLoop()  
while farming do  
if not character or not rootPart then break end  
		  
-- Find nearby enemies  
local npcs = getClosestNPCs(GROUP_RADIUS * 2) -- Double radius for grouping  
		  
if #npcs > 0 then  
-- Group and attack  
attackCluster(npcs)  
else  
-- No enemies nearby, wait and scan again  
task.wait(1)  
end  
		  
task.wait(SCAN_INTERVAL)  
end  
end

local function startFarm()  
if farming then return end  
farming = true  
print("Auto-farm STARTED (Tween Mode)")  
farmThread = task.spawn(farmLoop)  
end

local function stopFarm()  
farming = false  
if currentTween then  
currentTween:Cancel()  
end  
if farmThread then  
farmThread = nil  
end  
print("Auto-farm STOPPED")  
end

local function toggleFarm()  
if farming then  
stopFarm()  
else  
startFarm()  
end  
end

--==================================================  
-- INPUT  
--==================================================

UserInputService.InputBegan:Connect(function(input, gameProcessed)  
if gameProcessed then return end  
if input.KeyCode == TOGGLE_KEY then  
toggleFarm()  
end  
end)

print("Tween-based Auto-farm loaded.")  
print("Press F to toggle.")  
print("Features: Smooth movement, enemy grouping, no instant teleport.")  
