-- HapticHub Premium - Ultra Modern UI
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Cleanup existing GUI
if CoreGui:FindFirstChild("HapticHubUI") then
    CoreGui:FindFirstChild("HapticHubUI"):Destroy()
end

-- Create main GUI
local gui = Instance.new("ScreenGui")
gui.Name = "HapticHubUI"
gui.ResetOnSpawn = false
gui.Parent = CoreGui

-- Floating Toggle Button (like in screenshot)
local toggleButton = Instance.new("ImageButton")
toggleButton.Size = UDim2.new(0, 50, 0, 50)
toggleButton.Position = UDim2.new(0, 20, 0.5, -25)
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
toggleButton.BorderSizePixel = 0
toggleButton.Image = "rbxassetid://6031075938"
toggleButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Parent = gui

-- Perfect circle for toggle button
local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0.5, 0)
toggleCorner.Parent = toggleButton

-- Glow effect for toggle button
local toggleStroke = Instance.new("UIStroke")
toggleStroke.Color = Color3.fromRGB(100, 200, 255)
toggleStroke.Thickness = 2
toggleStroke.Transparency = 0.3
toggleStroke.Parent = toggleButton

-- Premium Hub Frame
local frame = Instance.new("Frame")
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.Size = UDim2.new(0, 520, 0, 420)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
frame.BorderSizePixel = 0
frame.Visible = false
frame.Parent = gui

-- Glass morphism effect
local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 20)
frameCorner.Parent = frame

local frameStroke = Instance.new("UIStroke")
frameStroke.Color = Color3.fromRGB(60, 60, 80)
frameStroke.Thickness = 1
frameStroke.Transparency = 0.5
frameStroke.Parent = frame

-- Premium gradient background
local bgGradient = Instance.new("UIGradient")
bgGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 30)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(15, 15, 25)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 20))
}
bgGradient.Rotation = 135
bgGradient.Parent = frame

-- Top bar with premium styling
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 60)
topBar.Position = UDim2.new(0, 0, 0, 0)
topBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
topBar.BorderSizePixel = 0
topBar.Parent = frame

local topBarCorner = Instance.new("UICorner")
topBarCorner.CornerRadius = UDim.new(0, 20)
topBarCorner.Parent = topBar

local topBarGradient = Instance.new("UIGradient")
topBarGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 45)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 35))
}
topBarGradient.Rotation = 90
topBarGradient.Parent = topBar

-- Premium logo
local logo = Instance.new("ImageLabel")
logo.Size = UDim2.new(0, 40, 0, 40)
logo.Position = UDim2.new(0, 15, 0, 10)
logo.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
logo.BorderSizePixel = 0
logo.Image = "rbxassetid://6031075938"
logo.ImageColor3 = Color3.fromRGB(255, 255, 255)
logo.Parent = topBar

local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(0.5, 0)
logoCorner.Parent = logo

-- Premium title with glow
local title = Instance.new("TextLabel")
title.Text = "HapticHub"
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Size = UDim2.new(0, 200, 0, 40)
title.Position = UDim2.new(0, 65, 0, 10)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topBar

local titleStroke = Instance.new("UIStroke")
titleStroke.Color = Color3.fromRGB(100, 200, 255)
titleStroke.Thickness = 1
titleStroke.Transparency = 0.7
titleStroke.Parent = title

-- Premium badge
local premiumBadge = Instance.new("TextLabel")
premiumBadge.Text = "PREMIUM"
premiumBadge.Font = Enum.Font.GothamBold
premiumBadge.TextSize = 10
premiumBadge.TextColor3 = Color3.fromRGB(255, 215, 0)
premiumBadge.BackgroundColor3 = Color3.fromRGB(40, 35, 0)
premiumBadge.BorderSizePixel = 0
premiumBadge.Size = UDim2.new(0, 60, 0, 18)
premiumBadge.Position = UDim2.new(0, 65, 0, 35)
premiumBadge.TextXAlignment = Enum.TextXAlignment.Center
premiumBadge.Parent = topBar

local badgeCorner = Instance.new("UICorner")
badgeCorner.CornerRadius = UDim.new(0, 9)
badgeCorner.Parent = premiumBadge

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 25, 25)
closeBtn.BorderSizePixel = 0
closeBtn.Size = UDim2.new(0, 35, 0, 35)
closeBtn.Position = UDim2.new(1, -50, 0, 12.5)
closeBtn.Parent = topBar

local closeBtnCorner = Instance.new("UICorner")
closeBtnCorner.CornerRadius = UDim.new(0.5, 0)
closeBtnCorner.Parent = closeBtn

-- Content container
local content = Instance.new("ScrollingFrame")
content.Size = UDim2.new(1, -30, 1, -80)
content.Position = UDim2.new(0, 15, 0, 70)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ScrollBarThickness = 4
content.ScrollBarImageColor3 = Color3.fromRGB(100, 200, 255)
content.CanvasSize = UDim2.new(0, 0, 0, 400)
content.Parent = frame

-- Feature states
local featureStates = {}
local connections = {}
local buttons = {}

