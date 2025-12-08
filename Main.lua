local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Villager4415 Hub",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Villager4415 Mods Loading..",
   LoadingSubtitle = "by Villager4415",
   ShowText = "Show", -- for mobile users to unhide rayfield, change if you'd like
   Theme = "Bloom", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Villager4415 Hub"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = true, -- Set this to true to use our key system
   KeySettings = {
      Title = "Key Stuff",
      Subtitle = "Private stuff",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "VHKAY", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"VHONLY"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

local Tab = Window:CreateTab("Mods", 4483362458)

local Button = Tab:CreateButton({
   Name = "ESP",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/PlayerYeep/villager4415hub/refs/heads/main/ESP.lua"))()
   end,
})

local Button = Tab:CreateButton({
   Name = "Fake UTG",
   Callback = function()
   loadstring(game:HttpGet("https://pastefy.app/rmdi1m55/raw"))()
   end,
})

local Button = Tab:CreateButton({
   Name = "Real UTG",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/radiuscool/UTG/refs/heads/main/as"))()
   end,
})

local Button = Tab:CreateButton({
   Name = "FE grab npc",
   Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/GUI-Offical/FileTest/refs/heads/main/Grab%20R6.txt", true))()
   -- The function that takes place when the button is pressed
   end,
})

local Button = Tab:CreateButton({
   Name = "INF YIELD",
   Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
   -- The function that takes place when the button is pressed
   end,
})

local Button = Tab:CreateButton({
   Name = "Fling or Spin",
   Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/PlayerYeep/villager4415hub/refs/heads/main/fling.lua", true))()
   -- The function that takes place when the button is pressed
   end,
})
