local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Visual by vomagla",
   LoadingTitle = "Visual Menu",
   LoadingSubtitle = "by vomagla",
   KeySystem = false,
   Theme = {
      TextColor = Color3.fromRGB(240, 240, 240),
      Background = Color3.fromRGB(5, 5, 5),
      Topbar = Color3.fromRGB(10, 10, 10),
      Shadow = Color3.fromRGB(0, 0, 0),
      NotificationBackground = Color3.fromRGB(5, 5, 5),
      NotificationActionsBackground = Color3.fromRGB(200, 200, 200),
      TabBackground = Color3.fromRGB(15, 15, 15),
      TabStroke = Color3.fromRGB(80, 80, 80),
      TabBackgroundSelected = Color3.fromRGB(30, 30, 30),
      TabTextColor = Color3.fromRGB(240, 240, 240),
      SelectedTabTextColor = Color3.fromRGB(255, 255, 255),
      ElementBackground = Color3.fromRGB(10, 10, 10),
      ElementBackgroundHover = Color3.fromRGB(20, 20, 20),
      SecondaryElementBackground = Color3.fromRGB(5, 5, 5),
      ElementStroke = Color3.fromRGB(100, 100, 100),
      SecondaryElementStroke = Color3.fromRGB(70, 70, 70),
      SliderBackground = Color3.fromRGB(25, 25, 25),
      SliderProgress = Color3.fromRGB(0, 255, 255),
      SliderStroke = Color3.fromRGB(120, 120, 120),
      ToggleBackground = Color3.fromRGB(15, 15, 15),
      ToggleEnabled = Color3.fromRGB(0, 255, 255),
      ToggleDisabled = Color3.fromRGB(80, 80, 80),
      ToggleEnabledStroke = Color3.fromRGB(0, 255, 255),
      ToggleDisabledStroke = Color3.fromRGB(120, 120, 120),
      ToggleEnabledOuterStroke = Color3.fromRGB(100, 100, 100),
      ToggleDisabledOuterStroke = Color3.fromRGB(70, 70, 70),
      DropdownSelected = Color3.fromRGB(25, 25, 25),
      DropdownUnselected = Color3.fromRGB(15, 15, 15),
      InputBackground = Color3.fromRGB(15, 15, 15),
      InputStroke = Color3.fromRGB(80, 80, 80),
      PlaceholderColor = Color3.fromRGB(150, 150, 150)
   }
})

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

-- Глобальные переменные состояний
local hatEnabled = false
local trailEnabled = false
local ffEnabled = false
local screenEnabled = false
local animeImageEnabled = false
local fpsPingEnabled = false

-- Main Tab
local MainTab = Window:CreateTab("Main", 4483362458)

MainTab:CreateParagraph({
   Title = "Important information",
   Content = "ALL FUNCTIONS ARE VISUAL ONLY. No one can see them except you."
})

-- Chinese Hat Tab
local ChineseTab = Window:CreateTab("Chinese Hat", 4483362458)
local hatParts = {}
local hatTransparency = 0.3
local hatRainbow = false
local hatColor = Color3.fromRGB(0, 255, 255)
local hatConnection

local function removeHat(char)
   if hatParts[char] then
      hatParts[char]:Destroy()
      hatParts[char] = nil
   end
end

local function addHat(char)
   task.wait(0.1)
   local head = char:WaitForChild("Head")
   removeHat(char)
   
   local hat = Instance.new("Part")
   hat.Name = "Hat"
   hat.Transparency = hatTransparency
   hat.Color = hatColor
   hat.Material = Enum.Material.Neon
   hat.CanCollide = false
   
   local mesh = Instance.new("SpecialMesh")
   mesh.MeshId = "rbxassetid://1033714"
   mesh.Scale = Vector3.new(2.4, 1.6, 2.4)
   mesh.Parent = hat
   
   local weld = Instance.new("WeldConstraint")
   weld.Part0 = head
   weld.Part1 = hat
   weld.Parent = hat
   
   hat.CFrame = head.CFrame * CFrame.new(0, 1.1, 0)
   hat.Parent = char
   
   hatParts[char] = hat
end

local function updateHats()
   for char, hat in pairs(hatParts) do
      if hat and hat.Parent and char == player.Character then
         hat.Transparency = hatTransparency
         if hatRainbow then
            hat.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
         else
            hat.Color = hatColor
         end
      end
   end
end

