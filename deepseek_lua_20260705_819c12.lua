--[[
    ⚡ CIPHER HUB - Blox Fruits
    Versão: 2.0
    Design: Moderno com gradiente e animações (estilo Banana Hub/Redz)
    Funcionalidades: Auto Farm, Auto Quest, Auto Sea Event, Teleport, ESP, Kill Aura, Fast Attack, e muito mais!
    Compatível com: Synapse X, KRNL, Delta, Hydrogen, Fluxus
]]

-- ============================================
-- 1. SERVIÇOS E VARIÁVEIS GLOBAIS
-- ============================================
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- ============================================
-- 2. ESTADO DO HUB
-- ============================================
local Cipher = {
    Enabled = false,
    Features = {
        AutoFarm = false,
        AutoQuest = false,
        AutoSeaEvent = false,
        BringMobs = false,
        FastAttack = false,
        InfiniteEnergy = false,
        NoClip = false,
        Fly = false,
        Speed = false,
        InfiniteJump = false,
        ESP = false,
        KillAura = false,
        AutoStats = {
            Enabled = false,
            Melee = false,
            Defense = false,
            Sword = false,
            Gun = false,
            Fruit = false
        }
    },
    Connections = {},
    SpeedValue = 100,
    FlySpeed = 100,
    KillAuraRadius = 150,
    SeaEventRadius = 500,
}

-- ============================================
-- 3. FUNÇÃO DE SEGURANÇA
-- ============================================
local function SafeCall(func, ...)
    local success, result = pcall(func, ...)
    if not success then
        warn("⚠️ Erro no Cipher Hub: " .. tostring(result))
    end
    return success, result
end

