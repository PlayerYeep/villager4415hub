local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Variable to track the state of invisibility
local isInvisible = false

-- Function to make the character parts and accessories transparent/visible
local function setInvisibility(char, isEnabled)
    if not char then return end

    -- 1 means invisible, 0 means visible
    local transparencyValue = isEnabled and 1 or 0
    
    -- Loop through all children and descendants of the character model
    -- Using GetDescendants() is more thorough than GetChildren() for accessories
    for _, child in ipairs(char:GetDescendants()) do
        -- Handle all BaseParts (Head, Torso, Limbs in R6/R15)
        if child:IsA("BasePart") then
            -- Skip the HumanoidRootPart as it is not visible by default, 
            -- and sometimes forcing it to Transparency=1 can cause issues.
            if child.Name ~= "HumanoidRootPart" then
                child.Transparency = transparencyValue
            end
        -- Handle Decals (often used for faces/clothing)
        elseif child:IsA("Decal") then
            -- Decals don't have Transparency, but their parent part does.
            -- This ensures the face is targeted if it's a direct child of a part.
            if child.Parent and child.Parent:IsA("BasePart") then
                child.Parent.Transparency = transparencyValue
            end
        end
        
        -- Special handling for accessories, whose 'Handle' is a BasePart
        -- The main loop's BasePart check already covers this if we used GetDescendants
        -- but this explicit check can also be useful if we stick to GetChildren.
        -- We'll rely on GetDescendants and the BasePart check for simplicity.
    end
end

-- Main function to toggle the state and apply the effect
local function toggleInvisibility()
    isInvisible = not isInvisible
    
    local currentCharacter = LocalPlayer.Character
    if currentCharacter then
        -- Force the character to load all appearance parts before setting transparency
        task.wait(0.2) -- The crucial fix: wait for a fraction of a second for parts to appear
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
    -- *** UPDATED FIX HERE: ***
    -- Wait a moment for character parts, accessories, and clothing to fully load.
    -- task.wait(0.2) is a common fix to ensure all parts have loaded before applying the script.
    task.wait(0.2) 
    
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
