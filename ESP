-- Script Name: PlayerHighlighterAndLabel
-- Location: ServerScriptService

local Players = game:GetService("Players")
local HighlightColor = Color3.fromRGB(255, 0, 0) -- Bright Red Highlight Color

-- Function to create and configure the TextLabel GUI
local function createTextLabel(player)
    
    -- 1. Create the BillboardGui
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "PlayerLabelGui"
    billboard.Size = UDim2.new(5, 0, 1, 0) -- Size (5 studs wide, 1 stud tall)
    billboard.Adornee = player.Character.PrimaryPart -- Adorn the label to the HumanoidRootPart
    billboard.AlwaysOnTop = true -- Ensures the text is always visible
    billboard.ExtentsOffsetWorldSpace = Vector3.new(0, 3, 0) -- Position 3 studs above the HumanoidRootPart
    
    -- 2. Create the TextLabel inside the BillboardGui
    local label = Instance.new("TextLabel")
    label.Name = "PlayerNameLabel"
    label.Text = player.DisplayName -- Use DisplayName (or .Name for the username)
    label.Size = UDim2.new(1, 0, 1, 0) -- Fill the whole BillboardGui
    label.BackgroundTransparency = 1 -- Make the background clear
    label.TextScaled = true -- Auto-size the text to fit
    label.TextColor3 = Color3.new(1, 1, 1) -- White Text
    label.Font = Enum.Font.SourceSansBold
    
    label.Parent = billboard
    billboard.Parent = player.Character
end

-- Function to apply a highlight and text label to a player's character
local function applyHighlightAndLabel(player)
    local character = player.Character or player.CharacterAdded:Wait()
    
    -- Check for existing label/highlight to prevent duplicates on respawn
    if character:FindFirstChild("PlayerLabelGui") or character:FindFirstChild("PlayerHighlight") then
        return
    end

    -- --- 1. HIGHLIGHT CREATION ---
    local highlight = Instance.new("Highlight")
    highlight.Name = "PlayerHighlight"
    highlight.FillColor = HighlightColor
    highlight.OutlineColor = HighlightColor
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- Shows through walls
    highlight.Enabled = true
    highlight.Parent = character
    
    -- --- 2. TEXT LABEL CREATION ---
    createTextLabel(player)
end

-- --- MAIN SCRIPT LOGIC ---

-- Apply highlights and labels to players currently in the game
for _, player in ipairs(Players:GetPlayers()) do
    applyHighlightAndLabel(player)
end

-- Apply highlights and labels to players who join AFTER the server has started
Players.PlayerAdded:Connect(function(player)
    -- This handles applying the effects every time the player respawns
    player.CharacterAdded:Connect(function()
        applyHighlightAndLabel(player)
    end)
    
    -- This handles the initial load if the character is ready immediately
    if player.Character then
        applyHighlightAndLabel(player)
    end
end)
