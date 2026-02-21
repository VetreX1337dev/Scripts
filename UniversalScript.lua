-- ======================================================
-- ИНИЦИАЛИЗАЦИЯ И СЕРВИСЫ
-- ======================================================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local LocalPlayer = player 
local camera = Workspace.CurrentCamera
local Camera = camera 

-- ======================================================
-- СОЗДАНИЕ ОКНА RAYFIELD
-- ======================================================
local Window = Rayfield:CreateWindow({
   Name = "Universal Hub",
   LoadingTitle = "Vetrex x Echeron",
   LoadingSubtitle = "Combined Script",
   KeySystem = false,
   Theme = {
      TextColor = Color3.fromRGB(240,240,240),
      Background = Color3.fromRGB(5,5,5),
      Topbar = Color3.fromRGB(10,10,10),
      Shadow = Color3.fromRGB(0,0,0),
      NotificationBackground = Color3.fromRGB(5,5,5),
      NotificationActionsBackground = Color3.fromRGB(200,200,200),
      TabBackground = Color3.fromRGB(15,15,15),
      TabStroke = Color3.fromRGB(80,80,80),
      TabBackgroundSelected = Color3.fromRGB(30,30,30),
      TabTextColor = Color3.fromRGB(240,240,240),
      SelectedTabTextColor = Color3.fromRGB(255,255,255),
      ElementBackground = Color3.fromRGB(10,10,10),
      ElementBackgroundHover = Color3.fromRGB(20,20,20),
      SecondaryElementBackground = Color3.fromRGB(5,5,5),
      ElementStroke = Color3.fromRGB(100,100,100),
      SecondaryElementStroke = Color3.fromRGB(70,70,70),
      SliderBackground = Color3.fromRGB(25,25,25),
      SliderProgress = Color3.fromRGB(0,255,255),
      SliderStroke = Color3.fromRGB(120,120,120),
      ToggleBackground = Color3.fromRGB(15,15,15),
      ToggleEnabled = Color3.fromRGB(0,255,255),
      ToggleDisabled = Color3.fromRGB(80,80,80),
      ToggleEnabledStroke = Color3.fromRGB(0,255,255),
      ToggleDisabledStroke = Color3.fromRGB(120,120,120),
      ToggleEnabledOuterStroke = Color3.fromRGB(100,100,100),
      ToggleDisabledOuterStroke = Color3.fromRGB(70,70,70),
      DropdownSelected = Color3.fromRGB(25,25,25),
      DropdownUnselected = Color3.fromRGB(15,15,15),
      InputBackground = Color3.fromRGB(15,15,15),
      InputStroke = Color3.fromRGB(80,80,80),
      PlaceholderColor = Color3.fromRGB(150,150,150)
   }
})

-- ======================================================
-- СОЗДАНИЕ ВКЛАДОК
-- ======================================================
local ProfileTab   = Window:CreateTab("Profile", 4483362458)
local CombatTab    = Window:CreateTab("Combat & Aim", 4483362458)
local MM2Tab       = Window:CreateTab("Murder Mystery 2", 4483362458)
local MovementTab  = Window:CreateTab("Movement", 4483362458)
local CosmeticsTab = Window:CreateTab("Cosmetics", 4483362458)
local VisualsTab   = Window:CreateTab("Visuals & Sky", 4483362458)
local MiscTab      = Window:CreateTab("Misc", 4483362458)

-- ======================================================
-- 1. ПРОФИЛЬ
-- ======================================================
local DEVELOPERS = { [9873358913] = "Developer" }
local ORIGINAL_DEVS = { [10017073535] = "Original Dev" }

local function getStatus()
   if DEVELOPERS[player.UserId] then return DEVELOPERS[player.UserId]
   elseif ORIGINAL_DEVS[player.UserId] then return ORIGINAL_DEVS[player.UserId]
   else return "User" end
end

ProfileTab:CreateParagraph({
   Title = "Player Profile",
   Content = "Username: "..player.Name.."\nDisplayName: "..player.DisplayName.."\nUserId: "..player.UserId.."\nStatus: "..getStatus()
})

