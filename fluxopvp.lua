-- ============================================================
-- VYSESAINT — FULL SCRIPT (Fixed Toggle Glitch)
-- Game: Fluxo PVP (multi-place support)
-- ============================================================

-- ============================================================
-- LOCK CHECKS
-- ============================================================
local ALLOWED_PLACE_IDS = {
    [99001115434148] = true,
    [83590755974448] = true,
    [133451168835128] = true,
}

local TARGET_GAME_NAME = "Fluxo PVP"
local CHEAT_BUILD_VERSION = "1.0.0"
local LOCKED_ROBLOX_VERSION = "version-c5aecda2245e4fae"

local function LockedPopup(title, message, color, blocking)
    local CoreGui = game:GetService("CoreGui")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local TweenService = game:GetService("TweenService")

    local WarnGui = Instance.new("ScreenGui")
    WarnGui.Name = "VYSESAINT_LOCK_" .. tostring(math.random(1000, 9999))
    WarnGui.ResetOnSpawn = false
    WarnGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() WarnGui.Parent = CoreGui end)
    if not WarnGui.Parent then WarnGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 380, 0, 220)
    Frame.Position = UDim2.new(0.5, -190, 0.5, -110)
    Frame.BackgroundColor3 = Color3.fromRGB(10, 0, 5)
    Frame.BorderSizePixel = 0
    Frame.Parent = WarnGui

    local FC = Instance.new("UICorner")
    FC.CornerRadius = UDim.new(0, 12)
    FC.Parent = Frame

    local FS = Instance.new("UIStroke")
    FS.Color = color or Color3.fromRGB(255, 30, 60)
    FS.Thickness = 2
    FS.Parent = Frame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -20, 0, 30)
    Title.Position = UDim2.new(0, 15, 0, 15)
    Title.BackgroundTransparency = 1
    Title.Text = title
    Title.TextColor3 = color or Color3.fromRGB(255, 30, 60)
    Title.TextSize = 16
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Frame

    local Msg = Instance.new("TextLabel")
    Msg.Size = UDim2.new(1, -30, 0, 120)
    Msg.Position = UDim2.new(0, 15, 0, 50)
    Msg.BackgroundTransparency = 1
    Msg.Text = message
    Msg.TextColor3 = Color3.fromRGB(220, 200, 210)
    Msg.TextSize = 13
    Msg.Font = Enum.Font.Gotham
    Msg.TextWrapped = true
    Msg.TextXAlignment = Enum.TextXAlignment.Left
    Msg.TextYAlignment = Enum.TextYAlignment.Top
    Msg.Parent = Frame

    local ExitButton = Instance.new("TextButton")
    ExitButton.Size = UDim2.new(1, -30, 0, 34)
    ExitButton.Position = UDim2.new(0, 15, 1, -48)
    ExitButton.BackgroundColor3 = color or Color3.fromRGB(255, 30, 60)
    ExitButton.Text = blocking and "EXIT" or "CONTINUE"
    ExitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ExitButton.TextSize = 13
    ExitButton.Font = Enum.Font.GothamBold
    ExitButton.BorderSizePixel = 0
    ExitButton.Parent = Frame

    local EC = Instance.new("UICorner")
    EC.CornerRadius = UDim.new(0, 6)
    EC.Parent = ExitButton

    ExitButton.MouseButton1Click:Connect(function()
        WarnGui:Destroy()
    end)

    Frame.Size = UDim2.new(0, 0, 0, 220)
    TweenService:Create(Frame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 380, 0, 220)}):Play()
end

if not ALLOWED_PLACE_IDS[game.PlaceId] then
    LockedPopup("WRONG GAME",
        "This cheat only works on " .. TARGET_GAME_NAME .. ".\n\n" ..
        "Place ID: " .. tostring(game.PlaceId) .. "\n" ..
        "This place is not on the allowlist.\n\n" ..
        "Script will not run.", nil, true)
    return
end

local function GetRobloxClientVersion()
    if getgenv and getgenv().RobloxVersion then return tostring(getgenv().RobloxVersion) end
    if getgenv and getgenv().ROBLOX_VERSION then return tostring(getgenv().ROBLOX_VERSION) end
    local version = "unknown"
    pcall(function()
        if isfile and readfile then
            for _, path in ipairs({"version.txt","Roblox/version.txt","roblox-version.txt"}) do
                if isfile(path) then version = readfile(path):gsub("%s+", "") break end
            end
        end
    end)
    pcall(function()
        local v = game:GetService("Version")
        if v then
            local ok, ver = pcall(function() return v:GetVersion() end)
            if ok and ver then version = tostring(ver) end
        end
    end)
    return version
end

local currentVersion = GetRobloxClientVersion()
if currentVersion ~= "unknown" and currentVersion ~= "" and currentVersion ~= LOCKED_ROBLOX_VERSION then
    LockedPopup("ROBLOX UPDATED",
        "Roblox client updated.\n\nLocked: " .. LOCKED_ROBLOX_VERSION .. "\nCurrent: " .. currentVersion ..
        "\n\nCheat must be re-verified.\nScript will not run.",
        Color3.fromRGB(255, 180, 0), true)
    return
end

if game.PlaceId == 99001115434148 then
    local hasCaster = false
    pcall(function() hasCaster = game.ReplicatedStorage:FindFirstChild("ZexisShared") ~= nil end)
    if not hasCaster then
        LockedPopup("INCOMPATIBLE GAME",
            "Built for " .. TARGET_GAME_NAME .. " only.\nRequired modules not found on main hub.\n\nScript will not run.",
            Color3.fromRGB(255, 180, 0), true)
        return
    end
end

if getgenv().VYSESAINT_LOCK then
    LockedPopup("ALREADY RUNNING", "The script is already running.\nYou can't run it twice.", Color3.fromRGB(255, 30, 60), true)
    return
end

-- ============================================================
-- SERVICES
-- ============================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local HOOK_KEY = "_" .. tostring(math.random(100000, 999999)) .. tostring(os.time()):reverse():sub(1,6)

local Theme = {
    Primary      = Color3.fromRGB(255, 20, 40),
    PrimaryDark  = Color3.fromRGB(120, 0, 15),
    PrimaryGlow  = Color3.fromRGB(255, 60, 80),
    Background   = Color3.fromRGB(8, 0, 2),
    Panel        = Color3.fromRGB(18, 2, 8),
    PanelLight   = Color3.fromRGB(28, 4, 12),
    Text         = Color3.fromRGB(240, 220, 225),
    TextDim      = Color3.fromRGB(160, 120, 130),
    Success      = Color3.fromRGB(0, 220, 90),
    Danger       = Color3.fromRGB(255, 30, 60),
    Warning      = Color3.fromRGB(255, 180, 0),
}

local Config = {
    ESPEnabled = true,
    ESPBox = true,
    ESPLine = true,
    SilentAimEnabled = true,
    SilentTargetPart = "Head",
    SafeSilentAim = false,
    SafeSilentChance = 5,
    SilentWallCheck = true,
    FOV = 50,
}

local function GetMouseViewportPos()
    local loc = UserInputService:GetMouseLocation()
    return Vector2.new(loc.X, loc.Y)
end

-- ============================================================
-- WHITELIST (live reference)
-- ============================================================
local Whitelist = {}

if getgenv then
    getgenv()._VYSE_WHITELIST = Whitelist
end

local function GetWhitelist()
    if getgenv and getgenv()._VYSE_WHITELIST then
        return getgenv()._VYSE_WHITELIST
    end
    return Whitelist
end

local function IsWhitelisted(plr)
    if not plr then return false end
    local uname = string.lower(plr.Name)
    return GetWhitelist()[uname] == true
end

-- ============================================================
-- GUI
-- ============================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VYSESAINT_" .. tostring(math.random(100000, 999999))
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

getgenv().VYSESAINT_LOCK = ScreenGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "VYSESAINT"
MainFrame.Size = UDim2.new(0, 360, 0, 600)
MainFrame.Position = UDim2.new(0.5, -180, 0.5, -300)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Theme.Primary
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.2
MainStroke.Parent = MainFrame

