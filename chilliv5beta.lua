-- ==============================================================================
--  CHILLI HUB V5 - DYNAMIC ISLAND, FAKE 85-120 FPS & FULL VIETNAMESE ENGINE
--  Sửa đúng vị trí lỗi mất Dynamic Island (Giữ nguyên 100% các phần đã chuẩn):
--    1. KHÔI PHỤC DYNAMIC ISLAND: Bắt chính xác cả khi chữ gốc là "Idle" hoặc
--       đã dịch thành "Bá Khí", khóa chống bốc nhầm thanh Header.
--    2. BỎ CHỮ "✨ rainbow": Chỉ hiện trạng thái màu cầu vồng trên nền đen #000000.
--    3. GIỮ NGUYÊN 100%: Fake FPS (85-120 FPS), Bảo vệ Quick Bar, Logo 60x60.
-- ==============================================================================

local NEW_TITLE = "Chilli Hub V5"
local CHILLI_LOGO_ID = "rbxassetid://92622270383869"
local LOGO_BG_COLOR = Color3.fromRGB(5, 7, 15)
local ISLAND_BLACK_BG = Color3.fromRGB(0, 0, 0)

-- 1. KHỞI CHẠY BASE SCRIPT LUARMOR
if not getgenv().__VenyxV5Loaded then
    getgenv().__VenyxV5Loaded = true
    task.spawn(function()
        pcall(function()
            loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/a40becae9d58ed4c969ab2f9d26f2f1b.lua"))()
        end)
    end)
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local roots = {
    gethui and gethui(),
    CoreGui,
    LocalPlayer:WaitForChild("PlayerGui")
}

-- Danh sách chứa các Gradient để xoay chung trong 1 luồng duy nhất (0% CPU)
local ActiveGradients = {}

local COLOR_SEQ_RAINBOW = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 55, 55)),
    ColorSequenceKeypoint.new(0.20, Color3.fromRGB(255, 175, 40)),
    ColorSequenceKeypoint.new(0.40, Color3.fromRGB(255, 235, 50)),
    ColorSequenceKeypoint.new(0.60, Color3.fromRGB(50, 255, 130)),
    ColorSequenceKeypoint.new(0.80, Color3.fromRGB(60, 185, 255)),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 55, 55))
})

-- VÒNG LẶP XOAY CẦU VỒNG DUY NHẤT TOÀN HỆ THỐNG (NHẸ TUYỆT ĐỐI)
if not getgenv().__ChilliV5RainbowLoop then
    getgenv().__ChilliV5RainbowLoop = true
    task.spawn(function()
        local rot = 0
        while true do
            rot = (rot + 4) % 360
            for i = #ActiveGradients, 1, -1 do
                local g = ActiveGradients[i]
                if g and g.Parent then
                    g.Rotation = rot
                else
                    table.remove(ActiveGradients, i)
                end
            end
            task.wait(0.03)
        end
    end)
end

-- ==================== 2. BỘ TẠO FPS ẢO (85 - 120 FPS) (GIỮ NGUYÊN) ====================
local currentFakeFps = math.random(96, 112)

local function generateNextFakeFps()
    local delta = math.random(-4, 4)
    currentFakeFps = math.clamp(currentFakeFps + delta, 85, 120)
    return currentFakeFps
end

local function isFpsCounterText(str)
    if not str then return false end
    return str:find("FPS") ~= nil and str:find("ms") ~= nil
end

local function hookFakeFpsCounter(lbl)
    if not (lbl:IsA("TextLabel") or lbl:IsA("TextButton")) then return end

    local function applyFakeFps()
        if lbl:GetAttribute("__UpdatingFps") then return end
        local raw = lbl.Text
        if not isFpsCounterText(raw) then return end

        lbl:SetAttribute("__UpdatingFps", true)
        local fakeVal = generateNextFakeFps()
        local patched = raw:gsub("%d+%s*FPS", tostring(fakeVal) .. " FPS", 1)
        if lbl.Text ~= patched then
            lbl.Text = patched
        end
        task.defer(function()
            lbl:SetAttribute("__UpdatingFps", false)
        end)
    end

    applyFakeFps()

    if not lbl:GetAttribute("__FpsHooked") then
        lbl:SetAttribute("__FpsHooked", true)
        lbl:GetPropertyChangedSignal("Text"):Connect(function()
            if not lbl:GetAttribute("__UpdatingFps") and isFpsCounterText(lbl.Text) then
                applyFakeFps()
            end
        end)

        task.spawn(function()
            while lbl and lbl.Parent do
                task.wait(0.7)
                if isFpsCounterText(lbl.Text) then
                    applyFakeFps()
                end
            end
        end)
    end
end

-- ==================== 3. HỆ THỐNG TỪ ĐIỂN DỊCH THUẬT TOÀN DIỆN ====================
local currentLanguage = "VI"
local FastCache = {}
local TrackedTexts = {}
local GlobalRefreshIslandStatus = nil

