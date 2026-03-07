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

local Window = Rayfield:CreateWindow({
   Name = "vetrex visuals [premium]",
   LoadingTitle = "vetrex visuals",
   LoadingSubtitle = "By DottaWasCorupted",
   KeySystem = false,
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "UniversalHubConfig",
      FileName = "HubSave"
   },
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

local ProfileTab   = Window:CreateTab("Profile", "brain")
local CombatTab    = Window:CreateTab("Combat & Aim", "sword")
local VisualsTab   = Window:CreateTab("Visuals", "eye")
local OtherTab     = Window:CreateTab("Other", "cog")

local DEVELOPERS = { [9873358913] = "Developer" }
local DEVELOPERS = { [9424172543] = "co-develober" }
local ORIALDEV = { [10017073535] = "Orialdev" }

local function getStatus()
   if DEVELOPERS[player.UserId] then return DEVELOPERS[player.UserId]
   elseif ORIGINAL_DEVS[player.UserId] then return ORIGINAL_DEVS[player.UserId]
   else return "User" end
end

ProfileTab:CreateParagraph({
   Title = "Player Profile",
   Content = "Username: "..player.Name.."\nDisplayName: "..player.DisplayName.."\nUserId: "..player.UserId.."\nStatus: "..getStatus()
})

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

function addHat(char)
    local head = char:FindFirstChild("Head")
    if not head then return end

    if hatPart then
        hatPart:Destroy()
    end

    local hat = Instance.new("Part")
    hat.Name = "ChinaHat"
    hat.Anchored = false
    hat.CanCollide = false
    hat.Material = Enum.Material.Neon
    hat.Color = Color3.fromRGB(255,0,0)
    hat.Size = Vector3.new(2,1,2)

    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.MeshId = "rbxassetid://1033714"
    mesh.Scale = Vector3.new(2.5,2.5,2.5)
    mesh.Parent = hat

    local weld = Instance.new("Weld")
    weld.Part0 = head
    weld.Part1 = hat
    weld.C0 = CFrame.new(0,1.3,0)
    weld.Parent = hat

    hat.Parent = char
    hatPart = hat
end

function removeHat()
    if hatPart then
        hatPart:Destroy()
        hatPart = nil
    end
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

-- Combat UI
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

-- ======================================================
-- KEYSTROKES (FIXED VERSION - NO CALLBACK ERROR)
-- ======================================================

-- Глобальные настройки
getgenv().KeySize = 60
getgenv().KeysDraggable = false
getgenv().PressedKeyColor = Color3.fromRGB(100, 100, 255)

-- Создаём GUI СРАЗУ
local KeyStrokesGui = Instance.new("ScreenGui")
KeyStrokesGui.Name = "KeyStrokesPC_V6"
KeyStrokesGui.ResetOnSpawn = false
KeyStrokesGui.Parent = game:GetService("CoreGui")
KeyStrokesGui.Enabled = false

local KeyFrame = Instance.new("Frame")
KeyFrame.Parent = KeyStrokesGui
KeyFrame.BackgroundTransparency = 0.9
KeyFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
KeyFrame.Position = UDim2.new(0.02, 0, 0.6, 0)
KeyFrame.Size = UDim2.new(0, 195, 0, 170)
KeyFrame.Active = true
KeyFrame.Draggable = false

-- =============================
-- DRAG SYSTEM (SAFE)
-- =============================
local dragging = false
local dragStart, startPos

KeyFrame.InputBegan:Connect(function(input)
	if not getgenv().KeysDraggable then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = KeyFrame.Position
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		KeyFrame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

-- =============================
-- CREATE KEY FUNCTION
-- =============================
local function createKey(text, pos, size)
	local key = Instance.new("TextLabel")
	key.BackgroundColor3 = Color3.fromRGB(20,20,20)
	key.BackgroundTransparency = 0.3
	key.BorderSizePixel = 0
	key.Position = pos
	key.Size = size
	key.Font = Enum.Font.GothamBold
	key.Text = text
	key.TextColor3 = Color3.fromRGB(255,255,255)
	key.TextSize = 18
	key.Parent = KeyFrame
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0,6)
	corner.Parent = key
	
	return key
end

-- =============================
-- CREATE KEYS
-- =============================
local Keys = {
	W = createKey("W", UDim2.new(0,65,0,0), UDim2.new(0,60,0,60)),
	A = createKey("A", UDim2.new(0,0,0,65), UDim2.new(0,60,0,60)),
	S = createKey("S", UDim2.new(0,65,0,65), UDim2.new(0,60,0,60)),
	D = createKey("D", UDim2.new(0,130,0,65), UDim2.new(0,60,0,60)),
	L = createKey("LMB", UDim2.new(0,0,0,0), UDim2.new(0,60,0,60)),
	R = createKey("RMB", UDim2.new(0,130,0,0), UDim2.new(0,60,0,60)),
	Space = createKey("SPACE", UDim2.new(0,0,0,130), UDim2.new(0,190,0,35))
}

local keyMap = {
	[Enum.KeyCode.W] = Keys.W,
	[Enum.KeyCode.A] = Keys.A,
	[Enum.KeyCode.S] = Keys.S,
	[Enum.KeyCode.D] = Keys.D,
	[Enum.KeyCode.Space] = Keys.Space,
	[Enum.UserInputType.MouseButton1] = Keys.L,
	[Enum.UserInputType.MouseButton2] = Keys.R
}

-- =============================
-- INPUT LOGIC (SAFE)
-- =============================
UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	local key = keyMap[input.KeyCode] or keyMap[input.UserInputType]
	if key then
		key.BackgroundColor3 = getgenv().PressedKeyColor
		key.TextColor3 = Color3.fromRGB(0,0,0)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	local key = keyMap[input.KeyCode] or keyMap[input.UserInputType]
	if key then
		key.BackgroundColor3 = Color3.fromRGB(20,20,20)
		key.TextColor3 = Color3.fromRGB(255,255,255)
	end
end)

-- ======================================================
-- VETREX VISUALS V3.2 - UPGRADED CHARACTER AURA SYSTEM
-- ======================================================

VisualsTab:CreateSection("Character Aura System")

-- SETTINGS
local auraEnabled = false
local auraLightning = false
local auraAnime = false

local auraColor = Color3.fromRGB(0,255,255)
local auraHeight = 1.5
local auraTransparency = 0

-- NEW SETTINGS
local auraRadius = 3
local auraParticleSize = 0.6
local auraParticleCount = 12

local nameTagEnabled = false

local auraConnection
local auraAngle = 0

local nameTagFolder = Instance.new("Folder", workspace)
nameTagFolder.Name = "VetrexNameTags"

-- ===============================
-- AURA PARTICLE
-- ===============================

local function createAuraParticle(position)
	local part = Instance.new("Part")
	part.Anchored = true
	part.CanCollide = false
	part.Material = Enum.Material.Neon
	part.Size = Vector3.new(auraParticleSize, auraParticleSize, auraParticleSize)
	part.Shape = Enum.PartType.Ball
	part.Transparency = auraTransparency
	
	part.Color = auraAnime and Color3.fromHSV(tick()%5/5,1,1) or auraColor
	part.CFrame = CFrame.new(position)
	part.Parent = workspace
	
	if auraLightning then
		local light = Instance.new("PointLight")
		light.Range = 10
		light.Brightness = auraAnime and 6 or 3
		light.Color = part.Color
		light.Parent = part
	end
	
	task.delay(0.4,function()
		if part then part:Destroy() end
	end)
end

-- ===============================
-- START AURA LOOP
-- ===============================

local function startAura()
	if auraConnection then auraConnection:Disconnect() end
	
	auraConnection = RunService.Heartbeat:Connect(function(dt)
		if not auraEnabled then return end
		
		local char = LocalPlayer.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		if not hrp then return end
		
		auraAngle += (auraAnime and 6 or 3) * dt
		
		for i = 1, auraParticleCount do
			local offset = Vector3.new(
				math.cos(auraAngle + i) * auraRadius,
				auraHeight,
				math.sin(auraAngle + i) * auraRadius
			)
			createAuraParticle(hrp.Position + offset)
		end
	end)
end

-- ==========================================
-- FLOATING NAMETAG 3D SYSTEM (NO MM2 ROLES)
-- ==========================================

local nameTagEnabled = false

local nameTagFolder = Instance.new("Folder")
nameTagFolder.Name = "VetrexNameTags"
nameTagFolder.Parent = workspace

