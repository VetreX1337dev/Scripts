local _5 = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local _call7 = game:GetService('Players')
local _call9 = game:GetService('RunService')
local _call13 = game:GetService('Lighting')
local _call15 = game:GetService('Workspace')
local _LocalPlayer16 = _call7.LocalPlayer
local _CurrentCamera17 = _call15.CurrentCamera
local _call81 = _5:CreateWindow({
    LoadingTitle = 'universal Vetrex hub',
    Name = 'universal vetrex Hub',
    KeySystem = false,
    LoadingSubtitle = 'by DottaWasCorupted',
    Theme = {
        Shadow = Color3.fromRGB(0, 0, 0),
        SliderProgress = Color3.fromRGB(0, 255, 255),
        PlaceholderColor = Color3.fromRGB(150, 150, 150),
        InputStroke = Color3.fromRGB(80, 80, 80),
        ToggleDisabledStroke = Color3.fromRGB(120, 120, 120),
        InputBackground = Color3.fromRGB(15, 15, 15),
        ElementBackgroundHover = Color3.fromRGB(20, 20, 20),
        DropdownUnselected = Color3.fromRGB(15, 15, 15),
        SelectedTabTextColor = Color3.fromRGB(255, 255, 255),
        NotificationBackground = Color3.fromRGB(5, 5, 5),
        DropdownSelected = Color3.fromRGB(25, 25, 25),
        SecondaryElementStroke = Color3.fromRGB(70, 70, 70),
        Background = Color3.fromRGB(5, 5, 5),
        ToggleDisabledOuterStroke = Color3.fromRGB(70, 70, 70),
        TabStroke = Color3.fromRGB(80, 80, 80),
        ElementBackground = Color3.fromRGB(10, 10, 10),
        ToggleEnabledOuterStroke = Color3.fromRGB(100, 100, 100),
        ToggleEnabled = Color3.fromRGB(0, 255, 255),
        ToggleEnabledStroke = Color3.fromRGB(0, 255, 255),
        ToggleDisabled = Color3.fromRGB(80, 80, 80),
        SecondaryElementBackground = Color3.fromRGB(5, 5, 5),
        ToggleBackground = Color3.fromRGB(15, 15, 15),
        TabTextColor = Color3.fromRGB(240, 240, 240),
        ElementStroke = Color3.fromRGB(100, 100, 100),
        SliderBackground = Color3.fromRGB(25, 25, 25),
        SliderStroke = Color3.fromRGB(120, 120, 120),
        NotificationActionsBackground = Color3.fromRGB(200, 200, 200),
        Topbar = Color3.fromRGB(10, 10, 10),
        TabBackground = Color3.fromRGB(15, 15, 15),
        TabBackgroundSelected = Color3.fromRGB(30, 30, 30),
        TextColor = Color3.fromRGB(240, 240, 240),
    },
    ConfigurationSaving = {
        Enabled = true,
        FolderName = 'UniversalHubConfig',
        FileName = 'HubSave',
    },
})
local _call83 = _call81:CreateTab('Profile', 4483362458)
local _call85 = _call81:CreateTab('Combat & Aim', 4483362458)
local _call87 = _call81:CreateTab('Murder Mystery 2', 4483362458)
local _call89 = _call81:CreateTab('Visuals', 4483362458)
local _call91 = _call81:CreateTab('Other', 4483362458)
local _ = _LocalPlayer16.UserId
local _ = _LocalPlayer16.UserId

_call83:CreateParagraph({
    Title = 'Player Profile',
    Content = 'Username: ' .. _LocalPlayer16.Name .. '\nDisplayName: ' .. _LocalPlayer16.DisplayName .. '\nUserId: ' .. _LocalPlayer16.UserId .. '\nStatus: User',
})

local _call106 = Drawing.new('Circle')

_call106.Color = Color3.fromRGB(255, 255, 255)
_call106.Thickness = 1
_call106.Filled = false
_call106.Transparency = 1
_call106.Radius = 100
_call106.Visible = false

local _call110 = Drawing.new('Line')