-- ============================================
-- 4. CRIAÇÃO DA GUI (Design Moderno)
-- ============================================
local function CreateGUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CipherHubGUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = CoreGui

    -- ===== Frame Principal =====
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 580, 0, 480)
    MainFrame.Position = UDim2.new(0.5, -290, 0.5, -240)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    -- Corner principal
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 16)
    MainCorner.Parent = MainFrame

    -- Sombra (glow effect)
    local Shadow = Instance.new("Frame")
    Shadow.Size = UDim2.new(1, 20, 1, 20)
    Shadow.Position = UDim2.new(0, -10, 0, -10)
    Shadow.BackgroundColor3 = Color3.fromRGB(100, 0, 200)
    Shadow.BackgroundTransparency = 0.8
    Shadow.BorderSizePixel = 0
    Shadow.ZIndex = 0
    Shadow.Parent = MainFrame
    local ShadowCorner = Instance.new("UICorner")
    ShadowCorner.CornerRadius = UDim.new(0, 20)
    ShadowCorner.Parent = Shadow

    -- ===== HEADER com gradiente =====
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 55)
    Header.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame

    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 16)
    HeaderCorner.Parent = Header

    -- Gradiente (UIStroke style)
    local Gradient = Instance.new("UIGradient")
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 0, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 100, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 0, 255))
    })
    Gradient.Parent = Header

    -- Título com ícone
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -20, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "⚡ CIPHER HUB"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 22
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header

    -- Subtítulo
    local SubTitle = Instance.new("TextLabel")
    SubTitle.Name = "SubTitle"
    SubTitle.Size = UDim2.new(1, -20, 0, 20)
    SubTitle.Position = UDim2.new(0, 10, 0, 30)
    SubTitle.BackgroundTransparency = 1
    SubTitle.Text = "Blox Fruits • Premium Script"
    SubTitle.TextColor3 = Color3.fromRGB(180, 180, 200)
    SubTitle.TextSize = 12
    SubTitle.Font = Enum.Font.Gotham
    SubTitle.TextXAlignment = Enum.TextXAlignment.Left
    SubTitle.Parent = Header

    -- Botão Fechar
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 40, 0, 40)
    CloseButton.Position = UDim2.new(1, -48, 0, 8)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 80)
    CloseButton.Text = "✕"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 20
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = Header

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 10)
    CloseCorner.Parent = CloseButton

    -- ===== CONTAINER DE ABAS =====
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(1, 0, 0, 40)
    TabContainer.Position = UDim2.new(0, 0, 0, 55)
    TabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = MainFrame

    -- Botões das Abas
    local Tabs = {"FARM", "COMBAT", "MOVEMENT", "ESP", "MISC"}
    local TabButtons = {}
    local CurrentTab = "FARM"

    for i, tabName in ipairs(Tabs) do
        local btn = Instance.new("TextButton")
        btn.Name = tabName .. "Tab"
        btn.Size = UDim2.new(1 / #Tabs, 0, 1, 0)
        btn.Position = UDim2.new((i - 1) / #Tabs, 0, 0, 0)
        btn.BackgroundTransparency = 1
        btn.Text = tabName
        btn.TextColor3 = Color3.fromRGB(200, 200, 220)
        btn.TextSize = 13
        btn.Font = Enum.Font.GothamBold
        btn.Parent = TabContainer

        -- Indicador de aba ativa
        local indicator = Instance.new("Frame")
        indicator.Name = "Indicator"
        indicator.Size = UDim2.new(0.6, 0, 0, 3)
        indicator.Position = UDim2.new(0.2, 0, 1, -3)
        indicator.BackgroundColor3 = Color3.fromRGB(150, 0, 255)
        indicator.BorderSizePixel = 0
        indicator.Visible = (i == 1)
        indicator.Parent = btn

        TabButtons[tabName] = {Button = btn, Indicator = indicator}

        btn.MouseButton1Click:Connect(function()
            CurrentTab = tabName
            for _, tb in pairs(TabButtons) do
                tb.Indicator.Visible = false
                tb.Button.TextColor3 = Color3.fromRGB(200, 200, 220)
            end
            indicator.Visible = true
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            -- Atualiza o conteúdo da aba
            UpdateTabContent(tabName)
        end)
    end

    -- ===== CONTEÚDO DAS ABAS (ScrollFrame) =====
    local ScrollFrame = Instance.new("ScrollingFrame")
    ScrollFrame.Name = "ScrollFrame"
    ScrollFrame.Size = UDim2.new(1, -20, 1, -105)
    ScrollFrame.Position = UDim2.new(0, 10, 0, 100)
    ScrollFrame.BackgroundTransparency = 1
    ScrollFrame.BorderSizePixel = 0
    ScrollFrame.ScrollBarThickness = 4
    ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(150, 0, 255)
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 800)
    ScrollFrame.Parent = MainFrame

    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.Padding = UDim.new(0, 6)
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Parent = ScrollFrame

    -- ===== FUNÇÃO PARA CRIAR TOGGLES =====
    local function CreateToggle(parent, name, callback, defaultColor)
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Size = UDim2.new(1, -10, 0, 38)
        ToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
        ToggleFrame.BorderSizePixel = 0
        ToggleFrame.Parent = parent

        local ToggleCorner = Instance.new("UICorner")
        ToggleCorner.CornerRadius = UDim.new(0, 8)
        ToggleCorner.Parent = ToggleFrame

        -- Hover effect
        local hover = false
        ToggleFrame.MouseEnter:Connect(function()
            hover = true
            TweenService:Create(ToggleFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 60)}):Play()
        end)
        ToggleFrame.MouseLeave:Connect(function()
            hover = false
            TweenService:Create(ToggleFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 45)}):Play()
        end)

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -70, 1, 0)
        Label.Position = UDim2.new(0, 12, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = name
        Label.TextColor3 = Color3.fromRGB(240, 240, 255)
        Label.TextSize = 14
        Label.Font = Enum.Font.Gotham
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = ToggleFrame

        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(0, 55, 0, 26)
        Button.Position = UDim2.new(1, -65, 0.5, -13)
        Button.BackgroundColor3 = Color3.fromRGB(255, 60, 80)
        Button.Text = "OFF"
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.TextSize = 12
        Button.Font = Enum.Font.GothamBold
        Button.Parent = ToggleFrame

        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 8)
        ButtonCorner.Parent = Button

        local toggled = false
        Button.MouseButton1Click:Connect(function()
            toggled = not toggled
            local color = toggled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(255, 60, 80)
            TweenService:Create(Button, TweenInfo.new(0.3), {BackgroundColor3 = color}):Play()
            Button.Text = toggled and "ON" or "OFF"
            SafeCall(callback, toggled)
        end)

        return Button
    end

    -- ===== FUNÇÃO PARA CRIAR BOTÃO DE AÇÃO =====
    local function CreateActionButton(parent, name, callback, icon)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 35)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        btn.Text = (icon or "▶") .. " " .. name
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 14
        btn.Font = Enum.Font.Gotham
        btn.BorderSizePixel = 0
        btn.Parent = parent

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = btn

        btn.MouseButton1Click:Connect(function()
            SafeCall(callback)
        end)

        -- Hover
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 85)}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 60)}):Play()
        end)

        return btn
    end

    -- ===== FUNÇÃO PARA ATUALIZAR CONTEÚDO DAS ABAS =====
    local TabContent = {}

    local function ClearTab()
        for _, child in pairs(ScrollFrame:GetChildren()) do
            if child:IsA("Frame") or child:IsA("TextButton") then
                child:Destroy()
            end
        end
    end

    function UpdateTabContent(tab)
        ClearTab()

        if tab == "FARM" then
            -- Auto Farm
            CreateToggle(ScrollFrame, "🎯 Auto Farm", function(state)
                Cipher.Features.AutoFarm = state
                if state then StartAutoFarm() else StopAutoFarm() end
            end)

            -- Auto Quest
            CreateToggle(ScrollFrame, "📋 Auto Quest", function(state)
                Cipher.Features.AutoQuest = state
                if state then StartAutoQuest() else StopAutoQuest() end
            end)

            -- Auto Sea Event
            CreateToggle(ScrollFrame, "🌊 Auto Sea Event", function(state)
                Cipher.Features.AutoSeaEvent = state
                if state then StartAutoSeaEvent() else StopAutoSeaEvent() end
            end)

            -- Bring Mobs
            CreateToggle(ScrollFrame, "🧲 Bring Mobs", function(state)
                Cipher.Features.BringMobs = state
                if state then StartBringMobs() else StopBringMobs() end
            end)

            -- Auto Stats
            CreateToggle(ScrollFrame, "📊 Auto Stats (All)", function(state)
                Cipher.Features.AutoStats.Enabled = state
                Cipher.Features.AutoStats.Melee = state
                Cipher.Features.AutoStats.Defense = state
                Cipher.Features.AutoStats.Sword = state
                Cipher.Features.AutoStats.Gun = state
                Cipher.Features.AutoStats.Fruit = state
                if state then StartAutoStats() else StopAutoStats() end
            end)

        elseif tab == "COMBAT" then
            -- Kill Aura
            CreateToggle(ScrollFrame, "🗡️ Kill Aura", function(state)
                Cipher.Features.KillAura = state
                if state then StartKillAura() else StopKillAura() end
            end)

            -- Fast Attack
            CreateToggle(ScrollFrame, "⚔️ Fast Attack", function(state)
                Cipher.Features.FastAttack = state
                if state then StartFastAttack() else StopFastAttack() end
            end)

            -- Infinite Energy
            CreateToggle(ScrollFrame, "⚡ Infinite Energy", function(state)
                Cipher.Features.InfiniteEnergy = state
                if state then StartInfiniteEnergy() else StopInfiniteEnergy() end
            end)

        elseif tab == "MOVEMENT" then
            -- Fly
            CreateToggle(ScrollFrame, "✈️ Fly", function(state)
                Cipher.Features.Fly = state
                if state then StartFly() else StopFly() end
            end)

            -- Speed Boost
            CreateToggle(ScrollFrame, "🚀 Speed Boost", function(state)
                Cipher.Features.Speed = state
                if state then StartSpeedBoost() else StopSpeedBoost() end
            end)

            -- Infinite Jump
            CreateToggle(ScrollFrame, "🦘 Infinite Jump", function(state)
                Cipher.Features.InfiniteJump = state
                if state then StartInfiniteJump() else StopInfiniteJump() end
            end)

            -- NoClip
            CreateToggle(ScrollFrame, "👻 NoClip", function(state)
                Cipher.Features.NoClip = state
                if state then StartNoClip() else StopNoClip() end
            end)

            -- Teleports
            CreateActionButton(ScrollFrame, "🌍 Teleport - Marine Island", function()
                TeleportToIsland("Marine")
            end, "🌍")

            CreateActionButton(ScrollFrame, "🌍 Teleport - Jungle Island", function()
                TeleportToIsland("Jungle")
            end, "🌍")

            CreateActionButton(ScrollFrame, "🌍 Teleport - Sky Island", function()
                TeleportToIsland("Sky")
            end, "🌍")

            CreateActionButton(ScrollFrame, "🌍 Teleport - Ice Island", function()
                TeleportToIsland("Ice")
            end, "🌍")

        elseif tab == "ESP" then
            -- ESP Players
            CreateToggle(ScrollFrame, "👁️ ESP Players", function(state)
                Cipher.Features.ESP = state
                if state then StartESP() else StopESP() end
            end)

            -- ESP Items (Fruits, Chests)
            CreateToggle(ScrollFrame, "📦 ESP Items", function(state)
                Cipher.Features.ESPItems = state
                if state then StartESPItems() else StopESPItems() end
            end)

        elseif tab == "MISC" then
            -- Server Hop
            CreateActionButton(ScrollFrame, "🔄 Server Hop", function()
                HopServer()
            end, "🔄")

            -- Rejoin
            CreateActionButton(ScrollFrame, "🔁 Rejoin", function()
                Rejoin()
            end, "🔁")

            -- Anti AFK
            CreateToggle(ScrollFrame, "💤 Anti AFK", function(state)
                Cipher.Features.AntiAFK = state
                if state then StartAntiAFK() else StopAntiAFK() end
            end)

            -- Stop All
            CreateActionButton(ScrollFrame, "🛑 STOP ALL", function()
                StopAll()
            end, "🛑")
        end
    end

    -- Inicializa com a aba FARM
    UpdateTabContent("FARM")

    -- ===== TORNAR ARRASTÁVEL =====
    local dragging, dragInput, dragStart, startPos

    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)

    Header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    Header.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    -- ===== FECHAR =====
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui.Enabled = false
    end)

    return ScreenGui
