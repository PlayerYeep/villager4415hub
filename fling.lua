-- Script Name: PlayerSpinnerMax
-- Location: ServerScriptService

local Players = game:GetService("Players")

-- === CONFIGURATION (MAXIMUM AND EXTENDED EFFECT) ===
local SPIN_VELOCITY = 2000        -- Max speed to ensure extreme, sustained spinning
local EFFECT_DURATION = 60.0      -- Spin for a full 60 seconds (1 minute)
local COOLDOWN = 1.0              -- Time before the player can be affected again

-- Table to track players currently on cooldown
local cooldowns = {}

-- Function to handle the player touch event
local function onPlayerTouch(touchingPlayer, otherCharacter)
    local rootPart = touchingPlayer.Character and touchingPlayer.Character:FindFirstChild("HumanoidRootPart")
    
    -- Check if the player is currently on cooldown
    if cooldowns[touchingPlayer] or not rootPart then
        return
    end

    -- Check if the touched part belongs to another player's character
    local otherPlayer = Players:GetPlayerFromCharacter(otherCharacter)

    if otherPlayer and otherPlayer ~= touchingPlayer then
        
        -- 1. Apply Cooldown
        cooldowns[touchingPlayer] = true
        
        -- 2. Apply Spin Forces (No Launch)
        
        -- Start the rapid spin around the Y-axis (vertical axis)
        rootPart.AssemblyAngularVelocity = Vector3.new(0, SPIN_VELOCITY, 0)
        
        print("Player " .. touchingPlayer.Name .. " is now spinning for 60 seconds!")
        
        -- 3. Wait for the full duration
        task.wait(EFFECT_DURATION)
        
        -- Stop the spin by resetting the angular velocity
        rootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        
        -- 4. End Cooldown
        task.wait(COOLDOWN)
        cooldowns[touchingPlayer] = nil
    end
end

-- Function to set up the touch listener for a single player
local function setupPlayerTouchListener(player)
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if rootPart then
        -- Connect the Touched event of the player's main part
        rootPart.Touched:Connect(function(otherPart)
            local otherCharacter = otherPart.Parent
            onPlayerTouch(player, otherCharacter)
        end)
    end
end

---

## 🚀 Main Script Logic

-- Set up listeners for players currently in the game
for _, player in ipairs(Players:GetPlayers()) do
    -- Set up listener when the player's character is added/respawned
    player.CharacterAdded:Connect(setupPlayerTouchListener)
    
    -- Set up immediately if the character is already loaded
    if player.Character then
        setupPlayerTouchListener(player)
    end
end

-- Set up listeners for players who join after the server starts
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(setupPlayerTouchListener)
end)