local function createNameTag(plr)
	if plr == LocalPlayer then return end
	
	local billboard = Instance.new("BillboardGui")
	billboard.Name = plr.Name .. "_NameTag"
	billboard.Size = UDim2.new(4,0,2,0)
	billboard.StudsOffset = Vector3.new(0,3,0)
	billboard.AlwaysOnTop = true
	billboard.Enabled = false
	billboard.Parent = nameTagFolder
	
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1,0,1,0)
	frame.BackgroundTransparency = 1
	frame.Parent = billboard
	
	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(1,0,0.5,0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.TextScaled = true
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextColor3 = Color3.fromRGB(255,255,255)
	nameLabel.TextStrokeTransparency = 0
	nameLabel.Parent = frame
	
	local hpBarBackground = Instance.new("Frame")
	hpBarBackground.Position = UDim2.new(0,0,0.65,0)
	hpBarBackground.Size = UDim2.new(1,0,0.2,0)
	hpBarBackground.BackgroundColor3 = Color3.fromRGB(40,40,40)
	hpBarBackground.BorderSizePixel = 0
	hpBarBackground.Parent = frame
	
	local hpBar = Instance.new("Frame")
	hpBar.Size = UDim2.new(1,0,1,0)
	hpBar.BorderSizePixel = 0
	hpBar.Parent = hpBarBackground
	
	RunService.Heartbeat:Connect(function()
		if not nameTagEnabled then
			billboard.Enabled = false
			return
		end
		
		if not plr.Character then return end
		local head = plr.Character:FindFirstChild("Head")
		local hum = plr.Character:FindFirstChildOfClass("Humanoid")
		local myChar = LocalPlayer.Character
		local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
		
		if not head or not hum or not myHRP then return end
		
		billboard.Enabled = true
		billboard.Adornee = head
		
		local distance = (myHRP.Position - head.Position).Magnitude
		nameLabel.Text = plr.Name .. " | " .. math.floor(distance) .. "m"
		
		local hpPercent = hum.Health / hum.MaxHealth
		hpBar.Size = UDim2.new(hpPercent,0,1,0)
		
		if hpPercent > 0.5 then
			hpBar.BackgroundColor3 = Color3.fromRGB(0,255,0)
		elseif hpPercent > 0.25 then
			hpBar.BackgroundColor3 = Color3.fromRGB(255,170,0)
		else
			hpBar.BackgroundColor3 = Color3.fromRGB(255,0,0)
		end
	end)
end

-- Создаём для всех игроков
for _, plr in pairs(Players:GetPlayers()) do
	createNameTag(plr)
end

-- Для новых игроков
Players.PlayerAdded:Connect(function(plr)
	createNameTag(plr)
end)

-- ===============================
-- UI CONTROLS
-- ===============================

VisualsTab:CreateToggle({
	Name = "Enable Aura",
	CurrentValue = false,
	Callback = function(v)
		auraEnabled = v
		if v then startAura()
		elseif auraConnection then auraConnection:Disconnect() end
	end
})

VisualsTab:CreateToggle({
	Name = "Lightning Effect",
	CurrentValue = false,
	Callback = function(v)
		auraLightning = v
	end
})

VisualsTab:CreateToggle({
	Name = "Rainbow Mode",
	CurrentValue = false,
	Callback = function(v)
		auraAnime = v
	end
})

VisualsTab:CreateColorPicker({
	Name = "Aura Color",
	Color = Color3.fromRGB(0,255,255),
	Callback = function(c)
		auraColor = c
	end
})

VisualsTab:CreateSlider({
	Name = "Aura Height",
	Range = {-5, 10},
	Increment = 0.5,
	CurrentValue = 1.5,
	Callback = function(v)
		auraHeight = v
	end
})

VisualsTab:CreateSlider({
	Name = "Aura Transparency",
	Range = {0, 1},
	Increment = 0.05,
	CurrentValue = 0,
	Callback = function(v)
		auraTransparency = v
	end
})

VisualsTab:CreateSlider({
	Name = "Aura Radius",
	Range = {1, 10},
	Increment = 0.5,
	CurrentValue = 3,
	Callback = function(v)
		auraRadius = v
	end
})

VisualsTab:CreateSlider({
	Name = "Particle Size",
	Range = {0.2, 3},
	Increment = 0.1,
	CurrentValue = 0.6,
	Callback = function(v)
		auraParticleSize = v
	end
})

VisualsTab:CreateSlider({
	Name = "Particle Count",
	Range = {3, 40},
	Increment = 1,
	CurrentValue = 12,
	Callback = function(v)
		auraParticleCount = v
	end
})

VisualsTab:CreateToggle({
	Name = "Floating NameTag 3D",
	CurrentValue = false,
	Callback = function(v)
		nameTagEnabled = v
	end
})

VisualsTab:CreateSection("Keystrokes")

VisualsTab:CreateToggle({
	Name = "Show Pressed Keys",
	CurrentValue = false,
	Callback = function(v)
		if KeyStrokesGui then
			KeyStrokesGui.Enabled = v
		end
	end
})

VisualsTab:CreateToggle({
	Name = "Unlock Position",
	CurrentValue = false,
	Callback = function(v)
		getgenv().KeysDraggable = v
		KeyFrame.BackgroundTransparency = v and 0.6 or 0.9
	end
})

VisualsTab:CreateColorPicker({
	Name = "Pressed Color",
	Color = Color3.fromRGB(100,100,255),
	Callback = function(v)
		getgenv().PressedKeyColor = v
	end
})
-- ==========================================
-- ОСНОВНОЙ ЦИКЛ ОБНОВЛЕНИЯ (ИСПРАВЛЕНО)
-- ==========================================
local function getTargetPart(char)
    -- Используем локальную переменную TargetPartName, которую меняет меню
    if TargetPartName == "Torso" then
        return char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart")
    end
    return char:FindFirstChild("Head")
end

local function GetClosestPlayer()
    local target = nil
    local dist = FOVRadius
    -- Центр экрана для расчетов
    local ScreenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            local p = getTargetPart(v.Character)
            if p then
                local pos, vis = Camera:WorldToViewportPoint(p.Position)
                if vis then
                    -- Считаем дистанцию от центра экрана, а не от мышки
                    local m = (Vector2.new(pos.X, pos.Y) - ScreenCenter).Magnitude
                    if m < dist then 
                        if VisibleCheckEnabled and not IsVisible(p) then continue end
                        target = v 
                        dist = m 
                    end
                end
            end
        end
    end
    return target
end

RunService.RenderStepped:Connect(function()
    -- Обновляем положение круга FOV (всегда в центре экрана)
    if FOVCircle then
        FOVCircle.Radius = FOVRadius
        FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    end

    -- ВАЖНО: Вызываем функцию ESP, чтобы она обновляла подсветку каждый кадр
    UpdateESP()

    local Target = GetClosestPlayer()

    -- Логика Аимлока
    if AimlockEnabled and Target and Target.Character then
        local p = getTargetPart(Target.Character)
        if p then
            local targetCFrame = CFrame.new(Camera.CFrame.Position, p.Position)
            Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, AimSensitivity)
        end
    end

    -- Логика Трассера (линия от центра экрана к цели)
    if TracerEnabled and Target and Target.Character then
        local p = getTargetPart(Target.Character)
        if p then
            local vec, vis = Camera:WorldToViewportPoint(p.Position)
            if vis then
                TargetTracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                TargetTracer.To = Vector2.new(vec.X, vec.Y)
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
end)
-- ======================================================
-- ПАРАМЕТРЫ НИМБА (ГЛОБАЛЬНЫЕ)
-- ======================================================
local haloEnabled = false
local haloRainbow = false
local haloColor = Color3.fromRGB(255, 255, 0)
local haloTransparency = 0
local haloHeight = 1.1   -- Высота (Distance)
local haloScaleValue = 1.7 -- Размер (Size)
local haloParts = {}
local haloConnection -- ДОБАВЛЕНА переменная для цикла

-- ======================================================
-- ФУНКЦИИ НИМБА
-- ======================================================
local function removeHalo(char)
    if haloParts[char] then
        haloParts[char]:Destroy()
        haloParts[char] = nil
    end
end

local function addHalo(char)
    task.wait(0.1)
    local head = char:WaitForChild("Head")
    removeHalo(char)

    local halo = Instance.new("Part")
    halo.Name = "AngelHalo"
    halo.Size = Vector3.new(1.5, 0.2, 1.5)
    halo.Material = Enum.Material.Neon
    halo.Color = haloColor
    halo.Transparency = haloTransparency
    halo.CanCollide = false
    halo.Massless = true

    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.MeshId = "rbxassetid://3270017"
    mesh.Scale = Vector3.new(haloScaleValue, haloScaleValue, 0.8) 
    mesh.Parent = halo

    -- ЭФФЕКТ СВЕЧЕНИЯ (GLOW)
    local glow = Instance.new("PointLight")
    glow.Name = "HaloGlow"
    glow.Color = haloColor
    glow.Brightness = 5 
    glow.Range = 8      
    glow.Shadows = false
    glow.Parent = halo

    local weld = Instance.new("Weld")
    weld.Part0 = head
    weld.Part1 = halo
    weld.C0 = CFrame.new(0, haloHeight, 0) * CFrame.Angles(math.rad(90), 0, 0)
    weld.Parent = halo

    halo.Parent = char
    haloParts[char] = halo
end

