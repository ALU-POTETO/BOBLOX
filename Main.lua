```lua
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

--==================================================
-- CONFIG
--==================================================

local TOGGLE_KEY = Enum.KeyCode.F
local SCAN_INTERVAL = 0.1
local ATTACK_DELAY = 0.2
local OFFSET = CFrame.new(0, 0, 2)

--==================================================
-- STATE
--==================================================

local farming = false
local farmThread = nil

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

	if not humanoid or not rootPart then
		warn("Character components not found.")
	end
end

updateCharacter(
	player.Character or player.CharacterAdded:Wait()
)

player.CharacterAdded:Connect(function(newCharacter)
	updateCharacter(newCharacter)
end)

--==================================================
-- FIND CLOSEST NPC
--==================================================

local function getClosestNPC()
	if not rootPart then
		return nil
	end

	local enemiesFolder = Workspace:FindFirstChild("Enemies")

	if not enemiesFolder then
		return nil
	end

	local closestNPC = nil
	local closestDistance = math.huge

	for _, npc in ipairs(enemiesFolder:GetChildren()) do
		local npcHumanoid = npc:FindFirstChildOfClass("Humanoid")
		local npcRoot = npc:FindFirstChild("HumanoidRootPart")

		if npcHumanoid
			and npcRoot
			and npcHumanoid.Health > 0 then

			local distance =
				(rootPart.Position - npcRoot.Position).Magnitude

			if distance < closestDistance then
				closestDistance = distance
				closestNPC = npc
			end
		end
	end

	return closestNPC
end

--==================================================
-- FARM ACTION
--==================================================

local function performFarmAction()
	if not farming then
		return
	end

	if not character or not character.Parent then
		return
	end

	if not humanoid or humanoid.Health <= 0 then
		return
	end

	if not rootPart then
		return
	end

	local target = getClosestNPC()

	if not target then
		return
	end

	local targetRoot =
		target:FindFirstChild("HumanoidRootPart")

	local targetHumanoid =
		target:FindFirstChildOfClass("Humanoid")

	if not targetRoot
		or not targetHumanoid
		or targetHumanoid.Health <= 0 then
		return
	end

	-- Controlled movement test.
	-- This deliberately creates an obvious teleport so
	-- the server anti-cheat can detect it.
	rootPart.CFrame =
		targetRoot.CFrame * OFFSET

	-- Executor-specific input function.
	-- Only use this in your own controlled test environment.
	if typeof(mouse1click) == "function" then
		mouse1click()
	end
end

--==================================================
-- FARM LOOP
--==================================================

local function startFarm()
	if farmThread then
		return
	end

	farming = true

	print("Auto-farm STARTED")

	farmThread = task.spawn(function()
		while farming do
			performFarmAction()

			task.wait(SCAN_INTERVAL)

			if farming then
				task.wait(ATTACK_DELAY)
			end
		end

		farmThread = nil

		print("Auto-farm STOPPED")
	end)
end

local function stopFarm()
	farming = false
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
	if gameProcessed then
		return
	end

	if input.KeyCode == TOGGLE_KEY then
		toggleFarm()
	end
end)

print("Auto-farm test client loaded.")
print("Press F to toggle.")
```