ChineseTab:CreateToggle({
   Name = "Enable Chinese Hat",
   CurrentValue = false,
   Flag = "HatToggle",
   Callback = function(value)
      hatEnabled = value
      if value and player.Character then
         addHat(player.Character)
         if hatConnection then hatConnection:Disconnect() end
         hatConnection = RunService.Heartbeat:Connect(updateHats)
      else
         if player.Character then removeHat(player.Character) end
         if hatConnection then hatConnection:Disconnect() hatConnection = nil end
      end
   end
})

ChineseTab:CreateToggle({
   Name = "Rainbow Hat",
   CurrentValue = false,
   Flag = "HatRainbow",
   Callback = function(value)
      hatRainbow = value
      updateHats()
   end
})

ChineseTab:CreateSlider({
   Name = "Transparency",
   Range = {0, 1},
   Increment = 0.01,
   CurrentValue = 0.3,
   Flag = "HatTransparency",
   Callback = function(value)
      hatTransparency = value
      updateHats()
   end
})

ChineseTab:CreateColorPicker({
   Name = "Hat Color",
   Color = Color3.fromRGB(0, 255, 255),
   Flag = "HatColor",
   Callback = function(color)
      hatColor = color
      updateHats()
   end
})

-- Trail Tab
local TrailTab = Window:CreateTab("Trail", 4483362458)
local trailParts = {}
local trailLifetime = 0.5
local trailTransparencyStart = 0
local trailRainbow = false
local trailColorStatic = Color3.fromRGB(0, 255, 255)
local trailConnection

local function removeTrail(char)
   if trailParts[char] then
      trailParts[char]:Destroy()
      trailParts[char] = nil
   end
   if char and char:FindFirstChild("HumanoidRootPart") then
      local torso = char.HumanoidRootPart
      if torso:FindFirstChild("TrailAttach0") then torso.TrailAttach0:Destroy() end
      if torso:FindFirstChild("TrailAttach1") then torso.TrailAttach1:Destroy() end
   end
end

local function addTrail(character)
   local torso = character:WaitForChild("HumanoidRootPart")
   removeTrail(character)
   
   local attachment0 = Instance.new("Attachment")
   attachment0.Name = "TrailAttach0"
   attachment0.Position = Vector3.new(0, 2, 0)
   attachment0.Parent = torso
   
   local attachment1 = Instance.new("Attachment")
   attachment1.Name = "TrailAttach1"
   attachment1.Position = Vector3.new(0, -2, 0)
   attachment1.Parent = torso
   
   local trail = Instance.new("Trail")
   trail.Attachment0 = attachment0
   trail.Attachment1 = attachment1
   trail.Lifetime = trailLifetime
   trail.Transparency = NumberSequence.new({
      NumberSequenceKeypoint.new(0, trailTransparencyStart),
      NumberSequenceKeypoint.new(1, 1)
   })
   trail.Color = ColorSequence.new(trailColorStatic)
   trail.LightEmission = 0.7
   trail.Enabled = true
   trail.Parent = character
   
   trailParts[character] = trail
end

local function updateTrails()
   for char, trail in pairs(trailParts) do
      if trail and trail.Parent and char == player.Character then
         trail.Lifetime = trailLifetime
         trail.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, trailTransparencyStart),
            NumberSequenceKeypoint.new(1, 1)
         })
         if trailRainbow then
            trail.Color = ColorSequence.new(Color3.fromHSV(tick() % 5 / 5, 1, 1))
         else
            trail.Color = ColorSequence.new(trailColorStatic)
         end
      end
   end
end

TrailTab:CreateToggle({
   Name = "Enable Trail",
   CurrentValue = false,
   Flag = "TrailToggle",
   Callback = function(value)
      trailEnabled = value
      if value and player.Character then
         addTrail(player.Character)
         if trailConnection then trailConnection:Disconnect() end
         trailConnection = RunService.Heartbeat:Connect(updateTrails)
      else
         if player.Character then removeTrail(player.Character) end
         if trailConnection then trailConnection:Disconnect() trailConnection = nil end
      end
   end
})

TrailTab:CreateToggle({
   Name = "Rainbow Trail",
   CurrentValue = false,
   Flag = "TrailRainbow",
   Callback = function(value)
      trailRainbow = value
      updateTrails()
   end
})

TrailTab:CreateSlider({
   Name = "Trail Lifetime",
   Range = {0.1, 3},
   Increment = 0.1,
   CurrentValue = 0.5,
   Flag = "TrailLifetime",
   Callback = function(value)
      trailLifetime = value
      updateTrails()
   end
})