end

-- ============================================
-- 5. FUNÇÕES DAS FEATURES
-- ============================================

-- 5.1 TELEPORT
local function TeleportTo(position)
    if not position then return end
    SafeCall(function()
        local tween = TweenService:Create(RootPart, TweenInfo.new(0.5), {CFrame = CFrame.new(position)})
        tween:Play()
        tween.Completed:Wait()
    end)
end

local function TeleportToIsland(islandName)
    SafeCall(function()
        for _, part in pairs(Workspace:GetDescendants()) do
            if part.Name:lower():find(islandName:lower()) and part:IsA("BasePart") then
                TeleportTo(part.Position + Vector3.new(0, 10, 0))
                return
            end
        end
        warn("Ilha '" .. islandName .. "' não encontrada!")
    end)
end

-- 5.2 AUTO FARM
local farmConnection = nil
local function StartAutoFarm()
    if farmConnection then return end
    print("✅ Auto Farm iniciado")
    farmConnection = RunService.Heartbeat:Connect(function()
        if not Cipher.Features.AutoFarm then return end
        SafeCall(function()
            for _, v in pairs(Workspace:GetDescendants()) do
                if v:IsA("Model") and v:FindFirstChild("Humanoid") and v ~= Character then
                    local hrp = v:FindFirstChild("HumanoidRootPart")
                    if hrp and v.Humanoid.Health > 0 then
                        local dist = (RootPart.Position - hrp.Position).Magnitude
                        if dist < 300 then
                            hrp.CFrame = RootPart.CFrame * CFrame.new(0, 0, -5)
                            hrp.CanCollide = false
                            v.Humanoid.WalkSpeed = 0
                        end
                    end
                end
            end
        end)
    end)
