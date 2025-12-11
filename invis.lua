local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Variable to track the state of invisibility
local isInvisible = false

-- Function to make the character parts and accessories transparent/visible
local function setInvisibility(char, isEnabled)
    if not char then return end

    -- 1 means invisible, 0 means visible
    local transparencyValue = isEnabled and 1 or 0
    
    -- Loop through all children of the character model to handle parts and accessories
    for _, child in ipairs(char:GetChildren()) do
        -- Handle all BaseParts (Head, Torso, Limbs in R6/R15)
        if child:IsA("BasePart") then
            child.Transparency = transparencyValue
        -- Handle accessories (Hats, Hair, gear, etc.)
        elseif child:IsA("Accessory") then
            local handle = child:FindFirstChild("Handle")
            if handle and handle:IsA("BasePart") then
                handle.Transparency = transparencyValue
            end
        -- Handle MeshParts which can be used in R15 rigs
        elseif child:IsA("MeshPart") then
             child.Transparency = transparencyValue
        -- Handle clothing (Shirt/Pants objects)
        elseif child:IsA("Shirt") or child:IsA("Pants") then
            -- Setting the transparency property on these objects makes the texture invisible
            child.Transparency = transparencyValue 
        end
    end
end

-- Main function to toggle the state and apply the effect
local function toggleInvisibility()
    isInvisible = not isInvisible
    
    -- Apply the current state to the existing character
    local currentCharacter = LocalPlayer.Character
    if currentCharacter then
        setInvisibility(currentCharacter, isInvisible)
    end
    
    if isInvisible then
        print("Invisible Character: ON")
    else
        print("Invisible Character: OFF")
    end
end

-- Function to handle initial load and respawns
local function onCharacterAdded(char)
    -- Wait a moment for character and accessories to load fully
    char.ChildAdded:Wait() 
    
    -- If the feature is currently enabled, re-apply it on respawn
    if isInvisible then
        setInvisibility(char, true)
    end
end

-- Connect to character changes (respawn)
LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

-- Initial run check (in case the character is already loaded)
if LocalPlayer.Character then
    onCharacterAdded(LocalPlayer.Character)
end

-- ******************************************************
-- EXECUTION: Toggles the state every time the script is run
-- ******************************************************
toggleInvisibility()
