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

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local AimlockEnabled = false
local VisibleCheckEnabled = false
local ESPEnabled = false
local TracerEnabled = false
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

local function GetClosestPlayerToCenter(ignoreVisibility)
    local Target = nil
    local ShortestDistance = math.huge
    local ViewportSize = Camera.ViewportSize
    local Center = Vector2.new(ViewportSize.X / 2, ViewportSize.Y / 2)

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            
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
                if ESPEnabled then
                    if not ESPHighlights[player] then
                        local highlight = Instance.new("Highlight")
                        highlight.Name = "ESPHighlight"
                        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        highlight.FillTransparency = 1
                        highlight.OutlineTransparency = 0
                        highlight.Parent = character
                        ESPHighlights[player] = highlight
                    end
                    local highlight = ESPHighlights[player]
                    highlight.OutlineColor = player.Team and player.TeamColor.Color or Color3.fromRGB(255, 255, 255)
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

-- Main Tab
local AimlockToggle = MainTab:CreateToggle({
    Name = "aimlock",
    CurrentValue = false,
    Flag = "AimlockFlag",
    Callback = function(Value) AimlockEnabled = Value end,
})

MainTab:CreateKeybind({
    Name = "Aimlock Bind",
    CurrentKeybind = "E",
    HoldToInteract = false,
    Flag = "AimlockKeybind",
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

-- Tracer Tab
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

RunService.RenderStepped:Connect(function()
    local ViewportSize = Camera.ViewportSize
    FOVCircle.Position = Vector2.new(ViewportSize.X / 2, ViewportSize.Y / 2)
    
    UpdateESP()
    
    local TargetForTracer = GetClosestPlayerToCenter(true)
    local TargetForAim = GetClosestPlayerToCenter(false)
    
    if TracerEnabled and TargetForTracer and TargetForTracer.Character then
        local part = TargetForTracer.Character:FindFirstChild(TargetPartName) or TargetForTracer.Character:FindFirstChild("HumanoidRootPart")
        if part then
            local Pos, OnScreen = Camera:WorldToViewportPoint(part.Position)
            if OnScreen then
                local StartPos
                if TracerPosition == "Top" then
                    StartPos = Vector2.new(ViewportSize.X / 2, 0)
                elseif TracerPosition == "Center" then
                    StartPos = Vector2.new(ViewportSize.X / 2, ViewportSize.Y / 2)
                else
                    StartPos = Vector2.new(ViewportSize.X / 2, ViewportSize.Y)
                end
                
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

    if AimlockEnabled and TargetForAim and TargetForAim.Character then
        local part = TargetForAim.Character:FindFirstChild(TargetPartName) or TargetForAim.Character:FindFirstChild("HumanoidRootPart")
        if part then
            local TargetCFrame = CFrame.new(Camera.CFrame.Position, part.Position)
            Camera.CFrame = Camera.CFrame:Lerp(TargetCFrame, AimSensitivity)
        end
    end
end)
