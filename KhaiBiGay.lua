--------------------------------------------------------------------
------------------------[ LAG REDUCER SCRIPT ]-----------------------
--// ⚡ Ultimate LagFix + FX Cleaner + Cinematic Intro — by VNTK

local player=game.Players.LocalPlayer
local Lighting=game:GetService("Lighting")
local TweenService=game:GetService("TweenService")

--== GUI setup ==
local gui=Instance.new("ScreenGui",player:WaitForChild("PlayerGui"))
gui.IgnoreGuiInset=true gui.ResetOnSpawn=false gui.Name="LagIntro"

-- hiệu ứng blur nền
local blur=Instance.new("BlurEffect",Lighting)
blur.Size=0
TweenService:Create(blur,TweenInfo.new(.6,Enum.EasingStyle.Sine),{Size=25}):Play()

--== text ==
local text=Instance.new("TextLabel",gui)
text.AnchorPoint=Vector2.new(0.5,0.5)
text.Position=UDim2.new(0.5,0,0.5,0)
text.BackgroundTransparency=1
text.TextColor3=Color3.fromRGB(255,255,255)
text.TextScaled=true
text.Font=Enum.Font.FredokaOne
text.TextTransparency=1

-- glow xanh nhẹ
local glow=Instance.new("UIStroke",text)
glow.Thickness=2
glow.Color=Color3.fromRGB(0,180,255)
glow.Transparency=0.4

local function cinematicShow(txt,time,dur)
	text.Text=txt
	text.Size=UDim2.new(0,0,0.2,0)
	text.TextTransparency=1
	local grow=TweenService:Create(text,TweenInfo.new(.6,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),
		{Size=UDim2.new(0.9,0,0.25,0),TextTransparency=0})
	local shrink=TweenService:Create(text,TweenInfo.new(.4,Enum.EasingStyle.Sine,Enum.EasingDirection.In),
		{Size=UDim2.new(0.5,0,0.18,0),TextTransparency=1})
	grow:Play() task.wait(time) shrink:Play()
	task.wait(dur or 0)
end

-- intro text
cinematicShow("Script Fix Lag by VNTK",1.1,0.25)
cinematicShow("Let's gooo",0.65,0.25)

TweenService:Create(blur,TweenInfo.new(1.3,Enum.EasingStyle.Sine),{Size=0}):Play()
task.wait(1.3)
blur:Destroy() gui:Destroy()

--== Fix Lag ==
pcall(function()
	Lighting.GlobalShadows=false
	Lighting.Brightness=0
	Lighting.FogEnd=9e9
	Lighting.FogStart=0
	Lighting.ClockTime=12
	Lighting.Ambient=Color3.new(1,1,1)
	Lighting.OutdoorAmbient=Color3.new(1,1,1)
	for _,v in ipairs(Lighting:GetChildren())do
		if v:IsA("Sky")or v:IsA("Atmosphere")or v:IsA("BloomEffect")
		or v:IsA("ColorCorrectionEffect")or v:IsA("SunRaysEffect")
		or v:IsA("DepthOfFieldEffect")or v:IsA("BlurEffect")then v:Destroy()end
	end
end)

for _,v in ipairs(game:GetDescendants())do
	pcall(function()
		if v:IsA("BasePart")then
			v.Material=Enum.Material.Plastic v.CastShadow=false v.Reflectance=0 v.LocalTransparencyModifier=1
		elseif v:IsA("Decal")or v:IsA("Texture")then v.Transparency=1
		elseif v:IsA("ParticleEmitter")or v:IsA("Trail")or v:IsA("Beam")
		or v:IsA("Smoke")or v:IsA("Fire")or v:IsA("Sparkles")then v.Enabled=false
		end
	end)
end

game.DescendantAdded:Connect(function(v)
	pcall(function()
		if v:IsA("BasePart")then
			v.Material=Enum.Material.Plastic v.CastShadow=false v.LocalTransparencyModifier=1
		elseif v:IsA("Decal")or v:IsA("Texture")then v.Transparency=1
		elseif v:IsA("ParticleEmitter")or v:IsA("Trail")or v:IsA("Beam")
		or v:IsA("Smoke")or v:IsA("Fire")or v:IsA("Sparkles")then v.Enabled=false end
	end)
end)

--== ⚡ FX Cleaner ==
local function clearFX(v)
	pcall(function()
		if v:IsA("ParticleEmitter") or v:IsA("Beam") or v:IsA("Trail") or v:IsA("Attachment")
		or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Explosion") or v:IsA("Sparkles")
		or v:IsA("Sound") or v:IsA("Light") then
			v:Destroy()
		end
	end)
end

-- dọn sẵn
for _,v in ipairs(game:GetDescendants()) do clearFX(v) end
-- auto dọn hiệu ứng mới
game.DescendantAdded:Connect(clearFX)

print("[✅] FX Cleaner: Tất cả hiệu ứng chiêu đã bị xoá hoàn toàn.")
print("[✅] LagFix Auto by VNTK — Ultra Performance Mode ON")
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