-- ДОБАВЛЕНА функция обновления цвета (для Rainbow и смены цвета)
local function updateHalo()
   for char, halo in pairs(haloParts) do
      if halo and halo.Parent and char == player.Character then
         -- Если радуга включена - генерируем цвет, если нет - используем выбранный haloColor
         local currentColor = haloRainbow and Color3.fromHSV(tick() % 5 / 5, 1, 1) or haloColor
         halo.Color = currentColor
         
         local glow = halo:FindFirstChild("HaloGlow")
         if glow then glow.Color = currentColor end
      end
   end
end

-- ======================================================
-- ЭЛЕМЕНТЫ УПРАВЛЕНИЯ (VISUALS)
-- ======================================================
VisualsTab:CreateSection("Angel Halo Settings")

VisualsTab:CreateToggle({
    Name = "Enable Angel Halo",
    CurrentValue = false,
    Callback = function(v)
        haloEnabled = v
        if v and player.Character then 
            addHalo(player.Character) 
            -- Подключаем цикл обновления при появлении нимба
            if haloConnection then haloConnection:Disconnect() end
            haloConnection = RunService.Heartbeat:Connect(updateHalo)
        else 
            if player.Character then removeHalo(player.Character) end 
            -- Отключаем цикл, когда нимб не нужен (для оптимизации)
            if haloConnection then haloConnection:Disconnect(); haloConnection = nil end
        end
    end
})

-- Слайдер размера
VisualsTab:CreateSlider({
    Name = "Halo Size",
    Range = {0.5, 4},
    Increment = 0.1,
    CurrentValue = 1.7,
    Callback = function(v)
        haloScaleValue = v
        if haloParts[player.Character] then
            local mesh = haloParts[player.Character]:FindFirstChildOfClass("SpecialMesh")
            if mesh then
                mesh.Scale = Vector3.new(v, v, 0.8)
            end
        end
    end
})

-- Слайдер высоты
VisualsTab:CreateSlider({
    Name = "Halo Distance (Height)",
    Range = {0.5, 2.5},
    Increment = 0.1,
    CurrentValue = 1.1,
    Callback = function(v)
        haloHeight = v
        if haloParts[player.Character] then
            local weld = haloParts[player.Character]:FindFirstChildOfClass("Weld")
            if weld then
                weld.C0 = CFrame.new(0, v, 0) * CFrame.Angles(math.rad(90), 0, 0)
            end
        end
    end
})

VisualsTab:CreateToggle({
    Name = "Rainbow Halo", 
    CurrentValue = false, 
    Callback = function(v) 
        haloRainbow = v 
        if not v and haloEnabled then updateHalo() end -- Возвращаем статичный цвет при выключении
    end
})

VisualsTab:CreateColorPicker({
    Name = "Halo Color & Glow",
    Color = Color3.fromRGB(255, 255, 0),
    Callback = function(c)
        haloColor = c
        if haloEnabled and not haloRainbow then updateHalo() end
    end
})

-- ======================================================
-- OTHER
-- ======================================================
OtherTab:CreateSection("Miscellaneous")
OtherTab:CreateToggle({Name = "FPS/Ping Counter", CurrentValue = false, Callback = function(v)
    if v then loadstring(game:HttpGet("https://raw.githubusercontent.com/GLAMOHGA/fling/refs/heads/main/хз%20как%20назвать%20типо%20фпс%20и%20пинг.md"))()
    else for _, gui in pairs(player.PlayerGui:GetChildren()) do if gui:IsA("ScreenGui") and (gui:FindFirstChild("FPS") or gui:FindFirstChild("Ping")) then gui:Destroy() end end end
end})

VisualsTab:CreateSection("China hat")
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

