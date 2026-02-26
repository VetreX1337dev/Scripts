if game.PlaceId ~= 136801880565837 then
    return
end

local rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local plrs = game:GetService("Players")
local cam = workspace.CurrentCamera
local me = plrs.LocalPlayer
local run = game:GetService("RunService")
local tele = game:GetService("TeleportService")
local uis = game:GetService("UserInputService")

local w = rayfield:CreateWindow({
    Name = "FPS flick",
    LoadingTitle = "vetrex hub",
    LoadingSubtitle = "by DottaWasCorupted",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "Vetrex hub",
        FileName = "Vetrex Hub"
    },
    KeySystem = falce,
    DisableRayfieldPrompts = false,
})

local MainTab = w:CreateTab("Main",4483362458)
local a = w:CreateTab("Combat",4483362458)
local e = w:CreateTab("ESP",4483362458)
local p = w:CreateTab("main",4483362458)
local v = w:CreateTab("Visual",4483362458)

MainTab:CreateParagraph({
    Title = "FPS FLICK",
    Content = "Добро пожаловать в Vetrex Hub!\n\nРазработчик:DottaWasCorupted\nчто планируется реализовать:\n-hitbox\n-autorespawn\nУдачи с отличным скриптом"
})

MainTab:CreateButton({
    Name = "📢 Discord chanes :3",
    Callback = function()
        local telegramLink = "https://discord.gg/bSCVptWePe"
        
        local success, errorMessage = pcall(function()
            setclipboard(telegramLink)
        end)
        
        if success then
            rayfield:Notify({
                Title = "Discord",
                Content = "The link has been copied to the clipboard!\nВставьте её в браузер.",
                Duration = 5,
                Image = 4483362458,
            })
        else
            rayfield:Notify({
                Title = "Discord",
                Content = "error copying link.\nLink: " .. DiscordLink,
                Duration = 10,
                Image = 4483362458,
            })
        end
    end,
})

local wm = nil
local enemyCounterText = nil
local fpsLabel = nil

local function createWM()
    if wm then
        wm:Remove()
        wm = nil
    end
    
    if Drawing then
        wm = Drawing.new("Text")
        wm.Text = "https://discord.gg/bSCVptWePe"
        wm.Size = 18
        wm.Center = true
        wm.Outline = false
        wm.Color = Color3.new(1, 1, 1)
        wm.Transparency = 0.45
        wm.Visible = true
        
        local vs = cam.ViewportSize
        wm.Position = Vector2.new(vs.X / 2, 20)
    end
end

local function createEnemyCounter()
    if enemyCounterText then
        enemyCounterText:Remove()
        enemyCounterText = nil
    end
    
    if Drawing then
        enemyCounterText = Drawing.new("Text")
        enemyCounterText.Visible = false
        enemyCounterText.Size = 16
        enemyCounterText.Center = true
        enemyCounterText.Outline = false
        enemyCounterText.Color = Color3.new(1, 0, 0)
    end
end

local function createFPSLabel()
    if fpsLabel then
        fpsLabel:Remove()
        fpsLabel = nil
    end
    
    if Drawing then
        fpsLabel = Drawing.new("Text")
        fpsLabel.Text = "FPS: 0"
        fpsLabel.Size = 14
        fpsLabel.Center = true
        fpsLabel.Outline = false
        fpsLabel.Color = Color3.fromRGB(255, 255, 255)
        fpsLabel.Visible = false
        local vs = cam.ViewportSize
        fpsLabel.Position = Vector2.new(vs.X - 50, 20)
    end
end

local function removeWM()
    if wm then
        wm:Remove()
        wm = nil
    end
    if enemyCounterText then
        enemyCounterText:Remove()
        enemyCounterText = nil
    end
    if fpsLabel then
        fpsLabel:Remove()
        fpsLabel = nil
    end
end

createWM()
createEnemyCounter()
createFPSLabel()

local eso = {}
local circ

local b, ln, nm, ch, hp, dst, tc, ab, ap, vc = false, false, false, false, false, false, false, false, false, false
local cr, md, ps, pred, tpws = 50, 1000, 16, 0.1, 20
local sf, rf, re, spd, nc, ij, cs, tpw = false, false, false, false, false, false, false, false
local csloc, cspart, rc = nil, nil, nil
local sa = false
local sv = 0.5

local vi = false
local ge = false
local bh = false
local fc = false
local fv = 70
local fovConnection = nil
local ec = false
local fpsDisplay = false
local fpsCounter = 0
local lastTime = 0

local bhc = nil
local debris = game:GetService("Debris")

local rc, fb = false, false
local nf, wme = true, true
local rcc, light = nil, nil
local lcc = 0
local ofe = 0
local ofc = Color3.new(0.5, 0.5, 0.5)
local oa = Color3.new(0.5, 0.5, 0.5)
local ooa = Color3.new(0.5, 0.5, 0.5)

local xr = false
local xp = {}

local fb_en = false
local op = {}
local wc = {}

local se = false
local sr = 0.80
local sc = nil

local gh = {}
local ghConnections = {}

local function updateFPS()
    if not fpsDisplay or not fpsLabel then return end
    
    fpsCounter = fpsCounter + 1
    local currentTime = tick()
    
    if currentTime - lastTime >= 1 then
        local fps = fpsCounter
        fpsCounter = 0
        lastTime = currentTime
        
        fpsLabel.Text = "FPS: " .. tostring(fps)
        
        if fps >= 120 then
            fpsLabel.Color = Color3.fromRGB(0, 255, 0)
        elseif fps >= 60 then
            fpsLabel.Color = Color3.fromRGB(100, 255, 100)
        elseif fps >= 30 then
            fpsLabel.Color = Color3.fromRGB(255, 255, 0)
        else
            fpsLabel.Color = Color3.fromRGB(255, 50, 50)
        end
        
        local vs = cam.ViewportSize
        fpsLabel.Position = Vector2.new(vs.X - 50, 20)
    end
end

local function togFPS(v)
    fpsDisplay = v
    if v then
        if not fpsLabel then
            createFPSLabel()
        end
        fpsLabel.Visible = true
        fpsCounter = 0
        lastTime = tick()
    else
        if fpsLabel then
            fpsLabel.Visible = false
        end
    end
end