local GlowFrame = Instance.new("Frame")
GlowFrame.Size = UDim2.new(1, 12, 1, 12)
GlowFrame.Position = UDim2.new(0, -6, 0, -6)
GlowFrame.BackgroundTransparency = 1
GlowFrame.ZIndex = 0
GlowFrame.Parent = MainFrame

local GlowCorner = Instance.new("UICorner")
GlowCorner.CornerRadius = UDim.new(0, 16)
GlowCorner.Parent = GlowFrame

local GlowStroke = Instance.new("UIStroke")
GlowStroke.Color = Theme.Primary
GlowStroke.Thickness = 3
GlowStroke.Transparency = 0.5
GlowStroke.Parent = GlowFrame

local Scanline = Instance.new("Frame")
Scanline.Size = UDim2.new(1, 0, 0, 2)
Scanline.Position = UDim2.new(0, 0, 0, 0)
Scanline.BackgroundColor3 = Theme.PrimaryGlow
Scanline.BackgroundTransparency = 0.6
Scanline.BorderSizePixel = 0
Scanline.ZIndex = 5
Scanline.Parent = MainFrame

local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 42)
TitleBar.BackgroundColor3 = Theme.Panel
TitleBar.BorderSizePixel = 0
TitleBar.ZIndex = 3
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 14)
TitleCorner.Parent = TitleBar

local TitleLine = Instance.new("Frame")
TitleLine.Size = UDim2.new(1, 0, 0, 1)
TitleLine.Position = UDim2.new(0, 0, 1, -1)
TitleLine.BackgroundColor3 = Theme.Primary
TitleLine.BackgroundTransparency = 0.4
TitleLine.BorderSizePixel = 0
TitleLine.ZIndex = 3
TitleLine.Parent = TitleBar

local LogoHolder = Instance.new("Frame")
LogoHolder.Size = UDim2.new(0, 220, 1, 0)
LogoHolder.Position = UDim2.new(0, 16, 0, 0)
LogoHolder.BackgroundTransparency = 1
LogoHolder.ZIndex = 4
LogoHolder.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 1, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "VYSESAINT"
TitleLabel.TextColor3 = Theme.Primary
TitleLabel.TextSize = 22
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 4
TitleLabel.Parent = LogoHolder

local TitleGlow = Instance.new("TextLabel")
TitleGlow.Size = UDim2.new(1, 0, 1, 0)
TitleGlow.BackgroundTransparency = 1
TitleGlow.Text = "VYSESAINT"
TitleGlow.TextColor3 = Theme.PrimaryGlow
TitleGlow.TextSize = 22
TitleGlow.Font = Enum.Font.GothamBlack
TitleGlow.TextXAlignment = Enum.TextXAlignment.Left
TitleGlow.TextTransparency = 0.7
TitleGlow.ZIndex = 3
TitleGlow.Parent = LogoHolder

local InfoBtn = Instance.new("TextButton")
InfoBtn.Size = UDim2.new(0, 30, 0, 30)
InfoBtn.Position = UDim2.new(1, -106, 0, 6)
InfoBtn.BackgroundColor3 = Theme.PanelLight
InfoBtn.Text = "?"
InfoBtn.TextColor3 = Theme.Primary
InfoBtn.TextSize = 16
InfoBtn.Font = Enum.Font.GothamBold
InfoBtn.BorderSizePixel = 0
InfoBtn.ZIndex = 5
InfoBtn.AutoButtonColor = false
InfoBtn.Parent = TitleBar

local InfoCorner = Instance.new("UICorner")
InfoCorner.CornerRadius = UDim.new(0, 6)
InfoCorner.Parent = InfoBtn

local InfoStroke = Instance.new("UIStroke")
InfoStroke.Color = Theme.Primary
InfoStroke.Thickness = 1
InfoStroke.Transparency = 0.4
InfoStroke.Parent = InfoBtn

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -72, 0, 6)
MinimizeBtn.BackgroundColor3 = Theme.PanelLight
MinimizeBtn.Text = "—"
MinimizeBtn.TextColor3 = Theme.Warning
MinimizeBtn.TextSize = 18
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.ZIndex = 5
MinimizeBtn.AutoButtonColor = false
MinimizeBtn.Parent = TitleBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinimizeBtn

local MinStroke = Instance.new("UIStroke")
MinStroke.Color = Theme.Warning
MinStroke.Thickness = 1
MinStroke.Transparency = 0.5
MinStroke.Parent = MinimizeBtn

local ExitBtn = Instance.new("TextButton")
ExitBtn.Size = UDim2.new(0, 30, 0, 30)
ExitBtn.Position = UDim2.new(1, -38, 0, 6)
ExitBtn.BackgroundColor3 = Theme.PanelLight
ExitBtn.Text = "X"
ExitBtn.TextColor3 = Theme.Danger
ExitBtn.TextSize = 16
ExitBtn.Font = Enum.Font.GothamBold
ExitBtn.BorderSizePixel = 0
ExitBtn.ZIndex = 5
ExitBtn.AutoButtonColor = false
ExitBtn.Parent = TitleBar

local ExitCorner = Instance.new("UICorner")
ExitCorner.CornerRadius = UDim.new(0, 6)
ExitCorner.Parent = ExitBtn

local ExitStroke = Instance.new("UIStroke")
ExitStroke.Color = Theme.Danger
ExitStroke.Thickness = 1
ExitStroke.Transparency = 0.4
ExitStroke.Parent = ExitBtn

local function AddHover(btn, normalColor, hoverColor, stroke)
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = hoverColor}):Play()
        if stroke then TweenService:Create(stroke, TweenInfo.new(0.2), {Transparency = 0}):Play() end
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = normalColor}):Play()
        if stroke then TweenService:Create(stroke, TweenInfo.new(0.2), {Transparency = 0.4}):Play() end
    end)
end

AddHover(InfoBtn, Theme.PanelLight, Color3.fromRGB(45, 10, 20), InfoStroke)
AddHover(MinimizeBtn, Theme.PanelLight, Color3.fromRGB(45, 20, 10), MinStroke)
AddHover(ExitBtn, Theme.PanelLight, Color3.fromRGB(60, 5, 15), ExitStroke)

-- ============================================================
-- INFO POPUP
-- ============================================================
local InfoGui = Instance.new("Frame")
InfoGui.Size = UDim2.new(0, 0, 0, 0)
InfoGui.Position = UDim2.new(0.5, -260, 0.5, -260)
InfoGui.BackgroundColor3 = Theme.Background
InfoGui.BorderSizePixel = 0
InfoGui.Visible = false
InfoGui.ZIndex = 100
InfoGui.Parent = ScreenGui

local InfoGuiCorner = Instance.new("UICorner")
InfoGuiCorner.CornerRadius = UDim.new(0, 14)
InfoGuiCorner.Parent = InfoGui

local InfoGuiStroke = Instance.new("UIStroke")
InfoGuiStroke.Color = Theme.Primary
InfoGuiStroke.Thickness = 2
InfoGuiStroke.Parent = InfoGui

local InfoTitle = Instance.new("TextLabel")
InfoTitle.Size = UDim2.new(1, -60, 0, 40)
InfoTitle.Position = UDim2.new(0, 20, 0, 12)
InfoTitle.BackgroundTransparency = 1
InfoTitle.Text = "VYSESAINT — GUIDE"
InfoTitle.TextColor3 = Theme.Primary
InfoTitle.TextSize = 18
InfoTitle.Font = Enum.Font.GothamBlack
InfoTitle.TextXAlignment = Enum.TextXAlignment.Left
InfoTitle.ZIndex = 101
InfoTitle.Parent = InfoGui

local InfoClose = Instance.new("TextButton")
InfoClose.Size = UDim2.new(0, 30, 0, 30)
InfoClose.Position = UDim2.new(1, -40, 0, 12)
InfoClose.BackgroundColor3 = Theme.PanelLight
InfoClose.Text = "X"
InfoClose.TextColor3 = Theme.Danger
InfoClose.TextSize = 16
InfoClose.Font = Enum.Font.GothamBold
InfoClose.BorderSizePixel = 0
InfoClose.ZIndex = 102
InfoClose.AutoButtonColor = false
InfoClose.Parent = InfoGui