end

local function StopAutoFarm()
    Cipher.Features.AutoFarm = false
    if farmConnection then farmConnection:Disconnect() farmConnection = nil end
    print("⏹️ Auto Farm parado")
end

-- 5.3 AUTO QUEST
local questConnection = nil
local function StartAutoQuest()
    if questConnection then return end
    print("✅ Auto Quest iniciado")
    questConnection = RunService.Heartbeat:Connect(function()
        if not Cipher.Features.AutoQuest then return end
        SafeCall(function()
            -- Procura NPC de quest mais próximo
            local nearestNPC = nil
            local nearestDist = math.huge
            for _, npc in pairs(Workspace:GetDescendants()) do
                if npc.Name:find("Quest") or npc.Name:find("NPC") then
                    local hrp = npc:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local dist = (RootPart.Position - hrp.Position).Magnitude
                        if dist < nearestDist then
                            nearestDist = dist
                            nearestNPC = npc
                        end
                    end
                end
            end
            if nearestNPC then
                local hrp = nearestNPC.HumanoidRootPart
                TeleportTo(hrp.Position + Vector3.new(0, 5, 5))
                task.wait(0.3)
                -- Simula interação (FireServer)
                local remote = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage
                local comm = remote:FindFirstChild("CommF_")
                if comm then
                    comm:InvokeServer("StartQuest")
                end
            end
        end)
    end)
end

local function StopAutoQuest()
    Cipher.Features.AutoQuest = false
    if questConnection then questConnection:Disconnect() questConnection = nil end
    print("⏹️ Auto Quest parado")
end