local function countEnemiesInRadius()
    if not ec then return 0 end
    
    local myChar = me.Character
    if not myChar then return 0 end
    
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return 0 end
    
    local myPos = myRoot.Position
    local enemyCount = 0
    
    for _, player in pairs(plrs:GetPlayers()) do
        if player == me then continue end
        
        if tc then
            if not enemy(player) then
                continue
            end
        end
        
        local char = player.Character
        if not char then continue end
        
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then continue end
        
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.Health <= 0 then continue end
        
        local distance = (myPos - root.Position).Magnitude
        
        if distance <= 400 then
            enemyCount = enemyCount + 1
        end
    end
    
    return enemyCount
end

local function updateEnemyCounterDisplay()
    if not ec or not enemyCounterText then 
        if enemyCounterText then
            enemyCounterText.Visible = false
        end
        return 
    end
    
    local enemyCount = countEnemiesInRadius()
    
    enemyCounterText.Text = "Врагов: " .. enemyCount
    enemyCounterText.Visible = true
    
    local vs = cam.ViewportSize
    local watermarkY = 20
    if wm then
        watermarkY = wm.Position.Y + 25
    end
    
    enemyCounterText.Position = Vector2.new(vs.X / 2, watermarkY)
end

if game:GetService("Lighting") then
    light = game:GetService("Lighting")
    ofe = light.FogEnd
    ofc = light.FogColor
    oa = light.Ambient
    ooa = light.OutdoorAmbient
end

local op = {}

local function recProps(inst)
    if inst:IsA("BasePart") then
        if not op[inst] then
            op[inst] = {
                Material = inst.Material,
                Reflectance = inst.Reflectance,
                CastShadow = inst.CastShadow,
                Transparency = inst.Transparency,
                Color = inst.Color,
                CanCollide = inst.CanCollide
            }
        end
    elseif inst:IsA("ParticleEmitter") or inst:IsA("Fire") or inst:IsA("Smoke") then
        if not op[inst] then
            op[inst] = {Enabled = inst.Enabled}
        end
    end
end

local function optParts(inst)
    if inst:IsA("BasePart") then
        recProps(inst)
        inst.Material = Enum.Material.Plastic
        inst.Reflectance = 0
        
        if inst:IsA("MeshPart") or inst:IsA("PartOperation") then
            inst.CastShadow = false
        end
    elseif inst:IsA("ParticleEmitter") or inst:IsA("Fire") or inst:IsA("Smoke") then
        recProps(inst)
        inst:Destroy()
    end
end

local function optWS()
    for _, obj in pairs(workspace:GetDescendants()) do
        optParts(obj)
    end
    
    local child = workspace.DescendantAdded:Connect(function(obj)
        optParts(obj)
    end)
    
    table.insert(wc, child)
end

local function restParts()
    for part, props in pairs(op) do
        if part and part.Parent then
            pcall(function()
                if part:IsA("BasePart") then
                    if props.Material then part.Material = props.Material end
                    if props.Reflectance then part.Reflectance = props.Reflectance end
                    if props.CastShadow ~= nil and (part:IsA("MeshPart") or part:IsA("PartOperation")) then
                        part.CastShadow = props.CastShadow
                    end
                    if props.Transparency then part.Transparency = props.Transparency end
                    if props.Color then part.Color = props.Color end
                    if props.CanCollide ~= nil then part.CanCollide = props.CanCollide end
                end
            end)
        end
    end
    
    op = {}
end

local fbos = {}

local function enFB()
    fbos = {
        QualityLevel = settings().Rendering.QualityLevel,
        FrameRateManager = settings().Rendering.FrameRateManager,
        GlobalShadows = light.GlobalShadows,
        FogEnd = light.FogEnd,
        Brightness = light.Brightness,
        ClockTime = light.ClockTime,
        OutdoorAmbient = light.OutdoorAmbient
    }
    
    if workspace:FindFirstChildOfClass("Terrain") then
        local t = workspace:FindFirstChildOfClass("Terrain")
        fbos.TWS = t.WaterWaveSize
        fbos.TWSp = t.WaterWaveSpeed
        fbos.TWR = t.WaterReflectance
        fbos.TWT = t.WaterTransparency
        fbos.TD = true
    end
    
    for _, eff in pairs(light:GetChildren()) do
        if eff:IsA("BlurEffect") or eff:IsA("SunRaysEffect") or 
           eff:IsA("ColorCorrectionEffect") or eff:IsA("BloomEffect") or
           eff:IsA("DepthOfFieldEffect") then
            fbos[eff] = {Enabled = eff.Enabled}
        end
    end
    
    settings().Rendering.QualityLevel = 1
    settings().Rendering.FrameRateManager = 0
    
    light.GlobalShadows = false
    light.FogEnd = 100000
    light.Brightness = 2
    light.ClockTime = 14
    
    if workspace:FindFirstChildOfClass("Terrain") then
        local t = workspace:FindFirstChildOfClass("Terrain")
        t.WaterWaveSize = 0
        t.WaterWaveSpeed = 0
        t.WaterReflectance = 0
        t.WaterTransparency = 1
        
        if pcall(function() return sethiddenproperty end) then
            pcall(function()
                sethiddenproperty(t, "Decoration", false)
            end)
        end
    end
    
    for _, eff in pairs(light:GetChildren()) do
        if eff:IsA("PostEffect") then
            eff.Enabled = false
        end
    end
    
    optWS()
    
    fb_en = true
end

local function disFB()
    if fbos.QualityLevel then
        settings().Rendering.QualityLevel = fbos.QualityLevel
        settings().Rendering.FrameRateManager = fbos.FrameRateManager
        
        light.GlobalShadows = fbos.GlobalShadows
        light.FogEnd = fbos.FogEnd
        light.Brightness = fbos.Brightness
        light.ClockTime = fbos.ClockTime or 14
        if fbos.OutdoorAmbient then
            light.OutdoorAmbient = fbos.OutdoorAmbient
        end
        
        if workspace:FindFirstChildOfClass("Terrain") and fbos.TWS then
            local t = workspace:FindFirstChildOfClass("Terrain")
            t.WaterWaveSize = fbos.TWS
            t.WaterWaveSpeed = fbos.TWSp
            t.WaterReflectance = fbos.TWR
            t.WaterTransparency = fbos.TWT
            
            if fbos.TD and pcall(function() return sethiddenproperty end) then
                pcall(function()
                    sethiddenproperty(t, "Decoration", true)
                end)
            end
        end
        
        for eff, set in pairs(fbos) do
            if typeof(eff) == "Instance" and eff:IsA("PostEffect") then
                if set.Enabled ~= nil then
                    eff.Enabled = set.Enabled
                end
            end
        end
        
        for _, con in pairs(wc) do
            con:Disconnect()
        end
        wc = {}
        
        restParts()
    end
    
    fb_en = false
    fbos = {}