local InfoCloseCorner = Instance.new("UICorner")
InfoCloseCorner.CornerRadius = UDim.new(0, 6)
InfoCloseCorner.Parent = InfoClose

local InfoScroll = Instance.new("ScrollingFrame")
InfoScroll.Size = UDim2.new(1, -30, 1, -70)
InfoScroll.Position = UDim2.new(0, 15, 0, 58)
InfoScroll.BackgroundTransparency = 1
InfoScroll.BorderSizePixel = 0
InfoScroll.ScrollBarThickness = 3
InfoScroll.ScrollBarImageColor3 = Theme.Primary
InfoScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
InfoScroll.ZIndex = 101
InfoScroll.Parent = InfoGui

local InfoLayout = Instance.new("UIListLayout")
InfoLayout.Padding = UDim.new(0, 10)
InfoLayout.SortOrder = Enum.SortOrder.LayoutOrder
InfoLayout.Parent = InfoScroll

local InfoPad = Instance.new("UIPadding")
InfoPad.PaddingTop = UDim.new(0, 4)
InfoPad.PaddingBottom = UDim.new(0, 4)
InfoPad.Parent = InfoScroll

local function AddInfoSection(header, body)
    local H = Instance.new("TextLabel")
    H.Size = UDim2.new(1, -8, 0, 22)
    H.BackgroundTransparency = 1
    H.Text = header
    H.TextColor3 = Theme.Primary
    H.TextSize = 14
    H.Font = Enum.Font.GothamBold
    H.TextXAlignment = Enum.TextXAlignment.Left
    H.ZIndex = 101
    H.Parent = InfoScroll

    local B = Instance.new("TextLabel")
    B.Size = UDim2.new(1, -8, 0, 0)
    B.AutomaticSize = Enum.AutomaticSize.Y
    B.BackgroundColor3 = Theme.Panel
    B.Text = body
    B.TextColor3 = Theme.Text
    B.TextSize = 12
    B.Font = Enum.Font.Gotham
    B.TextWrapped = true
    B.TextXAlignment = Enum.TextXAlignment.Left
    B.TextYAlignment = Enum.TextYAlignment.Top
    B.ZIndex = 101
    B.Parent = InfoScroll

    local BP = Instance.new("UIPadding")
    BP.PaddingTop = UDim.new(0, 8)
    BP.PaddingBottom = UDim.new(0, 8)
    BP.PaddingLeft = UDim.new(0, 10)
    BP.PaddingRight = UDim.new(0, 10)
    BP.Parent = B

    local BC = Instance.new("UICorner")
    BC.CornerRadius = UDim.new(0, 8)
    BC.Parent = B

    local BS = Instance.new("UIStroke")
    BS.Color = Theme.Primary
    BS.Thickness = 1
    BS.Transparency = 0.7
    BS.Parent = B
end

AddInfoSection("🎯 HOW TO HIDE THE MENU",
    "• Press [RIGHT SHIFT] to toggle the whole menu.\n" ..
    "• Press [END] to panic and force-close everything.\n" ..
    "• The [X] button closes the menu.\n" ..
    "• The [—] button minimizes the menu."
)

AddInfoSection("👥 WHITELIST — TEAMMATE PICK",
    "• Check the box next to a player to whitelist them.\n" ..
    "• Check = applied instantly. Uncheck = removed instantly. No apply button.\n" ..
    "• Search by display name or username.\n" ..
    "• Click [CLEAR ALL] at the top to remove everyone — a confirmation popup will appear.\n" ..
    "• Whitelisted players won't show on ESP and won't be targeted by silent aim.\n" ..
    "• Only 4 players are visible at a time — scroll to see the rest."
)

AddInfoSection("⚙️ WHAT EACH FEATURE DOES",
    "• ESP ENABLED — master switch for all visuals.\n" ..
    "• ESP BOX — draws a box around enemies.\n" ..
    "• ESP LINE — tracer from center of screen.\n" ..
    "• SILENT ENABLED — master switch for the silent aim hook.\n" ..
    "• TARGET PART — Head or HumanoidRootPart.\n" ..
    "• SAFE SILENT AIM — random chance between Head and body.\n" ..
    "• WALL CHECK — won't aim through walls.\n" ..
    "• FOV SIZE — size of the aim circle."
)

InfoLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    InfoScroll.CanvasSize = UDim2.new(0, 0, 0, InfoLayout.AbsoluteContentSize.Y + 12)
end)

local infoOpen = false
InfoBtn.MouseButton1Click:Connect(function()
    infoOpen = not infoOpen
    if infoOpen then
        InfoGui.Visible = true
        InfoGui.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(InfoGui, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 520, 0, 520)
        }):Play()
    else
        TweenService:Create(InfoGui, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0)
        }):Play()
        task.wait(0.26)
        InfoGui.Visible = false
    end
end)

InfoClose.MouseButton1Click:Connect(function()
    infoOpen = false
    TweenService:Create(InfoGui, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0)
    }):Play()
    task.wait(0.26)
    InfoGui.Visible = false
end)

-- ============================================================
-- CONTENT
-- ============================================================
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Name = "Content"
ScrollFrame.Size = UDim2.new(1, -20, 1, -58)
ScrollFrame.Position = UDim2.new(0, 10, 0, 50)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 3
ScrollFrame.ScrollBarImageColor3 = Theme.Primary
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.ZIndex = 3
ScrollFrame.Parent = MainFrame

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Padding = UDim.new(0, 7)
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentLayout.Parent = ScrollFrame

local ContentPadding = Instance.new("UIPadding")
ContentPadding.PaddingTop = UDim.new(0, 6)
ContentPadding.PaddingBottom = UDim.new(0, 6)
ContentPadding.Parent = ScrollFrame

local function CreateSectionLabel(text)
    local Holder = Instance.new("Frame")
    Holder.Size = UDim2.new(1, -6, 0, 26)
    Holder.BackgroundTransparency = 1
    Holder.Parent = ScrollFrame
    local Bar = Instance.new("Frame")
    Bar.Size = UDim2.new(0, 3, 0, 16)
    Bar.Position = UDim2.new(0, 0, 0.5, -8)
    Bar.BackgroundColor3 = Theme.Primary
    Bar.BorderSizePixel = 0
    Bar.Parent = Holder
    local BarGlow = Instance.new("UIStroke")
    BarGlow.Color = Theme.PrimaryGlow
    BarGlow.Thickness = 2
    BarGlow.Transparency = 0.3
    BarGlow.Parent = Bar
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -12, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Theme.Primary
    Label.TextSize = 12
    Label.Font = Enum.Font.GothamBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Holder
    return Holder
end