local EXACT_MATCH_VI = {
    -- Trạng thái tĩnh trên Dynamic Island & DOING
    ["Idle"] = "Bá Khí",
    ["Waiting"] = "Đang chờ",
    ["Nothing"] = "Không có gì",
    ["Waiting in safe zone"] = "Đợi ở vùng an toàn",
    ["Returning to safe zone"] = "Đang về vùng an toàn",
    ["Returning home"] = "Đang quay về nhà",
    ["Going home"] = "Đang về nhà",
    ["Delivering egg"] = "Đang giao trứng về chuồng",
    ["Dropping egg"] = "Đang thả trứng",
    ["Dropping eggs"] = "Đang thả trứng",
    ["Selling eggs"] = "Đang bán trứng",
    ["Selling pets"] = "Đang bán pet",
    ["Selling lab eggs"] = "Đang bán trứng Lab",
    ["Hatching eggs"] = "Đang ấp trứng",
    ["Placing eggs"] = "Đang đặt trứng",
    ["Mutating eggs"] = "Đang đột biến trứng",
    ["Fusing pets"] = "Đang dung hợp pet",
    ["Hopping server"] = "Đang đổi máy chủ",
    ["Rejoining"] = "Đang vào lại phòng",
    ["Avoiding guard"] = "Đang né vệ sĩ",
    ["Evading guard"] = "Đang né vệ sĩ",
    ["Using treadmill"] = "Đang chạy máy tập",
    ["Upgrading treadmill"] = "Đang nâng cấp máy tập",
    ["Upgrading base"] = "Đang nâng cấp căn cứ",
    ["Claiming rewards"] = "Đang nhận thưởng",
    ["Claiming offline cash"] = "Đang nhận tiền ngoại tuyến",
    ["Catching shooting star"] = "Đang bắt sao băng",
    ["Catching butterfly"] = "Đang bắt bướm",
    ["Joining race"] = "Đang vào đường đua",
    ["Racing"] = "Đang đua xe",

    -- Dashboard
    ["Dashboard"] = "Bảng Điều Khiển",
    ["Welcome back"] = "Chào mừng trở lại",
    ["Beta version"] = "Phiên bản Beta",
    ["This is a test build. Features may change and bugs can happen."] = "Đây là bản thử nghiệm. Tính năng có thể thay đổi và phát sinh lỗi.",
    ["Rejoin"] = "Vào lại",
    ["Server hop"] = "Đổi server",
    ["Copy Job ID"] = "Chép Job ID",
    ["Unload hub"] = "Tắt Hub",
    ["Save config"] = "Lưu cấu hình",
    ["Hide UI"] = "Ẩn Menu",
    ["SESSION"] = "PHIÊN CHƠI",
    ["STOLEN"] = "ĐÃ CƯỚP",
    ["LAST EGG"] = "TRỨNG CUỐI",
    ["PLACED"] = "ĐÃ ĐẶT",
    ["HATCHED"] = "ĐÃ ẤP",
    ["NIGHT IN"] = "ĐÊM SAU",
    ["SESSION TIME"] = "THỜI GIAN",
    ["BEST STEAL"] = "CƯỚP TỐT NHẤT",
    ["EGG BAG"] = "TÚI TRỨNG",
    ["PET BAG"] = "TÚI PET",
    ["WHAT'S NEW"] = "CÓ GÌ MỚI",
    ["NEW"] = "MỚI",
    ["Event"] = "Sự Kiện",
    ["Racing Event: ragdoll jump to the portal, races, leaves and claims"] = "Sự Kiện Đua Xe: tự nhảy vào cổng, đua, rời đi và nhận thưởng",
    ["Shooting Star catcher with ragdoll jump and run fallback"] = "Bắt Sao Băng kết hợp nhảy ragdoll và chạy dự phòng",
    ["Steal panel joins the game buttons and lists every egg"] = "Bảng Cướp tích hợp nút game và liệt kê mọi quả trứng",
    ["Search"] = "Tìm kiếm",
    ["Filter"] = "Lọc tìm",

    -- Steal & Egg Predictor & Egg Cards
    ["Steal"] = "Cướp Trứng",
    ["Auto Steal"] = "Tự Động Cướp",
    ["AUTO STEAL"] = "TỰ ĐỘNG CƯỚP",
    ["Auto steal"] = "Tự động cướp",
    ["Egg Predictor"] = "Dự Đoán Trứng",
    ["EGG PREDICTOR"] = "DỰ ĐOÁN TRỨNG",
    ["Go to egg"] = "Di chuyển tới trứng",
    ["Teleport to egg"] = "Dịch chuyển tới trứng",
    ["Tween"] = "Bay (Tween)",
    ["Delivery method"] = "Cách mang về",
    ["Fast tween speed"] = "Tốc độ bay nhanh",
    ["Tween speed"] = "Tốc độ bay",
    ["Steal missing index eggs"] = "Cướp trứng thiếu trong Chỉ mục",
    ["Steal back from players"] = "Cướp lại từ người chơi",
    ["Anti guard"] = "Chống vệ sĩ",
    ["Drop eggs at safe zone"] = "Thả trứng ở vùng an toàn",
    ["FILTER"] = "BỘ LỌC",
    ["Zones"] = "Khu vực",
    ["None"] = "Không có",
    ["Steal first"] = "Ưu tiên cướp",
    ["Best value"] = "Giá trị cao nhất",
    ["Lowest value"] = "Giá trị thấp nhất",
    ["Best rarity"] = "Độ hiếm cao nhất",
    ["Best mutation"] = "Đột biến tốt nhất",
    ["Biggest"] = "Kích thước to nhất",
    ["Closest"] = "Khoảng cách gần nhất",
    ["Mutations"] = "Đột biến",
    ["Rarities"] = "Độ hiếm",
    ["Only these eggs"] = "Chỉ những trứng này",
    ["Min value /s"] = "Giá trị tối thiểu /s",
    ["Off"] = "Tắt",
    ["Sell cheapest egg when bag is full"] = "Bán trứng rẻ nhất khi đầy túi",
    ["Keep lab eggs"] = "Giữ lại trứng Lab",
    ["AUTO HOP SERVER"] = "TỰ ĐỔI MÁY CHỦ",
    ["Only sell eggs below /s"] = "Chỉ bán trứng dưới mức /s",
    ["EGG SHOWCASE"] = "TRƯNG BÀY TRỨNG",
    ["Sort eggs"] = "Sắp xếp trứng",
    ["Preview card"] = "Thẻ xem trước",
    ["Pick one"] = "Chọn một mục",
    ["Pick any"] = "Chọn bất kỳ",
    ["Value"] = "Giá trị",
    ["Rarity"] = "Độ hiếm",
    ["Time left"] = "Thời gian còn lại",
    ["Default"] = "Mặc định",
    ["Clear"] = "Xóa chọn",
    ["Select all"] = "Chọn tất cả",
    ["SIZE"] = "KÍCH CỠ",
    ["WEIGHT"] = "CÂN NẶNG",
    ["READY"] = "SẴN SÀNG",
    ["IN BAG"] = "TRONG TÚI",
    ["GROWING"] = "ĐANG LỚN",
    ["Hatch now"] = "Ấp ngay",
    ["Hold egg"] = "Cầm trứng",
    ["Fly to egg"] = "Bay tới trứng",

    -- Zones (Khu vực)
    ["Enchanted Forest"] = "Rừng Phù Phép (Enchanted Forest)",
    ["Light Dark"] = "Sáng Tối (Light Dark)",
    ["Titan Temple"] = "Đền Titan (Titan Temple)",
    ["Cherry Blossom"] = "Hoa Anh Đào (Cherry Blossom)",
    ["Prehistoric"] = "Tiền Sử (Prehistoric)",
    ["Abyss Ocean"] = "Đáy Đại Dương (Abyss Ocean)",
    ["Volcano"] = "Núi Lửa (Volcano)",
    ["Snow"] = "Tuyết (Snow)",
    ["Jungle"] = "Rừng Rậm (Jungle)",
    ["Desert"] = "Sa Mạc (Desert)",
    ["Lake"] = "Hồ Nước (Lake)",
    ["Forest"] = "Khu Rừng (Forest)",

    -- Mutations (Đột biến)
    ["Silver"] = "Bạc (Silver)",
    ["Rainbow"] = "Cầu Vồng (Rainbow)",
    ["Golden"] = "Vàng (Golden)",
    ["Fractured"] = "Rạn Nứt (Fractured)",
    ["Scrambled"] = "Hỗn Loạn (Scrambled)",
    ["Enchanted"] = "Phù Phép (Enchanted)",
    ["Nitro"] = "Nitro",
    ["SCRAMBLED"] = "HỖN LOẠN",
    ["NITRO"] = "NITRO",
    ["FRACTURED"] = "RẠN NỨT",
    ["ENCHANTED"] = "PHÙ PHÉP",

    -- Farm: Pen, Treadmill, Mutate, Sell, Fuse, Priority
    ["Farm"] = "Cày Cuốc",
    ["Pen"] = "Chuồng Ấp",
    ["PEN"] = "CHUỒNG ẤP",
    ["Treadmill"] = "Máy Tập",
    ["TREADMILL"] = "MÁY TẬP CHẠY",
    ["Mutate"] = "Đột Biến",
    ["MUTATE"] = "ĐỘT BIẾN",
    ["Sell"] = "Bán",
    ["SELL"] = "BÁN TỰ ĐỘNG",
    ["Fuse"] = "Dung Hợp",
    ["FUSE"] = "DUNG HỢP",
    ["Priority"] = "Ưu Tiên",
    ["PRIORITY"] = "THỨ TỰ ƯU TIÊN",
    ["AUTO PLACE"] = "TỰ ĐỘNG ĐẶT TRỨNG",
    ["Auto place"] = "Tự động đặt trứng",
    ["Place when"] = "Đặt khi",
    ["Always"] = "Luôn luôn",
    ["Place first"] = "Ưu tiên đặt",
    ["AUTO HATCH"] = "TỰ ĐỘNG ẤP TRỨNG",
    ["Auto hatch"] = "Tự động ấp trứng",
    ["Equip best pets"] = "Trang bị pet mạnh nhất",
    ["READY NOW"] = "SẴN SÀNG ẤP",
    ["Auto treadmill"] = "Tự chạy máy tập",
    ["Auto upgrade treadmill"] = "Tự nâng cấp máy tập",
    ["PROGRESS"] = "TIẾN TRÌNH",
    ["Auto upgrade base"] = "Tự nâng cấp căn cứ",
    ["Auto buy trails"] = "Tự mua vệt sáng",
    ["Auto claim offline cash"] = "Tự nhận tiền ngoại tuyến",
    ["Auto claim index rewards"] = "Tự nhận thưởng Chỉ mục",
    ["AUTO MUTATE"] = "TỰ ĐỘNG ĐỘT BIẾN",
    ["Auto mutate"] = "Tự động đột biến",
    ["MUTATE FILTER"] = "BỘ LỌC ĐỘT BIẾN",
    ["Use items"] = "Dùng vật phẩm",
    ["Mutate first"] = "Ưu tiên đột biến",
    ["Auto buy Nitro"] = "Tự mua Nitro",
    ["PETS"] = "THÚ CƯNG (PETS)",
    ["EGGS"] = "TRỨNG (EGGS)",
    ["Auto sell pets"] = "Tự động bán pet",
    ["Auto sell eggs"] = "Tự động bán trứng",
    ["Sell rarities"] = "Độ hiếm bán",
    ["Never sell"] = "Không bao giờ bán",
    ["Only mutations"] = "Chỉ bán đột biến",
    ["Only below /s"] = "Chỉ dưới mức /s",
    ["Keep mutated"] = "Giữ lại đồ đột biến",
    ["Sell matching pets now"] = "Bán các pet khớp ngay",
    ["Sell matching eggs now"] = "Bán các trứng khớp ngay",
    ["LAB EGGS"] = "TRỨNG PHÒNG LAB",
    ["FAVORITE"] = "YÊU THÍCH (KHÓA)",
    ["Auto favorite"] = "Tự động khóa bảo vệ",
    ["Auto sell lab eggs"] = "Tự động bán trứng Lab",
    ["Sell matching lab eggs now"] = "Bán trứng Lab khớp ngay",
    ["Match"] = "Điều kiện khớp",
    ["All picked rules"] = "Khớp tất cả quy tắc",
    ["Any picked rule"] = "Khớp bất kỳ quy tắc",
    ["Always favorite"] = "Luôn khóa loài này",
    ["Favorite equipped"] = "Khóa pet đang trang bị",
    ["FUSE MACHINE"] = "MÁY DUNG HỢP",
    ["No 3 matching pets"] = "Chưa đủ 3 pet cùng loại",
    ["Auto fuse"] = "Tự động dung hợp",
    ["Fuse first"] = "Ưu tiên dung hợp",
    ["Lowest rarity"] = "Độ hiếm thấp nhất",
    ["Highest rarity"] = "Độ hiếm cao nhất",
    ["Use pets"] = "Sử dụng pet",
    ["Lowest value first"] = "Giá trị thấp nhất trước",
    ["Highest value first"] = "Giá trị cao nhất trước",
    ["Skip mutated"] = "Bỏ qua pet đột biến",
    ["Eject odd pets"] = "Đẩy pet lẻ ra ngoài",
    ["FUSE FILTER"] = "BỘ LỌC DUNG HỢP",
    ["Only these pets"] = "Chỉ những pet này",
    ["Never fuse"] = "Không bao giờ dung hợp",
    ["FUSE PREDICTOR"] = "DỰ ĐOÁN DUNG HỢP",
    ["SLOTS"] = "Ô CHỨA",
    ["STATUS"] = "TRẠNG THÁI",
    ["Waiting for pets"] = "Đang chờ pet",
    ["LIKELY SIZE"] = "KÍCH CỠ DỰ KIẾN",
    ["CHANCE"] = "TỶ LỆ",
    ["VALUE"] = "GIÁ TRỊ",
    ["BEST CASE"] = "TỐT NHẤT CÓ THỂ",
    ["TASK ORDER"] = "THỨ TỰ TÁC VỤ",
    ["Top goes first. A carried egg is always delivered first, and before the field opens every task waits in the safe zone."] = "Mục ở trên làm trước. Trứng đang bê luôn được giao trước, và trước khi khu vực mở thì mọi tác vụ sẽ đợi ở vùng an toàn.",
    ["DOING"] = "ĐANG LÀM",
    ["WAITING"] = "ĐANG CHỜ",
    ["Steal filter eggs"] = "Cướp trứng theo bộ lọc",
    ["Shooting Star"] = "Bắt Sao Băng",
    ["Racing Event"] = "Sự Kiện Đua Xe",
    ["Butterfly"] = "Bắt Bướm",
    ["Steal wisp eggs"] = "Cướp trứng Wisp",
    ["Wisp"] = "Nhặt Wisp",
    ["Steal missing index"] = "Cướp trứng thiếu trong Chỉ mục",
    ["Steal lab eggs"] = "Cướp trứng phòng Lab",
    ["Place"] = "Đặt trứng vào chuồng",
    ["Butterfly machine"] = "Máy đổi Bướm",

    -- Event: Race, Star, Butterfly, Lab, AA
    ["Race"] = "Đua Xe",
    ["RACE"] = "ĐUA XE",
    ["Star"] = "Sao Băng",
    ["STAR"] = "SAO BĂNG",
    ["BUTTERFLY"] = "BẮT BƯỚM",
    ["Lab"] = "Phòng Lab",
    ["LAB"] = "PHÒNG LAB",
    ["AA"] = "Admin (AA)",
    ["RACING EVENT"] = "SỰ KIỆN ĐUA XE",
    ["NEXT RACE"] = "ĐUA TIẾP THEO",
    ["WINS"] = "THẮNG",
    ["TROPHIES"] = "CÚP",
    ["Auto race"] = "Tự động đua xe",
    ["Race speed"] = "Tốc độ đua",
    ["Lower it if wins do not count"] = "Giảm tốc độ nếu thắng không được tính",
    ["Use power-ups"] = "Tự dùng vật phẩm tăng tốc",
    ["REWARDS"] = "PHẦN THƯỞNG",
    ["Auto claim rewards"] = "Tự nhận phần thưởng",
    ["Auto equip racer"] = "Tự trang bị xe đua",
    ["Racer"] = "Xe đua",
    ["Best owned"] = "Tốt nhất đang có",
    ["Auto buy shop"] = "Tự mua vật phẩm Shop",
    ["Shop items"] = "Vật phẩm Shop",
    ["SHOOTING STAR"] = "SAO BĂNG RƠI",
    ["LANDS IN"] = "RƠI SAU",
    ["CATCH"] = "BẮT SAO BĂNG",
    ["A Shooting Star is rare and only you can catch yours. It lands in Cosmic, runs from you, and needs a 1.6 s hold."] = "Sao Băng rất hiếm và chỉ bạn mới bắt được của mình. Nó rơi ở khu Vũ Trụ (Cosmic), chạy trốn bạn và cần nhấn giữ 1.6 giây.",
    ["CAUGHT"] = "ĐÃ BẮT",
    ["EXPIRES IN"] = "BIẾN MẤT SAU",
    ["SLIPPED"] = "TUỘT MẤT",
    ["TRIES"] = "SỐ LẦN THỬ",
    ["DISTANCE"] = "KHOẢNG CÁCH",
    ["Auto catch shooting star"] = "Tự động bắt sao băng",
    ["BUTTERFLY BLOOM"] = "MÙA BƯỚM NỞ",
    ["Auto butterfly bloom"] = "Tự động bắt bướm",
    ["EMERALD"] = "LỤC BẢO",
    ["SAPPHIRE"] = "LAM NGỌC",
    ["AMETHYST"] = "THẠCH ANH TÍM",
    ["RADIANT"] = "RỰC RỠ",
    ["ESSENCE"] = "TINH CHẤT",
    ["Catch mode"] = "Chế độ bắt",
    ["Stand"] = "Đứng yên",
    ["Chase"] = "Đuổi theo",
    ["BUTTERFLY MACHINE"] = "MÁY ĐỔI BƯỚM",
    ["Auto trade up"] = "Tự nâng cấp bậc bướm",
    ["Trade"] = "Giao dịch đổi",
    ["Smart trade for essence"] = "Đổi bướm lấy tinh chất thông minh",
    ["Auto craft essence"] = "Tự chế tạo tinh chất",
    ["WISP COMPANION"] = "ĐỒNG HÀNH WISP",
    ["Catch priority"] = "Ưu tiên bắt",
    ["Rarest"] = "Hiếm nhất",
    ["Catch"] = "Loại bướm bắt",
    ["Radiant"] = "Rực Rỡ (Radiant)",
    ["Catch speed"] = "Tốc độ bắt",
    ["Auto wisp quest"] = "Tự làm nhiệm vụ Wisp",
    ["Auto banjo cricket"] = "Tự bắt dế Banjo",
    ["STAGE"] = "GIAI ĐOẠN",
    ["LAB ODDS"] = "TỶ LỆ PHÒNG LAB",
    ["BANNER"] = "BĂNG RÔN",
    ["ENDS IN"] = "KẾT THÚC SAU",
    ["BANNER CHANCE"] = "TỶ LỆ BĂNG RÔN",
    ["NEXT"] = "TIẾP THEO",
    ["Experimental Pets"] = "Pet Thí Nghiệm",
    ["Biohazard Pets"] = "Pet Sinh Học",
    ["Lab banners"] = "Băng rôn phòng Lab",
    ["Auto trade in"] = "Tự động đổi trứng Lab",
    ["Auto reroll recipe"] = "Tự đổi lại công thức",
    ["Place lab reward eggs"] = "Đặt trứng thưởng từ Lab",
    ["ADMIN ABUSE"] = "LẠM DỤNG ADMIN (ABUSE)",
    ["No admin boost right now"] = "Hiện không có buff Admin nào",
    ["Instant steal (Admin Treadmill)"] = "Cướp tức thì (Máy tập Admin)",
    ["Use admin treadmill"] = "Tự dùng máy tập Admin",
    ["CAPTURE THE EGG"] = "CƯỚP TRỨNG SỰ KIỆN",
    ["Auto capture event egg"] = "Tự bắt trứng sự kiện",
    ["Take it from the holder"] = "Giật trứng từ người đang cầm",
    ["Hold height"] = "Độ cao giữ trứng",
    ["Keep away"] = "Khoảng cách né tránh",
    ["MINIGAME EGGS"] = "TRỨNG MINIGAME",
    ["Waiting for Red Light Green Light or T-Rex Run"] = "Đang chờ Đèn Đỏ Đèn Xanh hoặc Chạy Trốn T-Rex",
    ["Auto steal minigame egg"] = "Tự cướp trứng Minigame",

    -- Player: ESP, Move, Combat
    ["Player"] = "Người Chơi",
    ["ESP"] = "Định Vị (ESP)",
    ["Move"] = "Di Chuyển",
    ["MOVE"] = "DI CHUYỂN",
    ["Combat"] = "Chiến Đấu",
    ["COMBAT"] = "CHIẾN ĐẤU",
    ["FIELD EGGS"] = "TRỨNG NGOÀI SÂN",
    ["Egg ESP"] = "ESP Trứng",
    ["Show"] = "Hiển thị",
    ["Name"] = "Tên",
    ["Fixed size"] = "Cố định kích cỡ",
    ["OTHERS"] = "MỤC KHÁC",
    ["Pen egg ESP"] = "ESP trứng trong chuồng",
    ["Other pens ESP"] = "ESP chuồng người khác",
    ["Guard ESP"] = "ESP Vệ sĩ",
    ["Player ESP"] = "ESP Người chơi",
    ["ESP size"] = "Kích cỡ ESP",
    ["MOVEMENT"] = "TỐC ĐỘ & DI CHUYỂN",
    ["Speed boost"] = "Tăng tốc chạy",
    ["Boost speed"] = "Tốc độ tăng thêm",
    ["Infinite jump"] = "Nhảy vô hạn",
    ["God mode"] = "Bất tử (God mode)",
    ["PROTECTION"] = "BẢO VỆ NHÂN VẬT",
    ["Anti ragdoll"] = "Chống ngã (Anti Ragdoll)",
    ["Ignore traps"] = "Bỏ qua bẫy",
    ["Instant prompts"] = "Tương tác nhấn giữ tức thì",
    ["Anti AFK"] = "Chống treo máy (Anti AFK)",
    ["Invisible"] = "Tàng hình",
    ["AUTO HIT"] = "TỰ ĐỘNG ĐÁNH",
    ["Auto hit"] = "Tự động đánh",
    ["Hit who"] = "Mục tiêu đánh",
    ["Nearest player"] = "Người chơi gần nhất",
    ["Chosen player"] = "Người chơi chỉ định",
    ["Chase speed"] = "Tốc độ đuổi theo",
    ["HIT AURA"] = "VÒNG ĐÁNH TỰ ĐỘNG",
    ["Hit aura"] = "Vòng đánh tự động (Hit Aura)",
    ["Skip friends"] = "Bỏ qua bạn bè",
    ["WEAPONS"] = "VŨ KHÍ",
    ["Use weapons"] = "Sử dụng vũ khí",
    ["Hold each"] = "Thời gian cầm mỗi món",

    -- System: Server, Webhook, Optimizer, Interface, Config
    ["System"] = "Hệ Thống",
    ["Server"] = "Máy Chủ",
    ["SERVER"] = "MÁY CHỦ",
    ["Webhook"] = "Webhook",
    ["WEBHOOK"] = "WEBHOOK",
    ["Optimizer"] = "Tối Ưu Hóa",
    ["OPTIMIZER"] = "TỐI ƯU HÓA (GIẢM LAG)",
    ["Interface"] = "Giao Diện",
    ["Config"] = "Cấu Hình",
    ["Hop to"] = "Chuyển tới server",
    ["Least players"] = "Ít người chơi nhất",
    ["Hop server"] = "Đổi máy chủ",
    ["Hop"] = "Đổi ngay",
    ["Rejoin this server"] = "Vào lại máy chủ này",
    ["Copy"] = "Sao chép",
    ["JOIN AND STAY"] = "VÀO PHÒNG & DUY TRÌ",
    ["Job ID"] = "Mã phòng (Job ID)",
    ["Paste a Job ID"] = "Dán mã Job ID vào đây",
    ["Join that server"] = "Vào máy chủ đó",
    ["Join"] = "Vào ngay",
    ["Rejoin on kick"] = "Tự vào lại khi bị văng/kick",
    ["Auto load script"] = "Tự chạy lại script khi chuyển server",
    ["DISCORD WEBHOOK"] = "WEBHOOK DISCORD",
    ["Webhook URL"] = "Đường dẫn Webhook",
    ["Ping everyone"] = "Tag @everyone",
    ["WHAT TO POST"] = "NỘI DUNG GỬI BÁO CÁO",
    ["Post stolen eggs"] = "Báo cáo trứng cướp được",
    ["Post fused eggs"] = "Báo cáo trứng dung hợp",
    ["POSTED"] = "ĐÃ GỬI",
    ["Send a test post"] = "Gửi tin nhắn thử nghiệm",
    ["Test"] = "Thử nghiệm",
    ["Post when bag is full"] = "Gửi thông báo khi đầy túi",
    ["GRAPHICS"] = "ĐỒ HỌA",
    ["Low graphics"] = "Đồ họa thấp (Tăng FPS)",
    ["Disable 3D Render"] = "Tắt kết xuất 3D (Treo máy)",
    ["Background color"] = "Màu nền màn hình",
    ["Black"] = "Màu Đen",
    ["White"] = "Màu Trắng",
    ["Hide game UI"] = "Ẩn giao diện gốc của Game",
    ["FRAME RATE"] = "TỐC ĐỘ KHUNG HÌNH (FPS)",
    ["FPS cap"] = "Giới hạn FPS",
    ["Show FPS and ping"] = "Hiện chỉ số FPS và Ping",
    ["BASES"] = "CĂN CỨ (BASES)",
    ["Hide other players' pets and eggs"] = "Ẩn pet và trứng của người chơi khác",
    ["Hide my pets and eggs"] = "Ẩn pet và trứng của bản thân",

    -- Độ hiếm
    ["Common"] = "Phổ Thông (Common)",
    ["Uncommon"] = "Thường (Uncommon)",
    ["Rare"] = "Hiếm (Rare)",
    ["Epic"] = "Sử Thi (Epic)",
    ["Legendary"] = "Huyền Thoại (Legendary)",
    ["Mythic"] = "Thần Thoại (Mythic)",
    ["Cosmic"] = "Vũ Trụ (Cosmic)",
    ["Secret"] = "Bí Ẩn (Secret)",
    ["Divine"] = "Thánh Thần (Divine)",
    ["Eternal"] = "Vĩnh Cửu (Eternal)",
    ["COMMON"] = "PHỔ THÔNG",
    ["UNCOMMON"] = "THƯỜNG",
    ["RARE"] = "HIẾM",
    ["EPIC"] = "SỬ THI",
    ["LEGENDARY"] = "HUYỀN THOẠI",
    ["MYTHIC"] = "THẦN THOẠI",
    ["COSMIC"] = "VŨ TRỤ",
    ["SECRET"] = "BÍ ẨN",
    ["DIVINE"] = "THÁNH THẦN",
    ["ETERNAL"] = "VĨNH CỬU"
}