-- 5.4 AUTO SEA EVENT (Sea Beast, Leviathan, Mirage Island)
local seaEventConnection = nil
local function StartAutoSeaEvent()
    if seaEventConnection then return end
    print("✅ Auto Sea Event iniciado")
    seaEventConnection = RunService.Heartbeat:Connect(function()
        if not Cipher.Features.AutoSeaEvent then return end
        SafeCall(function()
            -- Procura por Sea Beasts, Leviathan, ou Mirage Island
            for _, obj in pairs(Workspace:GetDescendants()) do
                local name = obj.Name:lower()
                if name:find("seabeast") or name:find("leviathan") or name:find("mirage") or name:find("ship") then
                    local pos = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("PrimaryPart")
                    if pos then
                        local dist = (RootPart.Position - pos.Position).Magnitude
                        if dist < Cipher.SeaEventRadius then
                            TeleportTo(pos.Position + Vector3.new(0, 10, 0))
                            -- Ataca o evento
                            if obj:FindFirstChild("Humanoid") then
                                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Q, false, game)
                                task.wait(0.05)
                                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Q, false, game)
                            end
                        end
                    end
                end
            end
        end)
    end)
end

local function StopAutoSeaEvent()
    Cipher.Features.AutoSeaEvent = false
    if seaEventConnection then seaEventConnection:Disconnect() seaEventConnection = nil end
    print("⏹️ Auto Sea Event parado")
end

-- 5.5 BRING MOBS
local bringConnection = nil
local function StartBringMobs()
    if bringConnection then return end
    print("✅ Bring Mobs iniciado")
    bringConnection = RunService.Heartbeat:Connect(function()
        if not Cipher.Features.BringMobs then return end
        SafeCall(function()
            for _, v in pairs(Workspace:GetDescendants()) do
                if v:IsA("Model") and v:FindFirstChild("Humanoid") and v ~= Character then
                    local hrp = v:FindFirstChild("HumanoidRootPart")
                    if hrp and v.Humanoid.Health > 0 then
                        local dist = (RootPart.Position - hrp.Position).Magnitude
                        if dist < 200 then
                            hrp.CFrame = RootPart.CFrame * CFrame.new(0, 0, -5)
                            hrp.CanCollide = false
                            v.Humanoid.WalkSpeed = 0
                        end
                    end
                end
            end
        end)
    end)
end

local function StopBringMobs()
    Cipher.Features.BringMobs = false
    if bringConnection then bringConnection:Disconnect() bringConnection = nil end
    print("⏹️ Bring Mobs parado")
end

-- 5.6 FAST ATTACK
local fastAttackConnection = nil
local function StartFastAttack()
    if fastAttackConnection then return end
    print("✅ Fast Attack iniciado")
    fastAttackConnection = RunService.Heartbeat:Connect(function()
        if not Cipher.Features.FastAttack then return end
        SafeCall(function()
            local CombatFramework = require(LocalPlayer.PlayerScripts:FindFirstChild("CombatFramework"))
            if CombatFramework then
                local controller = getupvalues(CombatFramework)[2]
                if controller then
                    controller.activeController.timeToNextAttack = 0
                    controller.activeController.attacking = false
                    controller.activeController.increment = 3
                    controller.activeController.blocking = false
                end
            end
        end)
    end)
end

local function StopFastAttack()
    Cipher.Features.FastAttack = false
    if fastAttackConnection then fastAttackConnection:Disconnect() fastAttackConnection = nil end
    print("⏹️ Fast Attack parado")
end

-- 5.7 INFINITE ENERGY
local energyConnection = nil
local function StartInfiniteEnergy()
    if energyConnection then return end
    print("✅ Infinite Energy iniciado")
    energyConnection = RunService.Heartbeat:Connect(function()
        if not Cipher.Features.InfiniteEnergy then return end
        SafeCall(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                local humanoid = LocalPlayer.Character.Humanoid
                if humanoid:FindFirstChild("Energy") then
                    humanoid.Energy.Value = humanoid.Energy.MaxValue
                end
            end
        end)
    end)
end

local function StopInfiniteEnergy()
    Cipher.Features.InfiniteEnergy = false
    if energyConnection then energyConnection:Disconnect() energyConnection = nil end
    print("⏹️ Infinite Energy parado")
end

-- 5.8 NOCLIP
local noClipConnection = nil
local function StartNoClip()
    if noClipConnection then return end
    print("✅ NoClip iniciado")
    noClipConnection = RunService.Heartbeat:Connect(function()
        if not Cipher.Features.NoClip then return end
        SafeCall(function()
            if LocalPlayer.Character then
                for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            end
        end)
    end)