local function CreateToggle(name, defaultState, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, -6, 0, 34)
    ToggleFrame.BackgroundColor3 = Theme.Panel
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Parent = ScrollFrame
    local TCorner = Instance.new("UICorner")
    TCorner.CornerRadius = UDim.new(0, 8)
    TCorner.Parent = ToggleFrame
    local TStroke = Instance.new("UIStroke")
    TStroke.Color = Theme.Primary
    TStroke.Thickness = 1
    TStroke.Transparency = 0.7
    TStroke.Parent = ToggleFrame
    local Accent = Instance.new("Frame")
    Accent.Size = UDim2.new(0, 2, 1, -10)
    Accent.Position = UDim2.new(0, 0, 0, 5)
    Accent.BackgroundColor3 = Theme.Primary
    Accent.BackgroundTransparency = 0.4
    Accent.BorderSizePixel = 0
    Accent.Parent = ToggleFrame
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0, 14, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Theme.Text
    Label.TextSize = 13
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ToggleFrame
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 56, 0, 22)
    ToggleBtn.Position = UDim2.new(1, -64, 0.5, -11)
    ToggleBtn.BackgroundColor3 = defaultState and Theme.Success or Color3.fromRGB(45, 20, 25)
    ToggleBtn.Text = defaultState and "ON" or "OFF"
    ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBtn.TextSize = 11
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.BorderSizePixel = 0
    ToggleBtn.AutoButtonColor = false
    ToggleBtn.Parent = ToggleFrame
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = ToggleBtn
    local BtnStroke = Instance.new("UIStroke")
    BtnStroke.Color = defaultState and Theme.Success or Theme.Primary
    BtnStroke.Thickness = 1
    BtnStroke.Transparency = defaultState and 0.3 or 0.6
    BtnStroke.Parent = ToggleBtn
    local state = defaultState
    ToggleFrame.MouseEnter:Connect(function()
        TweenService:Create(TStroke, TweenInfo.new(0.2), {Transparency = 0.2, Color = Theme.PrimaryGlow}):Play()
        TweenService:Create(ToggleFrame, TweenInfo.new(0.2), {BackgroundColor3 = Theme.PanelLight}):Play()
    end)
    ToggleFrame.MouseLeave:Connect(function()
        TweenService:Create(TStroke, TweenInfo.new(0.2), {Transparency = 0.7, Color = Theme.Primary}):Play()
        TweenService:Create(ToggleFrame, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Panel}):Play()
    end)
    ToggleBtn.MouseButton1Click:Connect(function()
        state = not state
        local color = state and Theme.Success or Color3.fromRGB(45, 20, 25)
        local strokeColor = state and Theme.Success or Theme.Primary
        TweenService:Create(ToggleBtn, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {BackgroundColor3 = color}):Play()
        TweenService:Create(BtnStroke, TweenInfo.new(0.25), {Color = strokeColor, Transparency = state and 0.3 or 0.6}):Play()
        ToggleBtn.Text = state and "ON" or "OFF"
        ToggleBtn.BackgroundTransparency = 0.5
        TweenService:Create(ToggleBtn, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
        if callback then callback(state) end
    end)
    return ToggleFrame
end

local function CreateEditableSlider(name, min, max, default, suffix, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, -6, 0, 50)
    SliderFrame.BackgroundColor3 = Theme.Panel
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Parent = ScrollFrame
    local SCorner = Instance.new("UICorner")
    SCorner.CornerRadius = UDim.new(0, 8)
    SCorner.Parent = SliderFrame
    local SStroke = Instance.new("UIStroke")
    SStroke.Color = Theme.Primary
    SStroke.Thickness = 1
    SStroke.Transparency = 0.7
    SStroke.Parent = SliderFrame
    local Accent = Instance.new("Frame")
    Accent.Size = UDim2.new(0, 2, 1, -10)
    Accent.Position = UDim2.new(0, 0, 0, 5)
    Accent.BackgroundColor3 = Theme.Primary
    Accent.BackgroundTransparency = 0.4
    Accent.BorderSizePixel = 0
    Accent.Parent = SliderFrame
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.6, 0, 0, 22)
    Label.Position = UDim2.new(0, 14, 0, 5)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Theme.Text
    Label.TextSize = 13
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = SliderFrame
    local ValueBox = Instance.new("TextBox")
    ValueBox.Size = UDim2.new(0, 70, 0, 22)
    ValueBox.Position = UDim2.new(1, -80, 0, 5)
    ValueBox.BackgroundColor3 = Theme.PanelLight
    ValueBox.Text = tostring(default) .. suffix
    ValueBox.TextColor3 = Theme.Primary
    ValueBox.TextSize = 12
    ValueBox.Font = Enum.Font.GothamBold
    ValueBox.BorderSizePixel = 0
    ValueBox.ClearTextOnFocus = false
    ValueBox.Parent = SliderFrame
    local VB_corner = Instance.new("UICorner")
    VB_corner.CornerRadius = UDim.new(0, 5)
    VB_corner.Parent = ValueBox
    local VB_stroke = Instance.new("UIStroke")
    VB_stroke.Color = Theme.Primary
    VB_stroke.Thickness = 1
    VB_stroke.Transparency = 0.5
    VB_stroke.Parent = ValueBox
    local BarBg = Instance.new("Frame")
    BarBg.Size = UDim2.new(1, -28, 0, 6)
    BarBg.Position = UDim2.new(0, 14, 0, 34)
    BarBg.BackgroundColor3 = Color3.fromRGB(40, 10, 15)
    BarBg.BorderSizePixel = 0
    BarBg.Parent = SliderFrame
    local BarBgCorner = Instance.new("UICorner")
    BarBgCorner.CornerRadius = UDim.new(1, 0)
    BarBgCorner.Parent = BarBg
    local BarFill = Instance.new("Frame")
    BarFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    BarFill.BackgroundColor3 = Theme.Primary
    BarFill.BorderSizePixel = 0
    BarFill.Parent = BarBg
    local BarFillCorner = Instance.new("UICorner")
    BarFillCorner.CornerRadius = UDim.new(1, 0)
    BarFillCorner.Parent = BarFill
    local BarGlow = Instance.new("UIStroke")
    BarGlow.Color = Theme.PrimaryGlow
    BarGlow.Thickness = 2
    BarGlow.Transparency = 0.3
    BarGlow.Parent = BarFill
    SliderFrame.MouseEnter:Connect(function()
        TweenService:Create(SStroke, TweenInfo.new(0.2), {Transparency = 0.2, Color = Theme.PrimaryGlow}):Play()
        TweenService:Create(SliderFrame, TweenInfo.new(0.2), {BackgroundColor3 = Theme.PanelLight}):Play()
    end)
    SliderFrame.MouseLeave:Connect(function()
        TweenService:Create(SStroke, TweenInfo.new(0.2), {Transparency = 0.7, Color = Theme.Primary}):Play()
        TweenService:Create(SliderFrame, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Panel}):Play()
    end)
    local dragging = false
    local function setValue(value)
        value = math.clamp(math.floor(tonumber(value) or default), min, max)
        local relative = (value - min) / (max - min)
        TweenService:Create(BarFill, TweenInfo.new(0.1), {Size = UDim2.new(relative, 0, 1, 0)}):Play()
        ValueBox.Text = tostring(value) .. suffix
        if callback then callback(value) end
    end
    BarBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            local mouseX = input.Position.X
            local barAbsPos = BarBg.AbsolutePosition.X
            local barAbsSize = BarBg.AbsoluteSize.X
            local relative = math.clamp((mouseX - barAbsPos) / barAbsSize, 0, 1)
            setValue(min + (max - min) * relative)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mouseX = input.Position.X
            local barAbsPos = BarBg.AbsolutePosition.X
            local barAbsSize = BarBg.AbsoluteSize.X
            local relative = math.clamp((mouseX - barAbsPos) / barAbsSize, 0, 1)
            setValue(min + (max - min) * relative)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    ValueBox.FocusLost:Connect(function()
        local raw = ValueBox.Text:gsub("%%", ""):gsub("%s", "")
        setValue(raw)
    end)
    return SliderFrame
end

