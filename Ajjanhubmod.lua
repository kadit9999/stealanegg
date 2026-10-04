-- =========================================================
--  LANGUAGE SELECTOR + RUNTIME GUI TRANSLATOR (EN -> VI)
--  Hook GUI, dịch realtime mọi TextLabel/TextButton/TextBox
-- =========================================================

local Players     = game:GetService("Players")
local CoreGui     = game:GetService("CoreGui")
local RunService  = game:GetService("RunService")

-- 🔽 SCRIPT ĐÍCH (Luarmor loader)
local SCRIPT_URL  = "https://api.luarmor.net/files/v4/loaders/271f96ca25f29ae395be1c0f9e6f4ead.lua"

-- =========================================================
--  TỪ ĐIỂN DỊCH (EN -> VI)
-- =========================================================
local DICT = {
    -- ==================== TABS / MENUS ====================
    ["Main"]          = "Chính",
    ["Home"]          = "Trang chủ",
    ["Player"]        = "Người chơi",
    ["Players"]       = "Người chơi",
    ["Visuals"]       = "Hình ảnh",
    ["Visual"]        = "Hình ảnh",
    ["Combat"]        = "Chiến đấu",
    ["Misc"]          = "Khác",
    ["Miscellaneous"] = "Khác",
    ["Settings"]      = "Cài đặt",
    ["Setting"]       = "Cài đặt",
    ["Config"]        = "Cấu hình",
    ["Configs"]       = "Cấu hình",
    ["Scripts"]       = "Kịch bản",
    ["Script"]        = "Kịch bản",
    ["Teleport"]      = "Dịch chuyển",
    ["Movement"]      = "Di chuyển",
    ["World"]         = "Thế giới",
    ["Local"]         = "Cục bộ",
    ["Character"]     = "Nhân vật",
    ["Extra"]         = "Bổ sung",
    ["Utility"]       = "Tiện ích",
    ["Utilities"]     = "Tiện ích",
    ["Others"]        = "Khác",
    ["Fun"]           = "Giải trí",
    ["Shop"]          = "Cửa hàng",
    ["Trade"]         = "Giao dịch",

    -- ==================== TABS MỚI ====================
    ["Automation"]    = "Tự động hoá",
    ["Events"]        = "Sự kiện",
    ["Predictor"]     = "Dự đoán",

    -- ==================== ACTIONS / BUTTONS ====================
    ["Toggle"]        = "Bật/Tắt",
    ["Enable"]        = "Bật",
    ["Disable"]       = "Tắt",
    ["Enabled"]       = "Đã bật",
    ["Disabled"]      = "Đã tắt",
    ["On"]            = "Bật",
    ["Off"]           = "Tắt",
    ["Close"]         = "Đóng",
    ["Open"]          = "Mở",
    ["Confirm"]       = "Xác nhận",
    ["Cancel"]        = "Huỷ",
    ["Apply"]         = "Áp dụng",
    ["Reset"]         = "Đặt lại",
    ["Save"]          = "Lưu",
    ["Load"]          = "Tải",
    ["Select"]        = "Chọn",
    ["Copy"]          = "Sao chép",
    ["Execute"]       = "Thực thi",
    ["Start"]         = "Bắt đầu",
    ["Stop"]          = "Dừng",
    ["Refresh"]       = "Làm mới",
    ["Search"]        = "Tìm kiếm",
    ["Filter"]        = "Lọc",
    ["Sort"]          = "Sắp xếp",

    -- ==================== FEATURES ====================
    ["Speed"]         = "Tốc độ",
    ["Jump"]          = "Nhảy",
    ["Fly"]           = "Bay",
    ["Walk Speed"]    = "Tốc độ đi",
    ["Jump Power"]    = "Lực nhảy",
    ["God Mode"]      = "Bất tử",
    ["Infinite"]      = "Vô hạn",
    ["Health"]        = "Máu",
    ["Ammo"]          = "Đạn",
    ["Kill"]          = "Giết",
    ["Kill All"]      = "Giết tất cả",
    ["Aimbot"]        = "Ngắm tự động",
    ["Wallhack"]      = "Xuyên tường",
    ["Auto Farm"]     = "Tự động cày",
    ["Auto"]          = "Tự động",
    ["Farm"]          = "Cày",
    ["Noclip"]        = "Xuyên vật thể",
    ["Anti Ban"]      = "Chống ban",
    ["Anti AFK"]      = "Chống AFK",
    ["Full Bright"]   = "Ánh sáng đầy",
    ["No Fog"]        = "Không sương mù",
    ["FOV"]           = "Tầm nhìn",
    ["Hitbox"]        = "Vùng va chạm",
    ["Invisible"]     = "Tàng hình",
    ["Damage"]        = "Sát thương",
    ["Range"]         = "Phạm vi",
    ["Radius"]        = "Bán kính",
    ["Amount"]        = "Số lượng",
    ["Value"]         = "Giá trị",
    ["Time"]          = "Thời gian",
    ["Delay"]         = "Độ trễ",
    ["Cooldown"]      = "Hồi chiêu",

    -- ==================== STATUS / MESSAGES ====================
    ["Loading"]       = "Đang tải",
    ["Loaded"]        = "Đã tải",
    ["Please wait"]   = "Vui lòng đợi",
    ["Error"]         = "Lỗi",
    ["Success"]       = "Thành công",
    ["Failed"]        = "Thất bại",
    ["Warning"]       = "Cảnh báo",
    ["Notice"]        = "Thông báo",
    ["Language"]      = "Ngôn ngữ",
    ["Vietnamese"]    = "Tiếng Việt",
    ["English"]       = "Tiếng Anh",
    ["Copy Link"]     = "Sao chép liên kết",
    ["Made by"]       = "Được tạo bởi",
    ["Version"]       = "Phiên bản",
    ["Key"]           = "Khoá",
    ["Active"]        = "Kích hoạt",

    -- ==================== RARITY / ĐỘ HIẾM ====================
    ["Common"]        = "Thường",
    ["Uncommon"]      = "Ít gặp",
    ["Rare"]          = "Hiếm",
    ["Epic"]          = "Sử thi",
    ["Legendary"]     = "Huyền thoại",
    ["Mythic"]        = "Thần thoại",
    ["Cosmic"]        = "Vũ trụ",
    ["Secret"]        = "Bí ẩn",
    ["Eternal"]       = "Vĩnh cửu",
    ["Divine"]        = "Thần thánh",
}