_call110.Color = Color3.fromRGB(255, 255, 255)
_call110.Thickness = 1
_call110.Transparency = 1
_call110.Visible = false

local _call114 = _call85:CreateToggle({
    CurrentValue = false,
    Name = 'Aimlock',
    Callback = function(_115, _115_2, _115_3, _115_4, _115_5) end,
})

_call85:CreateKeybind({
    HoldToInteract = false,
    Callback = function(_118, _118_2, _118_3)
        _call114:Set(false)
    end,
    Name = 'Aimlock Bind',
    CurrentKeybind = 'E',
})
_call85:CreateDropdown({
    Callback = function(_123, _123_2, _123_3)
        local _ = _123[1]
    end,
    Options = {
        [1] = 'Head',
        [2] = 'Torso',
    },
    Name = 'Target Part',
    CurrentOption = {
        [1] = 'Head',
    },
})
_call85:CreateSlider({
    Name = 'Sensitivity',
    CurrentValue = 50,
    Increment = 1,
    Range = {
        [1] = 1,
        [2] = 100,
    },
    Callback = function(_127, _127_2, _127_3, _127_4)
        local _ = _127 / 100
    end,
})
_call85:CreateToggle({
    CurrentValue = false,
    Name = 'Visible Check',
    Callback = function(_131) end,
})
_call85:CreateToggle({
    CurrentValue = false,
    Name = 'Show FOV',
    Callback = function(_134, _134_2, _134_3, _134_4, _134_5, _134_6)
        _call106.Visible = _134
    end,
})
_call85:CreateSlider({
    Name = 'FOV Size',
    CurrentValue = 100,
    Increment = 1,
    Range = {
        [1] = 10,
        [2] = 800,
    },
    Callback = function(_137, _137_2, _137_3)
        _call106.Radius = _137
    end,
})
_call85:CreateToggle({
    CurrentValue = false,
    Name = 'ESP',
    Callback = function(_140) end,
})
_call85:CreateToggle({
    CurrentValue = false,
    Name = 'Show Target Tracer',
    Callback = function(_143, _143_2, _143_3, _143_4, _143_5, _143_6) end,
})
_call85:CreateDropdown({
    Callback = function(_146, _146_2, _146_3, _146_4, _146_5, _146_6)
        local _ = _146[1]
    end,
    Options = {
        [1] = 'Top',
        [2] = 'Center',
        [3] = 'Bottom',
    },
    Name = 'Tracer Position',
    CurrentOption = {
        [1] = 'Bottom',
    },
})

local _call149 = _call87:CreateToggle({
    CurrentValue = false,
    Name = 'Aimlock Murder',
    Callback = function(_150, _150_2, _150_3, _150_4, _150_5, _150_6) end,
})