local function CreateDropdown(name, options, default, callback)
    local DropFrame = Instance.new("Frame")
    DropFrame.Size = UDim2.new(1, -6, 0, 34)
    DropFrame.BackgroundColor3 = Theme.Panel
    DropFrame.BorderSizePixel = 0
    DropFrame.Parent = ScrollFrame
    local DCorner = Instance.new("UICorner")
    DCorner.CornerRadius = UDim.new(0, 8)
    DCorner.Parent = DropFrame
    local DStroke = Instance.new("UIStroke")
    DStroke.Color = Theme.Primary
    DStroke.Thickness = 1
    DStroke.Transparency = 0.7
    DStroke.Parent = DropFrame
    local Accent = Instance.new("Frame")
    Accent.Size = UDim2.new(0, 2, 1, -10)
    Accent.Position = UDim2.new(0, 0, 0, 5)
    Accent.BackgroundColor3 = Theme.Primary
    Accent.BackgroundTransparency = 0.4
    Accent.BorderSizePixel = 0
    Accent.Parent = DropFrame
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.5, 0, 1, 0)
    Label.Position = UDim2.new(0, 14, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Theme.Text
    Label.TextSize = 13
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = DropFrame
    local ValueBtn = Instance.new("TextButton")
    ValueBtn.Size = UDim2.new(0, 150, 0, 22)
    ValueBtn.Position = UDim2.new(1, -160, 0.5, -11)
    ValueBtn.BackgroundColor3 = Theme.PanelLight
    ValueBtn.Text = default
    ValueBtn.TextColor3 = Theme.Primary
    ValueBtn.TextSize = 11
    ValueBtn.Font = Enum.Font.GothamBold
    ValueBtn.BorderSizePixel = 0
    ValueBtn.AutoButtonColor = false
    ValueBtn.Parent = DropFrame
    local VCorner = Instance.new("UICorner")
    VCorner.CornerRadius = UDim.new(0, 5)
    VCorner.Parent = ValueBtn
    local VStroke = Instance.new("UIStroke")
    VStroke.Color = Theme.Primary
    VStroke.Thickness = 1
    VStroke.Transparency = 0.5
    VStroke.Parent = ValueBtn
    DropFrame.MouseEnter:Connect(function()
        TweenService:Create(DStroke, TweenInfo.new(0.2), {Transparency = 0.2, Color = Theme.PrimaryGlow}):Play()
        TweenService:Create(DropFrame, TweenInfo.new(0.2), {BackgroundColor3 = Theme.PanelLight}):Play()
    end)
    DropFrame.MouseLeave:Connect(function()
        TweenService:Create(DStroke, TweenInfo.new(0.2), {Transparency = 0.7, Color = Theme.Primary}):Play()
        TweenService:Create(DropFrame, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Panel}):Play()
    end)
    local currentIndex = 1
    for i, opt in ipairs(options) do
        if opt == default then currentIndex = i break end
    end
    ValueBtn.MouseButton1Click:Connect(function()
        currentIndex = currentIndex + 1
        if currentIndex > #options then currentIndex = 1 end
        ValueBtn.Text = options[currentIndex]
        ValueBtn.BackgroundTransparency = 0.5
        TweenService:Create(ValueBtn, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
        if callback then callback(options[currentIndex]) end
    end)
    return DropFrame, ValueBtn
end

-- ============================================================
-- BUILD MENU
-- ============================================================
CreateSectionLabel("ESP")
CreateToggle("ESP Enabled", Config.ESPEnabled, function(s) Config.ESPEnabled = s end)
CreateToggle("ESP Box", Config.ESPBox, function(s) Config.ESPBox = s end)
CreateToggle("ESP Line", Config.ESPLine, function(s) Config.ESPLine = s end)

CreateSectionLabel("SILENT AIM")
CreateToggle("Silent Enabled", Config.SilentAimEnabled, function(s) Config.SilentAimEnabled = s end)

local TargetPartFrame, TargetPartBtn = CreateDropdown("Target Part", {"Head", "HumanoidRootPart"}, Config.SilentTargetPart, function(v) Config.SilentTargetPart = v end)

local SafeSilentFrame = CreateToggle("Safe Silent Aim", Config.SafeSilentAim, function(s)
    Config.SafeSilentAim = s
    if s then
        TargetPartBtn.BackgroundColor3 = Color3.fromRGB(20, 5, 10)
        TargetPartBtn.TextColor3 = Theme.TextDim
        TargetPartBtn.AutoButtonColor = false
        TargetPartBtn.Active = false
    else
        TargetPartBtn.BackgroundColor3 = Theme.PanelLight
        TargetPartBtn.TextColor3 = Theme.Primary
        TargetPartBtn.AutoButtonColor = true
        TargetPartBtn.Active = true
    end
end)

CreateEditableSlider("Safe Silent Chance", 1, 100, Config.SafeSilentChance, "%", function(v) Config.SafeSilentChance = v end)

CreateToggle("Wall Check", Config.SilentWallCheck, function(s) Config.SilentWallCheck = s end)

CreateSectionLabel("FOV ALWAYS ON")
CreateEditableSlider("FOV Size", 10, 500, Config.FOV, "", function(v) Config.FOV = v end)

-- ============================================================
-- WHITELIST SECTION — TEAMMATE PICK
-- ============================================================
CreateSectionLabel("WHITELIST — TEAMMATE PICK")

local HeaderRow = Instance.new("Frame")
HeaderRow.Size = UDim2.new(1, -6, 0, 26)
HeaderRow.BackgroundTransparency = 1
HeaderRow.Parent = ScrollFrame

local WlCountLabel = Instance.new("TextLabel")
WlCountLabel.Size = UDim2.new(0, 90, 1, 0)
WlCountLabel.Position = UDim2.new(1, -188, 0, 0)
WlCountLabel.BackgroundTransparency = 1
WlCountLabel.Text = "Teammates: 0"
WlCountLabel.TextColor3 = Theme.TextDim
WlCountLabel.TextSize = 11
WlCountLabel.Font = Enum.Font.Gotham
WlCountLabel.TextXAlignment = Enum.TextXAlignment.Right
WlCountLabel.Parent = HeaderRow

local ClearAllBtn = Instance.new("TextButton")
ClearAllBtn.Size = UDim2.new(0, 90, 1, 0)
ClearAllBtn.Position = UDim2.new(1, -90, 0, 0)
ClearAllBtn.BackgroundColor3 = Theme.PanelLight
ClearAllBtn.Text = "✕ CLEAR ALL"
ClearAllBtn.TextColor3 = Theme.Danger
ClearAllBtn.TextSize = 11
ClearAllBtn.Font = Enum.Font.GothamBold
ClearAllBtn.BorderSizePixel = 0
ClearAllBtn.AutoButtonColor = false
ClearAllBtn.Parent = HeaderRow

local CABCorner = Instance.new("UICorner")
CABCorner.CornerRadius = UDim.new(0, 6)
CABCorner.Parent = ClearAllBtn

local CABStroke = Instance.new("UIStroke")
CABStroke.Color = Theme.Danger
CABStroke.Thickness = 1
CABStroke.Transparency = 0.4
CABStroke.Parent = ClearAllBtn

ClearAllBtn.MouseEnter:Connect(function()
    TweenService:Create(CABStroke, TweenInfo.new(0.15), {Transparency = 0}):Play()
    TweenService:Create(ClearAllBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(60, 5, 15)}):Play()
end)
ClearAllBtn.MouseLeave:Connect(function()
    TweenService:Create(CABStroke, TweenInfo.new(0.15), {Transparency = 0.4}):Play()
    TweenService:Create(ClearAllBtn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.PanelLight}):Play()
end)
ClearAllBtn.MouseButton1Down:Connect(function()
    TweenService:Create(ClearAllBtn, TweenInfo.new(0.08), {BackgroundColor3 = Color3.fromRGB(90, 5, 20)}):Play()
end)
ClearAllBtn.MouseButton1Up:Connect(function()
    TweenService:Create(ClearAllBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(60, 5, 15)}):Play()
end)

local SearchRow = Instance.new("Frame")
SearchRow.Size = UDim2.new(1, -6, 0, 32)
SearchRow.BackgroundTransparency = 1
SearchRow.Parent = ScrollFrame

local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1, 0, 1, 0)
SearchBox.BackgroundColor3 = Theme.Panel
SearchBox.TextColor3 = Theme.Text
SearchBox.TextSize = 12
SearchBox.Font = Enum.Font.Gotham
SearchBox.BorderSizePixel = 0
SearchBox.ClearTextOnFocus = false
SearchBox.PlaceholderText = "🔎 Search display name or username..."
SearchBox.Text = ""
SearchBox.Parent = SearchRow

local SearchCorner = Instance.new("UICorner")
SearchCorner.CornerRadius = UDim.new(0, 8)
SearchCorner.Parent = SearchBox

local SearchStroke = Instance.new("UIStroke")
SearchStroke.Color = Theme.Primary
SearchStroke.Thickness = 1
SearchStroke.Transparency = 0.7
SearchStroke.Parent = SearchBox

local SearchPad = Instance.new("UIPadding")
SearchPad.PaddingLeft = UDim.new(0, 10)
SearchPad.PaddingRight = UDim.new(0, 10)
SearchPad.Parent = SearchBox