-- BỘ MẪU CÂU HÀNH ĐỘNG ĐỘNG TRÊN DYNAMIC ISLAND & Ô DOING
local STATUS_ACTION_PATTERNS_VI = {
    { pat = "^[Cc]arrying (.+) to safe zone$", rep = "Đang mang %1 về vùng an toàn" },
    { pat = "^[Cc]arrying (.+) to base$", rep = "Đang mang %1 về căn cứ" },
    { pat = "^[Cc]arrying (.+) to pen$", rep = "Đang mang %1 về chuồng" },
    { pat = "^[Cc]arrying (.+) home$", rep = "Đang mang %1 về nhà" },
    { pat = "^[Cc]arrying (.+)$", rep = "Đang bê %1" },
    { pat = "^[Dd]elivering (.+) to (.+)$", rep = "Đang giao %1 tới %2" },
    { pat = "^[Dd]elivering (.+) home$", rep = "Đang giao %1 về nhà" },
    { pat = "^[Dd]elivering (.+)$", rep = "Đang giao %1" },
    { pat = "^[Bb]ringing (.+) home$", rep = "Đang mang %1 về nhà" },
    { pat = "^[Bb]ringing (.+)$", rep = "Đang mang %1" },
    { pat = "^[Tt]aking (.+) from (.+)$", rep = "Đang giật %1 từ %2" },
    { pat = "^[Tt]aking (.+) home$", rep = "Đang đem %1 về nhà" },
    { pat = "^[Tt]aking (.+)$", rep = "Đang lấy %1" },
    { pat = "^[Ss]tealing (.+) from (.+)$", rep = "Đang cướp %1 từ %2" },
    { pat = "^[Ss]tealing (.+)$", rep = "Đang cướp %1" },
    { pat = "^[Gg]rabbing (.+)$", rep = "Đang chộp lấy %1" },
    { pat = "^[Pp]icking up (.+)$", rep = "Đang nhặt %1" },
    { pat = "^[Cc]ollecting (.+)$", rep = "Đang thu thập %1" },
    { pat = "^[Hh]olding (.+)$", rep = "Đang giữ %1" },
    { pat = "^[Cc]apturing (.+)$", rep = "Đang bắt giữ %1" },
    { pat = "^[Dd]ropping (.+) at (.+)$", rep = "Đang thả %1 tại %2" },
    { pat = "^[Dd]ropping (.+)$", rep = "Đang thả %1" },
    { pat = "^[Tt]weening to (.+)$", rep = "Đang bay tới %1" },
    { pat = "^[Tt]eleporting to (.+)$", rep = "Đang dịch chuyển tới %1" },
    { pat = "^[Gg]oing to (.+)$", rep = "Đang đi tới %1" },
    { pat = "^[Mm]oving to (.+)$", rep = "Đang di chuyển tới %1" },
    { pat = "^[Ww]alking to (.+)$", rep = "Đang chạy tới %1" },
    { pat = "^[Rr]unning to (.+)$", rep = "Đang chạy tới %1" },
    { pat = "^[Ff]lying to (.+)$", rep = "Đang bay tới %1" },
    { pat = "^[Rr]eturning to (.+)$", rep = "Đang quay về %1" },
    { pat = "^[Hh]eading to (.+)$", rep = "Đang hướng tới %1" },
    { pat = "^[Pp]lacing (.+)$", rep = "Đang đặt %1" },
    { pat = "^[Hh]atching (.+)$", rep = "Đang ấp %1" },
    { pat = "^[Mm]utating (.+)$", rep = "Đang đột biến %1" },
    { pat = "^[Ss]elling (.+)$", rep = "Đang bán %1" },
    { pat = "^[Ff]using (.+)$", rep = "Đang dung hợp %1" },
    { pat = "^[Uu]pgrading (.+)$", rep = "Đang nâng cấp %1" },
    { pat = "^[Bb]uying (.+)$", rep = "Đang mua %1" },
    { pat = "^[Cc]laiming (.+)$", rep = "Đang nhận %1" },
    { pat = "^[Ee]quipping (.+)$", rep = "Đang trang bị %1" },
    { pat = "^[Ff]avoriting (.+)$", rep = "Đang khóa bảo vệ %1" },
    { pat = "^[Ee]jecting (.+)$", rep = "Đang đẩy %1 ra" },
    { pat = "^[Cc]atching (.+)$", rep = "Đang bắt %1" },
    { pat = "^[Cc]hasing (.+)$", rep = "Đang đuổi theo %1" },
    { pat = "^[Aa]ttacking (.+)$", rep = "Đang tấn công %1" },
    { pat = "^[Hh]itting (.+)$", rep = "Đang đánh %1" },
    { pat = "^[Kk]illing (.+)$", rep = "Đang hạ %1" },
    { pat = "^[Tt]rading (.+) for (.+)$", rep = "Đang đổi %1 lấy %2" },
    { pat = "^[Tt]rading in (.+)$", rep = "Đang đổi %1" },
    { pat = "^[Tt]rading (.+)$", rep = "Đang giao dịch %1" },
    { pat = "^[Cc]rafting (.+)$", rep = "Đang chế tạo %1" },
    { pat = "^[Rr]erolling (.+)$", rep = "Đang đổi lại %1" },
    { pat = "^[Aa]voiding (.+)$", rep = "Đang né %1" },
    { pat = "^[Ee]vading (.+)$", rep = "Đang tránh %1" },
    { pat = "^[Ww]aiting for (.+)$", rep = "Đang chờ %1" },
    { pat = "^[Ww]aiting in (.+)$", rep = "Đang đợi ở %1" },
    { pat = "^[Ww]aiting %((.+)%)$", rep = "Đang chờ (%1)" },
    { pat = "^[Ss]earching for (.+)$", rep = "Đang tìm %1" },
    { pat = "^[Ll]ooking for (.+)$", rep = "Đang tìm %1" },
    { pat = "^[Ff]arming (.+)$", rep = "Đang cày %1" },
    { pat = "^[Uu]sing (.+)$", rep = "Đang dùng %1" },
    { pat = "^[Jj]oining (.+)$", rep = "Đang tham gia %1" },
    { pat = "^[Hh]opping (.+)$", rep = "Đang đổi %1" }
}

