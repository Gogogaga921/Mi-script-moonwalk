-- Moonwalk con botón en pantalla (LocalScript)
-- Colócalo en StarterPlayerScripts

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")

-- === Opcional: animación personalizada ===
local MOON_ANIM_ID: number? = nil -- ej: 1234567890
local animTrack: AnimationTrack? = nil

local moonwalkOn = false
local moveConn: RBXScriptConnection? = nil

-- Si reaparece el jugador
player.CharacterAdded:Connect(function(char)
	character = char
	humanoid = character:WaitForChild("Humanoid")
	hrp = character:WaitForChild("HumanoidRootPart")
end)

-- Animación personalizada
local function loadMoonAnim()
	if MOON_ANIM_ID and humanoid then
		local anim = Instance.new("Animation")
		anim.AnimationId = "rbxassetid://" .. tostring(MOON_ANIM_ID)
		if animTrack then
			pcall(function() animTrack:Stop(0.2) animTrack:Destroy() end)
		end
		animTrack = humanoid:LoadAnimation(anim)
		animTrack.Looped = true
	end
end

-- Activar/Desactivar moonwalk
local function setMoonwalk(active: boolean)
	if moonwalkOn == active then return end
	moonwalkOn = active

	if active then
		humanoid.AutoRotate = false
		loadMoonAnim()
		if animTrack then pcall(function() animTrack:Play(0.15) end) end

		moveConn = RunService.RenderStepped:Connect(function()
			if humanoid and hrp and humanoid.Health > 0 then
				local backwards = -hrp.CFrame.LookVector
				humanoid:Move(backwards, true)
			end
		end)
	else
		humanoid.AutoRotate = true
		if animTrack then pcall(function() animTrack:Stop(0.15) end) end
		if moveConn then moveConn:Disconnect() moveConn = nil end
		humanoid:Move(Vector3.zero, true)
	end
end

-- Crear botón en pantalla
local function createButton()
	local button = Instance.new("TextButton")
	button.Name = "MoonwalkButton"
	button.Size = UDim2.new(0, 120, 0, 50)
	button.Position = UDim2.new(0.5, -60, 1, -80) -- centrado abajo
	button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.TextScaled = true
	button.Font = Enum.Font.SourceSansBold
	button.Text = "Moonwalk"

	button.Parent = StarterGui:WaitForChild("ScreenGui", 2) or Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))

	-- Toggle al pulsar
	button.MouseButton1Click:Connect(function()
		setMoonwalk(not moonwalkOn)
		button.Text = moonwalkOn and "Parar" or "Moonwalk"
	end)
end

-- Crear ScreenGui y botón al iniciar
local gui = Instance.new("ScreenGui")
gui.Name = "MoonwalkGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Name = "MoonwalkButton"
button.Size = UDim2.new(0, 120, 0, 50)
button.Position = UDim2.new(0.5, -60, 1, -80) -- centrado abajo
button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextScaled = true
button.Font = Enum.Font.SourceSansBold
button.Text = "Moonwalk"
button.Parent = gui

button.MouseButton1Click:Connect(function()
	setMoonwalk(not moonwalkOn)
	button.Text = moonwalkOn and "Parar" or "Moonwalk"
end)
