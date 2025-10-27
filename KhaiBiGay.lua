--------------------------------------------------------------------
------------------------[ LAG REDUCER SCRIPT ]-----------------------
--// ☠️ Invisible Map Mode (Keep Player Safe) — by VNTK
-- Giữ nguyên character của player, xóa mọi thứ khác trong workspace
-- ⚠️ Lưu ý: map vẫn bị xóa hoàn toàn (rejoin để phục hồi)

local player = game.Players.LocalPlayer
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")

-- == intro (giữ nguyên hiệu ứng cũ) ==
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.Name = "LagIntro"

local blur = Instance.new("BlurEffect", Lighting)
blur.Size = 0
TweenService:Create(blur, TweenInfo.new(.6, Enum.EasingStyle.Sine), {Size = 25}):Play()

local text = Instance.new("TextLabel", gui)
text.AnchorPoint = Vector2.new(0.5, 0.5)
text.Position = UDim2.new(0.5, 0, 0.5, 0)
text.BackgroundTransparency = 1
text.TextColor3 = Color3.fromRGB(255,255,255)
text.TextScaled = true
text.Font = Enum.Font.FredokaOne
text.TextTransparency = 1

local glow = Instance.new("UIStroke", text)
glow.Thickness = 2
glow.Color = Color3.fromRGB(0,180,255)
glow.Transparency = 0.4

local function cinematicShow(txt, time, dur)
	text.Text = txt
	text.Size = UDim2.new(0,0,0.2,0)
	text.TextTransparency = 1
	local grow = TweenService:Create(text, TweenInfo.new(.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
		{Size = UDim2.new(0.9,0,0.25,0), TextTransparency = 0})
	local shrink = TweenService:Create(text, TweenInfo.new(.4, Enum.EasingStyle.Sine, Enum.EasingDirection.In),
		{Size = UDim2.new(0.5,0,0.18,0), TextTransparency = 1})
	grow:Play()
	task.wait(time)
	shrink:Play()
	task.wait(dur or 0)
end

cinematicShow("Script Fix Lag by VNTK", 1.1, 0.25)
cinematicShow("Enjoy :))", 0.65, 0.25)

TweenService:Create(blur, TweenInfo.new(1.3, Enum.EasingStyle.Sine), {Size = 0}):Play()
task.wait(1.4)
gui:Destroy()
blur:Destroy()

-- == Bảo vệ player ==
local function isProtected(inst)
	-- bảo vệ character hiện tại (nếu có)
	local char = player.Character
	if char and (inst == char or inst:IsDescendantOf(char)) then
		return true
	end
	-- bảo vệ CurrentCamera (tránh hỏng view)
	if workspace.CurrentCamera and (inst == workspace.CurrentCamera or inst:IsDescendantOf(workspace.CurrentCamera)) then
		return true
	end
	-- bảo vệ PlayerGui & Player objects (nếu có thể)
	if inst:IsDescendantOf(player) or inst:IsDescendantOf(player:FindFirstChild("PlayerGui") or {}) then
		return true
	end
	-- giữ các thứ quan trọng khác (nếu cần mở rộng)
	return false
end

-- == Xóa/clear Lighting effects ==
pcall(function()
	for _, v in ipairs(Lighting:GetChildren()) do
		if v:IsA("Sky") or v:IsA("Atmosphere") or v:IsA("BloomEffect")
		or v:IsA("ColorCorrectionEffect") or v:IsA("SunRaysEffect")
		or v:IsA("DepthOfFieldEffect") or v:IsA("BlurEffect") then
			v:Destroy()
		end
	end
	Lighting.FogEnd = 1
	Lighting.GlobalShadows = false
	Lighting.Brightness = 0
	Lighting.Ambient = Color3.new(0,0,0)
	Lighting.OutdoorAmbient = Color3.new(0,0,0)
end)

-- == Hủy map (an toàn) ==
local function wipeChild(child)
	if not child then return end
	-- không chạm vào phần tử được bảo vệ
	if isProtected(child) then return end
	-- Terrain: clear, không destroy workspace.Terrain object (an toàn hơn)
	if child:IsA("Terrain") or child:IsA("TerrainRegion") then
		pcall(function() workspace.Terrain:Clear() end)
		return
	end
	-- nếu là model hoặc folder thì destroy toàn bộ (nếu không protected)
	pcall(function()
		child:Destroy()
	end)
end

-- Xóa tất cả children của workspace ngoại trừ player character và các object bảo vệ
for _, c in ipairs(workspace:GetChildren()) do
	-- skip Lighting-like or services accidentally parented (nếu có)
	if c ~= workspace.CurrentCamera then
		wipeChild(c)
	end
end

-- Nếu có object mới được spawn vào workspace, xóa nếu không phải của player
workspace.ChildAdded:Connect(function(c)
	-- đợi 1 tick để nếu đó là character thì isProtected nhận diện được
	task.wait(0.05)
	if not isProtected(c) then
		-- nếu là Terrain, clear
		if c:IsA("Terrain") then
			pcall(function() workspace.Terrain:Clear() end)
			return
		end
		pcall(function() c:Destroy() end)
	end
end)

-- Ngoài ra xóa các texture/decals/effect còn sót
for _, v in ipairs(game:GetDescendants()) do
	pcall(function()
		if isProtected(v) then return end
		if v:IsA("Decal") or v:IsA("Texture") or v:IsA("SurfaceAppearance") then
			v:Destroy()
		elseif v:IsA("ParticleEmitter") or v:IsA("Beam") or v:IsA("Trail")
			or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
			v:Destroy()
		end
	end)
end

-- Hiển thị thông báo nhỏ góc phải
local notif = Instance.new("TextLabel", player:WaitForChild("PlayerGui"))
notif.AnchorPoint = Vector2.new(1,1)
notif.Position = UDim2.new(1, -15, 1, -10)
notif.BackgroundTransparency = 1
notif.TextColor3 = Color3.fromRGB(0,255,100)
notif.Font = Enum.Font.GothamBold
notif.TextSize = 20
notif.Text = "LagFix Mode Activated ✅"
notif.TextTransparency = 1
TweenService:Create(notif, TweenInfo.new(0.6), {TextTransparency = 0}):Play()
task.wait(3)
TweenService:Create(notif, TweenInfo.new(0.6), {TextTransparency = 1}):Play()

print("[✅] Safe Invisible Map: map removed, player preserved.")

--------------------------------------------------------------------
--------------------------[ FPS + PING GUI KÍNH ]--------------------
--// Dynamic Island Hover + Soft Shadow — by PhanGiaHuy 🍎
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
--== M vào đây lm j v????? xem code à. Nếu xem thì cứ xem thoải mái :))))
--------------------------------------------------------------------

