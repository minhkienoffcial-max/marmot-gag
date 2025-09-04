-- HapticHub V2 - Modern UI with Logo Toggle
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

-- Main frame with rounded corners
local frame = Instance.new("Frame")
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.Size = UDim2.new(0, 450, 0, 380)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
frame.BorderSizePixel = 0
frame.Parent = gui

-- Rounded corners for main frame
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

-- Gradient background
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 30))
}
gradient.Rotation = 45
gradient.Parent = frame

-- Header bar
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 50)
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
header.BorderSizePixel = 0
header.Parent = frame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = header

-- Logo button (clickable to toggle) - Perfect Circle
local logoButton = Instance.new("ImageButton")
logoButton.Size = UDim2.new(0, 35, 0, 35)
logoButton.Position = UDim2.new(0, 10, 0, 7.5)
logoButton.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
logoButton.BorderSizePixel = 0
logoButton.Image = "rbxassetid://6031075938" -- Hub icon
logoButton.Parent = header

local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(0.5, 0) -- Perfect circle
logoCorner.Parent = logoButton

-- Title
local title = Instance.new("TextLabel")
title.Text = "HapticHub"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Size = UDim2.new(0, 200, 0, 35)
title.Position = UDim2.new(0, 55, 0, 7.5)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

-- Version label
local versionLabel = Instance.new("TextLabel")
versionLabel.Text = "v2.0"
versionLabel.Font = Enum.Font.Gotham
versionLabel.TextSize = 12
versionLabel.TextColor3 = Color3.fromRGB(120, 120, 140)
versionLabel.BackgroundTransparency = 1
versionLabel.Size = UDim2.new(0, 50, 0, 35)
versionLabel.Position = UDim2.new(1, -60, 0, 7.5)
versionLabel.TextXAlignment = Enum.TextXAlignment.Right
versionLabel.Parent = header

-- Close button
local closeButton = Instance.new("TextButton")
closeButton.Text = "×"
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 20
closeButton.TextColor3 = Color3.fromRGB(255, 100, 100)
closeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
closeButton.BorderSizePixel = 0
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -40, 0, 10)
closeButton.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

-- Content area
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -20, 1, -70)
content.Position = UDim2.new(0, 10, 0, 60)
content.BackgroundTransparency = 1
content.Parent = frame

-- Author label
local madeByLabel = Instance.new("TextLabel")
madeByLabel.Text = "Made By Cynox"
madeByLabel.Font = Enum.Font.Gotham
madeByLabel.TextSize = 11
madeByLabel.TextColor3 = Color3.fromRGB(120, 120, 140)
madeByLabel.BackgroundTransparency = 1
madeByLabel.Size = UDim2.new(0, 200, 0, 20)
madeByLabel.Position = UDim2.new(0, 0, 1, -25)
madeByLabel.TextXAlignment = Enum.TextXAlignment.Left
madeByLabel.Parent = content

-- Feature states and connections
local featureStates = {}
local connections = {}
local buttons = {}
local stateLabels = {}
local hubVisible = true

-- Drag functionality
local dragging = false
local dragInput, dragStart, startPos

header.InputBegan:Connect(function(input)
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

header.InputChanged:Connect(function(input)
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

-- Toggle hub function
local function toggleHub()
    hubVisible = not hubVisible
    local targetPos = hubVisible and UDim2.new(0.5, 0, 0.5, 0) or UDim2.new(0.5, 0, -0.5, 0)
    
    local tween = TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Position = targetPos})
    tween:Play()
    
    if not hubVisible then
        -- Disable all features when hiding
        for key, state in pairs(featureStates) do
            if state then
                featureStates[key] = false
                if buttons[key] then
                    buttons[key].BackgroundColor3 = Color3.fromRGB(45, 45, 60)
                end
                if stateLabels[key] then
                    stateLabels[key].Text = "OFF"
                    stateLabels[key].TextColor3 = Color3.fromRGB(255, 100, 100)
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

-- Logo button click to toggle
logoButton.MouseButton1Click:Connect(toggleHub)

-- Close button
closeButton.MouseButton1Click:Connect(function()
    gui:Destroy()
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

-- Create modern buttons
local buttonConfigs = {
    {name = "Moon Gravity", func = moonGravity, hasState = true, pos = {0, 10}},
    {name = "Speed Hack", func = speedHack, hasState = true, pos = {0, 50}},
    {name = "Teleport Up", func = teleport, hasState = false, pos = {0, 90}},
    {name = "Fly", func = fly, hasState = true, pos = {0, 130}},
    {name = "Noclip", func = noclip, hasState = true, pos = {220, 10}},
    {name = "Infinite Jump", func = infiniteJump, hasState = true, pos = {220, 50}},
    {name = "Invisibility", func = invisibility, hasState = true, pos = {220, 90}}
}

for i, config in pairs(buttonConfigs) do
    local button = Instance.new("TextButton")
    button.Text = config.name
    button.Font = Enum.Font.Gotham
    button.TextSize = 13
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    button.BorderSizePixel = 0
    button.Size = UDim2.new(0, 200, 0, 30)
    button.Position = UDim2.new(0, config.pos[1], 0, config.pos[2])
    button.Parent = content
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = button
    
    buttons[config.name:gsub(" ", "")] = button
    featureStates[config.name:gsub(" ", "")] = false
    
    if config.hasState then
        local stateLabel = Instance.new("TextLabel")
        stateLabel.Text = "OFF"
        stateLabel.Font = Enum.Font.GothamBold
        stateLabel.TextSize = 11
        stateLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        stateLabel.BackgroundTransparency = 1
        stateLabel.Size = UDim2.new(0, 40, 0, 30)
        stateLabel.Position = UDim2.new(0, config.pos[1] + 205, 0, config.pos[2])
        stateLabel.TextXAlignment = Enum.TextXAlignment.Left
        stateLabel.Parent = content
        stateLabels[config.name:gsub(" ", "")] = stateLabel
    end
    
    -- Button hover effect
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(55, 55, 70)}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        local color = featureStates[config.name:gsub(" ", "")] and Color3.fromRGB(70, 130, 255) or Color3.fromRGB(45, 45, 60)
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = color}):Play()
    end)
    
    button.MouseButton1Click:Connect(function()
        if config.hasState then
            local key = config.name:gsub(" ", "")
            featureStates[key] = not featureStates[key]
            local enabled = featureStates[key]
            
            button.BackgroundColor3 = enabled and Color3.fromRGB(70, 130, 255) or Color3.fromRGB(45, 45, 60)
            if stateLabels[key] then
                stateLabels[key].Text = enabled and "ON" or "OFF"
                stateLabels[key].TextColor3 = enabled and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
            end
            
            config.func(enabled)
        else
            config.func()
        end
    end)
end

-- Insert key toggle
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        toggleHub()
    end
end)

print("HapticHub V2 loaded! Click logo or press INSERT to toggle.")