-- ======================================================
-- 2. COMBAT & ESP 
-- ======================================================
local AimlockEnabled = false
local VisibleCheckEnabled = false
local ESPEnabled = false
local TracerEnabled = false
local MM2AimEnabled = false
local MM2ESPEnabled = false
local AimSensitivity = 0.5
local TargetPartName = "Head"
local FOVRadius = 100
local TracerPosition = "Bottom"

local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Thickness = 1
FOVCircle.Filled = false
FOVCircle.Transparency = 1
FOVCircle.Radius = FOVRadius
FOVCircle.Visible = false

local TargetTracer = Drawing.new("Line")
TargetTracer.Color = Color3.fromRGB(255, 255, 255)
TargetTracer.Thickness = 1
TargetTracer.Transparency = 1
TargetTracer.Visible = false

local ESPHighlights = {}

local function GetPlayerRole(plr)
    local char = plr.Character
    if not char then return "Innocent" end
    if char:FindFirstChild("Knife") or plr.Backpack:FindFirstChild("Knife") then return "Murderer"
    elseif char:FindFirstChild("Gun") or plr.Backpack:FindFirstChild("Gun") then return "Sheriff" end
    return "Innocent"
end

local function IsVisible(targetPart)
    local char = LocalPlayer.Character
    if not char then return false end
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {char, Camera}
    local origin = Camera.CFrame.Position
    local direction = targetPart.Position - origin
    local result = workspace:Raycast(origin, direction, params)
    if result then
        return result.Instance:IsDescendantOf(targetPart.Parent)
    end
    return true
end

local function GetClosestPlayerToCenter(ignoreVisibility, onlyMurder)
    local Target = nil
    local ShortestDistance = math.huge
    local Center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
            if onlyMurder and GetPlayerRole(plr) ~= "Murderer" then continue end

            local part = plr.Character:FindFirstChild(TargetPartName) or plr.Character:FindFirstChild("HumanoidRootPart")
            if part then
                if not ignoreVisibility and VisibleCheckEnabled and not IsVisible(part) then continue end

                local Pos, OnScreen = Camera:WorldToViewportPoint(part.Position)
                if OnScreen then
                    local Distance = (Vector2.new(Pos.X, Pos.Y) - Center).Magnitude
                    if Distance <= FOVRadius and Distance < ShortestDistance then
                        Target = plr
                        ShortestDistance = Distance
                    end
                end
            end
        end
    end
    return Target
end

local function UpdateESP()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local char = plr.Character
            if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                if ESPEnabled or MM2ESPEnabled then
                    if not ESPHighlights[plr] then
                        local highlight = Instance.new("Highlight")
                        highlight.Name = "ESPHighlight"
                        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        highlight.FillTransparency = 0.5
                        highlight.OutlineTransparency = 0
                        highlight.Parent = char
                        ESPHighlights[plr] = highlight
                    end
                    
                    local highlight = ESPHighlights[plr]
                    if MM2ESPEnabled then
                        local role = GetPlayerRole(plr)
                        if role == "Murderer" then
                            highlight.FillColor = Color3.fromRGB(255, 0, 0)
                            highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
                        elseif role == "Sheriff" then
                            highlight.FillColor = Color3.fromRGB(0, 0, 255)
                            highlight.OutlineColor = Color3.fromRGB(0, 0, 255)
                        else
                            highlight.FillColor = Color3.fromRGB(0, 255, 0)
                            highlight.OutlineColor = Color3.fromRGB(0, 255, 0)
                        end
                    else
                        highlight.FillColor = plr.Team and plr.TeamColor.Color or Color3.fromRGB(255, 255, 255)
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    end
                elseif ESPHighlights[plr] then
                    ESPHighlights[plr]:Destroy()
                    ESPHighlights[plr] = nil
                end
            elseif ESPHighlights[plr] then
                ESPHighlights[plr]:Destroy()
                ESPHighlights[plr] = nil
            end
        end
    end
end