end

local function StopNoClip()
    Cipher.Features.NoClip = false
    if noClipConnection then noClipConnection:Disconnect() noClipConnection = nil end
    print("⏹️ NoClip parado")
end

-- 5.9 FLY
local flyConnection = nil
local flyBodyGyro = nil
local flyBodyVelocity = nil
local flyCtrl = {f = 0, b = 0, l = 0, r = 0}
local flyLastCtrl = {f = 0, b = 0, l = 0, r = 0}
local flySpeed = 0

local function StartFly()
    if flyConnection then return end
    print("✅ Fly iniciado")
    flyConnection = RunService.Heartbeat:Connect(function()
        if not Cipher.Features.Fly then
            if flyBodyGyro then flyBodyGyro:Destroy() flyBodyGyro = nil end
            if flyBodyVelocity then flyBodyVelocity:Destroy() flyBodyVelocity = nil end
            return
        end
        SafeCall(function()
            if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
            local hrp = LocalPlayer.Character.HumanoidRootPart

            if not flyBodyGyro or not flyBodyGyro.Parent then
                flyBodyGyro = Instance.new("BodyGyro")
                flyBodyGyro.P = 9e4
                flyBodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
                flyBodyGyro.Parent = hrp
            end

            if not flyBodyVelocity or not flyBodyVelocity.Parent then
                flyBodyVelocity = Instance.new("BodyVelocity")
                flyBodyVelocity.velocity = Vector3.new(0, 0.1, 0)
                flyBodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
                flyBodyVelocity.Parent = hrp
            end

            local camera = Workspace.CurrentCamera
            if not camera then return end

            if flyCtrl.l + flyCtrl.r ~= 0 or flyCtrl.f + flyCtrl.b ~= 0 then
                flySpeed = Cipher.FlySpeed
            elseif flySpeed ~= 0 then
                flySpeed = 0
            end

            if flyCtrl.l + flyCtrl.r ~= 0 or flyCtrl.f + flyCtrl.b ~= 0 then
                local lookVector = camera.CoordinateFrame.lookVector
                local rightVector = (camera.CoordinateFrame * CFrame.new(1, 0, 0).p - camera.CoordinateFrame.p)
                local velocity = (lookVector * (flyCtrl.f + flyCtrl.b)) + (rightVector * (flyCtrl.l + flyCtrl.r))
                flyBodyVelocity.velocity = velocity * flySpeed
                flyLastCtrl = {f = flyCtrl.f, b = flyCtrl.b, l = flyCtrl.l, r = flyCtrl.r}
            elseif flySpeed ~= 0 then
                local lookVector = camera.CoordinateFrame.lookVector
                local rightVector = (camera.CoordinateFrame * CFrame.new(1, 0, 0).p - camera.CoordinateFrame.p)
                local velocity = (lookVector * (flyLastCtrl.f + flyLastCtrl.b)) + (rightVector * (flyLastCtrl.l + flyLastCtrl.r))
                flyBodyVelocity.velocity = velocity * flySpeed
            else
                flyBodyVelocity.velocity = Vector3.new(0, 0.1, 0)
            end

            flyBodyGyro.cframe = camera.CoordinateFrame
        end)
    end)

    -- Controles
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.W then flyCtrl.f = 1
        elseif input.KeyCode == Enum.KeyCode.S then flyCtrl.b = -1
        elseif input.KeyCode == Enum.KeyCode.A then flyCtrl.l = -1
        elseif input.KeyCode == Enum.KeyCode.D then flyCtrl.r = 1
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.W then flyCtrl.f = 0
        elseif input.KeyCode == Enum.KeyCode.S then flyCtrl.b = 0
        elseif input.KeyCode == Enum.KeyCode.A then flyCtrl.l = 0
        elseif input.KeyCode == Enum.KeyCode.D then flyCtrl.r = 0
        end
    end)
end

local function StopFly()
    Cipher.Features.Fly = false
    if flyConnection then flyConnection:Disconnect() flyConnection = nil end
    if flyBodyGyro then flyBodyGyro:Destroy() flyBodyGyro = nil end
    if flyBodyVelocity then flyBodyVelocity:Destroy() flyBodyVelocity = nil end
    print("⏹️ Fly parado")
end

-- 5.10 SPEED BOOST
local speedConnection = nil
local function StartSpeedBoost()
    if speedConnection then return end
    print("✅ Speed Boost iniciado")
    speedConnection = RunService.Heartbeat:Connect(function()
        SafeCall(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                local hum = LocalPlayer.Character.Humanoid
                if Cipher.Features.Speed then
                    hum.WalkSpeed = Cipher.SpeedValue
                else
                    hum.WalkSpeed = 16
                end
            end
        end)
    end)