-- =========================================================
--  HÀM DỊCH (khớp nguyên câu + khớp cụm có biên từ)
-- =========================================================
local sortedKeys = {}
for k in pairs(DICT) do table.insert(sortedKeys, k) end
table.sort(sortedKeys, function(a, b) return #a > #b end)

local escapePattern = function(s)
    return (s:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1"))
end

local translateText = function(text)
    if type(text) ~= "string" or text == "" then return text end
    if DICT[text] then return DICT[text] end

    local out = text
    for _, en in ipairs(sortedKeys) do
        local vi  = DICT[en]
        local pat = "%f[%w]" .. escapePattern(en) .. "%f[%W]"
        out = out:gsub(pat, vi)
    end
    return out
end

-- =========================================================
--  HOOK 1 OBJECT GUI
-- =========================================================
local translating = false

local function hookObject(obj)
    if not (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")) then
        return
    end

    local function apply()
        if translating then return end
        translating = true
        local ok, cur = pcall(function() return obj.Text end)
        if ok and type(cur) == "string" then
            local new = translateText(cur)
            if new ~= cur then
                pcall(function() obj.Text = new end)
            end
        end
        if obj:IsA("TextBox") then
            local ok2, ph = pcall(function() return obj.PlaceholderText end)
            if ok2 and type(ph) == "string" and ph ~= "" then
                local new = translateText(ph)
                if new ~= ph then pcall(function() obj.PlaceholderText = new end) end
            end
        end
        translating = false
    end

    apply()
    obj:GetPropertyChangedSignal("Text"):Connect(apply)
    if obj:IsA("TextBox") then
        obj:GetPropertyChangedSignal("PlaceholderText"):Connect(apply)
    end
end

local function watchGui(gui)
    if not gui:IsA("ScreenGui") and not gui:IsA("GuiObject") then return end
    for _, d in ipairs(gui:GetDescendants()) do hookObject(d) end
    gui.DescendantAdded:Connect(function(d)
        task.defer(hookObject, d)
    end)
end

-- =========================================================
--  HOOK MỌI CONTAINER (CoreGui / PlayerGui / gethui)
-- =========================================================
local containers = { CoreGui, Players.LocalPlayer:WaitForChild("PlayerGui") }
if gethui then
    local ok, h = pcall(gethui)
    if ok and h then table.insert(containers, h) end
end

for _, cont in ipairs(containers) do
    if cont then
        for _, d in ipairs(cont:GetDescendants()) do
            if d:IsA("ScreenGui") or d:IsA("GuiObject") then watchGui(d) end
        end
        cont.DescendantAdded:Connect(function(d)
            if d:IsA("ScreenGui") then
                task.defer(watchGui, d)
            elseif d:IsA("GuiObject") then
                task.defer(hookObject, d)
            end
        end)
    end
end

-- =========================================================
--  HÀM TẢI SCRIPT
-- =========================================================
local function fetchScript(url)
    local ok, res = pcall(function() return game:HttpGet(url) end)
    if ok and type(res) == "string" and #res > 0 then return res end
    for _, name in ipairs({"request", "http_request", "syn_request"}) do
        local fn = _G[name]
        if type(fn) == "function" then
            local ok2, r = pcall(fn, {Url = url, Method = "GET"})
            if ok2 and r and r.Body and #r.Body > 0 then return r.Body end
        end
    end
    return nil
end

-- =========================================================
--  UI CHỌN NGÔN NGỮ
-- =========================================================
local gui = Instance.new("ScreenGui")
gui.Name = "LangSelector"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
do
    local ok = pcall(function() gui.Parent = CoreGui end)
    if not ok or not gui.Parent then
        gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    end
end

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 380, 0, 220)
frame.Position = UDim2.new(0.5, -190, 0.5, -110)
frame.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(85, 85, 110)

-- Kéo thả
do
    local dragging, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X,
                                       startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
end

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 55)
title.BackgroundTransparency = 1
title.Text = "Chọn ngôn ngữ / Select Language"
title.TextColor3 = Color3.fromRGB(240, 240, 240)
title.Font = Enum.Font.GothamBold
title.TextSize = 16

local holder = Instance.new("Frame", frame)
holder.Size = UDim2.new(1, -40, 0, 60)
holder.Position = UDim2.new(0, 20, 0, 65)
holder.BackgroundTransparency = 1
local lay = Instance.new("UIListLayout", holder)
lay.FillDirection = Enum.FillDirection.Horizontal
lay.Padding = UDim.new(0, 10)
lay.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function makeBtn(text, color)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.5, -5, 1, 0)
    b.BackgroundColor3 = color
    b.BorderSizePixel = 0
    b.Text = text
    b.TextColor3 = Color3.fromRGB(240, 240, 240)
    b.Font = Enum.Font.GothamSemibold
    b.TextSize = 15
    b.Parent = holder
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    return b
end