_call87:CreateKeybind({
    HoldToInteract = false,
    Callback = function(_153, _153_2, _153_3, _153_4, _153_5)
        _call149:Set(false)
    end,
    Name = 'MM2 Aim Bind',
    CurrentKeybind = 'Q',
})
_call87:CreateToggle({
    CurrentValue = false,
    Name = 'ESP (Roles)',
    Callback = function(_158, _158_2, _158_3, _158_4, _158_5) end,
})
_call9.RenderStepped:Connect(function(_162, _162_2, _162_3, _162_4)
    _call106.Position = Vector2.new((_CurrentCamera17.ViewportSize.X / 2), (_CurrentCamera17.ViewportSize.Y / 2))

    for _173, _173_2 in pairs(_call7:GetPlayers())do
        local _ = _173_2 == _LocalPlayer16
        local _Character175 = _173_2.Character

        _Character175:FindFirstChild('Humanoid')

        local _ = _Character175.Humanoid.Health

        error('line 1: attempt to compare number < table')
    end
end)
_call89:CreateSection('Cosmetics')
_call89:CreateToggle({
    CurrentValue = false,
    Name = 'Enable Chinese Hat',
    Callback = function(_186, _186_2, _186_3, _186_4)
        local _ = _LocalPlayer16.Character
        local _Character188 = _LocalPlayer16.Character

        task.wait(0.1)

        local _call190 = _Character188:WaitForChild('Head')
        local _call192 = Instance.new('Part')

        _call192.Name = 'Hat'
        _call192.Transparency = 0.3
        _call192.Color = Color3.fromRGB(0, 255, 255)
        _call192.Material = Enum.Material.Neon
        _call192.CanCollide = false

        local _call196 = Instance.new('SpecialMesh')

        _call196.MeshId = 'rbxassetid://1033714'
        _call196.Scale = Vector3.new(2.4, 1.6, 2.4)
        _call196.Parent = _call192

        local _call200 = Instance.new('WeldConstraint')

        _call200.Part0 = _call190
        _call200.Part1 = _call192
        _call200.Parent = _call192
        _call192.CFrame = (_call190.CFrame * CFrame.new(0, 1.1, 0))
        _call192.Parent = _Character188

        _call9.Heartbeat:Connect(function(_208, _208_2, _208_3, _208_4)
            local _ = _call192.Parent
            local _ = _Character188 == _LocalPlayer16.Character
        end)
    end,
})
_call89:CreateToggle({
    CurrentValue = false,
    Name = 'Rainbow Hat',
    Callback = function(_214, _214_2, _214_3)
        local _ = _call192.Parent
        local _ = _Character188 == _LocalPlayer16.Character
    end,
})
_call89:CreateColorPicker({
    Color = Color3.fromRGB(0, 255, 255),
    Name = 'Hat Color',
    Callback = function(_222, _222_2) end,
})
_call89:CreateToggle({
    CurrentValue = false,
    Name = 'Enable Trail',
    Callback = function(_227, _227_2)
        local _ = _LocalPlayer16.Character
        local _Character229 = _LocalPlayer16.Character
        local _call231 = _Character229:WaitForChild('HumanoidRootPart')

        _Character229:FindFirstChild('HumanoidRootPart')

        local _HumanoidRootPart234 = _Character229.HumanoidRootPart

        _HumanoidRootPart234:FindFirstChild('TrailAttach0')
        _HumanoidRootPart234.TrailAttach0:Destroy()
        _HumanoidRootPart234:FindFirstChild('TrailAttach1')
        _HumanoidRootPart234.TrailAttach1:Destroy()

        local _call246 = Instance.new('Attachment', _call231)

        _call246.Name = 'TrailAttach0'
        _call246.Position = Vector3.new(0, 2, 0)

        local _call250 = Instance.new('Attachment', _call231)

        _call250.Name = 'TrailAttach1'
        _call250.Position = Vector3.new(0, -2, 0)

        local _call254 = Instance.new('Trail')

        _call254.Attachment0 = _call246
        _call254.Attachment1 = _call250
        _call254.Lifetime = 0.5

        local _call260 = NumberSequence.new({
            [1] = NumberSequenceKeypoint.new(0, 0),
            [2] = NumberSequenceKeypoint.new(1, 1),
        })

        _call254.Transparency = _call260
        _call254.Color = ColorSequence.new(Color3.fromRGB(0, 255, 255))
        _call254.LightEmission = 0.7
        _call254.Enabled = true
        _call254.Parent = _Character229

        _call9.Heartbeat:Connect(function(_266, _266_2)
            local _ = _call254.Parent
            local _ = _Character229 == _LocalPlayer16.Character
        end)
    end,
})
_call89:CreateToggle({
    CurrentValue = false,
    Name = 'Rainbow Trail',
    Callback = function(_272, _272_2, _272_3, _272_4, _272_5, _272_6)
        local _ = _call254.Parent
        local _ = _Character229 == _LocalPlayer16.Character
    end,
})
_call89:CreateColorPicker({
    Color = Color3.fromRGB(0, 255, 255),
    Name = 'Trail Color',
    Callback = function(_280, _280_2) end,
})
_call89:CreateToggle({
    CurrentValue = false,
    Name = 'Enable ForceField',
    Callback = function(_285, _285_2, _285_3)
        local _ = _LocalPlayer16.Character
        local _Character287 = _LocalPlayer16.Character

        for _291, _291_2 in pairs(_Character287:GetDescendants())do
            _291_2:IsA('BasePart')

            local _ = _291_2.Name
            local _ = _291_2.Color
            local _ = _291_2.Material
        end
        for _298, _298_2 in pairs(_Character287:GetDescendants())do
            _298_2:IsA('BasePart')

            local _ = _298_2.Name

            _298_2.Color = Color3.fromRGB(128, 128, 128)
            _298_2.Material = Enum.Material.ForceField
        end

        _call9.Heartbeat:Connect(function(_307, _307_2, _307_3, _307_4)
            local _ = _LocalPlayer16.Character

            for _312, _312_2 in pairs(_LocalPlayer16.Character:GetDescendants())do
                _312_2:IsA('BasePart')

                local _ = _312_2.Name
                local _ = _312_2.Material == Enum.Material.ForceField
            end
        end)
    end,
})
_call89:CreateToggle({
    CurrentValue = false,
    Name = 'Rainbow ForceField',
    Callback = function(_322, _322_2, _322_3, _322_4)
        local _ = _LocalPlayer16.Character

        for _327, _327_2 in pairs(_LocalPlayer16.Character:GetDescendants())do
            _327_2:IsA('BasePart')

            local _ = _327_2.Name
            local _ = _327_2.Material == Enum.Material.ForceField
        end
    end,
})
_call89:CreateColorPicker({
    Color = Color3.fromRGB(128, 128, 128),
    Name = 'ForceField Color',
    Callback = function(_339, _339_2, _339_3, _339_4, _339_5) end,
})
_call89:CreateSection('Environment & Sky')
_call9.Heartbeat:Connect(function()
    _call13.ClockTime = _call13.ClockTime
end)
_call89:CreateSlider({
    Name = 'Sky Time (0-24)',
    CurrentValue = 12,
    Increment = 0.1,
    Range = {
        [1] = 0,
        [2] = 24,
    },
    Callback = function(_349, _349_2, _349_3, _349_4, _349_5, _349_6) end,
})
_call89:CreateButton({
    Name = 'Custom Sky 1 (Original)',
    Callback = function(_352)
        for _356, _356_2 in pairs(game.Lighting:GetChildren())do
            _356_2:IsA('Sky')
            _356_2:Destroy()
        end

        local _call362 = Instance.new('Sky')

        _call362.SkyboxBk = 'http://www.roblox.com/asset/?id=171410628'
        _call362.SkyboxDn = 'http://www.roblox.com/asset/?id=171410649'
        _call362.SkyboxFt = 'http://www.roblox.com/asset/?id=171410620'
        _call362.SkyboxLf = 'http://www.roblox.com/asset/?id=171410666'
        _call362.SkyboxRt = 'http://www.roblox.com/asset/?id=171410657'
        _call362.SkyboxUp = 'http://www.roblox.com/asset/?id=171410636'
        _call362.Parent = game.Lighting
    end,
})
_call89:CreateButton({
    Name = 'Custom Sky 2',
    Callback = function(_366, _366_2, _366_3, _366_4, _366_5)
        for _370, _370_2 in pairs(game.Lighting:GetChildren())do
            _370_2:IsA('Sky')
            _370_2:Destroy()
        end

        local _call376 = Instance.new('Sky')

        _call376.SkyboxLf = 'rbxassetid://17279860360'
        _call376.SkyboxDn = 'rbxassetid://17279856318'
        _call376.SkyboxUp = 'rbxassetid://17279864507'
        _call376.SkyboxBk = 'rbxassetid://17279854976'
        _call376.SkyboxRt = 'rbxassetid://17279862234'
        _call376.SkyboxFt = 'rbxassetid://17279858447'
        _call376.Parent = game.Lighting
    end,
})
_call89:CreateButton({
    Name = 'Custom Sky 3',
    Callback = function(_380, _380_2, _380_3, _380_4)
        for _384, _384_2 in pairs(game.Lighting:GetChildren())do
            _384_2:IsA('Sky')
            _384_2:Destroy()
        end

        local _call390 = Instance.new('Sky')

        _call390.SkyboxLf = 'rbxassetid://12063984'
        _call390.SkyboxDn = 'rbxassetid://12064152'
        _call390.SkyboxUp = 'rbxassetid://12064131'
        _call390.SkyboxBk = 'rbxassetid://12064107'
        _call390.SkyboxRt = 'rbxassetid://12064115'
        _call390.SkyboxFt = 'rbxassetid://12064121'
        _call390.Parent = game.Lighting
    end,
})
_call89:CreateButton({
    Name = 'Enable 4:3',
    Callback = function(_394, _394_2, _394_3, _394_4, _394_5)
        _call9.RenderStepped:Connect(function(_398)
            _CurrentCamera17.CFrame = (_CurrentCamera17.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.65, 0, 0, 0, 1))
        end)
    end,
})
_call89:CreateButton({
    Name = 'Reset 4:3',
    Callback = function(_405, _405_2)
        _call397:Disconnect()
    end,
})
_call91:CreateSection('Movement')

