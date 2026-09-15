Понял! Значит executor рабочий, но большой скрипт не тянет. Давай сделаю компактную версию — то же самое, но в 3 раза короче и без сложных вложений. Должно заинжектиться.

```lua
--// COMPACT PREMIUM v5
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer

--// ЦВЕТА
local ACCENT = Color3.fromRGB(140, 90, 255)
local ACCENT2 = Color3.fromRGB(80, 200, 255)
local DANGER = Color3.fromRGB(255, 70, 90)
local SUCCESS = Color3.fromRGB(80, 255, 150)
local BG = Color3.fromRGB(14, 14, 20)
local BG2 = Color3.fromRGB(22, 22, 32)

--// СОСТОЯНИЕ
local S = {
    god = false, speed = false, spd = 50,
    jump = false, jmp = 100, noclip = false, esp = false
}

--// GUI
local gui = Instance.new("ScreenGui")
gui.Name = "CompactMenu"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = LP:WaitForChild("PlayerGui")

--// КНОПКА ОТКРЫТИЯ
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 55, 0, 55)
openBtn.Position = UDim2.new(0, 15, 0, 100)
openBtn.BackgroundColor3 = ACCENT
openBtn.Text = "⚡"
openBtn.TextColor3 = Color3.new(1,1,1)
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 28
openBtn.Active = true
openBtn.Selectable = true
openBtn.Parent = gui
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1,0)

--// КНОПКА FLASHBACK
local flashBtn = Instance.new("TextButton")
flashBtn.Size = UDim2.new(0, 90, 0, 90)
flashBtn.Position = UDim2.new(0.5, -45, 1, -120)
flashBtn.BackgroundColor3 = Color3.fromRGB(90, 50, 160)
flashBtn.Text = "⏪"
flashBtn.TextColor3 = Color3.new(1,1,1)
flashBtn.Font = Enum.Font.GothamBold
flashBtn.TextSize = 42
flashBtn.Active = true
flashBtn.Selectable = true
flashBtn.Parent = gui
Instance.new("UICorner", flashBtn).CornerRadius = UDim.new(1,0)

local flashLbl = Instance.new("TextLabel")
flashLbl.Size = UDim2.new(1, 0, 0, 16)
flashLbl.Position = UDim2.new(0, 0, 1, -20)
flashLbl.BackgroundTransparency = 1
flashLbl.Text = "FLASHBACK"
flashLbl.TextColor3 = Color3.new(1,1,1)
flashLbl.Font = Enum.Font.GothamBold
flashLbl.TextSize = 10
flashLbl.Parent = flashBtn

--// МЕНЮ
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 320, 0, 480)
menu.Position = UDim2.new(0.5, -160, 0.5, -240)
menu.BackgroundColor3 = BG
menu.BorderSizePixel = 0
menu.Active = true
menu.Draggable = true
menu.Visible = false
menu.Parent = gui
Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 16)

local stroke = Instance.new("UIStroke", menu)
stroke.Color = ACCENT
stroke.Thickness = 1.5
stroke.Transparency = 0.4

--// ЗАГОЛОВОК
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 44)
header.BackgroundColor3 = BG2
header.BorderSizePixel = 0
header.Parent = menu
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 16)

local hTitle = Instance.new("TextLabel")
hTitle.Size = UDim2.new(1, -60, 1, 0)
hTitle.Position = UDim2.new(0, 15, 0, 0)
hTitle.BackgroundTransparency = 1
hTitle.Text = "⚡ PREMIUM v5"
hTitle.TextColor3 = Color3.new(1,1,1)
hTitle.Font = Enum.Font.GothamBold
hTitle.TextSize = 15
hTitle.TextXAlignment = Enum.TextXAlignment.Left
hTitle.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 32, 0, 32)
closeBtn.Position = UDim2.new(1, -40, 0, 6)
closeBtn.BackgroundColor3 = DANGER
closeBtn.Text = "✖"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.Active = true
closeBtn.Selectable = true
closeBtn.Parent = header
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

--// ВКЛАДКИ
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, -20, 0, 36)
tabBar.Position = UDim2.new(0, 10, 0, 52)
tabBar.BackgroundColor3 = BG2
tabBar.BorderSizePixel = 0
tabBar.Parent = menu
Instance.new("UICorner", tabBar).CornerRadius = UDim.new(0, 8)

local tabs = {}
local pages = {}

local function makeTab(text, i)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1/3, 0, 1, 0)
    b.Position = UDim2.new((i-1)/3, 0, 0, 0)
    b.BackgroundTransparency = 1
    b.Text = text
    b.TextColor3 = Color3.fromRGB(180, 180, 200)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 11
    b.AutoButtonColor = false
    b.Active = true
    b.Selectable = true
    b.Parent = tabBar
    tabs[i] = b
    return b
end

local function makePage()
    local p = Instance.new("ScrollingFrame")
    p.Size = UDim2.new(1, -20, 1, -140)
    p.Position = UDim2.new(0, 10, 0, 96)
    p.BackgroundTransparency = 1
    p.BorderSizePixel = 0
    p.ScrollBarThickness = 4
    p.CanvasSize = UDim2.new(0, 0, 0, 0)
    p.AutomaticCanvasSize = Enum.AutomaticSize.Y
    p.Visible = false
    p.Parent = menu
    local l = Instance.new("UIListLayout", p)
    l.Padding = UDim.new(0, 6)
    l.SortOrder = Enum.SortOrder.LayoutOrder
    return p
end

local tabF = makeTab("Функции", 1)
local tabE = makeTab("ESP", 2)
local tabS = makeTab("Настройки", 3)

pages[1] = makePage()
pages[2] = makePage()
pages[3] = makePage()

local function switchTab(n)
    for i, p in ipairs(pages) do p.Visible = (i == n) end
    for i, t in ipairs(tabs) do
        t.TextColor3 = (i == n) and ACCENT2 or Color3.fromRGB(180, 180, 200)
    end
end

tabF.MouseButton1Click:Connect(function() switchTab(1) end)
tabE.MouseButton1Click:Connect(function() switchTab(2) end)
tabS.MouseButton1Click:Connect(function() switchTab(3) end)
switchTab(1)

--// ФУНКЦИИ ДЛЯ СОЗДАНИЯ ЭЛЕМЕНТОВ
local function section(parent, text, order)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, 0, 0, 18)
    l.BackgroundTransparency = 1
    l.Text = "▸ " .. text
    l.TextColor3 = ACCENT2
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Font = Enum.Font.GothamBold
    l.TextSize = 11
    l.LayoutOrder = order
    l.Parent = parent
    return l
end

local function toggle(parent, icon, title, sub, order, onClick)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 54)
    btn.BackgroundColor3 = BG2
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.Active = true
    btn.Selectable = true
    btn.LayoutOrder = order
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

    local ic = Instance.new("TextLabel")
    ic.Size = UDim2.new(0, 46, 1, 0)
    ic.BackgroundTransparency = 1
    ic.Text = icon
    ic.TextSize = 22
    ic.Parent = btn

    local t1 = Instance.new("TextLabel")
    t1.Size = UDim2.new(1, -100, 0, 20)
    t1.Position = UDim2.new(0, 52, 0, 8)
    t1.BackgroundTransparency = 1
    t1.Text = title
    t1.TextColor3 = Color3.new(1,1,1)
    t1.Font = Enum.Font.GothamBold
    t1.TextSize = 13
    t1.TextXAlignment = Enum.TextXAlignment.Left
    t1.Parent = btn

    local t2 = Instance.new("TextLabel")
    t2.Size = UDim2.new(1, -100, 0, 16)
    t2.Position = UDim2.new(0, 52, 0, 28)
    t2.BackgroundTransparency = 1
    t2.Text = sub
    t2.TextColor3 = Color3.fromRGB(150, 150, 170)
    t2.TextSize = 10
    t2.TextXAlignment = Enum.TextXAlignment.Left
    t2.Parent = btn

    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 12, 0, 12)
    dot.Position = UDim2.new(1, -26, 0.5, -6)
    dot.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    dot.BorderSizePixel = 0
    dot.Parent = btn
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        dot.BackgroundColor3 = active and SUCCESS or Color3.fromRGB(60, 60, 80)
        btn.BackgroundColor3 = active and Color3.fromRGB(28, 50, 40) or BG2
        onClick(active)
    end)
    return btn
end

local function slider(parent, name, min, max, default, order, cb)
    local h = Instance.new("Frame")
    h.Size = UDim2.new(1, 0, 0, 54)
    h.BackgroundColor3 = BG2
    h.BorderSizePixel = 0
    h.LayoutOrder = order
    h.Parent = parent
    Instance.new("UICorner", h).CornerRadius = UDim.new(0, 10)

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -16, 0, 18)
    l.Position = UDim2.new(0, 10, 0, 4)
    l.BackgroundTransparency = 1
    l.Text = name .. ": " .. default
    l.TextColor3 = Color3.fromRGB(230, 230, 240)
    l.Font = Enum.Font.GothamBold
    l.TextSize = 11
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = h

    local m = Instance.new("TextButton")
    m.Size = UDim2.new(0, 46, 0, 26)
    m.Position = UDim2.new(0, 10, 0, 24)
    m.BackgroundColor3 = Color3.fromRGB(60, 25, 40)
    m.Text = "−"
    m.TextColor3 = Color3.fromRGB(255, 150, 170)
    m.Font = Enum.Font.GothamBold
    m.TextSize = 18
    m.Active = true
    m.Selectable = true
    m.Parent = h
    Instance.new("UICorner", m).CornerRadius = UDim.new(0, 6)

    local p = Instance.new("TextButton")
    p.Size = UDim2.new(0, 46, 0, 26)
    p.Position = UDim2.new(1, -56, 0, 24)
    p.BackgroundColor3 = Color3.fromRGB(25, 60, 40)
    p.Text = "+"
    p.TextColor3 = Color3.fromRGB(150, 255, 180)
    p.Font = Enum.Font.GothamBold
    p.TextSize = 18
    p.Active = true
    p.Selectable = true
    p.Parent = h
    Instance.new("UICorner", p).CornerRadius = UDim.new(0, 6)

    local cur = default
    local step = (max - min) / 50
    local function upd(v)
        cur = math.clamp(v, min, max)
        l.Text = name .. ": " .. math.floor(cur)
        cb(cur)
    end
    m.MouseButton1Click:Connect(function() upd(cur - step) end)
    p.MouseButton1Click:Connect(function() upd(cur + step) end)
end

--// ЛОГИКА
local godConn, speedConn, jumpConn, noclipConn

local function applyGod()
    local c = LP.Character
    if not c then return end
    local h = c:FindFirstChildOfClass("Humanoid")
    if not h then return end
    if godConn then godConn:Disconnect() end
    if S.god then
        h.MaxHealth = math.huge
        h.Health = math.huge
        godConn = h.HealthChanged:Connect(function()
            if S.god and h.Health < h.MaxHealth then h.Health = h.MaxHealth end
        end)
    else
        h.MaxHealth = 100
        if h.Health > 100 then h.Health = 100 end
    end
end

local function applySpeed()
    local c = LP.Character
    if not c then return end
    local h = c:FindFirstChildOfClass("Humanoid")
    if not h then return end
    if speedConn then speedConn:Disconnect() end
    h.WalkSpeed = S.speed and S.spd or 16
    if S.speed then
        speedConn = h:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
            if S.speed then h.WalkSpeed = S.spd end
        end)
    end
end

local function applyJump()
    local c = LP.Character
    if not c then return end
    local h = c:FindFirstChildOfClass("Humanoid")
    if not h then return end
    if jumpConn then jumpConn:Disconnect() end
    h.UseJumpPower = true
    h.JumpPower = S.jump and S.jmp or 50
    if S.jump then
        jumpConn = h:GetPropertyChangedSignal("JumpPower"):Connect(function()
            if S.jump then h.JumpPower = S.jmp end
        end)
    end
end

local function applyNoclip()
    if noclipConn then noclipConn:Disconnect() noclipConn = nil end
    if not S.noclip then return end
    noclipConn = RunService.Stepped:Connect(function()
        local c = LP.Character
        if not c then return end
        for _, p in ipairs(c:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end)
end

--// ESP
local espObjs = {}

local function createESP(plr)
    if plr == LP then return end
    if espObjs[plr] then return end
    espObjs[plr] = {bb = nil, conn = nil}
    local function apply(c)
        if not c then return end
        local d = espObjs[plr]
        if not d then return end
        if d.bb then d.bb:Destroy() end
        local head = c:FindFirstChild("Head")
        if not head then return end
        local bb = Instance.new("BillboardGui")
        bb.Size = UDim2.new(0, 140, 0, 44)
        bb.StudsOffset = Vector3.new(0, 3, 0)
        bb.AlwaysOnTop = true
        bb.Adornee = head
        bb.Enabled = S.esp
        bb.Parent = head

        local nl = Instance.new("TextLabel")
        nl.Size = UDim2.new(1, 0, 0, 20)
        nl.BackgroundTransparency = 1
        nl.Text = plr.Name
        nl.TextColor3 = Color3.new(1,1,1)
        nl.TextStrokeTransparency = 0
        nl.Font = Enum.Font.GothamBold
        nl.TextSize = 13
        nl.Parent = bb

        local dl = Instance.new("TextLabel")
        dl.Size = UDim2.new(1, 0, 0, 18)
        dl.Position = UDim2.new(0, 0, 0, 22)
        dl.BackgroundTransparency = 1
        dl.TextColor3 = Color3.fromRGB(200, 255, 200)
        dl.TextStrokeTransparency = 0
        dl.Font = Enum.Font.GothamBold
        dl.TextSize = 11
        dl.Parent = bb

        d.bb = bb
        d.dl = dl
    end
    if plr.Character then apply(plr.Character) end
    espObjs[plr].conn = plr.CharacterAdded:Connect(function(c)
        task.wait(0.5)
        apply(c)
    end)
end

local function removeESP(plr)
    local d = espObjs[plr]
    if d then
        if d.bb then d.bb:Destroy() end
        if d.conn then d.conn:Disconnect() end
        espObjs[plr] = nil
    end
end

Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(removeESP)
for _, p in ipairs(Players:GetPlayers()) do createESP(p) end

-- Обновление дистанции
RunService.RenderStepped:Connect(function()
    if not S.esp then return end
    local c = LP.Character
    if not c then return end
    local hrp = c:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    for plr, d in pairs(espObjs) do
        if d.bb and d.dl then
            local pc = plr.Character
            if pc then
                local phrp = pc:FindFirstChild("HumanoidRootPart")
                if phrp then
                    d.dl.Text = "[" .. math.floor((hrp.Position - phrp.Position).Magnitude) .. "m]"
                end
            end
        end
    end
end)

--// FLASHBACK
local history = {}
local flashing = false

local function doFlashback()
    if flashing then return end
    if #history < 2 then return end
    local c = LP.Character
    if not c then return end
    local hrp = c:FindFirstChild("HumanoidRootPart")
    local hum = c:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    flashing = true
    hum.WalkSpeed = 0
    hum.JumpPower = 0

    task.spawn(function()
        for i = #history, 1, -1 do
            if not flashing then break end
            if history[i] then
                hrp.CFrame = history[i]
                RunService.RenderStepped:Wait()
            end
        end
        task.wait(0.1)
        local cc = LP.Character
        if cc then
            local h = cc:FindFirstChildOfClass("Humanoid")
            if h then
                h.WalkSpeed = S.speed and S.spd or 16
                h.JumpPower = S.jump and S.jmp or 50
            end
        end
        history = {}
        flashing = false
    end)
end

RunService.Heartbeat:Connect(function()
    if flashing then return end
    local c = LP.Character
    if not c then return end
    local hrp = c:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    table.insert(history, hrp.CFrame)
    local cutoff = tick() - 3
    while #history > 0 and #history > 180 do
        table.remove(history, 1)
    end
end)

flashBtn.MouseButton1Click:Connect(doFlashback)

--// ВКЛАДКА ФУНКЦИИ
local pF = pages[1]
section(pF, "ЗАЩИТА", 1)
toggle(pF, "🛡️", "GodMode", "Бессмертие", 2, function(a)
    S.god = a
    applyGod()
end)
toggle(pF, "👻", "Noclip", "Сквозь стены", 3, function(a)
    S.noclip = a
    applyNoclip()
end)

section(pF, "ДВИЖЕНИЕ", 10)
toggle(pF, "💨", "Speed", "Ускорение", 11, function(a)
    S.speed = a
    applySpeed()
end)
toggle(pF, "🦘", "High Jump", "Прыжок", 12, function(a)
    S.jump = a
    applyJump()
end)

section(pF, "FLASHBACK", 20)
local fbCard = Instance.new("TextButton")
fbCard.Size = UDim2.new(1, 0, 0, 54)
fbCard.BackgroundColor3 = Color3.fromRGB(40, 25, 60)
fbCard.Text = "⏪  Flashback — перемотка назад"
fbCard.TextColor3 = Color3.new(1,1,1)
fbCard.Font = Enum.Font.GothamBold
fbCard.TextSize = 13
fbCard.AutoButtonColor = false
fbCard.Active = true
fbCard.Selectable = true
fbCard.LayoutOrder = 21
fbCard.Parent = pF
Instance.new("UICorner", fbCard).CornerRadius = UDim.new(0, 10)
fbCard.MouseButton1Click:Connect(doFlashback)

section(pF, "УПРАВЛЕНИЕ", 30)
local stopBtn = Instance.new("TextButton")
stopBtn.Size = UDim2.new(1, 0, 0, 54)
stopBtn.BackgroundColor3 = Color3.fromRGB(80, 25, 35)
stopBtn.Text = "⛔  ОСТАНОВИТЬ ВСЁ"
stopBtn.TextColor3 = Color3.new(1,1,1)
stopBtn.Font = Enum.Font.GothamBold
stopBtn.TextSize = 14
stopBtn.AutoButtonColor = false
stopBtn.Active = true
stopBtn.Selectable = true
stopBtn.LayoutOrder = 31
stopBtn.Parent = pF
Instance.new("UICorner", stopBtn).CornerRadius = UDim.new(0, 10)
stopBtn.MouseButton1Click:Connect(function()
    S.god = false S.speed = false S.jump = false S.noclip = false
    applyGod() applySpeed() applyJump() applyNoclip()
    for _, child in ipairs(pF:GetChildren()) do
        if child:IsA("TextButton") then
            child.BackgroundColor3 = (child == stopBtn or child == fbCard) and child.BackgroundColor3 or BG2
        end
    end
end)

--// ВКЛАДКА ESP
local pE = pages[2]
section(pE, "ESP", 1)
toggle(pE, "👁️", "ESP", "Подсветка игроков", 2, function(a)
    S.esp = a
    for _, d in pairs(espObjs) do
        if d.bb then d.bb.Enabled = a end
    end
end)

--// ВКЛАДКА НАСТРОЙКИ
local pS = pages[3]
section(pS, "ДВИЖЕНИЕ", 1)
slider(pS, "WalkSpeed", 16, 300, 50, 2, function(v)
    S.spd = v
    if S.speed then applySpeed() end
end)
slider(pS, "JumpPower", 50, 500, 100, 3, function(v)
    S.jmp = v
    if S.jump then applyJump() end
end)

--// ОТКРЫТИЕ / ЗАКРЫТИЕ
local isOpen = false
openBtn.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    menu.Visible = isOpen
end)

closeBtn.MouseButton1Click:Connect(function()
    isOpen = false
    menu.Visible = false
end)

--// РЕСПАВН
LP.CharacterAdded:Connect(function()
    task.wait(1)
    if S.god then applyGod() end
    if S.speed then applySpeed() end
    if S.jump then applyJump() end
    history = {}
end)

print("✅ Compact Premium v5 загружен!")
```

---

✨ Что изменилось

Было Стало
~700 строк ~450 строк
Много TweenService Убрал всё лишнее
Сложные анимации Простые мгновенные
Длинные имена переменных Короткие (S, LP, gui)
Множество проверок Только необходимые

✅ Что осталось

· GodMode — бессмертие
· Noclip — сквозь стены
· Speed — ускорение
· High Jump — высокий прыжок
· ESP — имена + дистанция
· Flashback — кнопка внизу по центру
· 3 вкладки — Функции / ESP / Настройки
· Слайдеры — WalkSpeed, JumpPower
· Кнопка STOP

---

🧪 Как тестировать

1. Запусти этот скрипт
2. Если сработал — увидишь ✅ Compact Premium v5 загружен! в консоли (F9)
3. Если не сработал — пришли мне текст ошибки из консоли

Если и это не тянет

Тогда причина не в размере, а в конкретной функции. Скажи что именно — уберу её.

Какой у тебя executor? (Delta / Fluxus / Arceus X / Codex / Hydrogen)