local btnVI = makeBtn("🇻🇳  Tiếng Việt", Color3.fromRGB(200, 40, 40))
local btnEN = makeBtn("🇺🇸  English",    Color3.fromRGB(40, 90, 200))

local status = Instance.new("TextLabel", frame)
status.Size = UDim2.new(1, -40, 0, 26)
status.Position = UDim2.new(0, 20, 1, -40)
status.BackgroundTransparency = 1
status.Text = ""
status.TextColor3 = Color3.fromRGB(180, 180, 180)
status.Font = Enum.Font.Gotham
status.TextSize = 12

-- =========================================================
--  CHẠY
-- =========================================================
local loading = false

local function run(lang)
    if loading then return end
    loading = true

    status.Text = (lang == "vi") and "Đang tải script..." or "Loading script..."
    btnVI:Destroy(); btnEN:Destroy()

    task.spawn(function()
        local src = fetchScript(SCRIPT_URL)
        if not src then
            status.Text = (lang == "vi") and "❌ Không tải được script!" or "❌ Failed to fetch script!"
            loading = false
            return
        end

        status.Text = (lang == "vi") and "▶️ Đang chạy + dịch..." or "▶️ Running..."
        task.wait(0.3)
        gui:Destroy()

        local loader = loadstring or load
        local fn, err = loader(src)
        if not fn then
            warn("[LangSel] loadstring error: " .. tostring(err))
            return
        end

        -- Nếu chọn English -> khoá hook dịch (giữ nguyên tiếng Anh)
        if lang == "en" then
            translating = true
        end

        local ok, err2 = pcall(fn)
        if not ok then warn("[LangSel] runtime error: " .. tostring(err2)) end
    end)
end

btnVI.MouseButton1Click:Connect(function() run("vi") end)
btnEN.MouseButton1Click:Connect(function() run("en") end)