end

local function StopSpeedBoost()
    Cipher.Features.Speed = false
    if speedConnection then speedConnection:Disconnect() speedConnection = nil end
    print("⏹️ Speed Boost parado")
end

-- 5.11 INFINITE JUMP
local jumpConnection = nil
local function StartInfiniteJump()
    if jumpConnection then return end
    print("✅ Infinite Jump iniciado")
    jumpConnection = UserInputService.JumpRequest:Connect(function()
        if Cipher.Features.InfiniteJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end

local function StopInfiniteJump()
    Cipher.Features.InfiniteJump = false
    if jumpConnection then jumpConnection:Disconnect() jumpConnection = nil end
    print("⏹️ Infinite Jump parado")
end

-- 5.12 KILL AURA
local killAuraConnection = nil
local function StartKillAura()
    if killAuraConnection then return end
    print("✅ Kill Aura iniciado")
    killAuraConnection = RunService.Heartbeat:Connect(function()
        if not Cipher.Features.KillAura then return end
        SafeCall(function()
            local nearestEnemy = nil
            local nearestDist = math.huge
            for _, enemy in pairs(Workspace:GetDescendants()) do
                if enemy:IsA("Model") and enemy:FindFirstChild("Humanoid") and enemy ~= Character then
                    local hrp = enemy:FindFirstChild("HumanoidRootPart")
                    if hrp and enemy.Humanoid.Health > 0 then
                        local dist = (RootPart.Position - hrp.Position).Magnitude
                        if dist < Cipher.KillAuraRadius and dist < nearestDist then
                            nearestDist = dist
                            nearestEnemy = enemy
                        end
                    end
                end
            end
            if nearestEnemy then
                local hrp = nearestEnemy.HumanoidRootPart
                RootPart.CFrame = CFrame.new(RootPart.Position, Vector3.new(hrp.Position.X, RootPart.Position.Y, hrp.Position.Z))
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Q, false, game)
                task.wait(0.05)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Q, false, game)
            end
        end)
    end)
end

local function StopKillAura()
    Cipher.Features.KillAura = false
    if killAuraConnection then killAuraConnection:Disconnect() killAuraConnection = nil end
    print("⏹️ Kill Aura parado")
end

-- 5.13 ESP PLAYERS
local espConnection = nil
local espObjects = {}
local function StartESP()
    if espConnection then return end
    print("✅ ESP Players iniciado")
    espConnection = RunService.Heartbeat:Connect(function()
        if not Cipher.Features.ESP then
            for _, obj in pairs(espObjects) do
                obj:Destroy()
            end
            espObjects = {}
            return
        end
        SafeCall(function()
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                    if hrp and not hrp:FindFirstChild("ESPBox") then
                        local box = Instance.new("BoxHandleAdornment")
                        box.Name = "ESPBox"
                        box.Size = hrp.Size * 2
                        box.Color3 = Color3.fromRGB(255, 0, 100)
                        box.Transparency = 0.6
                        box.AlwaysOnTop = true
                        box.ZIndex = 5
                        box.Adornee = hrp
                        box.Parent = hrp
                        table.insert(espObjects, box)
                    end
                end
            end
        end)
    end)
end

local function StopESP()
    Cipher.Features.ESP = false
    if espConnection then espConnection:Disconnect() espConnection = nil end
    for _, obj in pairs(espObjects) do obj:Destroy() end
    espObjects = {}
    print("⏹️ ESP Players parado")
end

-- 5.14 ESP ITEMS
local espItemsConnection = nil
local espItemsObjects = {}
local function StartESPItems()
    if espItemsConnection then return end
    print("✅ ESP Items iniciado")
    espItemsConnection = RunService.Heartbeat:Connect(function()
        if not Cipher.Features.ESPItems then
            for _, obj in pairs(espItemsObjects) do obj:Destroy() end
            espItemsObjects = {}
            return
        end
        SafeCall(function()
            for _, item in pairs(Workspace:GetDescendants()) do
                local name = item.Name:lower()
                if (name:find("fruit") or name:find("chest") or name:find("candy") or name:find("bone")) and item:IsA("BasePart") then
                    if not item:FindFirstChild("ESPBox") then
                        local box = Instance.new("BoxHandleAdornment")
                        box.Name = "ESPBox"
                        box.Size = item.Size * 1.5
                        box.Color3 = Color3.fromRGB(0, 255, 100)
                        box.Transparency = 0.5
                        box.AlwaysOnTop = true
                        box.ZIndex = 5
                        box.Adornee = item
                        box.Parent = item
                        table.insert(espItemsObjects, box)
                    end
                end
            end
        end)
    end)
