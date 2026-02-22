local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/ImInsane-1337/neverlose-ui/refs/heads/main/source/library.lua"))()
local CheatName = "vetrex"

Library.Folders = {
    Directory = CheatName,
    Configs = CheatName .. "/Configs",
    Assets = CheatName .. "/Assets",
}

local Accent = Color3.fromRGB(255, 0, 0)
local Gradient = Color3.fromRGB(100, 0, 0)

Library.Theme.Accent = Accent
Library.Theme.AccentGradient = Gradient
Library:ChangeTheme("Accent", Accent)
Library:ChangeTheme("AccentGradient", Gradient)

local Window = Library:Window({
    Name = "vetrex",
    SubName = "vetrex scripts (best script)",
    Logo = "120959262762131"
})

local KeybindList = Library:KeybindList("Keybinds")

local Players = game:GetService("Players")
local Run = game:GetService("RunService")
local Replicated = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local localPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local enemyCache = {}
local skeletonCache = {}
local espDrawings = {} 

local AAConnection

local WEAPON_TYPE = { knife = "Knife_Equip" }
local throwStartRemote = Replicated.Remotes:WaitForChild("ThrowStart")
local throwHitRemote = Replicated.Remotes:WaitForChild("ThrowHit")

local function GetCurrentVisualColor()
    if Library.Flags["RainbowMode"] then
        return Color3.fromHSV(tick() % 5 / 5, 1, 1)
    end
    local flagColor = Library.Flags["VisualColor"]
    if flagColor then
        if typeof(flagColor) == "Color3" then return flagColor
        elseif typeof(flagColor) == "table" and flagColor.Color then return flagColor.Color end
    end
    return Color3.fromRGB(255, 0, 0)
end

local function CreateLine()
    local l = Drawing.new("Line")
    l.Visible = false; l.From = Vector2.new(0, 0); l.To = Vector2.new(0, 0)
    l.Color = Color3.fromRGB(255, 0, 0); l.Thickness = 1; l.Transparency = 1
    return l
end

local function ClearSkeleton(player)
    if skeletonCache[player] then
        for _, line in pairs(skeletonCache[player]) do line:Remove() end
        skeletonCache[player] = nil
    end
end

local function UpdateSkeleton(player, character)
    if not Library.Flags["SkeletonESP"] then ClearSkeleton(player); return end
    if not skeletonCache[player] then
        skeletonCache[player] = {
            HeadTorso = CreateLine(), TorsoArmL = CreateLine(), TorsoArmR = CreateLine(),
            TorsoLegL = CreateLine(), TorsoLegR = CreateLine(), LowerArmL = CreateLine(),
            LowerArmR = CreateLine(), LowerLegL = CreateLine(), LowerLegR = CreateLine()
        }
    end
    local lines = skeletonCache[player]
    local isR15 = (character:FindFirstChild("UpperTorso") ~= nil)
    local skeletonColor = GetCurrentVisualColor()
    local function GetPos(partName)
        local part = character:FindFirstChild(partName)
        if part then
            local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
            if onScreen then return Vector2.new(pos.X, pos.Y), true end
        end
        return nil, false
    end
    local head, h_os = GetPos("Head")
    local torso = isR15 and GetPos("UpperTorso") or GetPos("Torso")
    local lowerTorso = isR15 and GetPos("LowerTorso") or torso
    local l_arm = isR15 and GetPos("LeftUpperArm") or GetPos("Left Arm")
    local r_arm = isR15 and GetPos("RightUpperArm") or GetPos("Right Arm")
    local l_leg = isR15 and GetPos("LeftUpperLeg") or GetPos("Left Leg")
    local r_leg = isR15 and GetPos("RightUpperLeg") or GetPos("Right Leg")
    local function draw(line, p1, p2)
        if p1 and p2 then line.From = p1; line.To = p2; line.Color = skeletonColor; line.Visible = true
        else line.Visible = false end
    end
    draw(lines.HeadTorso, head, torso)
    draw(lines.TorsoArmL, torso, l_arm); draw(lines.TorsoArmR, torso, r_arm)
    draw(lines.TorsoLegL, lowerTorso, l_leg); draw(lines.TorsoLegR, lowerTorso, r_leg)
    if isR15 then
        draw(lines.LowerArmL, l_arm, GetPos("LeftLowerArm"))
        draw(lines.LowerArmR, r_arm, GetPos("RightLowerArm"))
        draw(lines.LowerLegL, l_leg, GetPos("LeftLowerLeg"))
        draw(lines.LowerLegR, r_leg, GetPos("RightLowerLeg"))
    else
        lines.LowerArmL.Visible = false; lines.LowerArmR.Visible = false
        lines.LowerLegL.Visible = false; lines.LowerLegR.Visible = false
    end