TrailTab:CreateSlider({
   Name = "Trail Transparency",
   Range = {0, 1},
   Increment = 0.01,
   CurrentValue = 0,
   Flag = "TrailTransparency",
   Callback = function(value)
      trailTransparencyStart = value
      updateTrails()
   end
})

TrailTab:CreateColorPicker({
   Name = "Trail Color",
   Color = Color3.fromRGB(0, 255, 255),
   Flag = "TrailColor",
   Callback = function(color)
      trailColorStatic = color
      updateTrails()
   end
})

-- Screen Tab
local ScreenTab = Window:CreateTab("Screen", 4483362458)
local screenIntensity = 0
local screenConnection

ScreenTab:CreateToggle({
   Name = "Enable Screen Effect",
   CurrentValue = false,
   Flag = "ScreenToggle",
   Callback = function(value)
      screenEnabled = value
      if value then
         getgenv().gg_scripters = "Aori0001"
         screenConnection = RunService.RenderStepped:Connect(function()
            camera.CFrame = camera.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, (0.65 + screenIntensity), 0, 0, 0, 1)
         end)
      else
         if screenConnection then
            screenConnection:Disconnect()
            screenConnection = nil
         end
         getgenv().gg_scripters = nil
      end
   end
})

ScreenTab:CreateSlider({
   Name = "Screen Stretch",
   Range = {0, 0.2},
   Increment = 0.001,
   CurrentValue = 0,
   Flag = "ScreenIntensity",
   Callback = function(value)
      screenIntensity = value
   end
})

-- Sky Tab
local SkyTab = Window:CreateTab("Sky", 4483362458)
local Lighting = game:GetService("Lighting")
local currentTime = Lighting.ClockTime

RunService.Heartbeat:Connect(function()
   Lighting.ClockTime = currentTime
end)

SkyTab:CreateSlider({
   Name = "Sky Time (0-24)",
   Range = {0, 24},
   Increment = 0.1,
   CurrentValue = 12,
   Flag = "SkyTime",
   Callback = function(value)
      currentTime = value
   end
})

SkyTab:CreateButton({
   Name = "Custom Sky",
   Callback = function()
      if not game.Lighting:FindFirstChildOfClass("Sky") then 
         Instance.new("Sky", game.Lighting)
      end
      for a, b in ipairs(game:GetService("Lighting"):GetChildren()) do 
         if b.Name == "Sky" then 
            b.SkyboxBk = "http://www.roblox.com/asset/?id=171410628"
            b.SkyboxDn = "http://www.roblox.com/asset/?id=171410649"
            b.SkyboxFt = "http://www.roblox.com/asset/?id=171410620"
            b.SkyboxLf = "http://www.roblox.com/asset/?id=171410666"
            b.SkyboxRt = "http://www.roblox.com/asset/?id=171410657"
            b.SkyboxUp = "http://www.roblox.com/asset/?id=171410636"
         end 
      end
   end
})

-- ForceField Tab
local ForceFieldTab = Window:CreateTab("ForceField", 4483362458)
local ffColor = Color3.fromRGB(128, 128, 128)
local ffRainbow = false
local originalColors = {}
local ffConnection

local function saveOriginalColors(char)
   originalColors[char] = {}
   for _, part in pairs(char:GetDescendants()) do
      if part:IsA("BasePart") and part.Name ~= "Hat" then
         originalColors[char][part] = {Color = part.Color, Material = part.Material}
      end
   end
end

local function applyForceField(char)
   saveOriginalColors(char)
   for _, part in pairs(char:GetDescendants()) do
      if part:IsA("BasePart") and part.Name ~= "Hat" then
         part.Color = ffColor
         part.Material = Enum.Material.ForceField
      end
   end
end

local function updateForceField()
   if player.Character and ffEnabled then
      for _, part in pairs(player.Character:GetDescendants()) do
         if part:IsA("BasePart") and part.Name ~= "Hat" and part.Material == Enum.Material.ForceField then
            if ffRainbow then
               part.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
            else
               part.Color = ffColor
            end
         end
      end
   end
end

local function removeForceField(char)
   if originalColors[char] then
      for part, data in pairs(originalColors[char]) do
         if part and part.Parent and part:IsA("BasePart") then
            part.Color = data.Color
            part.Material = data.Material
         end
      end
      originalColors[char] = {}
   end
end