-- Premium feature functions (same as before but optimized)
local function moonGravity(enabled)
    local character = Players.LocalPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildWhichIsA("Humanoid")
    local root = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not root then return end
    
    if enabled then
        humanoid.UseJumpPower = true
        humanoid.JumpPower = 76
        connections.MoonGravity = RunService.Stepped:Connect(function()
            if root.Velocity.Y < 0 then
                root.Velocity = Vector3.new(root.Velocity.X, root.Velocity.Y * 0.9, root.Velocity.Z)
            end
        end)
    else
        if connections.MoonGravity then
            connections.MoonGravity:Disconnect()
            connections.MoonGravity = nil
        end
        humanoid.JumpPower = 50
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
                moveVector = moveVector.Unit * 120
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
                moveVector = moveVector.Unit * 50
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
        root.CFrame = root.CFrame + Vector3.new(0, 150, 0)
        buttons.Teleport.Text = "Teleport Down"
    else
        root.CFrame = root.CFrame - Vector3.new(0, 189, 0)
        buttons.Teleport.Text = "Teleport Up"
    end
    teleportUp = not teleportUp
end

-- Create premium buttons
local buttonConfigs = {
    {name = "Moon Gravity", func = moonGravity, hasState = true, icon = "🌙"},
    {name = "Speed Hack", func = speedHack, hasState = true, icon = "⚡"},
    {name = "Teleport", func = teleport, hasState = false, icon = "📍"},
    {name = "Fly Mode", func = fly, hasState = true, icon = "✈️"},
    {name = "Noclip", func = noclip, hasState = true, icon = "👻"},
    {name = "Infinite Jump", func = infiniteJump, hasState = true, icon = "🦘"},
    {name = "Invisibility", func = invisibility, hasState = true, icon = "👤"}
}

for i, config in pairs(buttonConfigs) do
    local yPos = (i - 1) * 50
    
    -- Premium button container
    local btnContainer = Instance.new("Frame")
    btnContainer.Size = UDim2.new(1, -10, 0, 40)
    btnContainer.Position = UDim2.new(0, 5, 0, yPos + 10)
    btnContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    btnContainer.BorderSizePixel = 0
    btnContainer.Parent = content
    
    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 10)
    containerCorner.Parent = btnContainer
    
    local containerStroke = Instance.new("UIStroke")
    containerStroke.Color = Color3.fromRGB(50, 50, 70)
    containerStroke.Thickness = 1
    containerStroke.Transparency = 0.7
    containerStroke.Parent = btnContainer
    
    -- Icon
    local icon = Instance.new("TextLabel")
    icon.Text = config.icon
    icon.Font = Enum.Font.Gotham
    icon.TextSize = 18
    icon.TextColor3 = Color3.fromRGB(100, 200, 255)
    icon.BackgroundTransparency = 1
    icon.Size = UDim2.new(0, 30, 1, 0)
    icon.Position = UDim2.new(0, 10, 0, 0)
    icon.TextXAlignment = Enum.TextXAlignment.Center
    icon.Parent = btnContainer
    
    -- Button
    local button = Instance.new("TextButton")
    button.Text = config.name
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.BackgroundTransparency = 1
    button.BorderSizePixel = 0
    button.Size = UDim2.new(1, -100, 1, 0)
    button.Position = UDim2.new(0, 50, 0, 0)
    button.TextXAlignment = Enum.TextXAlignment.Left
    button.Parent = btnContainer
    
    buttons[config.name:gsub(" ", "")] = button
    featureStates[config.name:gsub(" ", "")] = false
    
    -- State indicator
    local stateIndicator = Instance.new("Frame")
    stateIndicator.Size = UDim2.new(0, 12, 0, 12)
    stateIndicator.Position = UDim2.new(1, -25, 0.5, -6)
    stateIndicator.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    stateIndicator.BorderSizePixel = 0
    stateIndicator.Parent = btnContainer
    
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(0.5, 0)
    indicatorCorner.Parent = stateIndicator
    
    -- Button functionality
    button.MouseButton1Click:Connect(function()
        if config.hasState then
            local key = config.name:gsub(" ", "")
            featureStates[key] = not featureStates[key]
            local enabled = featureStates[key]
            
            -- Animate state change
            local targetColor = enabled and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
            TweenService:Create(stateIndicator, TweenInfo.new(0.3), {BackgroundColor3 = targetColor}):Play()
            TweenService:Create(btnContainer, TweenInfo.new(0.3), {
                BackgroundColor3 = enabled and Color3.fromRGB(30, 35, 25) or Color3.fromRGB(25, 25, 35)
            }):Play()
            
            config.func(enabled)
        else
            config.func()
        end
    end)
    
    -- Hover effects
    button.MouseEnter:Connect(function()
        TweenService:Create(btnContainer, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 45)}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        local baseColor = featureStates[config.name:gsub(" ", "")] and Color3.fromRGB(30, 35, 25) or Color3.fromRGB(25, 25, 35)
        TweenService:Create(btnContainer, TweenInfo.new(0.2), {BackgroundColor3 = baseColor}):Play()
    end)
end

-- Toggle functionality
local hubVisible = false

local function toggleHub()
    hubVisible = not hubVisible
    
    if hubVisible then
        frame.Visible = true
        frame.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
            Size = UDim2.new(0, 520, 0, 420)
        }):Play()
    else
        TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            Size = UDim2.new(0, 0, 0, 0)
        }):Play()
        
        wait(0.3)
        frame.Visible = false
        
        -- Disable all features
        for key, state in pairs(featureStates) do
            if state then
                featureStates[key] = false
                config.func(false)
            end
        end
        for _, connection in pairs(connections) do
            if connection then connection:Disconnect() end
        end
        connections = {}
    end
end

-- Button events
toggleButton.MouseButton1Click:Connect(toggleHub)
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Drag functionality
local dragging = false
local dragInput, dragStart, startPos

topBar.InputBegan:Connect(function(input)
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

topBar.InputChanged:Connect(function(input)
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

print("HapticHub Premium loaded! Click the floating button to toggle.")