-- Вкладка Combat
local AimlockToggle = CombatTab:CreateToggle({
    Name = "Aimlock", CurrentValue = false,
    Callback = function(Value) AimlockEnabled = Value end,
})
CombatTab:CreateKeybind({
    Name = "Aimlock Bind", CurrentKeybind = "E", HoldToInteract = false,
    Callback = function() AimlockToggle:Set(not AimlockEnabled) end,
})
CombatTab:CreateDropdown({
    Name = "Target Part", Options = {"Head", "Torso"}, CurrentOption = {"Head"},
    Callback = function(Option) TargetPartName = Option[1] end,
})
CombatTab:CreateSlider({
    Name = "Sensitivity", Range = {1, 100}, Increment = 1, CurrentValue = 50,
    Callback = function(Value) AimSensitivity = Value / 100 end,
})
CombatTab:CreateToggle({
    Name = "Visible Check", CurrentValue = false,
    Callback = function(Value) VisibleCheckEnabled = Value end,
})
CombatTab:CreateToggle({
    Name = "Show FOV", CurrentValue = false,
    Callback = function(Value) FOVCircle.Visible = Value end,
})
CombatTab:CreateSlider({
    Name = "FOV Size", Range = {10, 800}, Increment = 1, CurrentValue = 100,
    Callback = function(Value) FOVRadius = Value; FOVCircle.Radius = Value end,
})
CombatTab:CreateToggle({
    Name = "ESP", CurrentValue = false,
    Callback = function(Value) ESPEnabled = Value end,
})
CombatTab:CreateToggle({
    Name = "Show Target Tracer", CurrentValue = false,
    Callback = function(Value) TracerEnabled = Value end,
})
CombatTab:CreateDropdown({
    Name = "Tracer Position", Options = {"Top", "Center", "Bottom"}, CurrentOption = {"Bottom"},
    Callback = function(Option) TracerPosition = Option[1] end,
})

-- Вкладка MM2
local MM2AimToggle = MM2Tab:CreateToggle({
    Name = "Aimlock Murder", CurrentValue = false,
    Callback = function(Value) MM2AimEnabled = Value end,
})
MM2Tab:CreateKeybind({
    Name = "MM2 Aim Bind", CurrentKeybind = "Q", HoldToInteract = false,
    Callback = function() MM2AimToggle:Set(not MM2AimEnabled) end,
})
MM2Tab:CreateToggle({
    Name = "ESP (Roles)", CurrentValue = false,
    Callback = function(Value) MM2ESPEnabled = Value end,
})

RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    UpdateESP()
    
    local TargetForTracer = GetClosestPlayerToCenter(true, false)
    local TargetForAim = MM2AimEnabled and GetClosestPlayerToCenter(false, true) or (AimlockEnabled and GetClosestPlayerToCenter(false, false))
    
    if TracerEnabled and TargetForTracer and TargetForTracer.Character then
        local part = TargetForTracer.Character:FindFirstChild(TargetPartName) or TargetForTracer.Character:FindFirstChild("HumanoidRootPart")
        if part then
            local Pos, OnScreen = Camera:WorldToViewportPoint(part.Position)
            if OnScreen then
                local StartPos = TracerPosition == "Top" and Vector2.new(Camera.ViewportSize.X / 2, 0) or (TracerPosition == "Center" and Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2) or Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y))
                TargetTracer.From = StartPos
                TargetTracer.To = Vector2.new(Pos.X, Pos.Y)
                TargetTracer.Visible = true
            else
                TargetTracer.Visible = false
            end
        else
            TargetTracer.Visible = false
        end
    else
        TargetTracer.Visible = false
    end

    if TargetForAim and TargetForAim.Character then
        local part = TargetForAim.Character:FindFirstChild(TargetPartName) or TargetForAim.Character:FindFirstChild("HumanoidRootPart")
        if part then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, part.Position), AimSensitivity)
        end
    end
end)

-- ======================================================
-- 3. MOVEMENT
-- ======================================================
local WallHopEnabled = false
local jumpLock = true
local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Blacklist

local function nearWall()
   local char = player.Character
   local hrp = char and char:FindFirstChild("HumanoidRootPart")
   if not hrp then return false end
   rayParams.FilterDescendantsInstances = {char}
   local dirs = { hrp.CFrame.LookVector, -hrp.CFrame.LookVector, hrp.CFrame.RightVector, -hrp.CFrame.RightVector }
   for _,d in ipairs(dirs) do
      if Workspace:Raycast(hrp.Position, d*3, rayParams) then return true end
   end
   return false
end

MovementTab:CreateToggle({
   Name = "Legit WallHop", CurrentValue = false,
   Callback = function(v) WallHopEnabled = v end
})