end

local function RemoveNewESP(player)
    if espDrawings[player] then
        for _, d in pairs(espDrawings[player]) do d:Remove() end
        espDrawings[player] = nil
    end
end

local function UpdateNewESP(player)
    if not player or not player.Character or player == localPlayer then 
        RemoveNewESP(player) 
        return 
    end
    if player.Team and localPlayer.Team and player.Team == localPlayer.Team then
        RemoveNewESP(player)
        return
    end

    local hrp = player.

Character:FindFirstChild("HumanoidRootPart")
    local hum = player.Character:FindFirstChild("Humanoid")

    if not hrp or not hum or hum.Health <= 0 then
        RemoveNewESP(player)
        return
    end

    if not espDrawings[player] then
        espDrawings[player] = {
            Box = Drawing.new("Square"),
            Name = Drawing.new("Text"),
            Distance = Drawing.new("Text"),
            Tracer = Drawing.new("Line")
        }
        local d = espDrawings[player]
        d.Box.Thickness = 1.5; d.Box.Filled = false; d.Box.Visible = false
        d.Name.Center = true; d.Name.Size = 13; d.Name.Outline = true; d.Name.Visible = false
        d.Distance.Center = true; d.Distance.Size = 12; d.Distance.Outline = true; d.Distance.Visible = false
        d.Tracer.Thickness = 1; d.Tracer.Visible = false
    end

    local d = espDrawings[player]
    local color = GetCurrentVisualColor()
    local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)

    if onScreen then
        local h = (Camera:WorldToViewportPoint(hrp.Position + Vector3.new(0, 3, 0)).Y - Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0)).Y)
        h = math.abs(h)
        local w = h / 2

        if Library.Flags["BoxESP"] then
            d.Box.Visible = true; d.Box.Color = color; d.Box.Size = Vector2.new(w, h); d.Box.Position = Vector2.new(pos.X - w / 2, pos.Y - h / 2)
        else d.Box.Visible = false end

        if Library.Flags["NameESP"] then
            d.Name.Visible = true; d.Name.Text = player.Name; d.Name.Color = color; d.Name.Position = Vector2.new(pos.X, pos.Y - h / 2 - 15)
        else d.Name.Visible = false end

        if Library.Flags["DistESP"] then
            local dist = (localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")) and math.floor((localPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude) or 0
            d.Distance.Visible = true; d.Distance.Text = dist .. "m"; d.Distance.Color = color; d.Distance.Position = Vector2.new(pos.X, pos.Y + h / 2 + 5)
        else d.Distance.Visible = false end

        if Library.Flags["TracerESP"] then
            d.Tracer.Visible = true; d.Tracer.Color = color; d.Tracer.To = Vector2.new(pos.X, pos.Y)
            if Library.Flags["TracerOrigin"] == "Mouse" then d.Tracer.From = UserInputService:GetMouseLocation()
            elseif Library.Flags["TracerOrigin"] == "Center" then d.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
            else d.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y) end
        else d.Tracer.Visible = false end
    else
        d.Box.Visible = false; d.Name.Visible = false; d.Distance.Visible = false; d.Tracer.Visible = false
    end