local _call411 = RaycastParams.new()

_call411.FilterType = Enum.RaycastFilterType.Blacklist

local _call415 = _call91:CreateToggle({
    CurrentValue = false,
    Name = 'Wallhop',
    Callback = function(_416, _416_2, _416_3, _416_4, _416_5) end,
})

_call91:CreateKeybind({
    HoldToInteract = false,
    Callback = function(_419, _419_2, _419_3, _419_4)
        _call415:Set(false)
    end,
    Name = 'Wallhop Bind',
    CurrentKeybind = 'J',
})
game:GetService('UserInputService').JumpRequest:Connect(function(_425)
    local _Character426 = _LocalPlayer16.Character

    _Character426:FindFirstChildOfClass('Humanoid')
    _Character426:FindFirstChild('HumanoidRootPart')

    local _Character431 = _LocalPlayer16.Character
    local _call433 = _Character431:FindFirstChild('HumanoidRootPart')

    _call411.FilterDescendantsInstances = {[1] = _Character431}

    local _ = -_call433.CFrame.LookVector
    local _ = _call433.CFrame.RightVector
    local _ = -_call433.CFrame.RightVector
    local _call447 = _call15:Raycast(_call433.Position, (_call433.CFrame.LookVector * 2), _call411)
    local _ = _call447.Instance
    local _ = _call447.Distance

    error('line 1: attempt to compare table < number')
end)