UserInputService.JumpRequest:Connect(function()
   if not WallHopEnabled or not jumpLock or not nearWall() then return end
   jumpLock = false
   local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
   if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
   task.wait(0.15)
   jumpLock = true
end)

local SpeedEnabled = false
local SpeedValue = 80

MovementTab:CreateToggle({
   Name = "Speed Glitch", CurrentValue = false,
   Callback = function(v) SpeedEnabled = v end
})
MovementTab:CreateSlider({
   Name = "Speed Value", Range = {16,500}, Increment = 1, CurrentValue = 80,
   Callback = function(v) SpeedValue = v end
})

RunService.Heartbeat:Connect(function()
   if not SpeedEnabled then return end
   local char = player.Character
   local hum = char and char:FindFirstChildOfClass("Humanoid")
   local hrp = char and char:FindFirstChild("HumanoidRootPart")
   if not hum or not hrp then return end

   if hum:GetState() == Enum.HumanoidStateType.Jumping or hum:GetState() == Enum.HumanoidStateType.Freefall then
      local dir = hum.MoveDirection
      if dir.Magnitude > 0 then
         hrp.AssemblyLinearVelocity = dir.Unit * SpeedValue + Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
      end
   end
end)

-- ======================================================
-- 4. COSMETICS (Chinese Hat, Trail, Forcefield)
-- ======================================================
-- Hat
local hatEnabled = false
local hatParts, hatTransparency, hatRainbow, hatColor = {}, 0.3, false, Color3.fromRGB(0, 255, 255)
local hatConnection

local function removeHat(char)
   if hatParts[char] then hatParts[char]:Destroy(); hatParts[char] = nil end
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
         if hatRainbow then hat.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1) else hat.Color = hatColor end
      end
   end
end

CosmeticsTab:CreateToggle({
   Name = "Enable Chinese Hat", CurrentValue = false,
   Callback = function(value)
      hatEnabled = value
      if value and player.Character then
         addHat(player.Character)
         if hatConnection then hatConnection:Disconnect() end
         hatConnection = RunService.Heartbeat:Connect(updateHats)
      else
         if player.Character then removeHat(player.Character) end
         if hatConnection then hatConnection:Disconnect(); hatConnection = nil end
      end
   end
})
CosmeticsTab:CreateToggle({
   Name = "Rainbow Hat", CurrentValue = false,
   Callback = function(value) hatRainbow = value; updateHats() end
})
CosmeticsTab:CreateColorPicker({
   Name = "Hat Color", Color = Color3.fromRGB(0, 255, 255),
   Callback = function(color)
      hatColor = color
      if hatEnabled and not hatRainbow then updateHats() end
   end
})

-- Trail
local trailEnabled = false
local trailParts, trailLifetime, trailTransparencyStart, trailRainbow, trailColorStatic = {}, 0.5, 0, false, Color3.fromRGB(0, 255, 255)
local trailConnection

local function removeTrail(char)
   if trailParts[char] then trailParts[char]:Destroy(); trailParts[char] = nil end
   if char and char:FindFirstChild("HumanoidRootPart") then
      local torso = char.HumanoidRootPart
      if torso:FindFirstChild("TrailAttach0") then torso.TrailAttach0:Destroy() end
      if torso:FindFirstChild("TrailAttach1") then torso.TrailAttach1:Destroy() end
   end
end
local function addTrail(character)
   local torso = character:WaitForChild("HumanoidRootPart")
   removeTrail(character)
   local attachment0 = Instance.new("Attachment", torso)
   attachment0.Name = "TrailAttach0"; attachment0.Position = Vector3.new(0, 2, 0)
   local attachment1 = Instance.new("Attachment", torso)
   attachment1.Name = "TrailAttach1"; attachment1.Position = Vector3.new(0, -2, 0)
   
   local trail = Instance.new("Trail")
   trail.Attachment0 = attachment0; trail.Attachment1 = attachment1
   trail.Lifetime = trailLifetime
   trail.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, trailTransparencyStart), NumberSequenceKeypoint.new(1, 1)})
   trail.Color = ColorSequence.new(trailColorStatic)
   trail.LightEmission = 0.7; trail.Enabled = true; trail.Parent = character
   trailParts[character] = trail