local FALLBACK_VERB_PREFIX_VI = {
    ["Carrying "] = "Đang mang ",
    ["Delivering "] = "Đang giao ",
    ["Stealing "] = "Đang cướp ",
    ["Going "] = "Đang đi ",
    ["Tweening "] = "Đang bay ",
    ["Teleporting "] = "Đang dịch chuyển ",
    ["Moving "] = "Đang di chuyển ",
    ["Walking "] = "Đang đi bộ ",
    ["Running "] = "Đang chạy ",
    ["Placing "] = "Đang đặt ",
    ["Hatching "] = "Đang ấp ",
    ["Mutating "] = "Đang đột biến ",
    ["Selling "] = "Đang bán ",
    ["Fusing "] = "Đang dung hợp ",
    ["Catching "] = "Đang bắt ",
    ["Chasing "] = "Đang đuổi theo ",
    ["Waiting "] = "Đang chờ ",
    ["Searching "] = "Đang tìm ",
    ["Claiming "] = "Đang nhận ",
    ["Upgrading "] = "Đang nâng cấp ",
    ["Buying "] = "Đang mua ",
    ["Trading "] = "Đang đổi ",
    ["Crafting "] = "Đang chế tạo ",
    ["Collecting "] = "Đang thu thập ",
    ["Holding "] = "Đang giữ ",
    ["Dropping "] = "Đang thả ",
    ["Returning "] = "Đang quay về ",
    ["Avoiding "] = "Đang né ",
    ["Evading "] = "Đang né ",
    ["Attacking "] = "Đang đánh ",
    ["Hitting "] = "Đang đánh "
}