ForceFieldTab:CreateToggle({
   Name = "Enable ForceField",
   CurrentValue = false,
   Flag = "ForceFieldToggle",
   Callback = function(value)
      ffEnabled = value
      if player.Character then
         if value then
            applyForceField(player.Character)
            if ffConnection then ffConnection:Disconnect() end
            ffConnection = RunService.Heartbeat:Connect(updateForceField)
         else
            if ffConnection then ffConnection:Disconnect() ffConnection = nil end
            removeForceField(player.Character)
         end
      end
   end
})

ForceFieldTab:CreateToggle({
   Name = "Rainbow ForceField",
   CurrentValue = false,
   Flag = "FFRainbow",
   Callback = function(value)
      ffRainbow = value
      updateForceField()
   end
})

ForceFieldTab:CreateColorPicker({
   Name = "ForceField Color",
   Color = Color3.fromRGB(128, 128, 128),
   Flag = "FFColor",
   Callback = function(color)
      ffColor = color
      if ffEnabled and not ffRainbow and player.Character then
         applyForceField(player.Character)
      end
   end
})

-- Other Tab
local OtherTab = Window:CreateTab("Other", 4483362458)

-- Переменная для хранения FPS/Ping GUI
local fpsPingGui = nil
local animeImageGui = nil

-- Функция для активации FPS/Ping счетчика
local function activateFpsPing()
   if not fpsPingEnabled then
      -- Выполняем запрошенный скрипт
      loadstring(game:HttpGet("https://raw.githubusercontent.com/GLAMOHGA/fling/refs/heads/main/хз%20как%20назвать%20типо%20фпс%20и%20пинг.md"))()
      fpsPingEnabled = true
   end
end

-- Функция для активации/деактивации аниме изображения
local function toggleAnimeImage(value)
   animeImageEnabled = value
   
   if value then
      -- Создаем аниме изображение
      animeImageGui = Instance.new("ScreenGui", player.PlayerGui)
      animeImageGui.Name = "AnimeImageGui"
      animeImageGui.ResetOnSpawn = false
      
      local imageLabel = Instance.new("ImageLabel", animeImageGui)
      imageLabel.Name = "AnimeImage"
      imageLabel.Image = "http://www.roblox.com/asset/?id=117783035423570"
      imageLabel.Size = UDim2.new(0, 350, 0, 400)
      imageLabel.Position = UDim2.new(1, -25, 0, 10)
      imageLabel.AnchorPoint = Vector2.new(1, 0)
      imageLabel.BackgroundTransparency = 1
      
      Rayfield:Notify({
         Title = "Anime Image",
         Content = "Anime image activated! --script by vomagla--",
         Duration = 3,
         Image = 4483362458
      })
   else
      -- Удаляем аниме изображение
      if animeImageGui then
         animeImageGui:Destroy()
         animeImageGui = nil
      end
   end
end

OtherTab:CreateButton({
   Name = "Activate FPS/Ping Counter",
   Callback = function()
      activateFpsPing()
      Rayfield:Notify({
         Title = "FPS/Ping Counter",
         Content = "FPS and Ping counter activated!",
         Duration = 3,
         Image = 4483362458
      })
   end
})

OtherTab:CreateToggle({
   Name = "Anime Image",
   CurrentValue = false,
   Flag = "AnimeImageToggle",
   Callback = function(value)
      toggleAnimeImage(value)
   end
})

-- Menu glow effect
RunService.Heartbeat:Connect(function()
   if Window.Flags then
      local isOpen = not Window.Flags.Minimized
      if isOpen then
         game.Lighting.Ambient = Color3.fromRGB(5, 5, 5)
         game.Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
         game.Lighting.ColorShift_Top = Color3.fromRGB(10, 10, 10)
      end
   end
end)

-- УНИВЕРСАЛЬНАЯ ФУНКЦИЯ АВТОРЕСПАВНА
local function reapplyVisuals(char)
   task.wait(0.5)
   if hatEnabled then 
      addHat(char) 
   end
   if trailEnabled then 
      addTrail(char) 
   end
   if ffEnabled then 
      applyForceField(char) 
   end
end

-- Подписка на респавн
player.CharacterAdded:Connect(reapplyVisuals)

-- Инициализация при первом запуске
if player.Character then
   reapplyVisuals(player.Character)
end

-- Автоматически применяем аниме изображение если оно было включено при респавне
player.CharacterAdded:Connect(function()
   if animeImageEnabled then
      task.wait(1)
      toggleAnimeImage(true)
   end
end)

print("Visual Menu Loaded!")
Rayfield:Notify({
   Title = "Visual by vomagla",
   Content = "Menu loaded successfully!",
   Duration = 4,
   Image = 4483362458
})
