-- JERRY SCRIPT - Admin Debug Menu
-- للاستخدام داخل لعبتك في Roblox Studio

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- غيّر هذا إلى UserId حقك
local ADMIN_USER_ID = 123456789

if player.UserId ~= ADMIN_USER_ID then
	return
end

local flying = false
local flySpeed = 50
local targetPlayer = nil
local flyConnection

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "JerryScript"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(420, 330)
main.Position = UDim2.fromScale(0.5, 0.5)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(255, 210, 0)
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 14)
corner.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 55)
title.BackgroundTransparency = 1
title.Text = "JERRY SCRIPT"
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.new(0, 0, 0)
title.Parent = main

local nameBox = Instance.new("TextBox")
nameBox.Size = UDim2.fromOffset(280, 45)
nameBox.Position = UDim2.fromOffset(20, 75)
nameBox.PlaceholderText = "اكتب اسم اللاعب"
nameBox.Text = ""
nameBox.TextScaled = true
nameBox.BackgroundColor3 = Color3.new(1, 1, 1)
nameBox.Parent = main

local linkButton = Instance.new("TextButton")
linkButton.Size = UDim2.fromOffset(90, 45)
linkButton.Position = UDim2.fromOffset(315, 75)
linkButton.Text = "Link Player"
linkButton.TextScaled = true
linkButton.Parent = main

local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.fromOffset(180, 50)
flyButton.Position = UDim2.fromOffset(20, 140)
flyButton.Text = "FLY"
flyButton.TextScaled = true
flyButton.Parent = main

local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.fromOffset(180, 50)
speedBox.Position = UDim2.fromOffset(215, 140)
speedBox.PlaceholderText = "Fly Speed: 1-300"
speedBox.Text = tostring(flySpeed)
speedBox.TextScaled = true
speedBox.Parent = main

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -40, 0, 50)
status.Position = UDim2.fromOffset(20, 210)
status.BackgroundTransparency = 1
status.Text = "Target: None"
status.TextScaled = true
status.Parent = main

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.fromOffset(120, 40)
closeButton.Position = UDim2.fromOffset(150, 275)
closeButton.Text = "Close"
closeButton.TextScaled = true
closeButton.Parent = main

-- اختيار اللاعب
linkButton.MouseButton1Click:Connect(function()
	local wanted = nameBox.Text:lower()

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr.Name:lower():sub(1, #wanted) == wanted then
			targetPlayer = plr
			status.Text = "Target: " .. plr.Name
			return
		end
	end

	status.Text = "Player not found"
	targetPlayer = nil
end)

-- السرعة
speedBox.FocusLost:Connect(function()
	local value = tonumber(speedBox.Text)

	if value then
		flySpeed = math.clamp(value, 1, 300)
		speedBox.Text = tostring(flySpeed)
	end
end)

-- Fly محلي للتجربة
local function stopFly()
	flying = false

	if flyConnection then
		flyConnection:Disconnect()
		flyConnection = nil
	end

	flyButton.Text = "FLY"
end

local function startFly()
	local character = player.Character
	if not character then return end

	local root = character:FindFirstChild("HumanoidRootPart")
	if not root then return end

	flying = true
	flyButton.Text = "STOP FLY"

	flyConnection = RunService.RenderStepped:Connect(function()
		if not flying or not root.Parent then
			stopFly()
			return
		end

		local camera = workspace.CurrentCamera
		local direction = Vector3.zero

		if UIS:IsKeyDown(Enum.KeyCode.W) then
			direction += camera.CFrame.LookVector
		end

		if UIS:IsKeyDown(Enum.KeyCode.S) then
			direction -= camera.CFrame.LookVector
		end

		if UIS:IsKeyDown(Enum.KeyCode.D) then
			direction += camera.CFrame.RightVector
		end

		if UIS:IsKeyDown(Enum.KeyCode.A) then
			direction -= camera.CFrame.RightVector
		end

		if UIS:IsKeyDown(Enum.KeyCode.Space) then
			direction += Vector3.yAxis
		end

		if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
			direction -= Vector3.yAxis
		end

		if direction.Magnitude > 0 then
			root.AssemblyLinearVelocity =
				direction.Unit * flySpeed
		else
			root.AssemblyLinearVelocity = Vector3.zero
		end
	end)
end

flyButton.MouseButton1Click:Connect(function()
	if flying then
		stopFly()
	else
		startFly()
	end
end)

closeButton.MouseButton1Click:Connect(function()
	gui.Enabled = false
end)