local DYNAMIC_PATTERNS_VI = {
    { pat = "^QUICK BAR (%d+)$", rep = "THANH NHANH %1" },
    { pat = "^ALL (%d+)$", rep = "TẤT CẢ %1" },
    { pat = "^READY (%d+)$", rep = "SẴN SÀNG %1" },
    { pat = "^GROWING (%d+)$", rep = "ĐANG LỚN %1" },
    { pat = "^IN BAG (%d+)$", rep = "TRONG TÚI %1" },
    { pat = "Pen (%d+/%d+) · (%d+) egg%(s%) ready to place", rep = "Chuồng %1 · %2 trứng sẵn sàng đặt" },
    { pat = "(%d+) egg%(s%) can be mutated", rep = "%1 trứng có thể đột biến" },
    { pat = "(%d+) pet%(s%) match", rep = "%1 pet khớp bộ lọc" },
    { pat = "(%d+) egg%(s%) match", rep = "%1 trứng khớp bộ lọc" },
    { pat = "(%d+) lab egg%(s%) match", rep = "%1 trứng Lab khớp bộ lọc" },
    { pat = "^(%d+) pets$", rep = "%1 thú cưng" },
    { pat = "(%d+ / %d+) players · (.+)", rep = "%1 người chơi · %2" },
    { pat = "Experimental Pets · needs (.-) · pity (%d+/%d+) · rerolls (%d+) · (.+)", rep = "Pet Thí Nghiệm · cần %1 · bảo hiểm %2 · lượt đổi %3 · %4" },
    { pat = "Biohazard Pets · needs (.-) · pity (%d+/%d+) · rerolls (%d+) · (.+)", rep = "Pet Sinh Học · cần %1 · bảo hiểm %2 · lượt đổi %3 · %4" },
    { pat = "Unstable DNA · needs (.-) · pity (%d+/%d+) · rerolls (%d+) · (.+)", rep = "DNA Bất Ổn · cần %1 · bảo hiểm %2 · lượt đổi %3 · %4" },
    { pat = "^Mythic · 1 in ([%d%.]+)$", rep = "Thần Thoại · 1 trên %1" },
    { pat = "^Cosmic · 1 in ([%d%.]+)$", rep = "Vũ Trụ · 1 trên %1" },
    { pat = "^Secret · 1 in ([%d%.]+)$", rep = "Bí Ẩn · 1 trên %1" },
    { pat = "^Divine · 1 in ([%d%.]+)$", rep = "Thánh Thần · 1 trên %1" },
    { pat = "^Eternal · 1 in ([%d%.]+)$", rep = "Vĩnh Cửu · 1 trên %1" }
}