end

local function enStr()
    if sc then
        sc:Disconnect()
        sc = nil
    end
    
    sc = run.RenderStepped:Connect(function()
        if se then
            cam.CFrame = cam.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, sr, 0, 0, 0, 1)
        end
    end)
    
    se = true
end

local function disStr()
    if sc then
        sc:Disconnect()
        sc = nil
    end
    
    se = false
end

local function appBH(c, h)
    if not c or not c.Parent or not bh then return end
    
    local rp = c:FindFirstChild("HumanoidRootPart")
    if not rp then return end
    
    local fs = 60
    local uf = 15
    
    local md = h.MoveDirection
    
    if md.Magnitude > 0.1 then
        local ov = rp:FindFirstChild("BYWVelocity")
        if ov then ov:Destroy() end
        
        local v = Instance.new("BodyVelocity")
        v.Name = "BYWVelocity"
        v.MaxForce = Vector3.new(4000, 0, 4000)
        v.P = 1250
        
        local hf = Vector3.new(md.X, 0, md.Z).Unit * fs
        v.Velocity = hf
        
        v.Parent = rp
        
        debris:AddItem(v, 0.2)
    else
        local ov = rp:FindFirstChild("BYWVelocity")
        if ov then ov:Destroy() end
        
        local v = Instance.new("BodyVelocity")
        v.Name = "BYWVelocity"
        v.MaxForce = Vector3.new(0, 4000, 0)
        v.P = 1250
        v.Velocity = Vector3.new(0, uf, 0)
        v.Parent = rp
        
        debris:AddItem(v, 0.15)
    end
end

local function enBH()
    if bhc then
        bhc:Disconnect()
        bhc = nil
    end
    
    local c = me.Character
    if not c then return end
    
    local h = c:FindFirstChildOfClass("Humanoid")
    if not h then return end
    
    bhc = h.StateChanged:Connect(function(o, n)
        if n == Enum.HumanoidStateType.Jumping then
            appBH(c, h)
        end
    end)
    
    local ic = uis.InputBegan:Connect(function(i, gp)
        if not gp and i.KeyCode == Enum.KeyCode.Space and h:GetState() ~= Enum.HumanoidStateType.Jumping then
            task.spawn(function()
                for _ = 1, 5 do
                    if h:GetState() == Enum.HumanoidStateType.Jumping then
                        appBH(c, h)
                        break
                    end
                    task.wait(0.01)
                end
            end)
        end
    end)
    
    table.insert(wc, ic)
end

local function disBH()
    if bhc then
        bhc:Disconnect()
        bhc = nil
    end
    
    local c = me.Character
    if c and c.Parent then
        local rp = c:FindFirstChild("HumanoidRootPart")
        if rp then
            for _, v in ipairs(rp:GetChildren()) do
                if v.Name == "BYWVelocity" then
                    v:Destroy()
                end
            end
        end
    end
end

local function toggleFOV(v)
    fc = v
    
    if fovConnection then
        fovConnection:Disconnect()
        fovConnection = nil
    end
    
    if v then
        fovConnection = run.Heartbeat:Connect(function()
            if cam and cam:IsA("Camera") and fc then
                cam.FieldOfView = fv
            end
        end)
        
        if cam and cam:IsA("Camera") then
            cam.FieldOfView = fv
        end
    else
        if cam and cam:IsA("Camera") then
            cam.FieldOfView = 70
        end
    end
end

local function onCameraChanged()
    cam = workspace.CurrentCamera
    if fc and cam and cam:IsA("Camera") then
        cam.FieldOfView = fv
    end
end

local function isVis(tc, lc)
    if not tc or not lc then return false end
    
    local th = tc:FindFirstChild("Head")
    local lh = lc:FindFirstChild("Head")
    
    if not th or not lh then return false end
    
    local o = lh.Position
    local tp = th.Position
    local d = (tp - o).Magnitude
    
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Blacklist
    rp.FilterDescendantsInstances = {lc, tc}
    
    local r = workspace:Raycast(o, (tp - o).Unit * d, rp)
    
    return r == nil
end

local function createGlowESPForPlayer(player)
    if not ge then return end
    if player == me then return end
    
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return end
    
    if gh[player] then
        gh[player]:Destroy()
        gh[player] = nil
    end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "GlowESP_" .. player.Name
    
    if vi and me.Character then
        if isVis(character, me.Character) then
            highlight.FillColor = Color3.fromRGB(50, 255, 50)
            highlight.OutlineColor = Color3.fromRGB(0, 200, 0)
        else
            highlight.FillColor = Color3.fromRGB(255, 50, 50)
            highlight.OutlineColor = Color3.fromRGB(200, 0, 0)
        end
    else
        highlight.FillColor = Color3.fromRGB(255, 50, 50)
        highlight.OutlineColor = Color3.fromRGB(200, 0, 0)
    end
    
    highlight.FillTransparency = 0.7
    highlight.OutlineTransparency = 0.3
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Enabled = true
    highlight.Adornee = character
    highlight.Parent = game:GetService("CoreGui")
    
    gh[player] = highlight
    
    if not ghConnections[player] then
        local diedConnection = humanoid.Died:Connect(function()
            if gh[player] then
                gh[player]:Destroy()
                gh[player] = nil
            end
        end)
        
        ghConnections[player] = diedConnection
    end
end

local function removeGlowESPForPlayer(player)
    if gh[player] then
        gh[player]:Destroy()
        gh[player] = nil
    end
    
    if ghConnections[player] then
        ghConnections[player]:Disconnect()
        ghConnections[player] = nil
    end
end

local function updateAllGlowESP()
    for player, highlight in pairs(gh) do
        if highlight then
            highlight:Destroy()
        end
    end
    gh = {}
    
    for player, connection in pairs(ghConnections) do
        if connection then
            connection:Disconnect()
        end
    end
    ghConnections = {}
    
    if not ge then return end
    
    for _, player in pairs(plrs:GetPlayers()) do
        if player ~= me then
            createGlowESPForPlayer(player)
        end
    end
end