local _call451 = _call91:CreateToggle({
    CurrentValue = false,
    Name = 'Speed Glitch',
    Callback = function(_452, _452_2, _452_3, _452_4) end,
})

_call91:CreateKeybind({
    HoldToInteract = false,
    Callback = function(_455, _455_2, _455_3, _455_4)
        _call451:Set(false)
    end,
    Name = 'Speed Glitch Bind',
    CurrentKeybind = 'L',
})
_call91:CreateSlider({
    Name = 'Speed Value',
    CurrentValue = 80,
    Increment = 1,
    Range = {
        [1] = 16,
        [2] = 500,
    },
    Callback = function(_460, _460_2, _460_3, _460_4, _460_5) end,
})
_call9.Heartbeat:Connect(function(_464, _464_2, _464_3, _464_4)
    local _Character465 = _LocalPlayer16.Character
    local _call467 = _Character465:FindFirstChildOfClass('Humanoid')

    _Character465:FindFirstChild('HumanoidRootPart')

    local _ = _call467:GetState() == Enum.HumanoidStateType.Jumping
    local _ = _call467:GetState() == Enum.HumanoidStateType.Freefall
end)
_call91:CreateSection('Misc')
_call91:CreateButton({
    Name = 'Activate FPS/Ping Counter',
    Callback = function(_484, _484_2)
        loadstring(game:HttpGet('https://raw.githubusercontent.com/GLAMOHGA/fling/refs/heads/main/\u{445}\u{437}%20\u{43a}\u{430}\u{43a}%20\u{43d}\u{430}\u{437}\u{432}\u{430}\u{442}\u{44c}%20\u{442}\u{438}\u{43f}\u{43e}%20\u{444}\u{43f}\u{441}%20\u{438}%20\u{43f}\u{438}\u{43d}\u{433}.md'))()
        _5:Notify({
            Image = 4483362458,
            Duration = 3,
            Title = 'FPS/Ping Counter',
            Content = 'Activated!',
        })
    end,
})
_call91:CreateToggle({
    CurrentValue = false,
    Name = 'Anime Image',
    Callback = function(_493, _493_2, _493_3)
        local _call496 = Instance.new('ScreenGui', _LocalPlayer16.PlayerGui)

        _call496.Name = 'AnimeImageGui'
        _call496.ResetOnSpawn = false

        local _call498 = Instance.new('ImageLabel', _call496)

        _call498.Image = 'http://www.roblox.com/asset/?id=117783035423570'
        _call498.Size = UDim2.new(0, 350, 0, 400)
        _call498.Position = UDim2.new(1, -25, 0, 10)
        _call498.AnchorPoint = Vector2.new(1, 0)
        _call498.BackgroundTransparency = 1

        _5:Notify({
            Image = 4483362458,
            Duration = 3,
            Title = 'Anime Image',
            Content = 'Activated!',
        })
    end,
})
_call9.Heartbeat:Connect(function(_510, _510_2)
    local _ = _call81.Flags
    local _ = _call81.Flags.Minimized
end)
_LocalPlayer16.CharacterAdded:Connect(function(_517, _517_2, _517_3, _517_4)
    task.wait(0.5)
    task.wait(0.1)

    local _call519 = _517:WaitForChild('Head')
    local _call521 = Instance.new('Part')

    _call521.Name = 'Hat'
    _call521.Transparency = 0.3
    _call521.Color = _222
    _call521.Material = Enum.Material.Neon
    _call521.CanCollide = false

    local _call525 = Instance.new('SpecialMesh')

    _call525.MeshId = 'rbxassetid://1033714'
    _call525.Scale = Vector3.new(2.4, 1.6, 2.4)
    _call525.Parent = _call521

    local _call529 = Instance.new('WeldConstraint')

    _call529.Part0 = _call519
    _call529.Part1 = _call521
    _call529.Parent = _call521
    _call521.CFrame = (_call519.CFrame * CFrame.new(0, 1.1, 0))
    _call521.Parent = _517

    local _call535 = _517:WaitForChild('HumanoidRootPart')

    _517:FindFirstChild('HumanoidRootPart')

    local _HumanoidRootPart538 = _517.HumanoidRootPart

    _HumanoidRootPart538:FindFirstChild('TrailAttach0')
    _HumanoidRootPart538.TrailAttach0:Destroy()
    _HumanoidRootPart538:FindFirstChild('TrailAttach1')
    _HumanoidRootPart538.TrailAttach1:Destroy()

    local _call550 = Instance.new('Attachment', _call535)

    _call550.Name = 'TrailAttach0'
    _call550.Position = Vector3.new(0, 2, 0)

    local _call554 = Instance.new('Attachment', _call535)

    _call554.Name = 'TrailAttach1'
    _call554.Position = Vector3.new(0, -2, 0)

    local _call558 = Instance.new('Trail')

    _call558.Attachment0 = _call550
    _call558.Attachment1 = _call554
    _call558.Lifetime = 0.5

    local _call564 = NumberSequence.new({
        [1] = NumberSequenceKeypoint.new(0, 0),
        [2] = NumberSequenceKeypoint.new(1, 1),
    })

    _call558.Transparency = _call564
    _call558.Color = ColorSequence.new(_280)
    _call558.LightEmission = 0.7
    _call558.Enabled = true
    _call558.Parent = _517

    for _570, _570_2 in pairs(_517:GetDescendants())do
        _570_2:IsA('BasePart')

        local _ = _570_2.Name
        local _ = _570_2.Color
        local _ = _570_2.Material
    end
    for _577, _577_2 in pairs(_517:GetDescendants())do
        _577_2:IsA('BasePart')

        local _ = _577_2.Name

        _577_2.Color = _339
        _577_2.Material = Enum.Material.ForceField
    end

    task.wait(0.5)

    local _call585 = Instance.new('ScreenGui', _LocalPlayer16.PlayerGui)

    _call585.Name = 'AnimeImageGui'
    _call585.ResetOnSpawn = false

    local _call587 = Instance.new('ImageLabel', _call585)

    _call587.Image = 'http://www.roblox.com/asset/?id=117783035423570'
    _call587.Size = UDim2.new(0, 350, 0, 400)
    _call587.Position = UDim2.new(1, -25, 0, 10)
    _call587.AnchorPoint = Vector2.new(1, 0)
    _call587.BackgroundTransparency = 1

    _5:Notify({
        Image = 4483362458,
        Duration = 3,
        Title = 'Anime Image',
        Content = 'Activated!',
    })
end)

