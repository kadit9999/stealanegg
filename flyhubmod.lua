-- =========================================================
--  LANGUAGE SELECTOR + TRANSLATOR (BẢN ĐƠN GIẢN - CHẮC CHẮN CHẠY)
-- =========================================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

-- 🔽 SCRIPT ĐÍCH
local SCRIPT_URL = "https://fyycommunity.com/"

-- =========================================================
--  TỪ ĐIỂN
-- =========================================================
local DICT = {
    -- Tabs / Menus
    ["Main"]="Chính", ["Home"]="Trang chủ", ["Player"]="Người chơi",
    ["Players"]="Người chơi", ["Visuals"]="Hình ảnh", ["Visual"]="Hình ảnh",
    ["Combat"]="Chiến đấu", ["Misc"]="Khác", ["Miscellaneous"]="Khác",
    ["Settings"]="Cài đặt", ["Setting"]="Cài đặt", ["Config"]="Cấu hình",
    ["Configs"]="Cấu hình", ["Scripts"]="Kịch bản", ["Script"]="Kịch bản",
    ["Teleport"]="Dịch chuyển", ["Movement"]="Di chuyển", ["World"]="Thế giới",
    ["Local"]="Cục bộ", ["Character"]="Nhân vật", ["Extra"]="Bổ sung",
    ["Utility"]="Tiện ích", ["Utilities"]="Tiện ích", ["Others"]="Khác",
    ["Fun"]="Giải trí", ["Shop"]="Cửa hàng", ["Trade"]="Giao dịch",
    ["Automation"]="Tự động hoá", ["Events"]="Sự kiện", ["Predictor"]="Dự đoán",
    ["Progress"]="Tiến độ", ["Server"]="Máy chủ",
    ["Overview"]="Tổng quan", ["Steal"]="Trộm", ["Event"]="Sự kiện",
    ["Inventory"]="Hành trang", ["Egg"]="Trứng", ["Eggs"]="Trứng",
    ["Reward"]="Phần thưởng", ["Rewards"]="Phần thưởng", ["Discord"]="Discord",
    ["Farm"]="Cày", ["Interface"]="Giao diện",

    -- ==================== FLY / BAY ====================
    ["Fly"]="Bay",
    ["Flight"]="Bay",
    ["Flying"]="Đang bay",
    ["Fly Mode"]="Chế độ Bay",
    ["Fly Speed"]="Tốc độ Bay",
    ["Fly Height"]="Độ cao Bay",
    ["Fly Toggle"]="Bật/Tắt Bay",
    ["Enable Fly"]="Bật Bay",
    ["Disable Fly"]="Tắt Bay",
    ["Enable Flight"]="Bật Bay",
    ["Disable Flight"]="Tắt Bay",
    ["Fly Enabled"]="Đã bật Bay",
    ["Fly Disabled"]="Đã tắt Bay",
    ["Toggle Fly"]="Bật/Tắt Bay",
    ["Vertical Speed"]="Tốc độ dọc",
    ["Horizontal Speed"]="Tốc độ ngang",
    ["Hover"]="Lơ lửng",
    ["Hovering"]="Đang lơ lửng",
    ["Glide"]="Lượn",
    ["Gliding"]="Đang lượn",
    ["Hover Mode"]="Chế độ Lơ lửng",
    ["Inf Fly"]="Bay vô hạn",
    ["Infinite Fly"]="Bay vô hạn",
    ["No Clip Fly"]="Bay xuyên vật thể",
    ["Fly + Noclip"]="Bay + Xuyên vật thể",
    ["Fly Method"]="Phương thức Bay",
    ["Method"]="Phương thức",
    ["Velocity"]="Vận tốc",
    ["Body Velocity"]="Vận tốc thân",
    ["BodyVelocity"]="Vận tốc thân",
    ["CFrame"]="CFrame",
    ["Align"]="Căn chỉnh",
    ["Height"]="Độ cao",
    ["Vertical"]="Dọc",
    ["Horizontal"]="Ngang",
    ["Up"]="Lên", ["Down"]="Xuống",
    ["Keybind"]="Phím tắt",
    ["Bind"]="Gán phím",
    ["Toggle Key"]="Phím bật/tắt",
    ["Bind Key"]="Phím gán",
    ["Activate"]="Kích hoạt",
    ["Deactivate"]="Vô hiệu hoá",
    ["Smooth"]="Mượt",
    ["Smoothness"]="Độ mượt",
    ["Anti Fall"]="Chống rơi",
    ["Anti-Fall"]="Chống rơi",
    ["No Fall Damage"]="Không sát thương rơi",
    ["Gravity"]="Trọng lực",
    ["No Gravity"]="Không trọng lực",
    ["Anti Gravity"]="Chống trọng lực",
    ["AntiGravity"]="Chống trọng lực",

    -- Chilli Hub
    ["Chilli Hub"]="Chilli Hub Mod Tiếng Việt By Rubu Roblox",
    ["Chilli Hub [PREMIUM]"]="Chilli Hub Mod Tiếng Việt By Rubu Roblox",
    ["Chilli Hub [Premium]"]="Chilli Hub Mod Tiếng Việt By Rubu Roblox",
    ["Slow Mode"]="Chế độ chậm", ["Slow"]="Chậm",
    ["Instant Steal"]="Tức thì Trộm", ["Instant Steal V2"]="Tức thì Trộm V2",
    ["Only works in"]="Chỉ hoạt động ở",
    ["Titan Temple"]="Đền Titan", ["Light Dark"]="Sáng Tối",
    ["Misc Zones Delivery"]="Giao hàng khu vực khác",
    ["Other Zones Delivery"]="Giao hàng khu vực khác",
    ["Fast Delivery"]="Giao nhanh",
    ["How eggs outside Titan Temple, Light Dark and Enchanted Forest come home"]
        = "Cách trứng ngoài Đền Titan, Sáng Tối và Rừng Phép Thuật về nhà",
    ["Delivers the egg to the safe zone in a few seconds, needs enough Speed"]
        = "Giao trứng đến vùng an toàn trong vài giây, cần đủ Tốc độ",
    ["Filter features..."]="Lọc tính năng...",
    ["Loc features..."]="Tìm tính năng...",
    ["Butterfly Bloom"]="Hoa Bướm Nở",
    ["Wisp Companion"]="Bạn Đồng Hành Wisp",
    ["Dr Scramble Lab & Mech"]="Phòng thí nghiệm Dr Scramble & Mech",
    ["Dr Scramble Lab"]="Phòng thí nghiệm Dr Scramble",
    ["Lab"]="Phòng thí nghiệm",

    -- Cụm ghép
    ["Auto Steal"]="Tự động Trộm", ["Steal Mode"]="Chế độ Trộm",
    ["Bay Mode"]="Chế độ Bay", ["Instant Carry"]="Mang tức thì",
    ["MoveTo"]="Di chuyển đến", ["Move To"]="Di chuyển đến",
    ["Last Area"]="Khu vực cuối", ["Rarest"]="Hiếm nhất",
    ["Enchanted Forest"]="Rừng Phép Thuật", ["Sacred Moth"]="Bướm Thiêng",
    ["Drop Stolen Egg at Forest"]="Thả Trứng Trộm tại Rừng",
    ["Steal From Other Players"]="Trộm từ người chơi khác",
    ["Mech Tween Speed"]="Tốc độ Mech Tween",
    ["Main Weapon Hold"]="Giữ vũ khí chính",
    ["Scrambler Hold"]="Giữ Scrambler",
    ["Swap Two Weapons"]="Đổi 2 vũ khí",
    ["Boss Server Hop"]="Chuyển máy chủ Boss",
    ["Auto Mech Boss"]="Tự động Mech Boss",
    ["Auto Hop"]="Tự động chuyển",
    ["Server Hop"]="Chuyển máy chủ",
    ["Next Mech Portal"]="Cổng Mech tiếp theo",
    ["Quick & Keys"]="Phím nhanh", ["Quick Bar"]="Thanh nhanh",
    ["Walk Speed"]="Tốc độ đi", ["Jump Power"]="Lực nhảy",
    ["God Mode"]="Bất tử", ["Kill All"]="Giết tất cả",
    ["Auto Farm"]="Tự động cày", ["Anti Ban"]="Chống ban",
    ["Anti AFK"]="Chống AFK", ["Full Bright"]="Ánh sáng đầy",
    ["No Fog"]="Không sương mù", ["Please wait"]="Vui lòng đợi",

    -- Từ đơn
    ["Mode"]="Chế độ", ["Bay"]="Vịnh", ["Carry"]="Mang",
    ["Instant"]="Tức thì", ["Drop"]="Thả", ["Stolen"]="Bị trộm",
    ["From"]="Từ", ["Other"]="Khác", ["Area"]="Khu vực", ["Forest"]="Rừng",

    -- Actions
    ["Toggle"]="Bật/Tắt", ["Enable"]="Bật", ["Disable"]="Tắt",
    ["Enabled"]="Đã bật", ["Disabled"]="Đã tắt", ["On"]="Bật", ["Off"]="Tắt",
    ["Close"]="Đóng", ["Open"]="Mở", ["Confirm"]="Xác nhận", ["Cancel"]="Huỷ",
    ["Apply"]="Áp dụng", ["Reset"]="Đặt lại", ["Save"]="Lưu", ["Load"]="Tải",
    ["Select"]="Chọn", ["Copy"]="Sao chép",
    ["Start"]="Bắt đầu", ["Stop"]="Dừng", ["Refresh"]="Làm mới",
    ["Search"]="Tìm kiếm", ["Filter"]="Lọc", ["Sort"]="Sắp xếp",
    ["Hold"]="Giữ", ["Swap"]="Đổi", ["Hop"]="Chuyển", ["Next"]="Tiếp theo",

    -- Features
    ["Speed"]="Tốc độ", ["Jump"]="Nhảy",
    ["Infinite"]="Vô hạn", ["Health"]="Máu", ["Ammo"]="Đạn",
    ["Kill"]="Giết", ["Aimbot"]="Ngắm tự động", ["Wallhack"]="Xuyên tường",
    ["Auto"]="Tự động", ["Noclip"]="Xuyên vật thể", ["FOV"]="Tầm nhìn",
    ["Hitbox"]="Vùng va chạm", ["Invisible"]="Tàng hình",
    ["Damage"]="Sát thương", ["Range"]="Phạm vi", ["Radius"]="Bán kính",
    ["Amount"]="Số lượng", ["Value"]="Giá trị", ["Time"]="Thời gian",
    ["Delay"]="Độ trễ", ["Cooldown"]="Hồi chiêu",
    ["Weapon"]="Vũ khí", ["Weapons"]="Vũ khí",
    ["Boss"]="Boss", ["Mech"]="Mech", ["Tween"]="Tween", ["Portal"]="Cổng",

    -- Status
    ["Loading"]="Đang tải", ["Loaded"]="Đã tải",
    ["Error"]="Lỗi", ["Success"]="Thành công", ["Failed"]="Thất bại",
    ["Warning"]="Cảnh báo", ["Notice"]="Thông báo",
    ["Language"]="Ngôn ngữ", ["Vietnamese"]="Tiếng Việt", ["English"]="Tiếng Anh",
    ["Version"]="Phiên bản", ["Key"]="Khoá", ["Active"]="Kích hoạt",

    -- Rarity
    ["Common"]="Thường", ["Uncommon"]="Ít gặp", ["Rare"]="Hiếm",
    ["Epic"]="Sử thi", ["Legendary"]="Huyền thoại", ["Mythic"]="Thần thoại",
    ["Cosmic"]="Vũ trụ", ["Secret"]="Bí ẩn", ["Eternal"]="Vĩnh cửu",
    ["Divine"]="Thần thánh",
}

