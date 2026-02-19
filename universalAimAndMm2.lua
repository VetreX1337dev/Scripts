local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "universal aim",
    LoadingTitle = " script created",
    LoadingSubtitle = "by Echeron",
    ConfigurationSaving = {
        Enabled = false
    },
    Discord = {
        Enabled = false
    }
})

local MainTab = Window:CreateTab("main", 4483362458)
local TracerTab = Window:CreateTab("tracer", 4483362458)
local MM2Tab = Window:CreateTab("murder mystery", 4483362458)

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

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

local function GetPlayerRole(player)
    local character = player.Character
    if not character then return "Innocent" end
    
    if character:FindFirstChild("Knife") or player.Backpack:FindFirstChild("Knife") then
        return "Murderer"
    elseif character:FindFirstChild("Gun") or player.Backpack:FindFirstChild("Gun") then
        return "Sheriff"
    end
    return "Innocent"
end

local function IsVisible(targetPart)
    local character = LocalPlayer.Character
    if not character then return false end
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {character, Camera}
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

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            
            if onlyMurder and GetPlayerRole(player) ~= "Murderer" then
                continue
            end

            local part = player.Character:FindFirstChild(TargetPartName) or player.Character:FindFirstChild("HumanoidRootPart")
            if part then
                if not ignoreVisibility and VisibleCheckEnabled and not IsVisible(part) then
                    continue
                end

                local Pos, OnScreen = Camera:WorldToViewportPoint(part.Position)
                if OnScreen then
                    local Distance = (Vector2.new(Pos.X, Pos.Y) - Center).Magnitude
                    if Distance <= FOVRadius and Distance < ShortestDistance then
                        Target = player
                        ShortestDistance = Distance
                    end
                end
            end
        end
    end
    return Target
end

local function UpdateESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local character = player.Character
            if character and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0 then
                if ESPEnabled or MM2ESPEnabled then
                    if not ESPHighlights[player] then
                        local highlight = Instance.new("Highlight")
                        highlight.Name = "ESPHighlight"
                        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        highlight.FillTransparency = 0.5
                        highlight.OutlineTransparency = 0
                        highlight.Parent = character
                        ESPHighlights[player] = highlight
                    end
                    
                    local highlight = ESPHighlights[player]
                    if MM2ESPEnabled then
                        local role = GetPlayerRole(player)
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
                        highlight.FillColor = player.Team and player.TeamColor.Color or Color3.fromRGB(255, 255, 255)
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    end
                elseif ESPHighlights[player] then
                    ESPHighlights[player]:Destroy()
                    ESPHighlights[player] = nil
                end
            elseif ESPHighlights[player] then
                ESPHighlights[player]:Destroy()
                ESPHighlights[player] = nil
            end
        end
    end
end

local AimlockToggle = MainTab:CreateToggle({
    Name = "aimlock",
    CurrentValue = false,
    Callback = function(Value) AimlockEnabled = Value end,
})

MainTab:CreateKeybind({
    Name = "Aimlock Bind",
    CurrentKeybind = "E",
    HoldToInteract = false,
    Callback = function() AimlockToggle:Set(not AimlockEnabled) end,
})

MainTab:CreateDropdown({
    Name = "Target Part",
    Options = {"Head", "Torso"},
    CurrentOption = {"Head"},
    Callback = function(Option) TargetPartName = Option[1] end,
})

MainTab:CreateSlider({
    Name = "Sensitivity",
    Range = {1, 100},
    Increment = 1,
    CurrentValue = 50,
    Callback = function(Value) AimSensitivity = Value / 100 end,
})

MainTab:CreateToggle({
    Name = "visible check",
    CurrentValue = false,
    Callback = function(Value) VisibleCheckEnabled = Value end,
})

MainTab:CreateToggle({
    Name = "show fov",
    CurrentValue = false,
    Callback = function(Value) FOVCircle.Visible = Value end,
})

MainTab:CreateSlider({
    Name = "fov size",
    Range = {10, 800},
    Increment = 1,
    CurrentValue = 100,
    Callback = function(Value) 
        FOVRadius = Value 
        FOVCircle.Radius = Value
    end,
})

MainTab:CreateToggle({
    Name = "esp",
    CurrentValue = false,
    Callback = function(Value) ESPEnabled = Value end,
})

TracerTab:CreateToggle({
    Name = "show target tracer",
    CurrentValue = false,
    Callback = function(Value) TracerEnabled = Value end,
})

TracerTab:CreateDropdown({
    Name = "Tracer Position",
    Options = {"Top", "Center", "Bottom"},
    CurrentOption = {"Bottom"},
    Callback = function(Option) TracerPosition = Option[1] end,
})

local MM2AimToggle = MM2Tab:CreateToggle({
    Name = "aimlock murder",
    CurrentValue = false,
    Callback = function(Value) MM2AimEnabled = Value end,
})

MM2Tab:CreateKeybind({
    Name = "MM2 Aim Bind",
    CurrentKeybind = "Q",
    HoldToInteract = false,
    Callback = function() MM2AimToggle:Set(not MM2AimEnabled) end,
})

MM2Tab:CreateToggle({
    Name = "esp (roles)",
    CurrentValue = false,
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
