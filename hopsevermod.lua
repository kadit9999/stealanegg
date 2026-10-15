loadstring(game:HttpGet("https://raw.githubusercontent.com/Makuscripts/StealAnEgg/refs/heads/main/FreePrivateServer.lua"))()

-- Đoạn code dưới đây dùng để dịch menu sang tiếng Việt
-- Lưu ý: Cần đảm bảo script gốc đã tải xong trước khi chạy phần này.
task.wait(1) -- Đợi 1 giây để UI hiện ra

-- Tìm và thay đổi các thành phần text trên UI
for _, v in pairs(game:GetService("CoreGui"):GetDescendants()) do
    if v:IsA("TextLabel") or v:IsA("TextButton") then
        if v.Text == "Private Server Script" then
            v.Text = "Script Server Riêng"
        elseif v.Text == "Made By Makuscripts" then
            v.Text = "Được tạo bởi Makuscripts"
        elseif v.Text == "Player Count: 2" then
            v.Text = "Số người chơi: 2"
        elseif v.Text == "Set a number to bypass server." then
            v.Text = "Đặt số lượng để bỏ qua server."
        elseif v.Text == "Hop if players in this server are MORE than:" then
            v.Text = "Chuyển nếu số người trong server này NHIỀU HƠN:"
        elseif v.Text == "Hop Once" then
            v.Text = "Chuyển 1 lần"
        elseif v.Text == "Auto Hop: OFF" then
            v.Text = "Tự động chuyển: TẮT"
        elseif v.Text == "Auto Hop: ON" then
            v.Text = "Tự động chuyển: BẬT"
        end
    end
end