end


local function updateCache()
    enemyCache = {}
    for _, enemy in pairs(Players:GetPlayers()) do
        if enemy and enemy ~= localPlayer and (not enemy.Team or enemy.Team ~= localPlayer.Team) then
            if enemy.Character and enemy.Character.Parent == Workspace then
                local targetPart = enemy.Character:FindFirstChild("HumanoidRootPart")
                if targetPart then enemyCache[enemy] = targetPart end
            end
        end
    end
    for p, _ in pairs(skeletonCache) do if not Players:FindFirstChild(p.Name) then ClearSkeleton(p) end end
end

local function ApplyAntiAim(character)
    if AAConnection then AAConnection:Disconnect() end
    local humanoid = character:WaitForChild("Humanoid", 10)
    local hrp = character:WaitForChild("HumanoidRootPart", 5)
    local isR15 = (humanoid.RigType == Enum.HumanoidRigType.R15)
    local torsoJoint = isR15 and character:WaitForChild("UpperTorso"):WaitForChild("Waist") or character:WaitForChild("Torso"):WaitForChild("Neck")
    local neckJoint = isR15 and character:WaitForChild("Head", 5):FindFirstChild("Neck") or character:WaitForChild("Torso", 5):FindFirstChild("Neck")

if not torsoJoint or not hrp then return end
    local originalTorsoC0 = torsoJoint.C0
    local originalNeckC0 = neckJoint and neckJoint.C0 or nil
    AAConnection = Run.RenderStepped:Connect(function()
        if not Library.Flags["AAEnabled"] or not character:IsDescendantOf(Workspace) then
            torsoJoint.C0 = originalTorsoC0
            if neckJoint and originalNeckC0 then neckJoint.C0 = originalNeckC0 end
            if AAConnection then AAConnection:Disconnect() end return
        end
        local mode = Library.Flags["AAMode"] or "Soft"
        local jitterIntensity = Library.Flags["AAJitter"] or 3
        local bend = Library.Flags["AABend"] or 1.2
        if mode == "Soft" then
            local intensity = jitterIntensity / 20 
            local rX, rY, rZ = math.rad(math.random(-15, 15) * intensity), math.rad(math.random(-25, 25) * intensity), math.rad(math.random(-15, 15) * intensity)
            torsoJoint.C0 = originalTorsoC0 * CFrame.Angles(bend + rX, rY, rZ)
        elseif mode == "Offset" then
            local offsetSpeed = tick() * 25
            local angleX, angleZ = math.sin(offsetSpeed) * (jitterIntensity * 0.4), math.cos(offsetSpeed * 0.8) * (jitterIntensity * 0.6)
            torsoJoint.C0 = originalTorsoC0 * CFrame.Angles(math.rad(angleX), math.rad(math.random(-180, 180)), math.rad(angleZ))
        end
        if neckJoint and originalNeckC0 then
            neckJoint.C0 = Library.Flags["AALookDown"] and originalNeckC0 * CFrame.Angles(math.rad(90), 0, 0) or originalNeckC0
        end
        if Library.Flags["AASpinbot"] then hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(Library.Flags["AASpinSpeed"] or 50), 0) end
    end)
end

local function equipWeapon(weaponType)
    local character = localPlayer.Character
    if not character or not character:FindFirstChild("Humanoid") then return end
    for _, tool in pairs(localPlayer.Backpack:GetChildren()) do
        if tool:GetAttribute("EquipAnimation") == weaponType then
            character.Humanoid:EquipTool(tool); return true
        end
    end
    return false
end

local function killAllKnife()
    local character = localPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = character.HumanoidRootPart
    for _, part in pairs(enemyCache) do
        task.spawn(function()
            if part and part.Parent then
                throwStartRemote:FireServer(hrp.Position, (part.Position - hrp.Position).Unit)
                throwHitRemote:FireServer(part, part.Position)
            end
        end)
    end