VisualsTab:CreateToggle({
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

VisualsTab:CreateToggle({
   Name = "Rainbow Hat",
   CurrentValue = false,
   Flag = "HatRainbow",
   Callback = function(value)
      hatRainbow = value
      updateHats()
   end
})

VisualsTab:CreateSlider({
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

VisualsTab:CreateColorPicker({
   Name = "Hat Color",
   Color = Color3.fromRGB(0, 255, 255),
   Flag = "HatColor",
   Callback = function(color)
      hatColor = color
      updateHats()
   end
})

-- Trail Logic
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

-- Секция для Trail
VisualsTab:CreateSection("trail")

VisualsTab:CreateToggle({
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

VisualsTab:CreateToggle({
   Name = "Rainbow Trail", CurrentValue = false,
   Callback = function(value) trailRainbow = value; updateTrails() end
})

VisualsTab:CreateColorPicker({
   Name = "Trail Color", Color = Color3.fromRGB(0, 255, 255),
   Callback = function(color) trailColorStatic = color; if trailEnabled and not trailRainbow then updateTrails() end end
})
-- ==========================================
-- TRAIL LIBRARY (НОВОЕ)
-- ==========================================
VisualsTab:CreateSection("Trail Library")

local currentTrail = nil
local trailEnabled = false
local selectedTrailType = "Sword Trail"

local function clearTrails(char)
    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("Trail") or v.Name == "TrailAttachmentTop" or v.Name == "TrailAttachmentBottom" then
            v:Destroy()
        end
    end
end

local function applyTrail()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    clearTrails(char)
    if not trailEnabled then return end
    
    local hrp = char.HumanoidRootPart
    
    local attTop = Instance.new("Attachment", hrp)
    attTop.Name = "TrailAttachmentTop"
    attTop.Position = Vector3.new(0, 1, 0)
    
    local attBottom = Instance.new("Attachment", hrp)
    attBottom.Name = "TrailAttachmentBottom"
    attBottom.Position = Vector3.new(0, -1, 0)
    
    local trail = Instance.new("Trail")
    trail.Attachment0 = attTop
    trail.Attachment1 = attBottom
    trail.Lifetime = 0.5
    trail.LightEmission = 1
    trail.Transparency = NumberSequence.new(0.2, 1)
    trail.Parent = hrp
    
    if selectedTrailType == "Sword Trail" then
        trail.Color = ColorSequence.new(Color3.fromRGB(200, 200, 200), Color3.fromRGB(100, 100, 100))
        trail.WidthScale = NumberSequence.new(1, 0)
    elseif selectedTrailType == "Lightning" then
        trail.Color = ColorSequence.new(Color3.fromRGB(0, 255, 255))
        trail.Texture = "rbxassetid://281983280"
        trail.TextureMode = Enum.TextureMode.Wrap
    elseif selectedTrailType == "Galaxy" then
        trail.Color = ColorSequence.new(Color3.fromRGB(150, 0, 255), Color3.fromRGB(0, 255, 255))
        trail.Texture = "rbxassetid://1265811370"
        trail.Lifetime = 0.8
    elseif selectedTrailType == "Flame" then
        trail.Color = ColorSequence.new(Color3.fromRGB(255, 100, 0), Color3.fromRGB(255, 0, 0))
        trail.Texture = "rbxassetid://244221440"
    end
end

VisualsTab:CreateToggle({
    Name = "Enable Trail",
    CurrentValue = false,
    Callback = function(v)
        trailEnabled = v
        applyTrail()
    end
})

VisualsTab:CreateDropdown({
    Name = "Trail Type",
    Options = {"Sword Trail", "Lightning", "Galaxy", "Flame"},
    CurrentOption = {"Sword Trail"},
    Callback = function(Option)
        selectedTrailType = Option[1]
        if trailEnabled then applyTrail() end
    end
})

-- Обновление трейла при респавне
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if trailEnabled then applyTrail() end
end)


-- Forcefield Logic
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

VisualsTab:CreateSection("ForceField")

VisualsTab:CreateToggle({
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

VisualsTab:CreateToggle({
   Name = "Rainbow ForceField", CurrentValue = false,
   Callback = function(value) ffRainbow = value; updateForceField() end
})

VisualsTab:CreateColorPicker({
   Name = "ForceField Color", Color = Color3.fromRGB(128, 128, 128),
   Callback = function(color) ffColor = color; if ffEnabled and not ffRainbow and player.Character then applyForceField(player.Character) end end
})

VisualsTab:CreateSection("Environment & Sky")

local currentTime = Lighting.ClockTime
RunService.Heartbeat:Connect(function() Lighting.ClockTime = currentTime end)

VisualsTab:CreateSlider({
   Name = "Sky Time (0-24)", Range = {0, 24}, Increment = 0.1, CurrentValue = 12,
   Callback = function(value) currentTime = value end
})

local function clearSkies()
   for _, v in pairs(game.Lighting:GetChildren()) do if v:IsA("Sky") then v:Destroy() end end
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
      ratioConn = RunService.RenderStepped:Connect(function() camera.CFrame = camera.CFrame * CFrame.new(0,0,0,1,0,0,0,0.65,0,0,0,1) end)
   end
})

VisualsTab:CreateButton({
   Name = "Reset 4:3",
   Callback = function() if ratioConn then ratioConn:Disconnect(); ratioConn = nil end end
})

-- ======================================================
-- 4. OTHER (MOVEMENT + MISC)
-- ======================================================
OtherTab:CreateSection("wallhop | speed glich")

local WallHopEnabled = false
local wallhopDebounce = true
local wallhopRayParams = RaycastParams.new()
wallhopRayParams.FilterType = Enum.RaycastFilterType.Blacklist

local function getWallRaycastResult()
    local char = player.Character
    if not char then return nil end
    local humanoidRootPart = char:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return nil end

    wallhopRayParams.FilterDescendantsInstances = {char}

    local directions = {
        humanoidRootPart.CFrame.LookVector,
        -humanoidRootPart.CFrame.LookVector,
        humanoidRootPart.CFrame.RightVector,
        -humanoidRootPart.CFrame.RightVector
    }
    local detectionDistance = 2
    local closestHit = nil
    local minDistance = detectionDistance + 1

    for _, direction in pairs(directions) do
        local ray = Workspace:Raycast(
            humanoidRootPart.Position,
            direction * detectionDistance,
            wallhopRayParams
        )
        if ray and ray.Instance then
             if ray.Distance < minDistance then
                 minDistance = ray.Distance
                 closestHit = ray
             end
        end
    end
    return closestHit
end

-- Wallhop UI
local WallhopToggle = OtherTab:CreateToggle({
   Name = "Wallhop", 
   CurrentValue = false,
   Callback = function(v) WallHopEnabled = v end
})

OtherTab:CreateKeybind({
    Name = "Wallhop Bind",
    CurrentKeybind = "J",
    HoldToInteract = false,
    Callback = function()
        WallhopToggle:Set(not WallHopEnabled)
    end,
})

UserInputService.JumpRequest:Connect(function()
    if not WallHopEnabled or not wallhopDebounce then return end

    local char = player.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    local rootPart = char and char:FindFirstChild("HumanoidRootPart")

    if not (humanoid and rootPart and camera) then return end

    local wallRayResult = getWallRaycastResult()

    if wallRayResult then
        wallhopDebounce = false
        local wallNormal = wallRayResult.Normal
        local horizontalWallNormal = Vector3.new(wallNormal.X, 0, wallNormal.Z).Unit
        if horizontalWallNormal.Magnitude < 0.1 then
             horizontalWallNormal = (rootPart.CFrame.LookVector * Vector3.new(1,0,1)).Unit
             if horizontalWallNormal.Magnitude < 0.1 then horizontalWallNormal = Vector3.new(0,0,-1) end
        end
        local baseDirectionAwayFromWall = horizontalWallNormal
        local cameraLook = camera.CFrame.LookVector
        local horizontalCameraLook = Vector3.new(cameraLook.X, 0, cameraLook.Z).Unit
        if horizontalCameraLook.Magnitude < 0.1 then horizontalCameraLook = baseDirectionAwayFromWall end
        local maxInfluenceAngle = math.rad(40)
        local dot = math.clamp(baseDirectionAwayFromWall:Dot(horizontalCameraLook), -1, 1)
        local angleBetween = math.acos(dot)
        local cross = baseDirectionAwayFromWall:Cross(horizontalCameraLook)
        local rotationSign = math.sign(cross.Y)
        if rotationSign == 0 then angleBetween = 0 end
        local actualInfluenceAngle = math.min(angleBetween, maxInfluenceAngle)
        local adjustmentRotation = CFrame.Angles(0, actualInfluenceAngle * rotationSign, 0)
        local initialTargetLookDirection = adjustmentRotation * baseDirectionAwayFromWall
        rootPart.CFrame = CFrame.lookAt(rootPart.Position, rootPart.Position + initialTargetLookDirection)
        RunService.Heartbeat:Wait()
        local didJump = false
        if humanoid and humanoid:GetState() ~= Enum.HumanoidStateType.Dead then
             humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
             didJump = true
        end
        if didJump then
             local directionTowardsWall = -baseDirectionAwayFromWall
             rootPart.CFrame = CFrame.lookAt(rootPart.Position, rootPart.Position + directionTowardsWall)
        end
        task.wait(0.15)
        wallhopDebounce = true
    end
end)

-- Speed Glitch UI
local SpeedEnabled = false
local SpeedValue = 80

local SpeedToggle = OtherTab:CreateToggle({
   Name = "Speed Glitch", CurrentValue = false,
   Callback = function(v) SpeedEnabled = v end
})

OtherTab:CreateKeybind({
    Name = "Speed Glitch Bind",
    CurrentKeybind = "L",
    HoldToInteract = false,
    Callback = function()
        SpeedToggle:Set(not SpeedEnabled)
    end,
})

OtherTab:CreateSlider({
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

OtherTab:CreateSection("Desync")

-- =============================
-- DESYNC: ФИКС ДЛЯ ТЕЛЕФОНОВ (ДЖОЙСТИК + ПРЫЖОК)
-- =============================
local desyncEnabled = false
local desyncSpeed = 16
local desyncAnchor = nil 
local desyncConnection = nil
local jumpConnection = nil

-- Физика прыжка
local verticalVelocity = 0
local jumpPower = 50
local gravity = 100
local groundY = 0

-- СОЗДАНИЕ UI ДЛЯ ЭКРАНА
local ScreenGui = Instance.new("ScreenGui")
local MainButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")

ScreenGui.Name = "DesyncGui"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.Enabled = false 

MainButton.Name = "DesyncControlButton"
MainButton.Parent = ScreenGui
MainButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainButton.BackgroundTransparency = 0.2
MainButton.Position = UDim2.new(0.1, 0, 0.5, 0)
MainButton.Size = UDim2.new(0, 80, 0, 80)
MainButton.Font = Enum.Font.GothamBlack 
MainButton.Text = "DESYNC"
MainButton.TextColor3 = Color3.fromRGB(255, 50, 50)
MainButton.TextSize = 16.0
MainButton.Draggable = true 

UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainButton
UIStroke.Parent = MainButton
UIStroke.Thickness = 3
UIStroke.Color = Color3.fromRGB(255, 50, 50)

-- ГЛАВНАЯ ФУНКЦИЯ ЛОГИКИ
local function UpdateDesyncState(state)
    desyncEnabled = state
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    
    if desyncEnabled then
        MainButton.TextColor3 = Color3.fromRGB(50, 255, 50)
        UIStroke.Color = Color3.fromRGB(50, 255, 50)
        
        if char and hrp and hum then
            -- СОЗДАЕМ ФАНТОМА
            char.Archivable = true
            desyncAnchor = char:Clone()
            char.Archivable = false
            desyncAnchor.Name = "DesyncPhantom"
            desyncAnchor.Parent = workspace
            
            for _, part in pairs(desyncAnchor:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 0.6
                    part.CanCollide = false
                elseif part:IsA("Decal") then
                    part.Transparency = 0.6
                end
            end
            
            local phantomHRP = desyncAnchor:FindFirstChild("HumanoidRootPart")
            if phantomHRP then phantomHRP.Anchored = true end

            -- Очистка фантома
            for _, item in pairs(desyncAnchor:GetDescendants()) do
                if item:IsA("LocalScript") or item:IsA("Script") or item:IsA("Sound") then
                    item:Destroy()
                end
            end

            groundY = hrp.Position.Y
            verticalVelocity = 0
            hrp.Anchored = true
            camera.CameraSubject = phantomHRP
            
            -- ФИКС ДВИЖЕНИЯ (Heartbeat)
            desyncConnection = RunService.Heartbeat:Connect(function(dt)
                if not phantomHRP or not hum then return end
                
                -- ПОЛУЧАЕМ НАПРАВЛЕНИЕ ИЗ ДЖОЙСТИКА ИЛИ WASD
                local moveDir = hum.MoveDirection 
                
                -- Гравитация
                if phantomHRP.Position.Y > groundY or verticalVelocity > 0 then
                    verticalVelocity = verticalVelocity - (gravity * dt)
                else
                    verticalVelocity = 0
                end
                
                -- Рассчитываем движение
                local horizontalMove = moveDir * desyncSpeed * dt
                local verticalMove = Vector3.new(0, verticalVelocity * dt, 0)
                local newPos = phantomHRP.Position + horizontalMove + verticalMove
                
                -- Пол
                if newPos.Y < groundY then newPos = Vector3.new(newPos.X, groundY, newPos.Z) end
                
                -- Поворот фантома в сторону движения
                if moveDir.Magnitude > 0 then
                    phantomHRP.CFrame = CFrame.new(newPos, newPos + moveDir)
                else
                    phantomHRP.CFrame = CFrame.new(newPos, newPos + phantomHRP.CFrame.LookVector)
                end
            end)

            -- ФИКС ПРЫЖКА ДЛЯ ТЕЛЕФОНА
            jumpConnection = UserInputService.JumpRequest:Connect(function()
                if phantomHRP and phantomHRP.Position.Y <= groundY + 0.1 then
                    verticalVelocity = jumpPower
                end
            end)
        end
    else
        -- ВЫКЛЮЧЕНИЕ
        MainButton.TextColor3 = Color3.fromRGB(255, 50, 50)
        UIStroke.Color = Color3.fromRGB(255, 50, 50)
        
        if desyncConnection then desyncConnection:Disconnect(); desyncConnection = nil end
        if jumpConnection then jumpConnection:Disconnect(); jumpConnection = nil end
        
        if desyncAnchor and hrp then
            local phantomHRP = desyncAnchor:FindFirstChild("HumanoidRootPart")
            if phantomHRP then hrp.CFrame = phantomHRP.CFrame end
            desyncAnchor:Destroy(); desyncAnchor = nil
        end
        if hrp then hrp.Anchored = false end
        if hum then camera.CameraSubject = hum end
    end
end

-- СИНХРОНИЗАЦИЯ КНОПОК
local DesyncMainToggle = OtherTab:CreateToggle({
    Name = "Enable Desync",
    CurrentValue = false,
    Callback = function(v) UpdateDesyncState(v) end
})

MainButton.MouseButton1Click:Connect(function()
    DesyncMainToggle:Set(not desyncEnabled)
end)

OtherTab:CreateToggle({
    Name = "Show Screen Button (Mobile)",
    CurrentValue = false,
    Callback = function(v) ScreenGui.Enabled = v end
})

OtherTab:CreateKeybind({
    Name = "Desync Keybind",
    CurrentKeybind = "X",
    HoldToInteract = false,
    Callback = function() DesyncMainToggle:Set(not desyncEnabled) end,
})

OtherTab:CreateSlider({
    Name = "Desync Speed",
    Range = {16, 150},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(v) desyncSpeed = v end
})

-- Glow Effect Logic
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

player.CharacterAdded:Connect(function(char) task.wait(0.5); if haloEnabled then addHalo(char) end end)

local korbloxEnabled = false
local headlessEnabled = false

VisualsTab:CreateToggle({
   Name = "Korblox",
   CurrentValue = false,
   Flag = "KorbloxToggle",
   Callback = function(value)
      korbloxEnabled = value
      if value then
         getgenv().Mscuaz_Korblox = true
         getgenv().Mscuaz_Headless = false
         getgenv().MscuazScriptIsTheBest = "MscuazScripter"
         loadstring(game:HttpGet('https://raw.githubusercontent.com/gwnrdt/Try/refs/heads/main/Headless%26Korblox.lua'))()
      else
         getgenv().Mscuaz_Korblox = false
      end
   end
})

VisualsTab:CreateToggle({
   Name = "Headless",
   CurrentValue = false,
   Flag = "HeadlessToggle",
   Callback = function(value)
      headlessEnabled = value
      if value then
         getgenv().Mscuaz_Headless = true
         getgenv().Mscuaz_Korblox = false
         getgenv().MscuazScriptIsTheBest = "MscuazScripter"
         loadstring(game:HttpGet('https://raw.githubusercontent.com/gwnrdt/Try/refs/heads/main/Headless%26Korblox.lua'))()
      else
         getgenv().Mscuaz_Headless = false
      end
   end
})

OtherTab:CreateSection("target player")

-- ======================================================
-- TARGET STRAFE (FIXED + NEAREST SUPPORT)
-- ======================================================

local strafeEnabled = false
local strafeDistance = 10
local strafeSpeed = 15
local selectedPlayerName = "Nearest"
local angle = 0

-- Получение списка игроков
local function getPlayerNames()
    local names = {"Nearest"}
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            table.insert(names, plr.Name)
        end
    end
    return names
end

-- Toggle
local TargetStrafe = OtherTab:CreateToggle({
   Name = "Target Strafe",
   CurrentValue = false,
   Flag = "TargetStrafeToggle",
   Callback = function(Value)
      strafeEnabled = Value
      if not Value then
          angle = 0
      end
   end,
})

-- Dropdown выбора игрока
local PlayerDropdown = OtherTab:CreateDropdown({
   Name = "Select Player",
   Options = getPlayerNames(),
   CurrentOption = {"Nearest"},
   MultipleOptions = false,
   Flag = "TargetPlayer",
   Callback = function(Option)
      if type(Option) == "table" and Option[1] then
          selectedPlayerName = Option[1]
      elseif type(Option) == "string" then
          selectedPlayerName = Option
      end
   end,
})

-- Обновление списка игроков
local function updateDropdown()
    PlayerDropdown:Refresh(getPlayerNames())
end
Players.PlayerAdded:Connect(updateDropdown)
Players.PlayerRemoving:Connect(updateDropdown)

-- Скорость
OtherTab:CreateSlider({
   Name = "Target Speed",
   Range = {1, 100},
   Increment = 1,
   Suffix = " speed",
   CurrentValue = 15,
   Flag = "StrafeSpeed",
   Callback = function(Value)
       strafeSpeed = Value
   end,
})

-- Дистанция
OtherTab:CreateSlider({
   Name = "Distance",
   Range = {2, 50},
   Increment = 1,
   Suffix = " studs",
   CurrentValue = 10,
   Flag = "StrafeDist",
   Callback = function(Value)
       strafeDistance = Value
   end,
})

-- Основная логика страйфа
RunService.Heartbeat:Connect(function(dt)
    if not strafeEnabled then return end
    
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")

    if not hrp or not hum or hum.Health <= 0 then return end

    -- Отключаем коллизию
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end

    local targetHRP = nil

    -- ===== NEAREST PLAYER =====
    if selectedPlayerName == "Nearest" then
        local closestDist = math.huge

        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local targetHum = plr.Character:FindFirstChildOfClass("Humanoid")
                local targetRoot = plr.Character:FindFirstChild("HumanoidRootPart")

                if targetHum and targetRoot and targetHum.Health > 0 then
                    local dist = (hrp.Position - targetRoot.Position).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        targetHRP = targetRoot
                    end
                end
            end
        end

    -- ===== PLAYER BY NAME =====
    else
        local targetPlayer = Players:FindFirstChild(selectedPlayerName)

        if targetPlayer and targetPlayer.Character then
            local targetHum = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
            local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")

            if targetHum and targetRoot and targetHum.Health > 0 then
                targetHRP = targetRoot
            end
        end
    end

    -- ===== STRAFE AROUND TARGET =====
    if targetHRP then
        angle = angle + (strafeSpeed * dt)

        local x = math.cos(angle) * strafeDistance
        local z = math.sin(angle) * strafeDistance

        local offset = Vector3.new(x, 0, z)
        local targetPosition = targetHRP.Position + offset

        hrp.CFrame = CFrame.new(targetPosition, targetHRP.Position)
    end
end)

-- Keybind для Target Strafe
OtherTab:CreateKeybind({
    Name = "Target Strafe Bind",
    CurrentKeybind = "C",
    HoldToInteract = false,
    Flag = "TargetStrafeBind",
    Callback = function()
        TargetStrafe:Set(not strafeEnabled)
    end,
})
-- ======================================================
-- ULTRA PREMIUM PARTICLES SYSTEM (FULL VERSION)
-- ======================================================

VisualsTab:CreateSection("Particles")

local particlesEnabled = false
local particleSize = 1
local particleAmount = 5
local particleTransparency = 0.2
local particleLifetime = 0.8
local particleShape = "Circle"
local particleColor = Color3.fromRGB(0,255,255)
local particleRainbow = false
local particleMaterial = Enum.Material.Neon

local rotateParticles = false
local orbitMode = false
local glowEnabled = false
local animeVFX = false

local particleConnection
local orbitAngle = 0
local lastParticleSpawn = 0

-- ==============================
-- SHAPE SYSTEM
-- ==============================

local function applyShape(part)

    part:ClearAllChildren()

    if particleShape == "Circle" then
        part.Shape = Enum.PartType.Ball

    elseif particleShape == "Square" then
        part.Shape = Enum.PartType.Block

    elseif particleShape == "Triangle" then
        part.Shape = Enum.PartType.Block
        local mesh = Instance.new("SpecialMesh")
        mesh.MeshType = Enum.MeshType.Wedge
        mesh.Parent = part

    elseif particleShape == "Dollar" then
        part.Shape = Enum.PartType.Block
        local mesh = Instance.new("SpecialMesh")
        mesh.MeshType = Enum.MeshType.FileMesh
        mesh.MeshId = "rbxassetid://121725792"
        mesh.Scale = Vector3.new(particleSize*2, particleSize*2, 0.5)
        mesh.Parent = part

    elseif particleShape == "Heart" then
        part.Shape = Enum.PartType.Block
        local mesh = Instance.new("SpecialMesh")
        mesh.MeshType = Enum.MeshType.FileMesh
        mesh.MeshId = "rbxassetid://380251974"
        mesh.Scale = Vector3.new(particleSize*2, particleSize*2, 0.5)
        mesh.Parent = part

    elseif particleShape == "Star" then
        part.Shape = Enum.PartType.Block
        local mesh = Instance.new("SpecialMesh")
        mesh.MeshType = Enum.MeshType.FileMesh
        mesh.MeshId = "rbxassetid://423103943"
        mesh.Scale = Vector3.new(particleSize*2, particleSize*2, 0.5)
        mesh.Parent = part
    end
end

-- ==============================
-- PARTICLE CREATION
-- ==============================

local function createParticle(position, burstMultiplier)

    local part = Instance.new("Part")
    part.Anchored = false
    part.CanCollide = false
    part.Material = particleMaterial
    part.Size = Vector3.new(particleSize, particleSize, particleSize)
    part.Transparency = particleTransparency
    part.Position = position
    part.Parent = workspace

    applyShape(part)

    -- Color
    if particleRainbow then
        part.Color = Color3.fromHSV(tick()%5/5,1,1)
    else
        part.Color = particleColor
    end

    -- Glow
    if glowEnabled then
        local light = Instance.new("PointLight")
        light.Brightness = 3
        light.Range = 8
        light.Color = part.Color
        light.Parent = part
    end

    -- Direction
    local randomDirection = Vector3.new(
        math.random(-100,100)/100,
        math.random(-20,100)/100,
        math.random(-100,100)/100
    ).Unit

    local power = animeVFX and 40 or 20
    if burstMultiplier then
        power = power * burstMultiplier
    end

    part.AssemblyLinearVelocity = randomDirection * math.random(power-5,power)

    -- Rotation
    if rotateParticles then
        part.AssemblyAngularVelocity = Vector3.new(
            math.random(-10,10),
            math.random(-10,10),
            math.random(-10,10)
        )
    end

    -- Fade out
    task.spawn(function()
        local start = tick()
        while tick() - start < particleLifetime do
            part.Transparency = particleTransparency + ((tick()-start)/particleLifetime)
            RunService.Heartbeat:Wait()
        end
        part:Destroy()
    end)
end

-- ==============================
-- NORMAL SPAWN
-- ==============================

local function spawnParticles()

    local char = LocalPlayer.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    local head = char:FindFirstChild("Head")
    local hum = char:FindFirstChildOfClass("Humanoid")

    if not hrp or not head or not hum then return end
    if hum.MoveDirection.Magnitude <= 0 then return end

    if orbitMode then
        orbitAngle += 0.2
        for i = 1, particleAmount do
            local offset = Vector3.new(
                math.cos(orbitAngle + i)*3,
                1,
                math.sin(orbitAngle + i)*3
            )
            createParticle(hrp.Position + offset)
        end
    else
        for i = 1, particleAmount do
            createParticle(hrp.Position - hrp.CFrame.LookVector*2)
            createParticle(head.Position)
            createParticle(hrp.Position - Vector3.new(0,2.5,0))
        end
    end
end

-- ==============================
-- JUMP BURST
-- ==============================

UserInputService.JumpRequest:Connect(function()
    if not particlesEnabled then return end

    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    for i = 1, particleAmount * 3 do
        createParticle(hrp.Position, 2)
    end
end)

-- ==============================
-- TOGGLE
-- ==============================

VisualsTab:CreateToggle({
    Name = "Enable Particles",
    CurrentValue = false,
    Callback = function(v)
        particlesEnabled = v
        if v then
            if particleConnection then particleConnection:Disconnect() end
            particleConnection = RunService.Heartbeat:Connect(function()
                if tick()-lastParticleSpawn > 0.1 then
                    spawnParticles()
                    lastParticleSpawn = tick()
                end
            end)
        else
            if particleConnection then
                particleConnection:Disconnect()
                particleConnection = nil
            end
        end
    end
})

-- ==============================
-- UI CONTROLS
-- ==============================

VisualsTab:CreateDropdown({
    Name = "Particle Shape",
    Options = {"Circle","Square","Triangle"},
    CurrentOption = {"Circle"},
    Callback = function(opt)
        particleShape = opt[1]
    end
})

VisualsTab:CreateDropdown({
    Name = "Particle Material",
    Options = {"Neon","Plastic","ForceField","Wood","Glass"},
    CurrentOption = {"Neon"},
    Callback = function(opt)
        local mat = opt[1]
        particleMaterial = Enum.Material[mat]
    end
})

VisualsTab:CreateSlider({
    Name = "Particle Size",
    Range = {0.2,5},
    Increment = 0.1,
    CurrentValue = 1,
    Callback = function(v) particleSize = v end
})

VisualsTab:CreateSlider({
    Name = "Particle Amount",
    Range = {1,20},
    Increment = 1,
    CurrentValue = 5,
    Callback = function(v) particleAmount = v end
})

VisualsTab:CreateSlider({
    Name = "Particle Transparency",
    Range = {0,0.9},
    Increment = 0.05,
    CurrentValue = 0.2,
    Callback = function(v) particleTransparency = v end
})

VisualsTab:CreateColorPicker({
    Name = "Particle Color",
    Color = Color3.fromRGB(0,255,255),
    Callback = function(c) particleColor = c end
})

VisualsTab:CreateToggle({
    Name = "Rainbow Particles",
    CurrentValue = false,
    Callback = function(v) particleRainbow = v end
})

VisualsTab:CreateToggle({
    Name = "Rotate Particles",
    CurrentValue = false,
    Callback = function(v) rotateParticles = v end
})

VisualsTab:CreateToggle({
    Name = "Orbit Mode",
    CurrentValue = false,
    Callback = function(v) orbitMode = v end
})

VisualsTab:CreateToggle({
    Name = "Glow Effect",
    CurrentValue = false,
    Callback = function(v) glowEnabled = v end
})

VisualsTab:CreateToggle({
    Name = "Anime VFX Mode",
    CurrentValue = false,
    Callback = function(v) animeVFX = v end
})

-- ======================================================
-- ОБНОВЛЕННЫЙ БЛОК JUMP CIRCLE (ТОЛЬКО С ЗЕМЛИ)
-- ======================================================
VisualsTab:CreateSection("Jump Circle")

local jumpCircleEnabled = false
local jumpCircleColor = Color3.fromRGB(0, 255, 255)
local jumpCircleRainbow = false
local jumpCircleSize = 12 
local jumpCircleLifetime = 0.4 -- Длительность анимации

local function createJumpCircle(position)
    local ring = Instance.new("Part")
    ring.Name = "JumpRing"
    ring.Anchored = true
    ring.CanCollide = false
    ring.Transparency = 0.2
    ring.Material = Enum.Material.Neon
    ring.Color = jumpCircleRainbow and Color3.fromHSV(tick() % 5 / 5, 1, 1) or jumpCircleColor
    
    -- Размер Part (очень плоский)
    ring.Size = Vector3.new(1, 0.05, 1)
    -- Поворачиваем горизонтально (на 90 градусов по X)
    ring.CFrame = CFrame.new(position) * CFrame.Angles(math.rad(90), 0, 0)
    ring.Parent = workspace

    -- Используем меш кольца (прозрачный центр)
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.MeshId = "rbxassetid://3270017" 
    mesh.Scale = Vector3.new(1, 1, 0.1)
    mesh.Parent = ring

    -- Анимация расширения
    task.spawn(function()
        local steps = 15
        for i = 1, steps do
            local progress = i / steps
            -- Плавное увеличение размера до jumpCircleSize
            local currentScale = progress * jumpCircleSize
            mesh.Scale = Vector3.new(currentScale, currentScale, 0.1)
            
            -- Плавное исчезновение
            ring.Transparency = 0.2 + (progress * 0.8)
            
            if jumpCircleRainbow then
                ring.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
            end
            
            task.wait(jumpCircleLifetime / steps)
        end
        ring:Destroy()
    end)
end

-- Обработка прыжка с проверкой нахождения на земле
UserInputService.JumpRequest:Connect(function()
    if not jumpCircleEnabled then return end
    
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChild("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    
    -- Проверка: Игрок должен существовать и НЕ находиться в воздухе (FloorMaterial ~= Air)
    if hum and hrp and hum.FloorMaterial ~= Enum.Material.Air then
        -- Позиция строго под ногами
        local pos = hrp.Position - Vector3.new(0, 2.9, 0)
        createJumpCircle(pos)
    end
end)

-- ==============================
-- ИНТЕРФЕЙС (UI)
-- ==============================
VisualsTab:CreateToggle({
    Name = "Jump Circle",
    CurrentValue = false,
    Callback = function(v)
        jumpCircleEnabled = v
    end
})

VisualsTab:CreateSlider({
    Name = "Circle Max Size",
    Range = {5, 40},
    Increment = 1,
    CurrentValue = 12,
    Callback = function(v)
        jumpCircleSize = v
    end
})

VisualsTab:CreateToggle({
    Name = "Rainbow Circle",
    CurrentValue = false,
    Callback = function(v)
        jumpCircleRainbow = v
    end
})

VisualsTab:CreateColorPicker({
    Name = "Circle Color",
    Color = Color3.fromRGB(0, 255, 255),
    Callback = function(c)
        jumpCircleColor = c
    end
})

VisualsTab:CreateSection("kill effect")

-- ==============================
-- ЛОГИКА ЭФФЕКТОВ УБИЙСТВА (KILL EFFECTS)
-- ==============================
local killEffectEnabled = false
local selectedKillEffect = "Explosion"

local function spawnKillEffect(pos)
    if not killEffectEnabled then return end

    if selectedKillEffect == "Explosion" then
        local exp = Instance.new("Explosion")
        exp.Position = pos
        exp.BlastRadius = 0
        exp.BlastPressure = 0
        exp.Parent = Workspace
        
    elseif selectedKillEffect == "Lightning" then
        -- Улучшенная реалистичная молния
        for i = 1, 3 do -- 3 основных разряда
            task.spawn(function()
                local lastPos = pos + Vector3.new(math.random(-5, 5), 25, math.random(-5, 5))
                local targetPos = pos
                local segments = 10
                
                for j = 1, segments do
                    local nextPos = lastPos + (targetPos - lastPos).Unit * (25/segments)
                    if j < segments then
                        -- Создаем зигзаг
                        nextPos = nextPos + Vector3.new(math.random(-4, 4), math.random(-1, 1), math.random(-4, 4))
                    else
                        nextPos = targetPos
                    end
                    
                    local beam = Instance.new("Part")
                    beam.Anchored = true
                    beam.CanCollide = false
                    beam.Material = Enum.Material.Neon
                    beam.Color = Color3.fromRGB(180, 230, 255)
                    beam.Size = Vector3.new(0.3, 0.3, (lastPos - nextPos).Magnitude)
                    beam.CFrame = CFrame.new(lastPos:Lerp(nextPos, 0.5), nextPos)
                    beam.Parent = Workspace
                    
                    -- Эффект свечения и затухания
                    task.delay(0.1, function()
                        for k = 1, 8 do
                            beam.Transparency = k/8
                            beam.Size = beam.Size * 0.9
                            task.wait(0.02)
                        end
                        beam:Destroy()
                    end)
                    lastPos = nextPos
                end
            end)
        end
        
    elseif selectedKillEffect == "Fire" then
        local p = Instance.new("Part")
        p.Size = Vector3.new(1,1,1)
        p.Transparency = 1
        p.Anchored = true
        p.Position = pos
        p.Parent = Workspace
        local f = Instance.new("Fire")
        f.Size = 12
        f.Heat = 25
        f.Parent = p
        task.delay(1.5, function() p:Destroy() end)
        
    elseif selectedKillEffect == "Anime slash" then
        local p = Instance.new("Part")
        p.Anchored = true
        p.CanCollide = false
        p.Material = Enum.Material.Neon
        p.Color = Color3.fromRGB(255, 0, 80)
        p.Size = Vector3.new(0.2, 0.2, 0.2)
        p.CFrame = CFrame.new(pos) * CFrame.Angles(0, 0, math.rad(90))
        p.Parent = Workspace
        local mesh = Instance.new("SpecialMesh", p)
        mesh.MeshType = Enum.MeshType.FileMesh
        mesh.MeshId = "rbxassetid://3270017"
        mesh.Scale = Vector3.new(1, 1, 0.1)
        task.spawn(function()
            for i = 1, 20 do
                mesh.Scale = mesh.Scale + Vector3.new(4, 4, 0)
                p.Transparency = i / 20
                task.wait(0.015)
            end
            p:Destroy()
        end)
        
    elseif selectedKillEffect == "Particle burst" then
        local p = Instance.new("Part")
        p.Size = Vector3.new(1,1,1)
        p.Transparency = 1
        p.Anchored = true
        p.Position = pos
        p.Parent = Workspace
        
        local pe = Instance.new("ParticleEmitter")
        pe.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 200, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 50, 255))
        })
        pe.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1.2),
            NumberSequenceKeypoint.new(1, 0)
        })
        pe.Acceleration = Vector3.new(0, -15, 0)
        pe.Rate = 10000 -- Максимальная плотность
        pe.Speed = NumberRange.new(25, 60)
        pe.SpreadAngle = Vector2.new(360, 360)
        pe.Lifetime = NumberRange.new(0.6, 1.5)
        pe.Parent = p
        
        task.wait(0.2)
        pe.Enabled = false
        task.delay(2, function() p:Destroy() end)
    end
end

-- Функция отслеживания смерти (включая Reset)
local function onCharacterAdded(char)
    local hum = char:WaitForChild("Humanoid", 15)
    if hum then
        hum.Died:Connect(function()
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                spawnKillEffect(hrp.Position)
            end
        end)
    end
end

local function observePlayer(plr)
    if plr.Character then onCharacterAdded(plr.Character) end
    plr.CharacterAdded:Connect(onCharacterAdded)
end

for _, plr in pairs(Players:GetPlayers()) do
    observePlayer(plr)
end
Players.PlayerAdded:Connect(observePlayer)

-- ==============================
-- JUMP CIRCLE (КОЛЬЦА ПРИ ПРЫЖКЕ)
-- ==============================
local jumpCircleEnabled = false
local jumpCircleSize = 12
local jumpCircleColor = Color3.fromRGB(255, 255, 255)
local jumpCircleThickness = 0.5
local jumpCircleLifetime = 0.8

local function createJumpCircle(pos)
    local ring = Instance.new("Part")
    ring.Shape = Enum.PartType.Cylinder
    ring.Material = Enum.Material.Neon
    ring.Color = jumpCircleColor
    ring.Transparency = 0.5
    ring.Anchored = true
    ring.CanCollide = false
    ring.Size = Vector3.new(jumpCircleThickness, 0.1, 0.1)
    ring.CFrame = CFrame.new(pos) * CFrame.Angles(0, 0, math.rad(90))
    ring.Parent = Workspace

    task.spawn(function()
        local steps = 25
        for i = 1, steps do
            local ratio = i / steps
            local currentSize = jumpCircleSize * ratio
            ring.Size = Vector3.new(jumpCircleThickness, currentSize, currentSize)
            ring.Transparency = 0.5 + (0.5 * ratio)
            task.wait(jumpCircleLifetime / steps)
        end
        ring:Destroy()
    end)
end

UserInputService.JumpRequest:Connect(function()
    if not jumpCircleEnabled then return end
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChild("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    
    if hum and hrp and hum.FloorMaterial ~= Enum.Material.Air then
        local pos = hrp.Position - Vector3.new(0, 2.9, 0)
        createJumpCircle(pos)
    end
end)

-- ==============================
-- ИНТЕРФЕЙС УПРАВЛЕНИЯ
-- ==============================

VisualsTab:CreateSection("Kill Effects")

VisualsTab:CreateToggle({
    Name = "Enable Kill Effect",
    CurrentValue = false,
    Callback = function(v)
        killEffectEnabled = v
    end
})

VisualsTab:CreateDropdown({
    Name = "Effect Type",
    Options = {"Explosion", "Lightning", "Fire", "Anime slash", "Particle burst"},
    CurrentOption = {"Explosion"},
    MultipleOptions = false,
    Callback = function(Option)
        selectedKillEffect = Option[1]
    end,
})

VisualsTab:CreateSection("Jump Circle Settings")

VisualsTab:CreateToggle({
    Name = "Jump Circle",
    CurrentValue = false,
    Callback = function(v)
        jumpCircleEnabled = v
    end
})

VisualsTab:CreateSlider({
    Name = "Circle Max Size",
    Range = {5, 40},
    Increment = 1,
    CurrentValue = 12,
    Callback = function(v)
        jumpCircleSize = v
    end
})

VisualsTab:CreateColorPicker({
    Name = "Circle Color",
    Color = Color3.fromRGB(255, 255, 255),
    Callback = function(color)
        jumpCircleColor = color
    end
})

-- ==============================
-- ЛОГИКА ЭФФЕКТОВ
-- ==============================
local footstepEnabled = false
local selectedFootstep = "Fire"

local function createStepEffect(pos)
    if not footstepEnabled then return end
    
    local part = Instance.new("Part")
    part.Size = Vector3.new(0.1, 0.1, 0.1)
    part.Transparency = 1
    part.CanCollide = false
    part.Anchored = true
    -- Смещаем точку спавна чуть ниже центра персонажа
    part.Position = pos - Vector3.new(0, 2.5, 0) 
    part.Parent = Workspace
    
    local pe = Instance.new("ParticleEmitter")
    pe.Enabled = true
    pe.Parent = part
    
    if selectedFootstep == "Fire" then
        pe.Color = ColorSequence.new(Color3.fromRGB(255, 100, 0), Color3.fromRGB(255, 0, 0))
        pe.Size = NumberSequence.new(0.6, 0)
        pe.Texture = "rbxassetid://244221440"
        pe.Lifetime = NumberRange.new(0.5, 0.8)
        pe.Rate = 100
        pe.Speed = NumberRange.new(2, 5)
        
    elseif selectedFootstep == "Lightning" then
        pe.Color = ColorSequence.new(Color3.fromRGB(0, 255, 255), Color3.fromRGB(255, 255, 255))
        pe.Size = NumberSequence.new(1.5, 0) -- Сделал побольше
        pe.Texture = "rbxassetid://281983280"
        pe.Lifetime = NumberRange.new(0.1, 0.3)
        pe.Rate = 120
        pe.LightEmission = 1 -- Молния должна светиться
        pe.Transparency = NumberSequence.new(0, 1)
        pe.Speed = NumberRange.new(0)
        
    elseif selectedFootstep == "Rainbow" then
        pe.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHSV(tick() % 1, 1, 1)),
            ColorSequenceKeypoint.new(1, Color3.fromHSV((tick() + 0.5) % 1, 1, 1))
        })
        pe.Size = NumberSequence.new(0.5, 0)
        pe.Texture = "rbxassetid://244221440"
        pe.Lifetime = NumberRange.new(0.5, 1)
        pe.Rate = 150
        
    elseif selectedFootstep == "Galaxy" then
        -- ТУТ ИСПРАВЛЕНИЯ:
        pe.Color = ColorSequence.new(Color3.fromRGB(180, 0, 255), Color3.fromRGB(0, 200, 255))
        pe.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.8), 
            NumberSequenceKeypoint.new(1, 0)
        })
        pe.Texture = "rbxassetid://1265811370"
        pe.Lifetime = NumberRange.new(0.8, 1.2)
        pe.Rate = 150
        pe.LightEmission = 1 -- Это делает эффект видимым
        pe.LightInfluence = 0 -- Чтобы не зависел от освещения карты
        pe.Rotation = NumberRange.new(-180, 180)
        pe.RotSpeed = NumberRange.new(50, 100)
        pe.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 1)
        })
    end
    
    -- Быстрое выключение эмиттера и удаление парта через время
    task.delay(0.1, function()
        pe.Enabled = false
    end)
    task.delay(2, function()
        part:Destroy()
    end)