local _ = _LocalPlayer16.Character
local _Character597 = _LocalPlayer16.Character

task.wait(0.5)
task.wait(0.1)

local _call599 = _Character597:WaitForChild('Head')
local _call601 = Instance.new('Part')

_call601.Name = 'Hat'
_call601.Transparency = 0.3
_call601.Color = _222
_call601.Material = Enum.Material.Neon
_call601.CanCollide = false

local _call605 = Instance.new('SpecialMesh')

_call605.MeshId = 'rbxassetid://1033714'
_call605.Scale = Vector3.new(2.4, 1.6, 2.4)
_call605.Parent = _call601

local _call609 = Instance.new('WeldConstraint')

_call609.Part0 = _call599
_call609.Part1 = _call601
_call609.Parent = _call601
_call601.CFrame = (_call599.CFrame * CFrame.new(0, 1.1, 0))
_call601.Parent = _Character597

local _call615 = _Character597:WaitForChild('HumanoidRootPart')

_Character597:FindFirstChild('HumanoidRootPart')

local _HumanoidRootPart618 = _Character597.HumanoidRootPart

_HumanoidRootPart618:FindFirstChild('TrailAttach0')
_HumanoidRootPart618.TrailAttach0:Destroy()
_HumanoidRootPart618:FindFirstChild('TrailAttach1')
_HumanoidRootPart618.TrailAttach1:Destroy()