end

local function CreateChams()
    if not Library.Flags["JumpChams"] or not localPlayer.Character then return end
    local Folder = Instance.new("Model", Workspace); Folder.Name = "Valex_JumpCham"
    local color = GetCurrentVisualColor()
    for _, v in pairs(localPlayer.Character:GetChildren()) do
        if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
            local p = Instance.new("Part")
            p.Size = v.Size; p.CFrame = v.CFrame; p.Anchored = true; p.CanCollide = false
            p.Material = Enum.Material.Neon; p.Color = color; p.Transparency = 0.5; p.Parent = Folder
            TweenService:Create(p, TweenInfo.new(1), {Transparency = 1}):Play()
        end
    end
    task.delay(1.1, function() Folder:Destroy() end)
end

local function CreateJumpRings()
    if not Library.Flags["JumpChams2"] or not localPlayer.Character then return end
    local hrp = localPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local color = GetCurrentVisualColor()
    local ring = Instance.new("Part")
    ring.Name = "Valex_JumpRing"; ring.Shape = Enum.PartType.Cylinder; ring.Size = Vector3.new(0.1, 1, 1)
    ring.CFrame = CFrame.new(hrp.Position - Vector3.new(0, 3, 0)) * CFrame.Angles(0, 0, math.rad(90))
    ring.Anchored = true; ring.CanCollide = false; ring.Material = Enum.Material.Neon; ring.Color = color; ring.Transparency = 0.3; ring.Parent = Workspace
    local tweenInfo = TweenInfo.new(0.8, Enum.EasingStyle.

Quart, Enum.EasingDirection.Out)
    TweenService:Create(ring, tweenInfo, {Size = Vector3.new(0.1, 15, 15), Transparency = 1}):Play()
    task.delay(0.8, function() ring:Destroy() end)
end

---------------------------------------------------------
-- UI
---------------------------------------------------------

Window:Category("Main")
local RagePage = Window:Page({Name = "Rage", Icon = "138827881557940"})
local AuraSection = RagePage:Section({Name = "Kill Aura", Side = 1})
AuraSection:Toggle({Name = "Kill Loop (Knife)", Flag = "KillKnife"})
local HitboxSection = RagePage:Section({Name = "Hitbox Mods", Side = 1})
HitboxSection:Toggle({Name = "Extend Hitboxes", Flag = "HitboxEnabled"})
HitboxSection:Slider({Name = "Size", Flag = "HitboxSize", Min = 2, Max = 50, Default = 10})

local AASection = RagePage:Section({Name = "Anti-Aim", Side = 2})
AASection:Toggle({Name = "Enabled", Flag = "AAEnabled", Callback = function(v) if v and localPlayer.Character then ApplyAntiAim(localPlayer.Character) end end})
AASection:Dropdown({Name = "Mode", Flag = "AAMode", List = {"Soft", "Offset"}, Default = "Soft"})
AASection:Slider({Name = "Bend", Flag = "AABend", Min = 0.1, Max = 2, Default = 1.2, Decimals = 1})
AASection:Slider({Name = "Jitter Intensity", Flag = "AAJitter", Min = 0, Max = 10, Default = 3, Decimals = 1})
AASection:Toggle({Name = "Look Down", Flag = "AALookDown"})
AASection:Toggle({Name = "Spinbot", Flag = "AASpinbot"})
AASection:Slider({Name = "Spin Speed", Flag = "AASpinSpeed", Min = 1, Max = 100, Default = 50})