local function translateStatusAction(cleanEn)
    if not cleanEn or cleanEn == "" then return "Bá Khí" end
    if currentLanguage == "EN" then
        if cleanEn == "Bá khí" then return "Idle" end
        return cleanEn
    end

    local trimmed = (cleanEn:match("^%s*(.-)%s*$") or cleanEn):gsub("%s+", " ")
    if trimmed:lower() == "idle" or trimmed == "Bá khí" then
        return "Bá khí"
    end

    local cacheKey = "STATUS_VI|" .. trimmed
    if FastCache[cacheKey] then return FastCache[cacheKey] end

    if EXACT_MATCH_VI[trimmed] then
        FastCache[cacheKey] = EXACT_MATCH_VI[trimmed]
        return EXACT_MATCH_VI[trimmed]
    end

    for _, item in ipairs(STATUS_ACTION_PATTERNS_VI) do
        if trimmed:find(item.pat) then
            local out = trimmed:gsub(item.pat, item.rep)
            FastCache[cacheKey] = out
            return out
        end
    end

    local result = trimmed
    for engPrefix, viPrefix in pairs(FALLBACK_VERB_PREFIX_VI) do
        if result:sub(1, #engPrefix):lower() == engPrefix:lower() then
            result = viPrefix .. result:sub(#engPrefix + 1)
            break
        end
    end
    result = result:gsub(" home$", " về nhà")
                   :gsub(" to safe zone$", " về vùng an toàn")
                   :gsub(" to base$", " về căn cứ")

    FastCache[cacheKey] = result
    return result
end

local function translateVenyxText(raw)
    if not raw or raw == "" then return raw end
    local cacheKey = currentLanguage .. "|" .. raw
    if FastCache[cacheKey] then return FastCache[cacheKey] end

    if raw:find("Venyx SAE") then
        raw = raw:gsub("Venyx SAE", "Chilli SAE")
    elseif raw == "VENYX" then
        raw = NEW_TITLE
    end

    if currentLanguage == "EN" then
        FastCache[cacheKey] = raw
        return raw
    end

    local normalized = (raw:match("^%s*(.-)%s*$") or raw):gsub("%s+", " ")
    if EXACT_MATCH_VI[normalized] then
        local out = EXACT_MATCH_VI[normalized]
        FastCache[cacheKey] = out
        return out
    end

    local prefix, wordPart = normalized:match("^([^%w%s]+%s*)(.+)$")
    if prefix and wordPart and EXACT_MATCH_VI[wordPart] then
        local out = prefix .. EXACT_MATCH_VI[wordPart]
        FastCache[cacheKey] = out
        return out
    end

    local result = normalized
    for _, item in ipairs(DYNAMIC_PATTERNS_VI) do
        if result:find(item.pat) then
            result = result:gsub(item.pat, item.rep)
            FastCache[cacheKey] = result
            return result
        end
    end

    for _, item in ipairs(STATUS_ACTION_PATTERNS_VI) do
        if result:find(item.pat) then
            result = result:gsub(item.pat, item.rep)
            FastCache[cacheKey] = result
            return result
        end
    end

    FastCache[cacheKey] = raw
    return raw
end

local function applyElementTranslation(inst)
    if not (inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox")) then return end
    if inst:GetAttribute("__IslandDone") or inst:GetAttribute("__FpsHooked") or inst.Name == "IslandExpandHint" or inst:FindFirstAncestor("ChilliV5_ExpandedIsland") then return end
    if inst:GetAttribute("__IsTranslating") then return end

    if inst:IsA("TextBox") then
        local origPh = inst:GetAttribute("OrigPlaceholder")
        if not origPh and inst.PlaceholderText ~= "" then
            origPh = inst.PlaceholderText
            inst:SetAttribute("OrigPlaceholder", origPh)
        end
        if origPh then
            inst.PlaceholderText = translateVenyxText(origPh)
        end
        return
    end

    local rawText = inst.Text
    if isFpsCounterText(rawText) then
        hookFakeFpsCounter(inst)
        return
    end

    local original = inst:GetAttribute("OrigRawText")
    if not original then
        original = rawText
        inst:SetAttribute("OrigRawText", original)
    end

    local mapped = translateVenyxText(original)
    if inst.Text ~= mapped then
        inst:SetAttribute("__IsTranslating", true)
        inst:SetAttribute("__LastTranslated", mapped)
        pcall(function() inst.Text = mapped end)
        task.defer(function()
            inst:SetAttribute("__IsTranslating", false)
        end)
    end
end

local function hookTextForTranslation(inst)
    if not (inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox")) then return end
    if inst:GetAttribute("__IslandDone") or inst.Name == "IslandExpandHint" or inst:FindFirstAncestor("ChilliV5_ExpandedIsland") then return end

    if not inst:IsA("TextBox") and isFpsCounterText(inst.Text) then
        hookFakeFpsCounter(inst)
        return
    end

    applyElementTranslation(inst)

    if inst:GetAttribute("__TransHooked") then return end
    inst:SetAttribute("__TransHooked", true)
    table.insert(TrackedTexts, inst)

    inst:GetPropertyChangedSignal("Text"):Connect(function()
        if inst:GetAttribute("__IsTranslating") or inst:GetAttribute("__IslandDone") then return end
        if isFpsCounterText(inst.Text) then
            hookFakeFpsCounter(inst)
            return
        end
        if inst.Text ~= inst:GetAttribute("__LastTranslated") then
            inst:SetAttribute("OrigRawText", inst.Text)
            applyElementTranslation(inst)
        end
    end)
end

local function refreshAllTranslations()
    for i = #TrackedTexts, 1, -1 do
        local el = TrackedTexts[i]
        if el and el.Parent then
            applyElementTranslation(el)
        else
            table.remove(TrackedTexts, i)
        end
    end
    if GlobalRefreshIslandStatus then
        GlobalRefreshIslandStatus()
    end
end

-- ==================== 4. DYNAMIC ISLAND NỀN ĐEN (BỎ CHỮ "✨ rainbow") ====================
local function setupDynamicIslandFromStatus(statusLbl, venyxGui)
    local pill = statusLbl.Parent
    if not (pill and pill:IsA("GuiObject")) then return end

    local badHitbox = pill:FindFirstChild("IslandClickHitbox")
    if badHitbox then
        badHitbox:Destroy()
    end

    for _, child in ipairs(pill:GetChildren()) do
        if child:IsA("UIGradient") then
            child:Destroy()
        end
    end

    pill.BackgroundColor3 = ISLAND_BLACK_BG
    pill.BackgroundTransparency = 0
    pill.Size = UDim2.new(0, 0, 0, 28)
    pill.AutomaticSize = Enum.AutomaticSize.X

    if not pill:GetAttribute("__BlackBgLocked") then
        pill:SetAttribute("__BlackBgLocked", true)
        pill:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
            if pill.BackgroundColor3 ~= ISLAND_BLACK_BG then
                pill.BackgroundColor3 = ISLAND_BLACK_BG
            end
        end)
        pill:GetPropertyChangedSignal("BackgroundTransparency"):Connect(function()
            if pill.BackgroundTransparency ~= 0 then
                pill.BackgroundTransparency = 0
            end
        end)
    end

    local expandHint = pill:FindFirstChild("IslandExpandHint")
    if not expandHint then
        expandHint = Instance.new("TextLabel")
        expandHint.Name = "IslandExpandHint"
        expandHint.Size = UDim2.new(0, 18, 0, 18)
        expandHint.BackgroundColor3 = Color3.fromRGB(28, 32, 48)
        expandHint.BorderSizePixel = 0
        expandHint.Text = "▼"
        expandHint.Font = Enum.Font.GothamBold
        expandHint.TextSize = 9
        expandHint.TextColor3 = Color3.fromRGB(165, 210, 255)
        expandHint.LayoutOrder = 99
        expandHint.ZIndex = 10000
        expandHint.Parent = pill

        local hintCorner = Instance.new("UICorner")
        hintCorner.CornerRadius = UDim.new(1, 0)
        hintCorner.Parent = expandHint

        local hintStroke = Instance.new("UIStroke")
        hintStroke.Thickness = 1
        hintStroke.Color = Color3.fromRGB(90, 130, 200)
        hintStroke.Parent = expandHint
    end

    local function updateStatusText(forceFromSavedOrig)
        if statusLbl:GetAttribute("__Updating") then return end
        statusLbl:SetAttribute("__Updating", true)

        local cleanEn
        if forceFromSavedOrig and statusLbl:GetAttribute("OrigStatusEn") then
            cleanEn = statusLbl:GetAttribute("OrigStatusEn")
        else
            local raw = statusLbl:GetAttribute("OrigRawText") or statusLbl.Text
            cleanEn = raw:gsub("●", ""):gsub("•", ""):gsub("✨%s*rainbow", ""):match("^%s*(.-)%s*$") or "Idle"
            if cleanEn == "" or cleanEn == "Bá khí" then cleanEn = "Idle" end
            if statusLbl.Text ~= statusLbl:GetAttribute("__LastTranslatedStatus") then
                local currentRaw = statusLbl.Text:gsub("●", ""):gsub("•", ""):gsub("✨%s*rainbow", ""):match("^%s*(.-)%s*$") or ""
                if currentRaw ~= "" and currentRaw ~= "Bá khí" then
                    cleanEn = currentRaw
                end
                statusLbl:SetAttribute("OrigStatusEn", cleanEn)
            else
                cleanEn = statusLbl:GetAttribute("OrigStatusEn") or cleanEn
            end
        end

        local translatedStatus = translateStatusAction(cleanEn)
        statusLbl:SetAttribute("__LastTranslatedStatus", translatedStatus)

        statusLbl.Text = translatedStatus
        statusLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        statusLbl.TextTransparency = 0
        statusLbl.Size = UDim2.new(0, 0, 1, 0)
        statusLbl.AutomaticSize = Enum.AutomaticSize.X

        task.defer(function()
            statusLbl:SetAttribute("__Updating", false)
        end)
    end

    GlobalRefreshIslandStatus = function()
        updateStatusText(true)
    end

    if statusLbl:GetAttribute("__IslandDone") and venyxGui:FindFirstChild("ChilliV5_ExpandedIsland") then
        updateStatusText(true)
        return
    end
    statusLbl:SetAttribute("__IslandDone", true)

    updateStatusText(false)

    local txtGrad = statusLbl:FindFirstChild("TextRainbow") or Instance.new("UIGradient")
    txtGrad.Name = "TextRainbow"
    txtGrad.Color = COLOR_SEQ_RAINBOW
    txtGrad.Parent = statusLbl
    table.insert(ActiveGradients, txtGrad)

    pill.Parent = venyxGui
    pill.AnchorPoint = Vector2.new(0.5, 0)
    pill.Position = UDim2.new(0.5, 0, 0, 10)
    pill.ZIndex = 9999
    pill.Active = true
    statusLbl.Active = true
    expandHint.Active = true

    local pillCorner = pill:FindFirstChildOfClass("UICorner") or Instance.new("UICorner")
    pillCorner.CornerRadius = UDim.new(1, 0)
    pillCorner.Parent = pill

    local pillStroke = pill:FindFirstChild("IslandStroke") or Instance.new("UIStroke")
    pillStroke.Name = "IslandStroke"
    pillStroke.Thickness = 1.6
    pillStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    pillStroke.Color = Color3.fromRGB(255, 255, 255)
    pillStroke.Parent = pill

    local strokeGrad = pillStroke:FindFirstChildOfClass("UIGradient") or Instance.new("UIGradient")
    strokeGrad.Color = COLOR_SEQ_RAINBOW
    strokeGrad.Parent = pillStroke
    table.insert(ActiveGradients, strokeGrad)

    -- TẠO BẢNG DYNAMIC ISLAND PHÓNG TO (NỀN ĐEN TUYỀN #000000)
    local oldExp = venyxGui:FindFirstChild("ChilliV5_ExpandedIsland")
    if oldExp then oldExp:Destroy() end

    local ExpandedIsland = Instance.new("Frame")
    ExpandedIsland.Name = "ChilliV5_ExpandedIsland"
    ExpandedIsland.AnchorPoint = Vector2.new(0.5, 0)
    ExpandedIsland.Position = pill.Position
    ExpandedIsland.Size = UDim2.new(0, 260, 0, 78)
    ExpandedIsland.BackgroundColor3 = ISLAND_BLACK_BG
    ExpandedIsland.BackgroundTransparency = 0
    ExpandedIsland.BorderSizePixel = 0
    ExpandedIsland.Visible = false
    ExpandedIsland.Active = true
    ExpandedIsland.ZIndex = 10000
    ExpandedIsland.Parent = venyxGui

    local ExpCorner = Instance.new("UICorner")
    ExpCorner.CornerRadius = UDim.new(0, 16)
    ExpCorner.Parent = ExpandedIsland

    local ExpStroke = Instance.new("UIStroke")
    ExpStroke.Thickness = 1.6
    ExpStroke.Color = Color3.fromRGB(255, 255, 255)
    ExpStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    ExpStroke.Parent = ExpandedIsland

    local ExpStrokeGrad = Instance.new("UIGradient")
    ExpStrokeGrad.Color = COLOR_SEQ_RAINBOW
    ExpStrokeGrad.Parent = ExpStroke
    table.insert(ActiveGradients, ExpStrokeGrad)

    local ExpTitle = Instance.new("TextLabel")
    ExpTitle.Size = UDim2.new(1, -44, 0, 28)
    ExpTitle.Position = UDim2.new(0, 14, 0, 4)
    ExpTitle.BackgroundTransparency = 1
    ExpTitle.Text = "🌶️ Chilli Hub V5"
    ExpTitle.Font = Enum.Font.GothamBold
    ExpTitle.TextSize = 11.5
    ExpTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    ExpTitle.TextXAlignment = Enum.TextXAlignment.Left
    ExpTitle.ZIndex = 10001
    ExpTitle.Parent = ExpandedIsland

    local CollapseBtn = Instance.new("TextButton")
    CollapseBtn.Size = UDim2.new(0, 24, 0, 22)
    CollapseBtn.Position = UDim2.new(1, -32, 0, 7)
    CollapseBtn.BackgroundColor3 = Color3.fromRGB(22, 24, 34)
    CollapseBtn.BorderSizePixel = 0
    CollapseBtn.Text = "▲"
    CollapseBtn.Font = Enum.Font.GothamBold
    CollapseBtn.TextSize = 10
    CollapseBtn.TextColor3 = Color3.fromRGB(160, 205, 255)
    CollapseBtn.ZIndex = 10002
    CollapseBtn.Parent = ExpandedIsland

    local CollapseCorner = Instance.new("UICorner")
    CollapseCorner.CornerRadius = UDim.new(1, 0)
    CollapseCorner.Parent = CollapseBtn

    local LangCapsule = Instance.new("Frame")
    LangCapsule.Size = UDim2.new(1, -20, 0, 34)
    LangCapsule.Position = UDim2.new(0, 10, 0, 36)
    LangCapsule.BackgroundColor3 = Color3.fromRGB(18, 20, 30)
    LangCapsule.BorderSizePixel = 0
    LangCapsule.ZIndex = 10001
    LangCapsule.Parent = ExpandedIsland

    local LangCorner = Instance.new("UICorner")
    LangCorner.CornerRadius = UDim.new(1, 0)
    LangCorner.Parent = LangCapsule

    local LangSlider = Instance.new("Frame")
    LangSlider.Size = UDim2.new(0.5, -4, 1, -4)
    LangSlider.Position = UDim2.new(0, 2, 0, 2)
    LangSlider.BackgroundColor3 = Color3.fromRGB(95, 110, 235)
    LangSlider.BorderSizePixel = 0
    LangSlider.ZIndex = 10002
    LangSlider.Parent = LangCapsule

    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(1, 0)
    SliderCorner.Parent = LangSlider

    local BtnVI = Instance.new("TextButton")
    BtnVI.Size = UDim2.new(0.5, 0, 1, 0)
    BtnVI.Position = UDim2.new(0, 0, 0, 0)
    BtnVI.BackgroundTransparency = 1
    BtnVI.Text = "🇻🇳 TIẾNG VIỆT"
    BtnVI.Font = Enum.Font.GothamBold
    BtnVI.TextSize = 10.5
    BtnVI.TextColor3 = Color3.fromRGB(255, 255, 255)
    BtnVI.ZIndex = 10003
    BtnVI.Parent = LangCapsule

    local BtnEN = Instance.new("TextButton")
    BtnEN.Size = UDim2.new(0.5, 0, 1, 0)
    BtnEN.Position = UDim2.new(0.5, 0, 0, 0)
    BtnEN.BackgroundTransparency = 1
    BtnEN.Text = "🌐 ENGLISH"
    BtnEN.Font = Enum.Font.GothamBold
    BtnEN.TextSize = 10.5
    BtnEN.TextColor3 = Color3.fromRGB(150, 165, 190)
    BtnEN.ZIndex = 10003
    BtnEN.Parent = LangCapsule

    local function setLanguage(lang)
        if currentLanguage == lang then return end
        currentLanguage = lang

        if lang == "VI" then
            TweenService:Create(LangSlider, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, 2, 0, 2)
            }):Play()
            BtnVI.TextColor3 = Color3.fromRGB(255, 255, 255)
            BtnEN.TextColor3 = Color3.fromRGB(150, 165, 190)
        else
            TweenService:Create(LangSlider, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = UDim2.new(0.5, 2, 0, 2)
            }):Play()
            BtnEN.TextColor3 = Color3.fromRGB(255, 255, 255)
            BtnVI.TextColor3 = Color3.fromRGB(150, 165, 190)
        end

        refreshAllTranslations()
    end

    BtnVI.MouseButton1Click:Connect(function() setLanguage("VI") end)
    BtnEN.MouseButton1Click:Connect(function() setLanguage("EN") end)

    local function toggleIsland(expand)
        if expand then
            ExpandedIsland.Position = pill.Position
            pill.Visible = false
            ExpandedIsland.Size = UDim2.new(0, 150, 0, 28)
            ExpandedIsland.Visible = true
            TweenService:Create(ExpandedIsland, TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 260, 0, 78)
            }):Play()
        else
            pill.Position = ExpandedIsland.Position
            ExpandedIsland.Visible = false
            pill.Visible = true
        end
    end

    CollapseBtn.MouseButton1Click:Connect(function()
        toggleIsland(false)
    end)

    local function attachDragAndClick(triggerObj, moveFrame, onTapCallback)
        if triggerObj:GetAttribute("__DragBound") then return end
        triggerObj:SetAttribute("__DragBound", true)

        local dragging, dragStart, startPos, moved = false, nil, nil, false

        triggerObj.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                moved = false
                dragStart = input.Position
                startPos = moveFrame.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        if dragging and not moved and onTapCallback then
                            onTapCallback()
                        end
                        dragging = false
                    end
                end)
            end
        end)

        triggerObj.InputChanged:Connect(function(input)
            if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragging then
                local delta = input.Position - dragStart
                if delta.Magnitude > 6 then
                    moved = true
                end
                local cam = workspace.CurrentCamera
                local maxX = cam and cam.ViewportSize.X - 140 or 800
                local maxY = cam and cam.ViewportSize.Y - 50 or 600
                local newX = math.clamp(startPos.X.Offset + delta.X, -maxX / 2, maxX / 2)
                local newY = math.clamp(startPos.Y.Offset + delta.Y, 4, maxY)
                local newPos = UDim2.new(startPos.X.Scale, newX, startPos.Y.Scale, newY)
                pill.Position = newPos
                ExpandedIsland.Position = newPos
            end
        end)
    end

    local openCallback = function() toggleIsland(true) end
    attachDragAndClick(pill, pill, openCallback)
    attachDragAndClick(statusLbl, pill, openCallback)
    attachDragAndClick(expandHint, pill, openCallback)
    attachDragAndClick(ExpandedIsland, ExpandedIsland, nil)

    statusLbl:GetPropertyChangedSignal("Text"):Connect(function()
        if not statusLbl:GetAttribute("__Updating") and statusLbl.Text ~= statusLbl:GetAttribute("__LastTranslatedStatus") then
            updateStatusText(false)
        end
    end)