end

-- Цикл проверки движения
RunService.Heartbeat:Connect(function()
    if not footstepEnabled then return end
    
    local char = LocalPlayer.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChild("Humanoid")
        
        -- Убрана проверка пола FloorMaterial ~= Air
        -- Теперь эффект работает всегда, пока персонаж бежит или летит
        if hrp and hum and hum.MoveDirection.Magnitude > 0 then
            createStepEffect(hrp.Position)
        end
    end
end)

-- ==============================
-- ИНТЕРФЕЙС
-- ==============================

VisualsTab:CreateSection("Footstep Effects")

VisualsTab:CreateToggle({
    Name = "Enable Footsteps",
    CurrentValue = false,
    Callback = function(v)
        footstepEnabled = v
    end
})

VisualsTab:CreateDropdown({
    Name = "Footstep Type",
    Options = {"Fire", "Lightning", "Rainbow"},
    CurrentOption = {"Fire"},
    MultipleOptions = false,
    Callback = function(Option)
        selectedFootstep = Option[1]
    end,
})

-- Находим или создаем эффекты для цветокоррекции
local ColorCorrection = Lighting:FindFirstChild("VetrexCC") or Instance.new("ColorCorrectionEffect")
ColorCorrection.Name = "VetrexCC"
ColorCorrection.Parent = Lighting