local VisualPage = Window:Page({Name = "Visuals", Icon = "138827881557940"})
local WorldSection = VisualPage:Section({Name = "World & Effects", Side = 1})
WorldSection:Toggle({Name = "Player ESP", Flag = "ESPEnabled"})
WorldSection:Toggle({Name = "Skeleton ESP", Flag = "SkeletonESP"})
WorldSection:Toggle({Name = "Trails", Flag = "Trails"})
WorldSection:Toggle({Name = "Jump Chams", Flag = "JumpChams"})
WorldSection:Toggle({Name = "Jump Chams 2 (Rings)", Flag = "JumpChams2"})
WorldSection:Toggle({Name = "World Color", Flag = "WorldColor"})
WorldSection:Toggle({Name = "Rainbow Mode", Flag = "RainbowMode"})
WorldSection:Toggle({Name = "Night Mode", Flag = "NightMode"})
WorldSection:Toggle({Name = "Fullbright", Flag = "Fullbright"})
WorldSection:Label("Global Visual Color"):Colorpicker({Name = "Color", Flag = "VisualColor", Default = Color3.fromRGB(255, 0, 0)})

local EspSection = VisualPage:Section({Name = "Extra 2D ESP", Side = 2})
EspSection:Toggle({Name = "Box ESP", Flag = "BoxESP"})
EspSection:Toggle({Name = "Name ESP", Flag = "NameESP"})
EspSection:Toggle({Name = "Distance ESP", Flag = "DistESP"})
EspSection:Toggle({Name = "Tracers (Lines)", Flag = "TracerESP"})
EspSection:Dropdown({Name = "Tracer Origin", Flag = "TracerOrigin", List = {"Bottom", "Center", "Mouse"}, Default = "Bottom"})

local PlayerPage = Window:Page({Name = "Player", Icon = "138827881557940"})
local MoveSection = PlayerPage:Section({Name = "Movement", Side = 1})
MoveSection:Toggle({Name = "Speed Glitch (Long Jump)", Flag = "SpeedGlitch"})
MoveSection:Slider({Name = "Jump Distance", Flag = "GlitchValue", Min = 1, Max = 25, Default = 8})
MoveSection:Toggle({Name = "Enable WalkSpeed", Flag = "WSEnabled"}) 
MoveSection:Slider({Name = "WalkSpeed Value", Flag = "WSValue", Min = 16, Max = 250, Default = 16})
MoveSection:Toggle({Name = "Infinite Jump", Flag = "InfJump"})
MoveSection:Toggle({Name = "Anti Stun", Flag = "AntiStun"})