end
local function updateTrails()
   for char, trail in pairs(trailParts) do
      if trail and trail.Parent and char == player.Character then
         trail.Lifetime = trailLifetime
         trail.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, trailTransparencyStart), NumberSequenceKeypoint.new(1, 1)})
         if trailRainbow then trail.Color = ColorSequence.new(Color3.fromHSV(tick() % 5 / 5, 1, 1)) else trail.Color = ColorSequence.new(trailColorStatic) end
      end
   end
end

CosmeticsTab:CreateToggle({
   Name = "Enable Trail", CurrentValue = false,
   Callback = function(value)
      trailEnabled = value
      if value and player.Character then
         addTrail(player.Character)
         if trailConnection then trailConnection:Disconnect() end
         trailConnection = RunService.Heartbeat:Connect(updateTrails)
      else
         if player.Character then removeTrail(player.Character) end
         if trailConnection then trailConnection:Disconnect(); trailConnection = nil end
      end
   end
})
CosmeticsTab:CreateToggle({
   Name = "Rainbow Trail", CurrentValue = false,
   Callback = function(value) trailRainbow = value; updateTrails() end
})
CosmeticsTab:CreateColorPicker({
   Name = "Trail Color", Color = Color3.fromRGB(0, 255, 255),
   Callback = function(color)
      trailColorStatic = color
      if trailEnabled and not trailRainbow then updateTrails() end
   end
})

-- Forcefield
local ffEnabled = false
local ffColor, ffRainbow, originalColors, ffConnection = Color3.fromRGB(128, 128, 128), false, {}, nil

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
         part.Color = ffColor; part.Material = Enum.Material.ForceField
      end
   end
end
local function updateForceField()
   if player.Character and ffEnabled then
      for _, part in pairs(player.Character:GetDescendants()) do
         if part:IsA("BasePart") and part.Name ~= "Hat" and part.Material == Enum.Material.ForceField then
            if ffRainbow then part.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1) else part.Color = ffColor end
         end
      end
   end
end
local function removeForceField(char)
   if originalColors[char] then
      for part, data in pairs(originalColors[char]) do
         if part and part.Parent and part:IsA("BasePart") then
            part.Color = data.Color; part.Material = data.Material
         end
      end
      originalColors[char] = {}
   end
end

CosmeticsTab:CreateToggle({
   Name = "Enable ForceField", CurrentValue = false,
   Callback = function(value)
      ffEnabled = value
      if player.Character then
         if value then
            applyForceField(player.Character)
            if ffConnection then ffConnection:Disconnect() end
            ffConnection = RunService.Heartbeat:Connect(updateForceField)
         else
            if ffConnection then ffConnection:Disconnect(); ffConnection = nil end
            removeForceField(player.Character)
         end
      end
   end
})
CosmeticsTab:CreateToggle({
   Name = "Rainbow ForceField", CurrentValue = false,
   Callback = function(value) ffRainbow = value; updateForceField() end
})
CosmeticsTab:CreateColorPicker({
   Name = "ForceField Color", Color = Color3.fromRGB(128, 128, 128),
   Callback = function(color)
      ffColor = color
      if ffEnabled and not ffRainbow and player.Character then applyForceField(player.Character) end
   end
})

-- ======================================================
-- 5. VISUALS & SKY
-- ======================================================
local currentTime = Lighting.ClockTime
RunService.Heartbeat:Connect(function() Lighting.ClockTime = currentTime end)

VisualsTab:CreateSlider({
   Name = "Sky Time (0-24)", Range = {0, 24}, Increment = 0.1, CurrentValue = 12,
   Callback = function(value) currentTime = value end
})

local function clearSkies()
   for _, v in pairs(game.Lighting:GetChildren()) do
      if v:IsA("Sky") then v:Destroy() end
   end
end

VisualsTab:CreateButton({
   Name = "Custom Sky 1 (Original)",
   Callback = function()
      clearSkies()
      local s = Instance.new("Sky")
      s.SkyboxBk = "http://www.roblox.com/asset/?id=171410628"
      s.SkyboxDn = "http://www.roblox.com/asset/?id=171410649"
      s.SkyboxFt = "http://www.roblox.com/asset/?id=171410620"
      s.SkyboxLf = "http://www.roblox.com/asset/?id=171410666"
      s.SkyboxRt = "http://www.roblox.com/asset/?id=171410657"
      s.SkyboxUp = "http://www.roblox.com/asset/?id=171410636"
      s.Parent = game.Lighting
   end
})