end

-- ==================== 5. NÚT TRÒN NỔI 1:1 (GIỮ NGUYÊN TUYỆT ĐỐI) ====================
local function setupUnclippedCircularLogo(img)
    if img:GetAttribute("__FloatingLogoV5Perfect") then return end

    local topPanel = img
    while topPanel.Parent and topPanel.Parent:IsA("GuiObject") and not topPanel.Parent:IsA("ScreenGui") do
        topPanel = topPanel.Parent
    end

    if topPanel:FindFirstChildWhichIsA("TextLabel", true) or topPanel.AbsoluteSize.X > 130 or topPanel.AbsolutePosition.X > 350 then
        return
    end

    img:SetAttribute("__FloatingLogoV5Perfect", true)

    local container = img
    while container.Parent and container.Parent:IsA("GuiObject") and not container.Parent:IsA("ScreenGui") do
        if container.Parent.AbsoluteSize.X <= 130 and container.Parent.AbsoluteSize.Y <= 130 then
            container = container.Parent
        else
            break
        end
    end

    for _, child in ipairs(container:GetDescendants()) do
        if child:IsA("UIPadding") or child:IsA("UIAspectRatioConstraint") or child:IsA("UISizeConstraint") then
            if child.Name ~= "PerfectCircleAspect" then
                pcall(function() child:Destroy() end)
            end
        end
        if child.Name == "InnerChilliLogo" or child.Name == "ChilliFullInnerLogo" then
            pcall(function() child:Destroy() end)
        end
    end

    container.Size = UDim2.new(0, 60, 0, 60)
    container.BackgroundColor3 = LOGO_BG_COLOR
    container.BackgroundTransparency = 0
    container.BorderSizePixel = 0
    container.ClipsDescendants = true

    local aspect = container:FindFirstChild("PerfectCircleAspect") or Instance.new("UIAspectRatioConstraint")
    aspect.Name = "PerfectCircleAspect"
    aspect.AspectRatio = 1
    aspect.Parent = container

    local cCorner = container:FindFirstChildOfClass("UICorner") or Instance.new("UICorner")
    cCorner.CornerRadius = UDim.new(1, 0)
    cCorner.Parent = container

    if not container:GetAttribute("__SizeLocked") then
        container:SetAttribute("__SizeLocked", true)
        container:GetPropertyChangedSignal("Size"):Connect(function()
            if container.Size ~= UDim2.new(0, 60, 0, 60) then
                container.Size = UDim2.new(0, 60, 0, 60)
            end
        end)
    end

    local stroke = container:FindFirstChild("RainbowBorder") or Instance.new("UIStroke")
    stroke.Name = "RainbowBorder"
    stroke.Thickness = 2.5
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Parent = container

    local strokeGrad = stroke:FindFirstChildOfClass("UIGradient") or Instance.new("UIGradient")
    strokeGrad.Color = COLOR_SEQ_RAINBOW
    strokeGrad.Parent = stroke
    table.insert(ActiveGradients, strokeGrad)

    for _, desc in ipairs(container:GetDescendants()) do
        if (desc:IsA("ImageLabel") or desc:IsA("ImageButton")) and desc.Name ~= "ChilliV5CoverLogo" then
            desc.ImageTransparency = 1
            desc.BackgroundTransparency = 1
        end
    end
    if container:IsA("ImageLabel") or container:IsA("ImageButton") then
        container.ImageTransparency = 1
    end

    local coverLogo = container:FindFirstChild("ChilliV5CoverLogo") or Instance.new("ImageLabel")
    coverLogo.Name = "ChilliV5CoverLogo"
    coverLogo.Size = UDim2.new(1, 0, 1, 0)
    coverLogo.Position = UDim2.new(0.5, 0, 0.5, 0)
    coverLogo.AnchorPoint = Vector2.new(0.5, 0.5)
    coverLogo.BackgroundTransparency = 1
    coverLogo.Image = CHILLI_LOGO_ID
    coverLogo.ImageTransparency = 0
    coverLogo.ScaleType = Enum.ScaleType.Fit
    coverLogo.Active = false
    coverLogo.ZIndex = container.ZIndex + 5
    coverLogo.Parent = container

    local logoCorner = coverLogo:FindFirstChildOfClass("UICorner") or Instance.new("UICorner")
    logoCorner.CornerRadius = UDim.new(1, 0)
    logoCorner.Parent = coverLogo