local function updateGlowESPColors()
    if not ge then return end
    
    for player, highlight in pairs(gh) do
        if player and player.Character and highlight and highlight.Parent then
            local character = player.Character
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            
            if humanoid and humanoid.Health > 0 then
                if vi and me.Character then
                    if isVis(character, me.Character) then
                        highlight.FillColor = Color3.fromRGB(50, 255, 50)
                        highlight.OutlineColor = Color3.fromRGB(0, 200, 0)
                    else
                        highlight.FillColor = Color3.fromRGB(255, 50, 50)
                        highlight.OutlineColor = Color3.fromRGB(200, 0, 0)
                    end
                else
                    highlight.FillColor = Color3.fromRGB(255, 50, 50)
                    highlight.OutlineColor = Color3.fromRGB(200, 0, 0)
                end
            else
                removeGlowESPForPlayer(player)
            end
        end
    end
end

local function togGE(v)
    ge = v
    if v then
        updateAllGlowESP()
    else
        for player, highlight in pairs(gh) do
            if highlight then
                highlight:Destroy()
            end
        end
        gh = {}
        
        for player, connection in pairs(ghConnections) do
            if connection then
                connection:Disconnect()
            end
        end
        ghConnections = {}
    end
end

local function rb()
    local t = tick()
    local r = math.sin(t * 2) * 0.5 + 0.5
    local g = math.sin(t * 2 + 2) * 0.5 + 0.5
    local b = math.sin(t * 2 + 4) * 0.5 + 0.5
    return Color3.new(r, g, b)
end

if Drawing then
    circ = Drawing.new("Circle")
    circ.Visible = false
    circ.Color = Color3.new(1, 1, 1)
    circ.Thickness = 1
    circ.NumSides = 64
    circ.Filled = false
    circ.Radius = cr
    circ.Position = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
end

local oc = {}

local function togRC(v)
    rc = v
    
    if v then
        if rcc then rcc:Disconnect() end
        
        if me.Character then
            local c = me.Character
            for _, p in pairs(c:GetChildren()) do
                if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
                    if not oc[p] then oc[p] = p.Color end
                end
            end
        end
        
        rcc = run.Heartbeat:Connect(function()
            if me.Character then
                local c = me.Character
                local col = rb()
                
                for _, p in pairs(c:GetChildren()) do
                    if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
                        p.Color = col
                    end
                end
            end
        end)
    else
        if rcc then
            rcc:Disconnect()
            rcc = nil
        end
        
        if me.Character then
            local c = me.Character
            for _, p in pairs(c:GetChildren()) do
                if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
                    if oc[p] then
                        p.Color = oc[p]
                        oc[p] = nil
                    end
                end
            end
        end
        oc = {}
    end
end

local function togFB(v)
    fb = v
    if v and light then
        light.GlobalShadows = false
        light.FogEnd = 100000
        light.Brightness = 7
        light.ClockTime = 14
        
        for _, o in pairs(light:GetChildren()) do
            if o:IsA("Light") or o:IsA("PostEffect") then
                o.Enabled = false
            end
        end
    elseif light then
        light.GlobalShadows = true
        light.FogEnd = ofe
        light.Brightness = 2
        light.ClockTime = 14
        
        for _, o in pairs(light:GetChildren()) do
            if o:IsA("Light") or o:IsA("PostEffect") then
                o.Enabled = true
            end
        end
    end
end

local function togNF(v)
    nf = v
    if v and light then
        ofe = light.FogEnd
        ofc = light.FogColor
        light.FogEnd = 100000
        light.FogColor = Color3.new(1, 1, 1)
    elseif light then
        light.FogEnd = ofe
        light.FogColor = ofc
    end
end

local function togXR(v)
    xr = v
    
    if xr then
        for _, p in pairs(workspace:GetDescendants()) do
            if p:IsA("BasePart") and p.Parent ~= me.Character then
                p.LocalTransparencyModifier = 0.5
                table.insert(xp, p)
            end
        end
    else
        for _, p in pairs(xp) do
            if p and p.Parent then
                p.LocalTransparencyModifier = 0
            end
        end
        xp = {}
    end
end

local function togStr(v)
    if v then
        enStr()
    else
        disStr()
    end
end

local function togBH(v)
    bh = v
    if v then
        enBH()
    else
        disBH()
    end
end

local function smoothAim(pos)
    if not pos then return end
    local cam = workspace.CurrentCamera
    if not cam then return end
    
    local cp = cam.CFrame.Position
    local td = (pos - cp).Unit
    local cd = cam.CFrame.LookVector
    
    local smoothFactor = math.clamp(sv, 0.05, 2.0)
    
    local lerpFactor = 1.05 - (smoothFactor * 0.5)
    
    lerpFactor = math.clamp(lerpFactor, 0.05, 1.0)
    
    if smoothFactor < 0.2 then
        lerpFactor = math.max(0.8, lerpFactor)
    end
    
    local nd = cd:Lerp(td, lerpFactor)
    
    cam.CFrame = CFrame.lookAt(cp, cp + nd)
end

local function togSpawn(v)
    cs = v
    if v then
        local c = me.Character
        if c and c:FindFirstChild("HumanoidRootPart") then
            local pos = c.HumanoidRootPart.Position
            csloc = pos
            if cspart then cspart:Destroy() end
            cspart = Instance.new("Part")
            cspart.Name = "CustomSpawnPoint"
            cspart.Size = Vector3.new(5, 1, 5)
            cspart.Position = pos
            cspart.Anchored = true
            cspart.CanCollide = false
            cspart.Transparency = 0.7
            cspart.Color = Color3.fromRGB(0, 255, 0)
            cspart.Material = Enum.Material.Neon
            cspart.Parent = workspace
            local l = Instance.new("PointLight")
            l.Brightness = 1
            l.Range = 10
            l.Color = Color3.fromRGB(0, 255, 0)
            l.Parent = cspart
        end
        if rc then rc:Disconnect() end
        rc = me.CharacterAdded:Connect(function(c)
            wait(0.1)
            if cs and csloc then
                local hrp = c:WaitForChild("HumanoidRootPart", 5)
                if hrp then hrp.CFrame = CFrame.new(csloc) end
            end
        end)
    else
        if cspart then cspart:Destroy() cspart = nil end
        csloc = nil
        if rc then rc:Disconnect() rc = nil end
    end
end