-- =========================================================
--  HÀM DỊCH
-- =========================================================
local escapePattern = function(s)
    return (s:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1"))
end

local translateText = function(text)
    if type(text) ~= "string" or text == "" then return text end
    if DICT[text] then return DICT[text] end
    local out = text
    for en, vi in pairs(DICT) do
        local pat = "%f[%w]" .. escapePattern(en) .. "%f[%W]"
        out = out:gsub(pat, vi)
    end
    return out
end

-- =========================================================
--  DỊCH 1 OBJECT
-- =========================================================
local function translateObj(obj)
    if not (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")) then
        return
    end
    local ok, cur = pcall(function() return obj.Text end)
    if ok and type(cur) == "string" and cur ~= "" then
        local new = translateText(cur)
        if new ~= cur then
            pcall(function() obj.Text = new end)
        end
    end
    if obj:IsA("TextBox") then
        local ok2, ph = pcall(function() return obj.PlaceholderText end)
        if ok2 and type(ph) == "string" and ph ~= "" then
            local new = translateText(ph)
            if new ~= ph then
                pcall(function() obj.PlaceholderText = new end)
            end
        end
    end
end

local function scanContainer(cont)
    if not cont then return end
    for _, d in ipairs(cont:GetDescendants()) do
        translateObj(d)
    end
end

-- =========================================================
--  HOOK
-- =========================================================
local active = false

local function activateHooks()
    active = true

    local containers = { CoreGui, Players.LocalPlayer:WaitForChild("PlayerGui") }
    if gethui then
        local ok, h = pcall(gethui)
        if ok and h then table.insert(containers, h) end
    end

    for _, cont in ipairs(containers) do
        if cont then
            cont.DescendantAdded:Connect(function(d)
                if active then
                    task.spawn(function()
                        translateObj(d)
                        if d:IsA("GuiObject") then
                            for _, c in ipairs(d:GetDescendants()) do
                                translateObj(c)
                            end
                        end
                    end)
                end
            end)
        end
    end
end

-- =========================================================
--  TẢI SCRIPT
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

    if lang == "vi" then
        activateHooks()
    end

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
        task.wait(0.2)
        gui:Destroy()

        local loader = loadstring or load
        local fn, err = loader(src)
        if not fn then
            warn("[LangSel] loadstring error: " .. tostring(err))
            return
        end

        local ok, err2 = pcall(fn)
        if not ok then warn("[LangSel] runtime error: " .. tostring(err2)) end

        if lang == "vi" then
            local containers = { CoreGui, Players.LocalPlayer:WaitForChild("PlayerGui") }
            if gethui then
                local ok3, h = pcall(gethui)
                if ok3 and h then table.insert(containers, h) end
            end

            task.spawn(function()
                for i = 1, 30 do
                    task.wait(0.1)
                    for _, cont in ipairs(containers) do
                        scanContainer(cont)
                    end
                end
            end)
        end
    end)
end

btnVI.MouseButton1Click:Connect(function() run("vi") end)
btnEN.MouseButton1Click:Connect(function() run("en") end)