local PlayerListHolder = Instance.new("Frame")
PlayerListHolder.Size = UDim2.new(1, -6, 0, 180)
PlayerListHolder.BackgroundColor3 = Theme.Panel
PlayerListHolder.BorderSizePixel = 0
PlayerListHolder.ClipsDescendants = true
PlayerListHolder.Parent = ScrollFrame

local PLHCorner = Instance.new("UICorner")
PLHCorner.CornerRadius = UDim.new(0, 8)
PLHCorner.Parent = PlayerListHolder

local PLHStroke = Instance.new("UIStroke")
PLHStroke.Color = Theme.Primary
PLHStroke.Thickness = 1
PLHStroke.Transparency = 0.7
PLHStroke.Parent = PlayerListHolder

local PlayerListScroll = Instance.new("ScrollingFrame")
PlayerListScroll.Size = UDim2.new(1, 0, 1, 0)
PlayerListScroll.BackgroundTransparency = 1
PlayerListScroll.BorderSizePixel = 0
PlayerListScroll.ScrollBarThickness = 3
PlayerListScroll.ScrollBarImageColor3 = Theme.Primary
PlayerListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerListScroll.ScrollingDirection = Enum.ScrollingDirection.Y
PlayerListScroll.Parent = PlayerListHolder

local PlayerListLayout = Instance.new("UIListLayout")
PlayerListLayout.Padding = UDim.new(0, 4)
PlayerListLayout.SortOrder = Enum.SortOrder.LayoutOrder
PlayerListLayout.Parent = PlayerListScroll

local PlayerListPad = Instance.new("UIPadding")
PlayerListPad.PaddingTop = UDim.new(0, 6)
PlayerListPad.PaddingBottom = UDim.new(0, 6)
PlayerListPad.PaddingLeft = UDim.new(0, 6)
PlayerListPad.PaddingRight = UDim.new(0, 6)
PlayerListPad.Parent = PlayerListScroll

PlayerListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    PlayerListScroll.CanvasSize = UDim2.new(0, 0, 0, PlayerListLayout.AbsoluteContentSize.Y + 12)
end)

local PlayerRows = {}

local function CreatePlayerRow(player)
    local uname = player.Name
    local unameLower = string.lower(uname)
    local dname = player.DisplayName or uname

    local Row = Instance.new("TextButton")
    Row.Name = uname
    Row.Size = UDim2.new(1, -4, 0, 38)
    Row.BackgroundColor3 = Theme.PanelLight
    Row.Text = ""
    Row.BorderSizePixel = 0
    Row.AutoButtonColor = false
    Row.Parent = PlayerListScroll

    local RowCorner = Instance.new("UICorner")
    RowCorner.CornerRadius = UDim.new(0, 6)
    RowCorner.Parent = Row

    local RowStroke = Instance.new("UIStroke")
    RowStroke.Color = Theme.Primary
    RowStroke.Thickness = 1
    RowStroke.Transparency = 0.7
    RowStroke.Parent = Row

    local CheckBox = Instance.new("Frame")
    CheckBox.Size = UDim2.new(0, 20, 0, 20)
    CheckBox.Position = UDim2.new(0, 6, 0.5, -10)
    CheckBox.BackgroundColor3 = GetWhitelist()[unameLower] and Theme.Success or Color3.fromRGB(45, 20, 25)
    CheckBox.BorderSizePixel = 0
    CheckBox.Parent = Row

    local CheckCorner = Instance.new("UICorner")
    CheckCorner.CornerRadius = UDim.new(0, 4)
    CheckCorner.Parent = CheckBox

    local CheckStroke = Instance.new("UIStroke")
    CheckStroke.Color = GetWhitelist()[unameLower] and Theme.Success or Theme.Primary
    CheckStroke.Thickness = 1
    CheckStroke.Transparency = GetWhitelist()[unameLower] and 0.2 or 0.5
    CheckStroke.Parent = CheckBox

    local CheckMark = Instance.new("TextLabel")
    CheckMark.Size = UDim2.new(1, 0, 1, 0)
    CheckMark.BackgroundTransparency = 1
    CheckMark.Text = GetWhitelist()[unameLower] and "✔" or ""
    CheckMark.TextColor3 = Color3.fromRGB(255, 255, 255)
    CheckMark.TextSize = 13
    CheckMark.Font = Enum.Font.GothamBold
    CheckMark.Parent = CheckBox

    local DisplayLabel = Instance.new("TextLabel")
    DisplayLabel.Size = UDim2.new(1, -40, 0, 18)
    DisplayLabel.Position = UDim2.new(0, 32, 0, 3)
    DisplayLabel.BackgroundTransparency = 1
    DisplayLabel.Text = dname
    DisplayLabel.TextColor3 = Theme.Text
    DisplayLabel.TextSize = 13
    DisplayLabel.Font = Enum.Font.GothamBold
    DisplayLabel.TextXAlignment = Enum.TextXAlignment.Left
    DisplayLabel.Parent = Row

    local UsernameLabel = Instance.new("TextLabel")
    UsernameLabel.Size = UDim2.new(1, -40, 0, 14)
    UsernameLabel.Position = UDim2.new(0, 32, 0, 20)
    UsernameLabel.BackgroundTransparency = 1
    UsernameLabel.Text = "@" .. uname
    UsernameLabel.TextColor3 = Theme.TextDim
    UsernameLabel.TextSize = 10
    UsernameLabel.Font = Enum.Font.Gotham
    UsernameLabel.TextXAlignment = Enum.TextXAlignment.Left
    UsernameLabel.Parent = Row

    local state = { checked = GetWhitelist()[unameLower] == true, row = Row, check = CheckBox, checkStroke = CheckStroke, checkMark = CheckMark, uname = unameLower }

    Row.MouseEnter:Connect(function()
        TweenService:Create(RowStroke, TweenInfo.new(0.15), {Transparency = 0.2, Color = Theme.PrimaryGlow}):Play()
        TweenService:Create(Row, TweenInfo.new(0.15), {BackgroundColor3 = Theme.Panel}):Play()
    end)
    Row.MouseLeave:Connect(function()
        TweenService:Create(RowStroke, TweenInfo.new(0.15), {Transparency = 0.7, Color = Theme.Primary}):Play()
        TweenService:Create(Row, TweenInfo.new(0.15), {BackgroundColor3 = Theme.PanelLight}):Play()
    end)

    Row.MouseButton1Click:Connect(function()
        state.checked = not state.checked
        CheckBox.BackgroundColor3 = state.checked and Theme.Success or Color3.fromRGB(45, 20, 25)
        CheckStroke.Color = state.checked and Theme.Success or Theme.Primary
        CheckStroke.Transparency = state.checked and 0.2 or 0.5
        CheckMark.Text = state.checked and "✔" or ""
        CheckBox.BackgroundTransparency = 0.4
        TweenService:Create(CheckBox, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
        local wl = GetWhitelist()
        if state.checked then
            wl[state.uname] = true
        else
            wl[state.uname] = nil
        end
    end)

    PlayerRows[unameLower] = state
    return Row
end

local function RefreshPlayerList()
    for _, state in pairs(PlayerRows) do
        pcall(function() state.row:Destroy() end)
    end
    PlayerRows = {}

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            CreatePlayerRow(plr)
        end
    end
end

local function ApplySearchFilter()
    local query = string.lower(SearchBox.Text or "")
    for unameLower, state in pairs(PlayerRows) do
        local dname = ""
        for _, child in ipairs(state.row:GetChildren()) do
            if child:IsA("TextLabel") and child.Font == Enum.Font.GothamBold then
                dname = string.lower(child.Text)
                break
            end
        end
        if query == "" or string.find(unameLower, query, 1, true) or string.find(dname, query, 1, true) then
            state.row.Visible = true
        else
            state.row.Visible = false
        end
    end
end

SearchBox:GetPropertyChangedSignal("Text"):Connect(ApplySearchFilter)

-- confirm popup for clear all
local ConfirmGui = Instance.new("Frame")
ConfirmGui.Size = UDim2.new(0, 0, 0, 0)
ConfirmGui.Position = UDim2.new(0.5, -140, 0.5, -75)
ConfirmGui.BackgroundColor3 = Theme.Background
ConfirmGui.BorderSizePixel = 0
ConfirmGui.Visible = false
ConfirmGui.ZIndex = 200
ConfirmGui.Parent = ScreenGui

local ConfirmCorner = Instance.new("UICorner")
ConfirmCorner.CornerRadius = UDim.new(0, 12)
ConfirmCorner.Parent = ConfirmGui

local ConfirmStroke = Instance.new("UIStroke")
ConfirmStroke.Color = Theme.Danger
ConfirmStroke.Thickness = 2
ConfirmStroke.Parent = ConfirmGui

local ConfirmTitle = Instance.new("TextLabel")
ConfirmTitle.Size = UDim2.new(1, -24, 0, 28)
ConfirmTitle.Position = UDim2.new(0, 12, 0, 12)
ConfirmTitle.BackgroundTransparency = 1
ConfirmTitle.Text = "CLEAR ALL TEAMMATES?"
ConfirmTitle.TextColor3 = Theme.Danger
ConfirmTitle.TextSize = 14
ConfirmTitle.Font = Enum.Font.GothamBold
ConfirmTitle.TextXAlignment = Enum.TextXAlignment.Left
ConfirmTitle.ZIndex = 201
ConfirmTitle.Parent = ConfirmGui

local ConfirmMsg = Instance.new("TextLabel")
ConfirmMsg.Size = UDim2.new(1, -24, 0, 40)
ConfirmMsg.Position = UDim2.new(0, 12, 0, 42)
ConfirmMsg.BackgroundTransparency = 1
ConfirmMsg.Text = "This will remove all whitelisted teammates. Are you sure?"
ConfirmMsg.TextColor3 = Theme.Text
ConfirmMsg.TextSize = 12
ConfirmMsg.Font = Enum.Font.Gotham
ConfirmMsg.TextWrapped = true
ConfirmMsg.TextXAlignment = Enum.TextXAlignment.Left
ConfirmMsg.TextYAlignment = Enum.TextYAlignment.Top
ConfirmMsg.ZIndex = 201
ConfirmMsg.Parent = ConfirmGui

local ConfirmYes = Instance.new("TextButton")
ConfirmYes.Size = UDim2.new(0, 120, 0, 32)
ConfirmYes.Position = UDim2.new(0, 12, 1, -44)
ConfirmYes.BackgroundColor3 = Theme.Danger
ConfirmYes.Text = "YES, CLEAR"
ConfirmYes.TextColor3 = Color3.fromRGB(255, 255, 255)
ConfirmYes.TextSize = 12
ConfirmYes.Font = Enum.Font.GothamBold
ConfirmYes.BorderSizePixel = 0
ConfirmYes.AutoButtonColor = false
ConfirmYes.ZIndex = 201
ConfirmYes.Parent = ConfirmGui

local CYCorner = Instance.new("UICorner")
CYCorner.CornerRadius = UDim.new(0, 6)
CYCorner.Parent = ConfirmYes

local ConfirmNo = Instance.new("TextButton")
ConfirmNo.Size = UDim2.new(0, 120, 0, 32)
ConfirmNo.Position = UDim2.new(1, -132, 1, -44)
ConfirmNo.BackgroundColor3 = Theme.PanelLight
ConfirmNo.Text = "CANCEL"
ConfirmNo.TextColor3 = Theme.Text
ConfirmNo.TextSize = 12
ConfirmNo.Font = Enum.Font.GothamBold
ConfirmNo.BorderSizePixel = 0
ConfirmNo.AutoButtonColor = false
ConfirmNo.ZIndex = 201
ConfirmNo.Parent = ConfirmGui

local CNCorner = Instance.new("UICorner")
CNCorner.CornerRadius = UDim.new(0, 6)
CNCorner.Parent = ConfirmNo

local CNStroke = Instance.new("UIStroke")
CNStroke.Color = Theme.Primary
CNStroke.Thickness = 1
CNStroke.Transparency = 0.5
CNStroke.Parent = ConfirmNo

local function CloseConfirm()
    TweenService:Create(ConfirmGui, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0)
    }):Play()
    task.wait(0.21)
    ConfirmGui.Visible = false