local ijc
local function togJump(v)
    ij = v
    if v then
        ijc = uis.JumpRequest:Connect(function()
            local c = me.Character
            if c and c:FindFirstChild("Humanoid") then
                c.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    else
        if ijc then ijc:Disconnect() end
    end
end

local function updSpeed()
    local c = me.Character
    if c and c:FindFirstChild("Humanoid") then
        if spd then
            c.Humanoid.WalkSpeed = ps
        else
            c.Humanoid.WalkSpeed = 16
        end
    end
end

local function updTpW()
    if tpw then
        getgenv().TpWalking = true
        getgenv().Speed = tpws
    else
        getgenv().TpWalking = false
    end
end

local ncc
local function togNC(v)
    nc = v
    if v then
        ncc = run.Stepped:Connect(function()
            if me.Character then
                for _, p in pairs(me.Character:GetDescendants()) do
                    if p:IsA("BasePart") then
                        p.CanCollide = false
                    end
                end
            end
        end)
    else
        if ncc then ncc:Disconnect() end
    end
end

local function enemy(p)
    if not tc then return true end
    if not me.Team then return true end
    if not p.Team then return true end
    return p.Team ~= me.Team
end

local function teamC(p)
    if p.Team then
        local tc = p.Team.TeamColor
        if tc then return tc.Color end
    end
    local lb = game:GetService("Players"):FindFirstChild("Leaderboard")
    if not lb then lb = workspace:FindFirstChild("Leaderboard") end
    if not lb then lb = game:GetService("StarterGui"):FindFirstChild("Leaderboard") end
    if not lb then return Color3.fromRGB(255, 50, 50) end
    local has = false
    for _, c in pairs(lb:GetChildren()) do
        if c:IsA("Team") then has = true break end
    end
    if not has then return Color3.fromRGB(255, 50, 50) end
    for _, c in pairs(lb:GetChildren()) do
        if c:IsA("Team") then
            for _, m in pairs(c:GetPlayers()) do
                if m == p then
                    if c.TeamColor then return c.TeamColor.Color end
                    break
                end
            end
        end
    end
    return Color3.fromRGB(255, 50, 50)
end

local function teamColorS(p)
    local tc = teamC(p)
    if tc and not enemy(p) then
        return Color3.new(tc.R * 0.3, tc.G * 0.3, tc.B * 0.3)
    end
    return tc
end

local function showE(p)
    if p == me then return false end
    if tc then return enemy(p) end
    return true
end

local function validC(c)
    if not c then return false end
    local hrp = c:FindFirstChild("HumanoidRootPart")
    local h = c:FindFirstChildOfClass("Humanoid")
    return hrp and h and h.Health > 0
end

local function inD(p)
    if not me.Character then return false end
    if not p.Character then return false end
    if not me.Character:FindFirstChild("HumanoidRootPart") then return false end
    if not p.Character:FindFirstChild("HumanoidRootPart") then return false end
    local d = (me.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
    return d <= md
end

local chams = {}
local function addC(p, c, tc)
    if not c then return end
    if chams[p] then chams[p]:Destroy() chams[p] = nil end
    
    local hl = Instance.new("Highlight")
    hl.Parent = game:GetService("CoreGui")
    hl.Adornee = c
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    
    if vi and me.Character then
        if isVis(c, me.Character) then
            hl.FillColor = Color3.fromRGB(50, 255, 50)
        else
            hl.FillColor = Color3.fromRGB(255, 50, 50)
        end
    else
        hl.FillColor = tc
    end
    
    hl.FillTransparency = 0.3
    hl.OutlineColor = Color3.new(0, 0, 0)
    hl.OutlineTransparency = 0
    hl.Enabled = true
    chams[p] = hl
end

local function remC(p)
    if chams[p] then chams[p]:Destroy() chams[p] = nil end
end

local function newE(p)
    if eso[p] then return eso[p] end
    if not Drawing then return end
    local b = Drawing.new("Square")
    b.Thickness = 2 b.Filled = false b.Visible = false b.Color = Color3.new(1, 0, 0)
    local l = Drawing.new("Line")
    l.Thickness = 1.5 l.Visible = false l.ZIndex = 1
    local n = Drawing.new("Text")
    n.Size = 14 n.Center = true n.Outline = false n.Visible = false n.ZIndex = 1
    local ho = Drawing.new("Square")
    ho.Thickness = 1 ho.Filled = false ho.Visible = false ho.ZIndex = 1
    local hf = Drawing.new("Square")
    hf.Thickness = 1 hf.Filled = true hf.Visible = false hf.ZIndex = 1
    local ht = Drawing.new("Text")
    ht.Size = 12 ht.Center = true ht.Outline = false ht.Visible = false ht.ZIndex = 1
    local d = Drawing.new("Text")
    d.Size = 14 d.Center = true d.Outline = false d.Visible = false d.ZIndex = 1
    eso[p] = {Box = b, Line = l, Name = n, HOut = ho, HFill = hf, HText = ht, Dist = d}
    return eso[p]
end

local function delE(p)
    local e = eso[p]
    if e then
        if e.Box then e.Box:Remove() end
        if e.Line then e.Line:Remove() end
        if e.Name then e.Name:Remove() end
        if e.HOut then e.HOut:Remove() end
        if e.HFill then e.HFill:Remove() end
        if e.HText then e.HText:Remove() end
        if e.Dist then e.Dist:Remove() end
        eso[p] = nil
    end
    remC(p)
end

local function clearE()
    for p, e in pairs(eso) do
        if e then
            if e.Box then e.Box.Visible = false end
            if e.Line then e.Line.Visible = false end
            if e.Name then e.Name.Visible = false end
            if e.HOut then e.HOut.Visible = false end
            if e.HFill then e.HFill.Visible = false end
            if e.HText then e.HText.Visible = false end
            if e.Dist then e.Dist.Visible = false end
        end
        if not ch then remC(p) end
    end
end

local function updE()
    for p, e in pairs(eso) do
        if e then
            if e.Box then e.Box.Visible = false end
            if e.Line then e.Line.Visible = false end
            if e.Name then e.Name.Visible = false end
            if e.HOut then e.HOut.Visible = false end
            if e.HFill then e.HFill.Visible = false end
            if e.HText then e.HText.Visible = false end
            if e.Dist then e.Dist.Visible = false end
        end
        if not ch then remC(p) end
    end

    if not (b or ln or nm or ch or hp or dst) then return end

    for _, p in pairs(plrs:GetPlayers()) do
        if not inD(p) then
            local e = eso[p]
            if e then
                if e.Box then e.Box.Visible = false end
                if e.Line then e.Line.Visible = false end
                if e.Name then e.Name.Visible = false end
                if e.HOut then e.HOut.Visible = false end
                if e.HFill then e.HFill.Visible = false end
                if e.HText then e.HText.Visible = false end
                if e.Dist then e.Dist.Visible = false end
            end
            remC(p)
            continue
        end
        
        if not showE(p) then
            local e = eso[p]
            if e then
                if e.Box then e.Box.Visible = false end
                if e.Line then e.Line.Visible = false end
                if e.Name then e.Name.Visible = false end
                if e.HOut then e.HOut.Visible = false end
                if e.HFill then e.HFill.Visible = false end
                if e.HText then e.HText.Visible = false end
                if e.Dist then e.Dist.Visible = false end
            end
            remC(p)
            continue
        end
        
        local e = eso[p]
        if not e then e = newE(p) end
        if not e then continue end
        
        local c = p.Character
        if c and c:FindFirstChild("HumanoidRootPart") and c:FindFirstChild("Head") and c:FindFirstChildOfClass("Humanoid") then
            local h = c.Head
            local hrp = c.HumanoidRootPart
            local hum = c:FindFirstChildOfClass("Humanoid")
            
            local hp_w, hv = cam:WorldToViewportPoint(h.Position)
            local fp = cam:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
            
            if hv and fp.Z > 0 then
                local h2 = Vector2.new(hp_w.X, hp_w.Y)
                local f2 = Vector2.new(fp.X, fp.Y)
                
                local ht = math.abs(f2.Y - h2.Y)
                local w = ht * 0.6
                
                local min = 15
                if w < min then w = min ht = min / 0.6 end
                
                if ht < 5 then
                    if e.Box then e.Box.Visible = false end
                    if e.HOut then e.HOut.Visible = false end
                    if e.HFill then e.HFill.Visible = false end
                    if e.HText then e.HText.Visible = false end
                    if e.Dist then e.Dist.Visible = false end
                    continue
                end
                
                local d = 0
                if me.Character and validC(me.Character) then
                    d = (hrp.Position - me.Character.HumanoidRootPart.Position).Magnitude
                end
                
                local tc = re and rb() or teamColorS(p)
                
                if b then
                    e.Box.Position = Vector2.new(h2.X - w/2, h2.Y)
                    e.Box.Size = Vector2.new(w, ht)
                    e.Box.Visible = true
                    e.Box.Color = tc
                else
                    e.Box.Visible = false
                end
                
                if ln then
                    local sc = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y)
                    e.Line.From = sc
                    e.Line.To = Vector2.new(h2.X, h2.Y)
                    e.Line.Color = tc
                    e.Line.Visible = true
                else
                    e.Line.Visible = false
                end
                
                if nm then
                    e.Name.Text = p.Name
                    e.Name.Position = Vector2.new(h2.X, h2.Y - ht/2 - 20)
                    e.Name.Color = tc
                    e.Name.Visible = true
                else
                    e.Name.Visible = false
                end
                
                if hp then
                    local hpv = hum.Health
                    local max = hum.MaxHealth
                    local per = math.clamp(hpv / max, 0, 1)
                    
                    local bw = 4
                    local bh = math.max(ht - 4, 10)
                    local bx = h2.X - w/2 - 10
                    local by = h2.Y + 2
                    
                    local fh = bh * per
                    local fy = by + (bh - fh)
                    
                    e.HFill.Position = Vector2.new(bx, fy)
                    e.HFill.Size = Vector2.new(bw, fh)
                    
                    local hc = Color3.new(1 - per, per, 0)
                    e.HFill.Color = hc
                    e.HFill.Visible = true
                    
                    e.HText.Text = tostring(math.floor(hpv))
                    e.HText.Position = Vector2.new(bx + bw/2, by + bh + 5)
                    e.HText.Color = Color3.new(1, 1, 1)
                    e.HText.Visible = true
                    
                    e.HOut.Visible = false
                else
                    e.HOut.Visible = false
                    e.HFill.Visible = false
                    e.HText.Visible = false
                end
                
                if dst then
                    local distanceY = h2.Y - ht/2 - 35
                    if nm then
                        distanceY = h2.Y - ht/2 - 55
                    end
                    
                    e.Dist.Text = math.floor(d) .. "м"
                    e.Dist.Position = Vector2.new(h2.X, distanceY)
                    e.Dist.Color = tc
                    e.Dist.Visible = true
                else
                    e.Dist.Visible = false
                end
                
                if ch then
                    addC(p, c, tc)
                else
                    remC(p)
                end
                
            else
                if e.Box then e.Box.Visible = false end
                if e.Line then e.Line.Visible = false end
                if e.Name then e.Name.Visible = false end
                if e.HOut then e.HOut.Visible = false end
                if e.HFill then e.HFill.Visible = false end
                if e.HText then e.HText.Visible = false end
                if e.Dist then e.Dist.Visible = false end
                remC(p)
            end
        else
            if e then
                if e.Box then e.Box.Visible = false end
                if e.Line then e.Line.Visible = false end
                if e.Name then e.Name.Visible = false end
                if e.HOut then e.HOut.Visible = false end
                if e.HFill then e.HFill.Visible = false end
                if e.HText then e.HText.Visible = false end
                if e.Dist then e.Dist.Visible = false end
            end
            remC(p)
        end
    end
end

local function visibleS(t)
    if not vc then return true end
    local lc = me.Character
    local tc = t.Character
    if not lc or not tc then return false end
    local th = tc:FindFirstChild("Head")
    if not th then return false end
    local o = cam.CFrame.Position
    local tp = th.Position
    local pts = {
        tp,
        tp - Vector3.new(0, 1.5, 0),
        tp - Vector3.new(0, 3, 0)
    }
    for _, pt in ipairs(pts) do
        local dir = (pt - o).Unit
        local dis = (pt - o).Magnitude
        local rp = RaycastParams.new()
        rp.FilterType = Enum.RaycastFilterType.Blacklist
        rp.FilterDescendantsInstances = {lc, tc}
        local r = workspace:Raycast(o, dir * dis, rp)
        if not r then return true end
        local m = r.Instance:FindFirstAncestorOfClass("Model")
        if m == tc then return true end
    end
    return false
end

local function closest()
    local cp = nil
    local cd = math.huge
    for _, p in pairs(plrs:GetPlayers()) do
        if p == me then continue end
        if tc and not enemy(p) then continue end
        local c = p.Character
        if c and c:FindFirstChild("Head") then
            local h = c.Head
            local hp, ons = cam:WorldToViewportPoint(h.Position)
            if ons then
                local dp = (h.Position - cam.CFrame.Position).Magnitude
                if not vc or visibleS(p) then
                    if dp < cd then cp = p cd = dp end
                end
            end
        end
    end
    return cp
end

local function closestC()
    local cp = nil
    local cd = math.huge
    local sc = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    for _, p in pairs(plrs:GetPlayers()) do
        if p == me then continue end
        if tc and not enemy(p) then continue end
        local c = p.Character
        if c and c:FindFirstChild("Head") then
            local h = c.Head
            local hp, ons = cam:WorldToViewportPoint(h.Position)
            if ons then
                local sp = Vector2.new(hp.X, hp.Y)
                local dc = (sp - sc).Magnitude
                if dc <= cr then
                    if not vc or visibleS(p) then
                        if dc < cd then cp = p cd = dc end
                    end
                end
            end
        end
    end
    return cp
end

local function aimAt(pos)
    if not pos then return end
    local cam = workspace.CurrentCamera
    if not cam then return end
    
    if sa then
        smoothAim(pos)
    else
        local cp = cam.CFrame.Position
        local d = (pos - cp).Unit
        cam.CFrame = CFrame.lookAt(cp, cp + d)
    end
end

local function updCirc()
    if circ then
        circ.Visible = sf
        circ.Radius = cr
        if rf then
            circ.Color = rb()
        else
            circ.Color = Color3.new(1, 1, 1)
        end
        local cam = workspace.CurrentCamera
        if cam then
            circ.Position = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
        end
    end
end

local function rejoin()
    tele:TeleportToPlaceInstance(game.PlaceId, game.JobId)
end

a:CreateToggle({
    Name = "aimbot",
    CurrentValue = false,
    Flag = "AimBotToggle",
    Callback = function(v) ab = v end,
})

a:CreateToggle({
    Name = "Smoothness Aim",
    CurrentValue = false,
    Flag = "SmoothAimToggle",
    Callback = function(v) sa = v end,
})

a:CreateToggle({
    Name = "Prediction aim",
    CurrentValue = false,
    Flag = "AimPredictionToggle",
    Callback = function(v) ap = v end,
})

a:CreateToggle({
    Name = "Show fov",
    CurrentValue = false,
    Flag = "ShowFOVToggle",
    Callback = function(v) sf = v updCirc() end,
})

a:CreateToggle({
    Name = "Visibility check",
    CurrentValue = false,
    Flag = "VisibleCheckToggle",
    Callback = function(v) vc = v end,
})

a:CreateToggle({
    Name = "Rainbow fov",
    CurrentValue = false,
    Flag = "RainbowFOVToggle",
    Callback = function(v) rf = v end,
})

a:CreateSlider({
    Name = "Fov size",
    Range = {10, 500},
    Increment = 5,
    Suffix = "fov XD",
    CurrentValue = 50,
    Flag = "CircleSizeSlider",
    Callback = function(v) cr = v updCirc() end,
})

a:CreateSlider({
    Name = "Prediction",
    Range = {0.001, 0.5},
    Increment = 0.001,
    Suffix = "",
    CurrentValue = 0.001,
    Flag = "PredictionStrengthSlider",
    Callback = function(v) pred = v end,
})

a:CreateSlider({
    Name = "Smoothness aim",
    Range = {0.05, 2.0},
    Increment = 0.05,
    Suffix = "",
    CurrentValue = 0.5,
    Flag = "SmoothnessSlider",
    Callback = function(v) 
        sv = v 
    end,
})

e:CreateToggle({
    Name = "Boxes",
    CurrentValue = false,
    Flag = "BoxesToggle",
    Callback = function(v) 
        b = v 
        if not v then clearE() end
    end,
})

e:CreateToggle({
    Name = "Lines", 
    CurrentValue = false,
    Flag = "LinesToggle",
    Callback = function(v) ln = v clearE() end,
})

e:CreateToggle({
    Name = "Nicknames",
    CurrentValue = false,
    Flag = "NamesToggle",
    Callback = function(v) nm = v if not v then clearE() end end,
})

e:CreateToggle({
    Name = "Chams",
    CurrentValue = false,
    Flag = "ChamsToggle",
    Callback = function(v) ch = v if not v then clearE() end end,
})

e:CreateToggle({
    Name = "Glow",
    CurrentValue = false,
    Flag = "GlowESPToggle",
    Callback = function(v) togGE(v) end,
})

e:CreateToggle({
    Name = "Visibility indicator",
    CurrentValue = false,
    Flag = "VisibilityIndicatorToggle",
    Callback = function(v) 
        vi = v
        if ge then
            updateGlowESPColors()
        end
        if ch then
            for p, h in pairs(chams) do
                if h and h.Parent then
                    if v and me.Character then
                        local c = plrs:FindFirstChild(p.Name)
                        if c and c.Character then
                            if isVis(c.Character, me.Character) then
                                h.FillColor = Color3.fromRGB(50, 255, 50)
                            else
                                h.FillColor = Color3.fromRGB(255, 50, 50)
                            end
                        end
                    else
                        local tc = re and rb() or teamColorS(p)
                        h.FillColor = tc
                    end
                end
            end
        end
    end,
})

e:CreateToggle({
    Name = "Health bar",
    CurrentValue = false,
    Flag = "HealthBarToggle",
    Callback = function(v) hp = v if not v then clearE() end end,
})

e:CreateToggle({
    Name = "Distance",
    CurrentValue = false,
    Flag = "DistanceESPToggle",
    Callback = function(v) dst = v if not v then clearE() end end,
})

e:CreateToggle({
    Name = "Rainbow ESP",
    CurrentValue = false,
    Flag = "RainbowESPToggle",
    Callback = function(v) re = v end,
})

e:CreateToggle({
    Name = "Team check",
    CurrentValue = false,
    Flag = "TeamCheckToggle",
    Callback = function(v) tc = v clearE() end,
})

e:CreateToggle({
    Name = "Enemy counter",
    CurrentValue = false,
    Flag = "EnemyCounterToggle",
    Callback = function(v) 
        ec = v
        updateEnemyCounterDisplay()
    end,
})

e:CreateToggle({
    Name = "x-ray",
    CurrentValue = false,
    Flag = "XRayToggle",
    Callback = function(v) togXR(v) end,
})

e:CreateSlider({
    Name = "Distance ESP",
    Range = {100, 1000},
    Increment = 50,
    Suffix = "Distance",
    CurrentValue = 1000,
    Flag = "ESPDistanceSlider",
    Callback = function(v) md = v end,
})


p:CreateToggle({
    Name = "FPS boost",
    CurrentValue = false,
    Flag = "FPSBoostToggle",
    Callback = function(v)
        if v then
            enFB()
        else
            disFB()
        end
    end,
})

p:CreateToggle({
    Name = "4:3",
    CurrentValue = false,
    Flag = "StretchToggle",
    Callback = function(v) togStr(v) end,
})

p:CreateSlider({
    Name = "setting 4:3",
    Range = {0.5, 1.0},
    Increment = 0.05,
    Suffix = "",
    CurrentValue = 0.80,
    Flag = "StretchResolutionSlider",
    Callback = function(v) 
        sr = v 
        if se then
            disStr()
            enStr()
        end
    end,
})

p:CreateToggle({
    Name = "change FOV",
    CurrentValue = false,
    Flag = "FOVChangerToggle",
    Callback = function(v) 
        toggleFOV(v)
    end,
})

p:CreateSlider({
    Name = "FOV",
    Range = {30, 120},
    Increment = 1,
    Suffix = "°",
    CurrentValue = 70,
    Flag = "FOVValueSlider",
    Callback = function(v) 
        fv = v 
        if fc and cam and cam:IsA("Camera") then
            cam.FieldOfView = v
        end
    end,
})

p:CreateButton({
    Name = "rejoin",
    Callback = rejoin,
})

v:CreateToggle({
    Name = "Rainbow charcher(unstable)",
    CurrentValue = false,
    Flag = "RainbowCharToggle",
    Callback = function(v) togRC(v) end,
})

v:CreateToggle({
    Name = "brightness",
    CurrentValue = false,
    Flag = "FullBrightToggle",
    Callback = function(v) togFB(v) end,
})

v:CreateToggle({
    Name = "fullbright",
    CurrentValue = false,
    Flag = "NoFogToggle",
    Callback = function(v) togNF(v) end,
})

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(onCameraChanged)

run.Heartbeat:Connect(function()
    local cam = workspace.CurrentCamera
    if not cam then return end
    
    updE()
    updCirc()
    updSpeed()
    updateEnemyCounterDisplay()
    updateFPS()
    
    if ge and vi then
        updateGlowESPColors()
    end
    
    if ab then
        local cp
        if sf then
            cp = closestC()
        else
            cp = closest()
        end
        
        if cp then
            local c = cp.Character
            if c and c:FindFirstChild("HumanoidRootPart") and c:FindFirstChild("Head") and c:FindFirstChildOfClass("Humanoid") then
                local targetHead = c.Head
                local targetPosition = targetHead.Position
                local targetHRP = c.HumanoidRootPart
                local targetVelocity = targetHRP.Velocity
                local predictedPosition = targetPosition
                
                if ap then
                    predictedPosition = targetPosition + (targetVelocity * pred)
                end
                
                aimAt(predictedPosition)
            end
        end
    end
end)

local function setupPlayerGlowESP(player)
    if player == me then return end
    
    player.CharacterAdded:Connect(function(character)
        if ge then
            task.wait(0.5)
            createGlowESPForPlayer(player)
            
            local humanoid = character:WaitForChild("Humanoid", 5)
            if humanoid then
                if ghConnections[player] then
                    ghConnections[player]:Disconnect()
                end
                
                ghConnections[player] = humanoid.Died:Connect(function()
                    removeGlowESPForPlayer(player)
                end)
            end
        end
    end)
    
    if player.Character then
        task.spawn(function()
            task.wait(1)
            if ge then
                createGlowESPForPlayer(player)
                
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    if ghConnections[player] then
                        ghConnections[player]:Disconnect()
                    end
                    
                    ghConnections[player] = humanoid.Died:Connect(function()
                        removeGlowESPForPlayer(player)
                    end)
                end
            end
        end)
    end
end

for _, player in pairs(plrs:GetPlayers()) do
    if player ~= me then
        setupPlayerGlowESP(player)
    end
end

plrs.PlayerAdded:Connect(function(player)
    if player ~= me then
        newE(player)
        setupPlayerGlowESP(player)
    end
end)

plrs.PlayerRemoving:Connect(function(player)
    delE(player)
    removeGlowESPForPlayer(player)
end)

game:GetService("Players").PlayerRemoving:Connect(function(p)
    if p == me then
        togJump(false)
        togSpawn(false)
        togRC(false)
        togFB(false)
        togNF(false)
        togFPS(false)
        toggleFOV(false)
        
        if xr then togXR(false) end
        if fb_en then disFB() end
        if se then disStr() end
        if bh then disBH() end
        if ec then
            ec = false
            updateEnemyCounterDisplay()
        end
        if ge then
            togGE(false)
        end
        
        for _, h in pairs(chams) do
            if h then h:Destroy() end
        end
        chams = {}
        
        removeWM()
    end
    delE(p)
    removeGlowESPForPlayer(p)
end)

me.CharacterAdded:Connect(function()
    if se then enStr() end
    if fc and cam and cam:IsA("Camera") then
        cam.FieldOfView = fv
    end
    if bh then
        task.wait(0.5)
        enBH()
    end
    if ge then
        task.wait(0.5)
        updateAllGlowESP()
    end
    
    if wm and wm.Visible then
        local vs = cam.ViewportSize
        wm.Position = Vector2.new(vs.X / 2, 20)
    end
end)

cam:GetPropertyChangedSignal("ViewportSize"):Connect(function()
    if wm and wm.Visible then
        local vs = cam.ViewportSize
        wm.Position = Vector2.new(vs.X / 2, 20)
    end
    if enemyCounterText then
        local watermarkY = 20
        if wm then
            watermarkY = wm.Position.Y + 25
        end
        enemyCounterText.Position = Vector2.new(cam.ViewportSize.X / 2, watermarkY)
    end
    if fpsLabel then
        local vs = cam.ViewportSize
        fpsLabel.Position = Vector2.new(vs.X - 50, 20)
    end
end)

game:BindToClose(function()
    if fb_en then disFB() end
    if se then disStr() end
    if bh then disBH() end
    removeWM()
end)

for _, p in pairs(plrs:GetPlayers()) do
    if p ~= me then
        newE(p)
    end
end

if ge then
    task.wait(1)
    updateAllGlowESP()
end