local _call630 = Instance.new('Attachment', _call615)

_call630.Name = 'TrailAttach0'
_call630.Position = Vector3.new(0, 2, 0)

local _call634 = Instance.new('Attachment', _call615)

_call634.Name = 'TrailAttach1'
_call634.Position = Vector3.new(0, -2, 0)

local _call638 = Instance.new('Trail')

_call638.Attachment0 = _call630
_call638.Attachment1 = _call634
_call638.Lifetime = 0.5

local _call644 = NumberSequence.new({
    [1] = NumberSequenceKeypoint.new(0, 0),
    [2] = NumberSequenceKeypoint.new(1, 1),
})

_call638.Transparency = _call644
_call638.Color = ColorSequence.new(_280)
_call638.LightEmission = 0.7
_call638.Enabled = true
_call638.Parent = _Character597

for _650, _650_2 in pairs(_Character597:GetDescendants())do
    _650_2:IsA('BasePart')

    local _ = _650_2.Name
    local _ = _650_2.Color
    local _ = _650_2.Material
end
for _657, _657_2 in pairs(_Character597:GetDescendants())do
    _657_2:IsA('BasePart')

    local _ = _657_2.Name

    _657_2.Color = _339
    _657_2.Material = Enum.Material.ForceField
end

task.wait(0.5)

local _call665 = Instance.new('ScreenGui', _LocalPlayer16.PlayerGui)

_call665.Name = 'AnimeImageGui'
_call665.ResetOnSpawn = false

local _call667 = Instance.new('ImageLabel', _call665)

_call667.Image = 'http://www.roblox.com/asset/?id=117783035423570'
_call667.Size = UDim2.new(0, 350, 0, 400)
_call667.Position = UDim2.new(1, -25, 0, 10)
_call667.AnchorPoint = Vector2.new(1, 0)
_call667.BackgroundTransparency = 1

_5:Notify({
    Image = 4483362458,
    Duration = 3,
    Title = 'Anime Image',
    Content = 'Activated!',
})
