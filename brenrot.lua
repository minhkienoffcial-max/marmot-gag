-- HapticHub Loader
-- Paste this into your executor

local function loadHub()
    -- Load config first
    local configSource = game:HttpGet("https://raw.githubusercontent.com/minhkienoffcial-max/marmot-gag/refs/heads/main/brenrot.lua")
    local config = loadstring(configSource)()
    
    -- Load main hub
    local hubSource = game:HttpGet("https://raw.githubusercontent.com/minhkienoffcial-max/marmot-gag/refs/heads/main/brenrot.lua")
    local hub = loadstring(hubSource)()
    
    print("HapticHub loaded successfully!")
end

-- Alternative local loading (if files are in workspace)
local function loadLocal()
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local CoreGui = game:GetService("CoreGui")
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")

    -- Cleanup existing GUI
    if CoreGui:FindFirstChild("HapticHubUI") then
        CoreGui:FindFirstChild("HapticHubUI"):Destroy()
    end

    -- Inline config for local use
    local Config = {
        HubName = "HapticHub",
        Author = "Cynox",
        Version = "1.0",
        UI = {
            Size = {400, 350},
            Position = {0.5, 0.5},
            BackgroundColor = Color3.fromRGB(34, 34, 34),
            TitleColor = Color3.fromRGB(255, 255, 255),
            TextColor = Color3.fromRGB(200, 200, 200),
            ButtonColor = Color3.fromRGB(51, 51, 51),
            ActiveColor = Color3.fromRGB(80, 80, 80),
            ToggleKey = Enum.KeyCode.Insert
        },
        Features = {
            MoonGravity = {JumpPower = 76, FallMultiplier = 0.9, DefaultJumpPower = 50},
            Speed = {SpeedValue = 120},
            Teleport = {UpDistance = 150, DownDistance = 189},
            Fly = {FlySpeed = 50}
        }
    }

    -- Create main GUI
    local gui = Instance.new("ScreenGui")
    gui.Name = "HapticHubUI"
    gui.ResetOnSpawn = false
    gui.Parent = CoreGui

    local frame = Instance.new("Frame")
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    frame.Size = UDim2.new(0, 400, 0, 350)
    frame.BackgroundColor3 = Config.UI.BackgroundColor
    frame.BorderSizePixel = 0
    frame.Parent = gui

    -- Title
    local title = Instance.new("TextLabel")
    title.Text = Config.HubName
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 20
    title.TextColor3 = Config.UI.TitleColor
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(0, 200, 0, 30)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = frame

    -- Author label
    local madeByLabel = Instance.new("TextLabel")
    madeByLabel.Text = "Made By " .. Config.Author
    madeByLabel.Font = Enum.Font.SourceSans
    madeByLabel.TextSize = 12
    madeByLabel.TextColor3 = Color3.fromRGB(150,150,150)
    madeByLabel.BackgroundTransparency = 1
    madeByLabel.Size = UDim2.new(0, 200, 0, 20)
    madeByLabel.Position = UDim2.new(0, 10, 1, -25)
    madeByLabel.TextXAlignment = Enum.TextXAlignment.Left
    madeByLabel.Parent = frame

    -- Feature states and connections
    local featureStates = {}
    local connections = {}
    local buttons = {}
    local stateLabels = {}

    -- Drag functionality
    local dragging = false
    local dragInput, dragStart, startPos

    title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    title.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Feature functions
    local function moonGravity(enabled)
        local character = Players.LocalPlayer.Character
        if not character then return end
        
        local humanoid = character:FindFirstChildWhichIsA("Humanoid")
        local root = character:FindFirstChild("HumanoidRootPart")
        if not humanoid or not root then return end
        
        if enabled then
            humanoid.UseJumpPower = true
            humanoid.JumpPower = Config.Features.MoonGravity.JumpPower
            connections.MoonGravity = RunService.Stepped:Connect(function()
                if root.Velocity.Y < 0 then
                    root.Velocity = Vector3.new(root.Velocity.X, root.Velocity.Y * Config.Features.MoonGravity.FallMultiplier, root.Velocity.Z)
                end
            end)
        else
            if connections.MoonGravity then
                connections.MoonGravity:Disconnect()
                connections.MoonGravity = nil
            end
            humanoid.JumpPower = Config.Features.MoonGravity.DefaultJumpPower
        end
    end

    local function speedHack(enabled)
        if enabled then
            local player = Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local root = character:WaitForChild("HumanoidRootPart")
            local camera = workspace.CurrentCamera
            
            connections.Speed = RunService.RenderStepped:Connect(function()
                local moveVector = Vector3.zero
                
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    moveVector += camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    moveVector -= camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    moveVector -= camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    moveVector += camera.CFrame.RightVector
                end
                
                if moveVector.Magnitude > 0 then
                    moveVector = moveVector.Unit * Config.Features.Speed.SpeedValue
                end
                
                root.AssemblyLinearVelocity = Vector3.new(moveVector.X, root.AssemblyLinearVelocity.Y, moveVector.Z)
            end)
        else
            if connections.Speed then
                connections.Speed:Disconnect()
                connections.Speed = nil
            end
        end
    end

    local function fly(enabled)
        local character = Players.LocalPlayer.Character
        if not character then return end
        
        local root = character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        if enabled then
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.Parent = root
            
            connections.Fly = RunService.RenderStepped:Connect(function()
                local camera = workspace.CurrentCamera
                local moveVector = Vector3.zero
                
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    moveVector += camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    moveVector -= camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    moveVector -= camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    moveVector += camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    moveVector += Vector3.new(0, 1, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    moveVector -= Vector3.new(0, 1, 0)
                end
                
                if moveVector.Magnitude > 0 then
                    moveVector = moveVector.Unit * Config.Features.Fly.FlySpeed
                end
                
                bodyVelocity.Velocity = moveVector
            end)
        else
            if connections.Fly then
                connections.Fly:Disconnect()
                connections.Fly = nil
            end
            if root:FindFirstChild("BodyVelocity") then
                root:FindFirstChild("BodyVelocity"):Destroy()
            end
        end
    end

    local function noclip(enabled)
        local character = Players.LocalPlayer.Character
        if not character then return end
        
        if enabled then
            connections.Noclip = RunService.Stepped:Connect(function()
                for _, part in pairs(character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end)
        else
            if connections.Noclip then
                connections.Noclip:Disconnect()
                connections.Noclip = nil
            end
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = true
                end
            end
        end
    end

    local function infiniteJump(enabled)
        if enabled then
            connections.InfiniteJump = UserInputService.JumpRequest:Connect(function()
                local character = Players.LocalPlayer.Character
                if character then
                    local humanoid = character:FindFirstChildWhichIsA("Humanoid")
                    if humanoid then
                        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end
            end)
        else
            if connections.InfiniteJump then
                connections.InfiniteJump:Disconnect()
                connections.InfiniteJump = nil
            end
        end
    end

    local function invisibility(enabled)
        local character = Players.LocalPlayer.Character
        if not character then return end
        
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.Transparency = enabled and 1 or 0
            elseif part:IsA("Accessory") then
                part.Handle.Transparency = enabled and 1 or 0
            end
        end
        
        local head = character:FindFirstChild("Head")
        if head and head:FindFirstChild("face") then
            head.face.Transparency = enabled and 1 or 0
        end
    end

    local teleportUp = true
    local function teleport()
        local character = Players.LocalPlayer.Character
        if not character then return end
        
        local root = character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        if teleportUp then
            root.CFrame = root.CFrame + Vector3.new(0, Config.Features.Teleport.UpDistance, 0)
            buttons.Teleport.Text = "Teleport Down"
        else
            root.CFrame = root.CFrame - Vector3.new(0, Config.Features.Teleport.DownDistance, 0)
            buttons.Teleport.Text = "Teleport Up"
        end
        teleportUp = not teleportUp
    end

    -- Create buttons
    local buttonConfigs = {
        {name = "Moon Gravity", func = moonGravity, hasState = true, pos = {10, 35}},
        {name = "Speed Hack", func = speedHack, hasState = true, pos = {10, 70}},
        {name = "Teleport Up", func = teleport, hasState = false, pos = {10, 105}},
        {name = "Fly", func = fly, hasState = true, pos = {10, 140}},
        {name = "Noclip", func = noclip, hasState = true, pos = {210, 35}},
        {name = "Infinite Jump", func = infiniteJump, hasState = true, pos = {210, 70}},
        {name = "Invisibility", func = invisibility, hasState = true, pos = {210, 105}}
    }

    for i, config in pairs(buttonConfigs) do
        local button = Instance.new("TextButton")
        button.Text = config.name
        button.Font = Enum.Font.SourceSans
        button.TextSize = 14
        button.TextColor3 = Color3.fromRGB(255,255,255)
        button.BackgroundColor3 = Config.UI.ButtonColor
        button.BorderSizePixel = 0
        button.Size = UDim2.new(0, 180, 0, 25)
        button.Position = UDim2.new(0, config.pos[1], 0, config.pos[2])
        button.Parent = frame
        
        buttons[config.name:gsub(" ", "")] = button
        featureStates[config.name:gsub(" ", "")] = false
        
        if config.hasState then
            local stateLabel = Instance.new("TextLabel")
            stateLabel.Text = "OFF"
            stateLabel.Font = Enum.Font.SourceSans
            stateLabel.TextSize = 12
            stateLabel.TextColor3 = Config.UI.TextColor
            stateLabel.BackgroundTransparency = 1
            stateLabel.Size = UDim2.new(0, 30, 0, 25)
            stateLabel.Position = UDim2.new(0, config.pos[1] + 185, 0, config.pos[2])
            stateLabel.TextXAlignment = Enum.TextXAlignment.Left
            stateLabel.Parent = frame
            stateLabels[config.name:gsub(" ", "")] = stateLabel
        end
        
        button.MouseButton1Click:Connect(function()
            if config.hasState then
                local key = config.name:gsub(" ", "")
                featureStates[key] = not featureStates[key]
                local enabled = featureStates[key]
                
                button.BackgroundColor3 = enabled and Config.UI.ActiveColor or Config.UI.ButtonColor
                if stateLabels[key] then
                    stateLabels[key].Text = enabled and "ON" or "OFF"
                end
                
                config.func(enabled)
            else
                config.func()
            end
        end)
    end

    -- Toggle GUI visibility
    local uiVisible = true
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Config.UI.ToggleKey then
            uiVisible = not uiVisible
            frame.Visible = uiVisible
            
            if not uiVisible then
                for key, state in pairs(featureStates) do
                    if state then
                        featureStates[key] = false
                        if buttons[key] then
                            buttons[key].BackgroundColor3 = Config.UI.ButtonColor
                        end
                        if stateLabels[key] then
                            stateLabels[key].Text = "OFF"
                        end
                    end
                end
                for _, connection in pairs(connections) do
                    if connection then
                        connection:Disconnect()
                    end
                end
                connections = {}
            end
        end
    end)

    print("HapticHub loaded successfully! Press INSERT to toggle.")
end

-- Run the local loader
loadLocal()