end

local function OpenConfirm()
    ConfirmGui.Visible = true
    ConfirmGui.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(ConfirmGui, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 280, 0, 150)
    }):Play()
end

ConfirmNo.MouseButton1Click:Connect(CloseConfirm)

ConfirmYes.MouseButton1Click:Connect(function()
    for _, state in pairs(PlayerRows) do
        state.checked = false
        state.check.BackgroundColor3 = Color3.fromRGB(45, 20, 25)
        state.checkStroke.Color = Theme.Primary
        state.checkStroke.Transparency = 0.5
        state.checkMark.Text = ""
    end
    local wl = GetWhitelist()
    for k in pairs(wl) do wl[k] = nil end
    CloseConfirm()
end)

ClearAllBtn.MouseButton1Click:Connect(function()
    local hasAny = false
    for _ in pairs(GetWhitelist()) do hasAny = true break end
    if not hasAny then
        ClearAllBtn.Text = "EMPTY"
        task.wait(1)
        ClearAllBtn.Text = "✕ CLEAR ALL"
        return
    end
    OpenConfirm()
end)

RefreshPlayerList()

task.spawn(function()
    while WlCountLabel.Parent do
        local count = 0
        for _ in pairs(GetWhitelist()) do count = count + 1 end
        WlCountLabel.Text = "Teammates: " .. tostring(count)
        task.wait(0.5)
    end
end)

task.spawn(function()
    while PlayerListScroll.Parent do
        task.wait(1)
        local currentCount = #Players:GetPlayers() - 1
        local cachedCount = 0
        for _ in pairs(PlayerRows) do cachedCount = cachedCount + 1 end
        if currentCount ~= cachedCount then
            RefreshPlayerList()
            ApplySearchFilter()
        end
    end
end)

Players.PlayerAdded:Connect(function(plr)
    if plr ~= LocalPlayer then
        task.wait(0.2)
        RefreshPlayerList()
        ApplySearchFilter()
    end
end)

Players.PlayerRemoving:Connect(function(plr)
    if plr ~= LocalPlayer then
        task.wait(0.2)
        RefreshPlayerList()
        ApplySearchFilter()
    end
end)

ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 12)
end)

-- ============================================================
-- ANIMATIONS
-- ============================================================
MainFrame.Size = UDim2.new(0, 0, 0, 0)
task.spawn(function()
    TweenService:Create(MainFrame, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 360, 0, 600)
    }):Play()
    task.wait(0.5)
    MainFrame.Size = UDim2.new(0, 360, 0, 600)
end)

task.spawn(function()
    while MainFrame.Parent do
        TweenService:Create(GlowStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Transparency = 0.15, Thickness = 4
        }):Play()
        task.wait(1.5)
        TweenService:Create(GlowStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Transparency = 0.6, Thickness = 2
        }):Play()
        task.wait(1.5)
    end
end)

task.spawn(function()
    while MainFrame.Parent do
        Scanline.Position = UDim2.new(0, 0, 0, 0)
        TweenService:Create(Scanline, TweenInfo.new(2.5, Enum.EasingStyle.Linear), {
            Position = UDim2.new(0, 0, 1, -2)
        }):Play()
        task.wait(2.8)
    end
end)

task.spawn(function()
    while MainFrame.Parent do
        TweenService:Create(TitleGlow, TweenInfo.new(1.2, Enum.EasingStyle.Sine), {TextTransparency = 0.4}):Play()
        task.wait(1.2)
        TweenService:Create(TitleGlow, TweenInfo.new(1.2, Enum.EasingStyle.Sine), {TextTransparency = 0.8}):Play()
        task.wait(1.2)
    end
end)

-- ============================================================
-- FOV CIRCLE
-- ============================================================
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = true
FOVCircle.Radius = Config.FOV
FOVCircle.Color = Theme.Primary
FOVCircle.Thickness = 2
FOVCircle.Transparency = 0.8
FOVCircle.Filled = false
FOVCircle.NumSides = 64

