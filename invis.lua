local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Variable to track the state of invisibility
local isInvisible = false

-- List of all common R6 and R15 character parts
local CHARACTER_PARTS = {
    -- R6 Parts
    "Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg",
    -- R15 Parts
    "UpperTorso", "LowerTorso", "LeftUpperArm", "LeftLowerArm", "LeftHand", 
    "RightUpperArm", "RightLowerArm", "RightHand", "LeftUpperLeg", 
    "LeftLowerLeg", "LeftFoot", "RightUpperLeg", "RightLowerLeg", "RightFoot"
}

-- Function to make the character parts and accessories invisible (Transparency = 1)
local function setInvisibility(char, isEnabled)
    if not char or not char:FindFirstChild("Humanoid") then return end

    -- 1 means invisible, 0 means visible
    -- We use LocalTransparencyModifier for reliability
    local transparencyValue = isEnabled and 1 or 0
    
    -- 1. Target all known body parts explicitly
    for _, partName in ipairs(CHARACTER_PARTS) do
        local part = char:FindFirstChild(partName)
        if part and part:IsA("BasePart") then
            part.LocalTransparencyModifier = transparencyValue
        end
    end
    
    -- 2. Loop through descendants to catch Accessories, Clothing, and faces
    for _, child in ipairs(char:GetDescendants()) do
        -- Catch any parts not in the explicit list (e.g., layered clothing, hats, tools)
        if child:IsA("BasePart") and child.Name ~= "HumanoidRootPart" then
            child.LocalTransparencyModifier = transparencyValue
        -- Catch faces (Decals)
        elseif child:IsA("Decal") and child.Name == "face" then
            -- Setting the part's LocalTransparencyModifier makes the decal invisible
            if child.Parent and child.Parent:IsA("BasePart") then
                child.Parent.LocalTransparencyModifier = transparencyValue
            end
        end
    end
end

-- Main function to toggle the state and apply the effect
local function toggleInvisibility()
    isInvisible = not isInvisible
    
    local currentCharacter = LocalPlayer.Character
    if currentCharacter then
        -- Wait a small amount for the character to finish loading completely
        task.wait(0.1) 
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
    -- Crucial wait after character respawns to ensure all parts (especially accessories) are present
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