-- ==========================================
-- WORLD VISUALS (УПРАВЛЕНИЕ МИРОМ)
-- ==========================================
VisualsTab:CreateSection("World Visuals")

-- FullBright
local fbConnection
VisualsTab:CreateToggle({
    Name = "FullBright",
    CurrentValue = false,
    Callback = function(v)
        if v then
            fbConnection = RunService.RenderStepped:Connect(function()
                Lighting.Brightness = 2
                Lighting.ClockTime = 14
                Lighting.FogEnd = 100000
                Lighting.GlobalShadows = false
                Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            end)
        else
            if fbConnection then fbConnection:Disconnect() end
            Lighting.Brightness = 1
            Lighting.GlobalShadows = true
        end
    end
})

-- No Fog
VisualsTab:CreateToggle({
    Name = "No Fog",
    CurrentValue = false,
    Callback = function(v)
        Lighting.FogEnd = v and 100000 or 1000 -- Примерные значения
    end
})

-- Saturation
VisualsTab:CreateSlider({
    Name = "Saturation",
    Range = {-1, 5},
    Increment = 0.1,
    Suffix = "Level",
    CurrentValue = 0,
    Callback = function(v)
        ColorCorrection.Saturation = v
    end
})

-- Shadow Intensity (Exposure)
VisualsTab:CreateSlider({
    Name = "Shadow Intensity",
    Range = {0, 5},
    Increment = 0.1,
    Suffix = "Exp",
    CurrentValue = 1,
    Callback = function(v)
        Lighting.ExposureCompensation = v
    end
})