end

local function StopESPItems()
    Cipher.Features.ESPItems = false
    if espItemsConnection then espItemsConnection:Disconnect() espItemsConnection = nil end
    for _, obj in pairs(espItemsObjects) do obj:Destroy() end
    espItemsObjects = {}
    print("⏹️ ESP Items parado")
end

-- 5.15 AUTO STATS
local statsConnection = nil
local function StartAutoStats()
    if statsConnection then return end
    print("✅ Auto Stats iniciado")
    statsConnection = RunService.Heartbeat:Connect(function()
        if not Cipher.Features.AutoStats.Enabled then return end
        SafeCall(function()
            local remote = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage
            local comm = remote:FindFirstChild("CommF_")
            if not comm then return end
            if Cipher.Features.AutoStats.Melee then
                comm:InvokeServer("AddPoint", "Melee", 1)
            end
            if Cipher.Features.AutoStats.Defense then
                comm:InvokeServer("AddPoint", "Defense", 1)
            end
            if Cipher.Features.AutoStats.Sword then
                comm:InvokeServer("AddPoint", "Sword", 1)
            end
            if Cipher.Features.AutoStats.Gun then
                comm:InvokeServer("AddPoint", "Gun", 1)
            end
            if Cipher.Features.AutoStats.Fruit then
                comm:InvokeServer("AddPoint", "Demon Fruit", 1)
            end
        end)
    end)
end

local function StopAutoStats()
    Cipher.Features.AutoStats.Enabled = false
    if statsConnection then statsConnection:Disconnect() statsConnection = nil end
    print("⏹️ Auto Stats parado")
end

-- 5.16 ANTI AFK
local antiAFKConnection = nil
local function StartAntiAFK()
    if antiAFKConnection then return end
    print("✅ Anti AFK iniciado")
    antiAFKConnection = RunService.Heartbeat:Connect(function()
        if Cipher.Features.AntiAFK then
            SafeCall(function()
                local vim = VirtualInputManager
                vim:SendKeyEvent(true, Enum.KeyCode.W, false, game)
                task.wait(0.1)
                vim:SendKeyEvent(false, Enum.KeyCode.W, false, game)
            end)
        end
    end)
end

local function StopAntiAFK()
    Cipher.Features.AntiAFK = false
    if antiAFKConnection then antiAFKConnection:Disconnect() antiAFKConnection = nil end
    print("⏹️ Anti AFK parado")
end

-- 5.17 SERVER HOP
local function HopServer()
    SafeCall(function()
        local servers = {}
        for _, v in pairs(game:GetService("HttpService"):JSONDecode(game:HttpGetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100"))) do
            if type(v) == "table" and v.playing ~= v.maxPlayers then
                table.insert(servers, v.id)
            end
        end
        if #servers > 0 then
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)])
        end
    end)
end

-- 5.18 REJOIN
local function Rejoin()
    SafeCall(function()
        game:GetService("TeleportService"):Teleport(game.PlaceId)
    end)
end

-- 5.19 STOP ALL
local function StopAll()
    StopAutoFarm()
    StopAutoQuest()
    StopAutoSeaEvent()
    StopBringMobs()
    StopFastAttack()
    StopInfiniteEnergy()
    StopNoClip()
    StopFly()
    StopSpeedBoost()
    StopInfiniteJump()
    StopKillAura()
    StopESP()
    StopESPItems()
    StopAutoStats()
    StopAntiAFK()
    print("🛑 Todas as funções foram paradas!")
end

-- ============================================
-- 6. INICIALIZAÇÃO
-- ============================================
local GUI = CreateGUI()

-- Keybind: INSERT para abrir/fechar
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Insert then
        GUI.Enabled = not GUI.Enabled
    end
end)

-- Inicia conexões padrão (Speed Boost e outras que não dependem de toggle)
StartSpeedBoost()

print("=========================================")
print("   ⚡ CIPHER HUB - CARREGADO COM SUCESSO!")
print("   Pressione INSERT para abrir o menu")
print("   Features: Auto Farm, Auto Sea Event,")
print("   Kill Aura, ESP, Fly, Teleport e mais!")
print("=========================================")