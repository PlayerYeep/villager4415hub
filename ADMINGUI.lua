-- Script Name: AllInOneAdminSystem
-- Location: ServerScriptService

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

-- === 1. CONFIGURATION (CHANGE THIS) ===
local ADMIN_NAME = "YourUsernameHere" -- !!! IMPORTANT: Change this to YOUR Roblox username !!!
local DEFAULT_SPEED = 16
local DEFAULT_JUMP_HEIGHT = 7.2

-- === 2. REMOTE EVENT SETUP ===
local AdminEvent = Instance.new("RemoteEvent")
AdminEvent.Name = "AdminCommandEvent"
AdminEvent.Parent = ReplicatedStorage -- Placed in ReplicatedStorage for client/server access

-- === 3. CLIENT CODE (This code will be injected into StarterPlayerScripts) ===

local ClientScriptCode = [[
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local UserInputService = game:GetService("UserInputService")
    local LocalPlayer = Players.LocalPlayer
    
    local AdminEvent = ReplicatedStorage:WaitForChild("AdminCommandEvent")
    
    -- Function to create and build the admin panel GUI
    local function createAdminGui()
        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "AdminPanel"
        ScreenGui.Parent = LocalPlayer.PlayerGui

        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(0, 200, 0, 250)
        Frame.Position = UDim2.new(0.05, 0, 0.5, -125)
        Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        Frame.BorderSizePixel = 2
        Frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
        Frame.Parent = ScreenGui

        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1, 0, 0, 30)
        Title.Text = "✨ ADMIN PANEL"
        Title.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.Font = Enum.Font.SourceSansBold
        Title.TextSize = 18
        Title.Parent = Frame
        
        return Frame
    end

    -- Function to create command buttons
    local function createButton(parent, text, command, yOffset, value)
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(0.9, 0, 0, 30)
        Button.Position = UDim2.new(0.05, 0, 0, yOffset)
        Button.Text = text
        Button.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.Font = Enum.Font.SourceSans
        Button.TextSize = 14
        Button.Parent = parent

        Button.MouseButton1Click:Connect(function()
            -- Send the command and value to the server
            AdminEvent:FireServer(command, value)
        end)
    end
    
    -- Function to handle the custom infinite jump logic
    local function onJumpAttempt(input, gameProcessedEvent)
        -- Check if the server script has enabled infinite jump on the player object
        if LocalPlayer:GetAttribute("InfiniteJumpActive") then
            local character = LocalPlayer.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end

    -- Connect the jump logic to the input system
    UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
        if input.KeyCode == Enum.KeyCode.Space then
            onJumpAttempt(input, gameProcessedEvent)
        end
    end)


    -- === EXECUTE GUI CREATION ===
    
    local adminFrame = createAdminGui()
    
    -- Button Definitions
    createButton(adminFrame, "Speed (25) / Default", "Speed", 35, 25)
    createButton(adminFrame, "Jump Height (50) / Default", "JumpHeight", 70, 50)
    createButton(adminFrame, "Infinite Jump On / Off", "InfiniteJump", 105, 0)
    createButton(adminFrame, "Fly Mode On / Off", "Fly", 140, 0)
    createButton(adminFrame, "RESET ALL TO DEFAULT", "Reset", 175, 0)
]]

-- === 4. SERVER CODE (Handles the commands securely) ===

local function setPlayerProperties(player, command, value)
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    
    if not character or not humanoid then return end

    if command == "Speed" then
        humanoid.WalkSpeed = (humanoid.WalkSpeed == DEFAULT_SPEED) and value or DEFAULT_SPEED
        
    elseif command == "JumpHeight" then
        humanoid.JumpHeight = (humanoid.JumpHeight == DEFAULT_JUMP_HEIGHT) and value or DEFAULT_JUMP_HEIGHT
        
    elseif command == "InfiniteJump" then
        if player:GetAttribute("InfiniteJumpActive") then
            player:SetAttribute("InfiniteJumpActive", nil)
            humanoid.PlatformStand = false
        else
            player:SetAttribute("InfiniteJumpActive", true)
            humanoid.PlatformStand = true -- Enables client-side jump logic
        end

    elseif command == "Fly" then
        if player:GetAttribute("FlyActive") then
            -- Disable fly effect
            player:SetAttribute("FlyActive", nil)
            humanoid.WalkSpeed = DEFAULT_SPEED
            humanoid.JumpPower = 50 
        else
            -- Enable fly effect (High Speed/JumpPower for approximation)
            player:SetAttribute("FlyActive", true)
            humanoid.WalkSpeed = 60
            humanoid.JumpPower = 100 
        end
        
    elseif command == "Reset" then
        humanoid.WalkSpeed = DEFAULT_SPEED
        humanoid.JumpHeight = DEFAULT_JUMP_HEIGHT
        humanoid.JumpPower = 50
        humanoid.PlatformStand = false
        player:SetAttribute("InfiniteJumpActive", nil)
        player:SetAttribute("FlyActive", nil)
    end
end


local function onAdminCommand(requester, command, value)
    -- Security check: Only allow the designated admin to use the commands
    if requester.Name == ADMIN_NAME then
        setPlayerProperties(requester, command, value)
    else
        warn(requester.Name .. " attempted to execute admin command but is not authorized.")
    end
end

AdminEvent.OnServerEvent:Connect(onAdminCommand)


-- === 5. SELF-PLACEMENT LOGIC (Runs once for every joining player) ===

local function createClientScript(player)
    -- Check if the player is the admin before injecting the script
    if player.Name ~= ADMIN_NAME then return end

    local clientScript = Instance.new("LocalScript")
    clientScript.Name = "AdminGuiLoader"
    clientScript.Source = ClientScriptCode -- The source is the client code string defined above
    clientScript.Parent = player:FindFirstChild("PlayerScripts") -- Place inside the player's PlayerScripts folder
end

-- Connect the setup function to PlayerAdded
Players.PlayerAdded:Connect(function(player)
    -- Wait for the PlayerScripts folder to be available
    player.CharacterAdded:Wait() 
    createClientScript(player)
end)

-- Run for any players already in the game when the server starts
for _, player in ipairs(Players:GetPlayers()) do
    createClientScript(player)
end