-- Ambient Color
VisualsTab:CreateColorPicker({
    Name = "Ambient Color",
    Color = Color3.fromRGB(127, 127, 127),
    Callback = function(color)
        Lighting.Ambient = color
        Lighting.OutdoorAmbient = color
    end
})

local cloakParts = {}
local cloakEnabled = false
local cloakDistance = 0.6
local cloakAngle = 0
local cloakHeight = -0.4
local selectedText = "vetrex scripts"

-- Цветовые настройки
local cloakColor = Color3.fromRGB(0,0,0)
local textColor = Color3.fromRGB(255,255,255)

local function removeCloak()
    for _, obj in pairs(cloakParts) do
        if obj then obj:Destroy() end
    end
    cloakParts = {}
end

local function addCloak()
    removeCloak()
    if not cloakEnabled then return end
    
    local char = LocalPlayer.Character
    if not char then return end
    local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    if not torso then return end

    local cloak = Instance.new("Part")
    cloak.Name = "VetrexCloakStatic"
    cloak.Size = Vector3.new(2.2, 3.8, 0.1)
    cloak.Color = cloakColor
    cloak.Material = Enum.Material.Plastic
    cloak.CanCollide = false
    cloak.Massless = true
    cloak.Parent = char

    local surfaceGui = Instance.new("SurfaceGui", cloak)
    surfaceGui.Face = Enum.NormalId.Back
    surfaceGui.CanvasSize = Vector2.new(400, 700)

    local textLabel = Instance.new("TextLabel", surfaceGui)
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = selectedText
    textLabel.TextColor3 = textColor
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.GothamBold

    local weld = Instance.new("Weld", cloak)
    weld.Part0 = torso
    weld.Part1 = cloak
    
    local positionOffset = CFrame.new(0, cloakHeight, cloakDistance)
    local rotationOffset = CFrame.Angles(math.rad(cloakAngle), 0, 0)
    
    weld.C0 = positionOffset * rotationOffset
    
    table.insert(cloakParts, cloak)