end

local function cleanupAccidentalQuickBarLogos(gui)
    for _, desc in ipairs(gui:GetDescendants()) do
        if desc.Name == "ChilliV5CoverLogo" then
            local topPanel = desc
            while topPanel.Parent and topPanel.Parent:IsA("GuiObject") and not topPanel.Parent:IsA("ScreenGui") do
                topPanel = topPanel.Parent
            end
            if topPanel:FindFirstChildWhichIsA("TextLabel", true) then
                local parentBox = desc.Parent
                desc:Destroy()
                if parentBox then
                    local rb = parentBox:FindFirstChild("RainbowBorder")
                    if rb then rb:Destroy() end
                    local pa = parentBox:FindFirstChild("PerfectCircleAspect")
                    if pa then pa:Destroy() end
                    parentBox.BackgroundTransparency = 1
                end
            end
        end
    end
end

-- ==================== 6. BỘ QUÉT ĐỊNH VỊ & DỊCH THUẬT AN TOÀN ====================
local function tryPatchVenyx()
    for _, root in ipairs(roots) do
        if root then
            for _, gui in ipairs(root:GetChildren()) do
                if gui:IsA("ScreenGui") and gui.Name ~= "RobloxGui" and gui.Name ~= "TopBarApp" then
                    -- Quét bắt thanh FPS (59 FPS - 97 ms) trên mọi ScreenGui của Venyx
                    for _, d in ipairs(gui:GetDescendants()) do
                        if (d:IsA("TextLabel") or d:IsA("TextButton")) and isFpsCounterText(d.Text) then
                            hookFakeFpsCounter(d)
                        end
                    end

                    local titleLbl = nil
                    for _, d in ipairs(gui:GetDescendants()) do
                        if (d:IsA("TextLabel") or d:IsA("TextButton")) and not d:FindFirstAncestorOfClass("ScrollingFrame") then
                            local t = d.Text
                            if t == "VENYX" or t == NEW_TITLE then
                                titleLbl = d
                                break
                            end
                        end
                    end

                    if titleLbl then
                        cleanupAccidentalQuickBarLogos(gui)

                        -- 1. Đổi tên tiêu đề
                        if titleLbl.Text ~= NEW_TITLE then
                            titleLbl.Text = NEW_TITLE
                            titleLbl.AutomaticSize = Enum.AutomaticSize.X
                        end

                        -- Tìm khung Main Window (kích thước lớn >= 350x220)
                        local mainWindow = nil
                        local curr = titleLbl
                        while curr.Parent and curr.Parent ~= gui do
                            curr = curr.Parent
                            if curr:IsA("GuiObject") and curr.AbsoluteSize.X >= 350 and curr.AbsoluteSize.Y >= 220 then
                                mainWindow = curr
                            end
                        end

                        local headerY = titleLbl.AbsolutePosition.Y

                        -- Bắt sự kiện cho các phần tử Text khi mở Dropdown / Modal / Quick Bar mới
                        if not gui:GetAttribute("__TextListenerAttached") then
                            gui:SetAttribute("__TextListenerAttached", true)
                            gui.DescendantAdded:Connect(function(newDesc)
                                if newDesc:IsA("TextLabel") or newDesc:IsA("TextButton") or newDesc:IsA("TextBox") then
                                    task.defer(function()
                                        hookTextForTranslation(newDesc)
                                    end)
                                end
                            end)
                        end

                        -- Quét có kiểm soát bên trong ScreenGui của Venyx
                        for _, desc in ipairs(gui:GetDescendants()) do
                            if desc:IsA("TextLabel") or desc:IsA("TextButton") or desc:IsA("TextBox") then
                                local txt = desc.Text or ""
                                local origTxt = desc:GetAttribute("OrigRawText") or ""
                                local isAlreadyMovedIdle = desc:GetAttribute("__IslandDone")

                                -- 2. SỬA ĐÚNG VỊ TRÍ LỖI MẤT DYNAMIC ISLAND:
                                -- Bắt chuẩn cả khi chữ còn là "Idle" hoặc đã dịch sang "Bá Khí",
                                -- đồng thời đảm bảo desc.Parent không chứa titleLbl (chặn bốc nhầm Header)
                                local isStatusKeyword = txt:lower():find("idle")
                                    or origTxt:lower():find("idle")
                                    or txt == "Bá Khí"

                                local isHeaderIdle = (not gui:GetAttribute("__IslandLocked"))
                                    and (not desc:FindFirstAncestorOfClass("ScrollingFrame"))
                                    and desc.Parent
                                    and (not titleLbl:IsDescendantOf(desc.Parent))
                                    and math.abs(desc.AbsolutePosition.Y - headerY) < 35
                                    and desc.AbsolutePosition.X > titleLbl.AbsolutePosition.X + 60
                                    and isStatusKeyword

                                if isHeaderIdle or isAlreadyMovedIdle then
                                    gui:SetAttribute("__IslandLocked", true)
                                    setupDynamicIslandFromStatus(desc, gui)
                                else
                                    hookTextForTranslation(desc)
                                end

                            elseif (desc:IsA("ImageLabel") or desc:IsA("ImageButton"))
                            and desc.Name ~= "ChilliV5CoverLogo"
                            and desc.Name ~= "InnerChilliLogo" then
                                if not desc:FindFirstAncestorOfClass("ScrollingFrame") then
                                    -- 3. Đổi Logo nhỏ trên thanh Header (bên trái tiêu đề)
                                    if math.abs(desc.AbsolutePosition.Y - headerY) < 35 and desc.AbsolutePosition.X < titleLbl.AbsolutePosition.X then
                                        if desc.Image ~= CHILLI_LOGO_ID then
                                            desc.Image = CHILLI_LOGO_ID
                                            desc.BackgroundTransparency = 1
                                            desc.ScaleType = Enum.ScaleType.Fit
                                        end

                                    -- 4. Định vị đúng Nút Tròn Nổi bên ngoài Main Window
                                    elseif mainWindow and not desc:IsDescendantOf(mainWindow) then
                                        setupUnclippedCircularLogo(desc)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

-- Chạy kiểm tra nhịp nhàng mỗi 0.5s trong 10 giây đầu
task.spawn(function()
    for _ = 1, 20 do
        pcall(tryPatchVenyx)
        task.wait(0.5)
    end
end)