VisualsTab:CreateButton({
   Name = "Custom Sky 2",
   Callback = function()
      clearSkies()
      local s = Instance.new("Sky")
      for k,v in pairs({Bk=17279854976,Dn=17279856318,Ft=17279858447,Lf=17279860360,Rt=17279862234,Up=17279864507}) do 
         s["Skybox"..k] = "rbxassetid://"..v 
      end 
      s.Parent = game.Lighting
   end
})

VisualsTab:CreateButton({
   Name = "Custom Sky 3",
   Callback = function()
      clearSkies()
      local s = Instance.new("Sky")
      for k,v in pairs({Bk=12064107,Dn=12064152,Ft=12064121,Lf=12063984,Rt=12064115,Up=12064131}) do 
         s["Skybox"..k] = "rbxassetid://"..v 
      end 
      s.Parent = game.Lighting
   end
})

local ratioConn
VisualsTab:CreateButton({
   Name = "Enable 4:3",
   Callback = function()
      if ratioConn then return end
      ratioConn = RunService.RenderStepped:Connect(function()
         camera.CFrame = camera.CFrame * CFrame.new(0,0,0,1,0,0,0,0.65,0,0,0,1)
      end)
   end
})
VisualsTab:CreateButton({
   Name = "Reset 4:3",
   Callback = function()
      if ratioConn then ratioConn:Disconnect(); ratioConn = nil end
   end
})

-- ======================================================
-- 6. MISC & AUTO-REAPPLY
-- ======================================================
local fpsPingEnabled, animeImageEnabled = false, false
local animeImageGui = nil

MiscTab:CreateButton({
   Name = "Activate FPS/Ping Counter",
   Callback = function()
      if not fpsPingEnabled then
         loadstring(game:HttpGet("https://raw.githubusercontent.com/GLAMOHGA/fling/refs/heads/main/хз%20как%20назвать%20типо%20фпс%20и%20пинг.md"))()
         fpsPingEnabled = true
         Rayfield:Notify({Title = "FPS/Ping Counter", Content = "Activated!", Duration = 3, Image = 4483362458})
      end
   end
})

local function toggleAnimeImage(value)
   animeImageEnabled = value
   if value then
      animeImageGui = Instance.new("ScreenGui", player.PlayerGui)
      animeImageGui.Name = "AnimeImageGui"
      animeImageGui.ResetOnSpawn = false
      local imageLabel = Instance.new("ImageLabel", animeImageGui)
      imageLabel.Image = "http://www.roblox.com/asset/?id=117783035423570"
      imageLabel.Size = UDim2.new(0, 350, 0, 400)
      imageLabel.Position = UDim2.new(1, -25, 0, 10)
      imageLabel.AnchorPoint = Vector2.new(1, 0)
      imageLabel.BackgroundTransparency = 1
      Rayfield:Notify({Title = "Anime Image", Content = "Activated!", Duration = 3, Image = 4483362458})
   else
      if animeImageGui then animeImageGui:Destroy(); animeImageGui = nil end
   end
end

MiscTab:CreateToggle({
   Name = "Anime Image", CurrentValue = false,
   Callback = function(value) toggleAnimeImage(value) end
})

RunService.Heartbeat:Connect(function()
   if Window.Flags then
      local isOpen = not Window.Flags.Minimized
      if isOpen then
         Lighting.Ambient = Color3.fromRGB(5, 5, 5)
         Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
         Lighting.ColorShift_Top = Color3.fromRGB(10, 10, 10)
      end
   end
end)

local function reapplyVisuals(char)
   task.wait(0.5)
   if hatEnabled then addHat(char) end
   if trailEnabled then addTrail(char) end
   if ffEnabled then applyForceField(char) end
   if animeImageEnabled then task.wait(0.5); toggleAnimeImage(true) end
end

player.CharacterAdded:Connect(reapplyVisuals)
if player.Character then reapplyVisuals(player.Character) end