end

--------------------------------------------------
-- UI
--------------------------------------------------

VisualsTab:CreateSection("Cloak Settings")

VisualsTab:CreateToggle({
    Name = "Cloak",
    CurrentValue = false,
    Callback = function(v)
        cloakEnabled = v
        if v then addCloak() else removeCloak() end
    end
})

VisualsTab:CreateDropdown({
    Name = "Cloak Text",
    Options = {"vetrex scripts", "vetrex visuals","♡", "ツ", "v"},
    CurrentOption = {"vetrex scripts"},
    Callback = function(Option)
        selectedText = Option[1]
        if cloakEnabled then addCloak() end
    end,
})

VisualsTab:CreateSlider({
    Name = "Cloak Height",
    Range = {-3, 3},
    Increment = 0.1,
    CurrentValue = -0.4,
    Callback = function(v)
        cloakHeight = v
        if cloakEnabled then addCloak() end
    end
})

VisualsTab:CreateSlider({
    Name = "Cloak Distance",
    Range = {0.3, 2},
    Increment = 0.1,
    CurrentValue = 0.6,
    Callback = function(v)
        cloakDistance = v
        if cloakEnabled then addCloak() end
    end
})

VisualsTab:CreateSlider({
    Name = "Cloak Angle",
    Range = {-20, 90},
    Increment = 1,
    CurrentValue = 0,
    Callback = function(v)
        cloakAngle = v
        if cloakEnabled then addCloak() end
    end
})

VisualsTab:CreateColorPicker({
    Name = "Cloak Color",
    Color = Color3.fromRGB(0,0,0),
    Callback = function(color)
        cloakColor = color
        if cloakEnabled then addCloak() end
    end
})

VisualsTab:CreateColorPicker({
    Name = "Text Color",
    Color = Color3.fromRGB(255,255,255),
    Callback = function(color)
        textColor = color
        if cloakEnabled then addCloak() end
    end
})

--------------------------------------------------
-- Auto Respawn
--------------------------------------------------

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if cloakEnabled then addCloak() end
end)