-- ============================================================
-- ESP DRAWINGS
-- ============================================================
local ESPCache = {}
local function CreateESP(player)
    if player == LocalPlayer then return end
    if ESPCache[player] then return end
    local drawings = { Box = Drawing.new("Square"), Line = Drawing.new("Line") }
    drawings.Box.Visible = false
    drawings.Box.Thickness = 2
    drawings.Box.Color = Theme.Primary
    drawings.Box.Filled = false
    drawings.Box.Transparency = 1
    drawings.Line.Visible = false
    drawings.Line.Thickness = 1
    drawings.Line.Color = Theme.Primary
    ESPCache[player] = drawings
end
local function RemoveESP(player)
    if ESPCache[player] then
        for _, d in pairs(ESPCache[player]) do d:Remove() end
        ESPCache[player] = nil
    end
end
Players.PlayerAdded:Connect(CreateESP)
Players.PlayerRemoving:Connect(RemoveESP)
for _, p in ipairs(Players:GetPlayers()) do CreateESP(p) end

-- ============================================================
-- HELPERS
-- ============================================================
local function IsVisible(part)
    local origin = Camera.CFrame.Position
    local direction = (part.Position - origin)
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {LocalPlayer.Character, part.Parent}
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.IgnoreWater = true
    return Workspace:Raycast(origin, direction, params) == nil
end

local function GetTargetPosition(plr)
    if not plr or not plr.Character then return nil end
    if Config.SafeSilentAim then
        if math.random(1, 100) <= Config.SafeSilentChance then
            local head = plr.Character:FindFirstChild("Head")
            if head then return head.Position end
        end
        local root = plr.Character:FindFirstChild("HumanoidRootPart")
        if root then return root.Position end
        local head = plr.Character:FindFirstChild("Head")
        if head then return head.Position end
        return nil
    else
        local part = plr.Character:FindFirstChild(Config.SilentTargetPart)
        if not part then part = plr.Character:FindFirstChild("HumanoidRootPart") end
        if not part then part = plr.Character:FindFirstChild("Head") end
        if not part then return nil end
        return part.Position
    end
end

local CachedTarget = nil
local function GetClosestTarget(fovValue, wallCheck)
    local closest, closestDist = nil, math.huge
    local mousePos = GetMouseViewportPos()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer or not plr.Character then continue end
        if IsWhitelisted(plr) then continue end
        local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.Health <= 0 then continue end
        local refPart = plr.Character:FindFirstChild("Head") or plr.Character:FindFirstChild("HumanoidRootPart")
        if not refPart then continue end
        if wallCheck and not IsVisible(refPart) then continue end
        local screenPos, onScreen = Camera:WorldToViewportPoint(refPart.Position)
        if not onScreen then continue end
        local screenDist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
        if screenDist > fovValue then continue end
        if screenDist < closestDist then
            closestDist = screenDist
            closest = plr
        end
    end
    return closest
end

-- ============================================================
-- SILENT AIM — CASTER HOOK
-- ============================================================
local Caster
pcall(function() Caster = require(ReplicatedStorage.ZexisShared.Modules.Caster) end)
local restoreCasterHook = function() end
if Caster then
    for _, key in ipairs({HOOK_KEY, "ShotHookCaster"}) do
        local existing = getgenv and getgenv()[key]
        if existing and existing.Restore then
            pcall(function() existing.Restore() end)
            if getgenv then getgenv()[key] = nil end
        end
    end
    local oldCast = Caster.Cast
    Caster.Cast = function(p1, p2, p3, p4, p5, p6)
        if Config.SilentAimEnabled and CachedTarget then
            local targetPos = GetTargetPosition(CachedTarget)
            if targetPos then p6 = targetPos end
        end
        return oldCast(p1, p2, p3, p4, p5, p6)
    end
    if getgenv then getgenv()[HOOK_KEY] = { Restore = function() Caster.Cast = oldCast end } end
    restoreCasterHook = function()
        pcall(function() Caster.Cast = oldCast end)
        if getgenv then getgenv()[HOOK_KEY] = nil end
    end
end

-- ============================================================
-- RENDER LOOP
-- ============================================================
local RenderConn

local function DrawLoop()
    local mousePos = GetMouseViewportPos()
    FOVCircle.Position = mousePos
    FOVCircle.Radius = Config.FOV
    FOVCircle.Visible = true
    FOVCircle.Color = Theme.Primary

    if Config.SilentAimEnabled then
        CachedTarget = GetClosestTarget(Config.FOV, Config.SilentWallCheck)
    else
        CachedTarget = nil
    end

    for player, drawings in pairs(ESPCache) do
        local shouldDraw = Config.ESPEnabled
            and player ~= LocalPlayer
            and player.Character
            and player.Character:FindFirstChildOfClass("Humanoid")
            and player.Character.Humanoid.Health > 0
            and not IsWhitelisted(player)

        if not shouldDraw then
            drawings.Box.Visible = false
            drawings.Line.Visible = false
            continue
        end

        local char = player.Character
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local head = char:FindFirstChild("Head")
        if not hrp or not head then
            drawings.Box.Visible = false
            drawings.Line.Visible = false
            continue
        end
        local rootPos, rootOn = Camera:WorldToViewportPoint(hrp.Position)
        local headPos, headOn = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
        local legPos, legOn = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
        if not rootOn or not headOn or not legOn then
            drawings.Box.Visible = false
            drawings.Line.Visible = false
            continue
        end
        local boxHeight = math.abs(headPos.Y - legPos.Y)
        local boxWidth = boxHeight * 0.6
        drawings.Box.Visible = Config.ESPBox
        if Config.ESPBox then
            drawings.Box.Size = Vector2.new(boxWidth, boxHeight)
            drawings.Box.Position = Vector2.new(rootPos.X - boxWidth / 2, rootPos.Y - boxHeight / 2)
            drawings.Box.Color = Theme.Primary
        end
        drawings.Line.Visible = Config.ESPLine
        if Config.ESPLine then
            drawings.Line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
            drawings.Line.To = Vector2.new(rootPos.X, rootPos.Y)
            drawings.Line.Color = Theme.Primary
        end
    end
end

RenderConn = RunService.RenderStepped:Connect(DrawLoop)

-- ============================================================
-- CLEANUP
-- ============================================================
local cleanedUp = false
local function PanicCleanup()
    if cleanedUp then return end
    cleanedUp = true

    if RenderConn then
        pcall(function() RenderConn:Disconnect() end)
        RenderConn = nil
    end

    pcall(function()
        if FOVCircle then
            FOVCircle.Visible = false
            FOVCircle:Remove()
            FOVCircle = nil
        end
    end)

    for player, drawings in pairs(ESPCache) do
        for _, d in pairs(drawings) do
            pcall(function()
                d.Visible = false
                d:Remove()
            end)
        end
    end
    ESPCache = {}

    pcall(restoreCasterHook)

    if getgenv then getgenv().VYSESAINT_LOCK = nil end
    pcall(function() ScreenGui:Destroy() end)
end

LocalPlayer.CharacterRemoving:Connect(function() Config.SilentAimEnabled = false end)
LocalPlayer.CharacterAdded:Connect(function() task.wait(0.5); Config.SilentAimEnabled = true end)

-- ============================================================
-- MINIMIZE (instant, no tween)
-- ============================================================
MinimizeBtn.MouseButton1Click:Connect(function()
    if ScrollFrame.Visible then
        ScrollFrame.Visible = false
        MainFrame.Size = UDim2.new(0, 360, 0, 42)
        MinimizeBtn.Text = "+"
    else
        ScrollFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 360, 0, 600)
        MinimizeBtn.Text = "—"
    end
end)

ExitBtn.MouseButton1Click:Connect(function()
    PanicCleanup()
end)

-- ============================================================
-- KEYBINDS
-- ============================================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
    if input.KeyCode == Enum.KeyCode.End then
        PanicCleanup()
    end
end)