Window:Category("Information")
local InfoPage = Window:Page({Name = "Info", Icon = "138827881557940"})
local InfoSection = InfoPage:Section({Name = "Release Info", Side = 1})
InfoSection:Label("vetrex scripts")
InfoSection:Label("Discord - https://discord.gg/bSCVptWePe")
InfoSection:Button({Name = "Copy Telegram Link", Callback = function() setclipboard("https://discord.gg/bSCVptWePe"); Library:Notification({Title = "Vetrex", Text = "Link copied!", Duration = 3}) end
        

Run.Heartbeat:Connect(function()

updateCache()
    local CurrentColor = GetCurrentVisualColor()
    if Library.Flags["KillKnife"] then equipWeapon(WEAPON_TYPE.knife); killAllKnife() end
    for enemy, hrp in pairs(enemyCache) do
        if Library.Flags["HitboxEnabled"] then
            hrp.Size = Vector3.new(Library.Flags["HitboxSize"], Library.Flags["HitboxSize"], Library.Flags["HitboxSize"])
            hrp.Color = CurrentColor; hrp.Transparency = 0.7
        end
        if Library.Flags["ESPEnabled"] then
            local hl = enemy.Character:FindFirstChild("ValexESP") or Instance.new("Highlight", enemy.Character)
            hl.Name = "ValexESP"; hl.FillColor = CurrentColor; hl.OutlineColor = Color3.new(1,1,1)
        elseif enemy.Character and enemy.Character:FindFirstChild("ValexESP") then enemy.Character.ValexESP:Destroy() end
        UpdateSkeleton(enemy, enemy.Character)
    end

    if Library.Flags["SpeedGlitch"] and localPlayer.Character then
        local hum = localPlayer.Character:FindFirstChildOfClass("Humanoid")
        local hrp = localPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hum and hrp and hum.MoveDirection.Magnitude > 0 then
            if hum.FloorMaterial == Enum.Material.Air then
                local Power = Library.Flags["GlitchValue"] or 8
                hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (Power / 10))
            end
        end
    end

    local char = localPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local trail = char.HumanoidRootPart:FindFirstChild("ValexTrail")
        if Library.Flags["Trails"] then
            if not trail then
                local a0, a1 = Instance.new("Attachment", char.HumanoidRootPart), Instance.new("Attachment", char.HumanoidRootPart)
                a0.Name, a1.Name = "TrailA0", "TrailA1"; a0.Position, a1.Position = Vector3.new(0, 1, 0), Vector3.new(0, -1, 0)
                trail = Instance.new("Trail", char.HumanoidRootPart); trail.Name = "ValexTrail"; trail.Attachment0, trail.Attachment1 = a0, a1; trail.Lifetime = 0.5
            end
            trail.Color = ColorSequence.new(CurrentColor)
        elseif trail then 
            if char.HumanoidRootPart:FindFirstChild("TrailA0") then char.HumanoidRootPart.TrailA0:Destroy() end
            if char.HumanoidRootPart:FindFirstChild("TrailA1") then char.HumanoidRootPart.TrailA1:Destroy() end
            trail:Destroy() 
        end
    end

    if Library.Flags["NightMode"] then Lighting.ClockTime, Lighting.Brightness, Lighting.ExposureCompensation = 0, 0, -1
    elseif Library.Flags["Fullbright"] then Lighting.ClockTime, Lighting.Brightness, Lighting.ExposureCompensation = 14, 2, 0.5
    else Lighting.ExposureCompensation = 0 end
    
    if Library.Flags["WorldColor"] then
        Lighting.Ambient, Lighting.OutdoorAmbient = CurrentColor, CurrentColor
        Lighting.ColorShift_Top, Lighting.ColorShift_Bottom = CurrentColor, CurrentColor
    else
        Lighting.Ambient, Lighting.OutdoorAmbient = Color3.fromRGB(0,0,0), Color3.fromRGB(127,127,127)
        Lighting.ColorShift_Top, Lighting.ColorShift_Bottom = Color3.fromRGB(0,0,0), Color3.fromRGB(0,0,0)
    end
end)

Run.RenderStepped:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do UpdateNewESP(player) end
end)

Players.PlayerRemoving:Connect(function(player) RemoveNewESP(player) end)

Run.RenderStepped:Connect(function()
    if localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then
        if Library.Flags["WSEnabled"] then
            localPlayer.Character.Humanoid.WalkSpeed = Library.Flags["WSValue"] or 16
        end
        if Library.Flags["AntiStun"] then for _, p in ipairs(localPlayer.Character:GetChildren()) do if p:IsA("BasePart") and p.Anchored then p.Anchored = false end end end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid") then
        if Library.Flags["InfJump"] then localPlayer.Character.Humanoid:ChangeState(3) end
        if Library.

Flags["JumpChams"] then CreateChams() end
        if Library.Flags["JumpChams2"] then CreateJumpRings() end
    end
end)

localPlayer.CharacterAdded:Connect(function(char) if Library.Flags["AAEnabled"] then task.wait(1); ApplyAntiAim(char) end end)

task.spawn(function()
    while true do
        Library:Watermark({ "vetrex beta", "FPS: " .. math.floor(1 / Run.RenderStepped:Wait()) })
        task.wait(0.5)
    end
end)

Window:Category("Settings")
local SettingsPage = Library:CreateSettingsPage(Window, KeybindList)
Window:Init()
