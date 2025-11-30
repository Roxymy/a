-- Roblox GUI Script
-- Replicating the dark purple aesthetic from the provided image

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Configuration & Theme
local Theme = {
	Background = Color3.fromRGB(18, 18, 28), -- Very dark purple/black
	CardBackground = Color3.fromRGB(28, 28, 42), -- Lighter purple for cards
	Accent = Color3.fromRGB(85, 65, 165), -- Purple accent (buttons)
	AccentHover = Color3.fromRGB(100, 80, 180),
	TextPrimary = Color3.fromRGB(255, 255, 255),
	TextSecondary = Color3.fromRGB(180, 180, 200),
	Navbar = Color3.fromRGB(22, 22, 34),
}

local function createRoundedCorner(parent, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius or 8)
	corner.Parent = parent
	return corner
end

local function createPadding(parent, padding)
	local pad = Instance.new("UIPadding")
	pad.PaddingTop = UDim.new(0, padding)
	pad.PaddingBottom = UDim.new(0, padding)
	pad.PaddingLeft = UDim.new(0, padding)
	pad.PaddingRight = UDim.new(0, padding)
	pad.Parent = parent
	return pad
end

local function createLabel(parent, text, size, color, font, position, anchor)
	local label = Instance.new("TextLabel")
	label.Text = text
	label.TextSize = size or 14
	label.TextColor3 = color or Theme.TextPrimary
	label.Font = font or Enum.Font.GothamBold
	label.BackgroundTransparency = 1
	label.Position = position or UDim2.new(0, 0, 0, 0)
	label.AnchorPoint = anchor or Vector2.new(0, 0)
	label.Size = UDim2.new(0, 0, 0, 0) -- Auto size usually
	label.AutomaticSize = Enum.AutomaticSize.XY
	label.Parent = parent
	return label
end

local function createButton(parent, text, size, position, color)
	local button = Instance.new("TextButton")
	button.Text = text
	button.Size = size
	button.Position = position
	button.BackgroundColor3 = color or Theme.Accent
	button.TextColor3 = Theme.TextPrimary
	button.Font = Enum.Font.GothamBold
	button.TextSize = 14
	button.AutoButtonColor = true
	button.Parent = parent
	
	createRoundedCorner(button, 6)
	
	return button
end

-- Main GUI Creation
local function createGUI()
	-- Clean up old GUI if exists
	if PlayerGui:FindFirstChild("MajoGUI") then
		PlayerGui.MajoGUI:Destroy()
	end

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "MajoGUI"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.DisplayOrder = 999999
	ScreenGui.Parent = PlayerGui

	-- Main Container (The Window)
	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	MainFrame.Size = UDim2.new(0, 900, 0, 600)
	MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	MainFrame.BackgroundColor3 = Theme.Background
	MainFrame.BorderSizePixel = 0
	MainFrame.Parent = ScreenGui
	
	createRoundedCorner(MainFrame, 16)

	-- 1. Navigation Bar
	local NavBar = Instance.new("Frame")
	NavBar.Name = "NavBar"
	NavBar.Size = UDim2.new(1, 0, 0, 60)
	NavBar.BackgroundColor3 = Theme.Navbar
	NavBar.BorderSizePixel = 0
	NavBar.Parent = MainFrame
	
	createRoundedCorner(NavBar, 16)
	
	-- Window Controls (Minimize/Close) - Right side
	local Controls = Instance.new("Frame")
	Controls.Size = UDim2.new(0, 60, 0, 30)
	Controls.Position = UDim2.new(1, -80, 0, 15)
	Controls.BackgroundTransparency = 1
	Controls.Parent = NavBar
	
	local minBtn = Instance.new("TextButton")
	minBtn.Text = "-"
	minBtn.Size = UDim2.new(0, 25, 0, 25)
	minBtn.Position = UDim2.new(0, 0, 0, 0)
	minBtn.BackgroundColor3 = Theme.CardBackground
	minBtn.TextColor3 = Theme.TextPrimary
	minBtn.Font = Enum.Font.GothamBold
	minBtn.TextSize = 18
	minBtn.AutoButtonColor = false
	minBtn.Parent = Controls
	createRoundedCorner(minBtn, 6)
	
	local closeBtn = Instance.new("TextButton")
	closeBtn.Text = "X"
	closeBtn.Size = UDim2.new(0, 25, 0, 25)
	closeBtn.Position = UDim2.new(0, 35, 0, 0)
	closeBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
	closeBtn.TextColor3 = Theme.TextPrimary
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.TextSize = 14
	closeBtn.AutoButtonColor = false
	closeBtn.Parent = Controls
	createRoundedCorner(closeBtn, 6)
	
	closeBtn.MouseButton1Click:Connect(function()
		ScreenGui:Destroy()
	end)
	
	local minimized = false
	minBtn.MouseButton1Click:Connect(function()
		minimized = not minimized
		if minimized then
			Content.Visible = false
			MainFrame:TweenSize(UDim2.new(0, 900, 0, 60), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.3, true)
		else
			MainFrame:TweenSize(UDim2.new(0, 900, 0, 600), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.3, true)
			task.wait(0.2)
			Content.Visible = true
		end
	end)
	
	-- Nav Buttons Container
	local NavBtnContainer = Instance.new("Frame")
	NavBtnContainer.Size = UDim2.new(0, 700, 1, 0)
	NavBtnContainer.Position = UDim2.new(0.5, 0, 0, 0)
	NavBtnContainer.AnchorPoint = Vector2.new(0.5, 0)
	NavBtnContainer.BackgroundTransparency = 1
	NavBtnContainer.Parent = NavBar
	
	local NavList = Instance.new("UIListLayout")
	NavList.FillDirection = Enum.FillDirection.Horizontal
	NavList.HorizontalAlignment = Enum.HorizontalAlignment.Center
	NavList.VerticalAlignment = Enum.VerticalAlignment.Center
	NavList.Padding = UDim.new(0, 10)
	NavList.Parent = NavBtnContainer

	-- Content Container
	local Content = Instance.new("Frame")
	Content.Name = "Content"
	Content.Size = UDim2.new(1, 0, 1, -60)
	Content.Position = UDim2.new(0, 0, 0, 60)
	Content.BackgroundTransparency = 1
	Content.Parent = MainFrame
	createPadding(Content, 25)

	-- Tabs Logic
	local navItems = {"Aimbot", "ESP", "Players", "Execute", "Extras", "Configuração"}
	
	-- ESP State
	local espEnabled = {
		boxes = false,
		names = false,
		health = false,
		distance = false,
		tracers = false
	}
	local espObjects = {}
	
	-- Aimbot State
	local aimbotKeybind = Enum.KeyCode.E -- default keybind
	local flyKeybind = Enum.KeyCode.X -- default keybind
	local aimbotSettings = {
		enabled = false,
		fov = 400,
		smoothness = 0.05,
		teamCheck = false
	}
	local tabs = {}
	local buttons = {}
	
	-- Global Functions
	local RunService = game:GetService("RunService")
	local Camera = workspace.CurrentCamera
	local Mouse = LocalPlayer:GetMouse()
	
	-- ESP Functions
	local function createESP(player)
		if espObjects[player] then return end
		
		espObjects[player] = {}
		
		local box = Drawing.new("Square")
		box.Color = Color3.fromRGB(255, 255, 255)
		box.Thickness = 2
		box.Filled = false
		box.Transparency = 1
		box.Visible = false
		espObjects[player].box = box
		
		local nameText = Drawing.new("Text")
		nameText.Text = player.Name
		nameText.Color = Color3.fromRGB(255, 255, 255)
		nameText.Size = 16
		nameText.Center = true
		nameText.Outline = true
		nameText.Visible = false
		espObjects[player].name = nameText
		
		local healthBar = Drawing.new("Square")
		healthBar.Color = Color3.fromRGB(0, 255, 0)
		healthBar.Thickness = 1
		healthBar.Filled = true
		healthBar.Transparency = 1
		healthBar.Visible = false
		espObjects[player].health = healthBar
		
		local distText = Drawing.new("Text")
		distText.Color = Color3.fromRGB(200, 200, 255)
		distText.Size = 14
		distText.Center = true
		distText.Outline = true
		distText.Visible = false
		espObjects[player].distance = distText
		
		local tracer = Drawing.new("Line")
		tracer.Color = Color3.fromRGB(255, 255, 255)
		tracer.Thickness = 2
		tracer.Transparency = 1
		tracer.Visible = false
		espObjects[player].tracer = tracer
	end
	
	local function removeESP(player)
		if espObjects[player] then
			for _, obj in pairs(espObjects[player]) do
				pcall(function() obj:Remove() end)
			end
			espObjects[player] = nil
		end
	end
	
	local function updateESP()
		local camera = workspace.CurrentCamera
		for player, objects in pairs(espObjects) do
			if player and player.Parent and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
				local hrp = player.Character.HumanoidRootPart
				local hum = player.Character.Humanoid
				local pos, onScreen = camera:WorldToViewportPoint(hrp.Position)
				
				if onScreen and pos.Z > 0 then
					local distance = (hrp.Position - camera.CFrame.Position).Magnitude
					
					if objects.box then
						local head = player.Character:FindFirstChild("Head")
						if head then
							local headPos = camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
							local legPos = camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
							
							local height = math.abs(headPos.Y - legPos.Y)
							local width = height / 2
							
							objects.box.Size = Vector2.new(width, height)
							objects.box.Position = Vector2.new(pos.X - width/2, pos.Y - height/2)
							objects.box.Visible = espEnabled.master and espEnabled.boxes
						end
					end
					
					if objects.name then
						objects.name.Position = Vector2.new(pos.X, pos.Y - 40)
						objects.name.Visible = espEnabled.master and espEnabled.names
					end
					
					if objects.health and objects.box then
						local healthPercent = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
						objects.health.Color = Color3.fromRGB(255 * (1-healthPercent), 255 * healthPercent, 0)
						objects.health.Size = Vector2.new(3, objects.box.Size.Y * healthPercent)
						objects.health.Position = Vector2.new(objects.box.Position.X - 6, objects.box.Position.Y + objects.box.Size.Y * (1-healthPercent))
						objects.health.Visible = espEnabled.master and espEnabled.health and espEnabled.boxes
					end
					
					if objects.distance then
						objects.distance.Text = string.format("%d studs", math.floor(distance))
						objects.distance.Position = Vector2.new(pos.X, pos.Y + 25)
						objects.distance.Visible = espEnabled.master and espEnabled.distance
					end
					
					if objects.tracer then
						local screenSize = camera.ViewportSize
						objects.tracer.From = Vector2.new(screenSize.X / 2, screenSize.Y)
						objects.tracer.To = Vector2.new(pos.X, pos.Y)
						objects.tracer.Visible = espEnabled.master and espEnabled.tracers
					end
				else
					for _, obj in pairs(objects) do
						obj.Visible = false
					end
				end
			else
				removeESP(player)
			end
		end
	end
	
	-- Player List Function
	local updatePlayerList


	-- Create Tab Frames
	for _, name in ipairs(navItems) do
		local tabFrame = Instance.new("ScrollingFrame")
		tabFrame.Name = name .. "Tab"
		tabFrame.Size = UDim2.new(1, 0, 1, 0)
		tabFrame.BackgroundTransparency = 1
		tabFrame.ScrollBarThickness = 6
		tabFrame.ScrollBarImageColor3 = Theme.Accent
		tabFrame.BorderSizePixel = 0
		tabFrame.Visible = false
		tabFrame.Parent = Content
		
		local list = Instance.new("UIListLayout")
		list.Padding = UDim.new(0, 10)
		list.SortOrder = Enum.SortOrder.LayoutOrder
		list.Parent = tabFrame
		
		tabs[name] = tabFrame
		
		-- Content for Tabs
		if name == "Aimbot" then
			-- Section Title
			local titleLabel = createLabel(tabFrame, "Aimbot Settings", 18, Theme.TextPrimary, Enum.Font.GothamBlack)
			titleLabel.Size = UDim2.new(1, 0, 0, 30)
			titleLabel.TextXAlignment = Enum.TextXAlignment.Left
			
			-- Enable Aimbot Toggle
			local aimFrame = Instance.new("Frame")
			aimFrame.Size = UDim2.new(1, 0, 0, 60)
			aimFrame.BackgroundColor3 = Theme.CardBackground
			aimFrame.Parent = tabFrame
			createRoundedCorner(aimFrame, 10)
			createPadding(aimFrame, 15)
			
			local aimLabel = createLabel(aimFrame, "Enable Aimbot", 14, Theme.TextPrimary, Enum.Font.GothamBold, UDim2.new(0, 0, 0, 0), Vector2.new(0, 0))
			aimLabel.Size = UDim2.new(0, 200, 1, 0)
			aimLabel.TextXAlignment = Enum.TextXAlignment.Left
			aimLabel.TextYAlignment = Enum.TextYAlignment.Top
			
			local aimDesc = createLabel(aimFrame, "Automatically lock onto nearby players", 11, Theme.TextSecondary, Enum.Font.Gotham, UDim2.new(0, 0, 0, 22), Vector2.new(0, 0))
			aimDesc.Size = UDim2.new(0, 300, 0, 20)
			aimDesc.TextXAlignment = Enum.TextXAlignment.Left
			
			local toggleBtn = Instance.new("TextButton")
			toggleBtn.Text = ""
			toggleBtn.Size = UDim2.new(0, 50, 0, 26)
			toggleBtn.Position = UDim2.new(1, -50, 0.5, 0)
			toggleBtn.AnchorPoint = Vector2.new(0, 0.5)
			toggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
			toggleBtn.Parent = aimFrame
			createRoundedCorner(toggleBtn, 13)
			
			local circle = Instance.new("Frame")
			circle.Size = UDim2.new(0, 20, 0, 20)
			circle.Position = UDim2.new(0, 3, 0.5, 0)
			circle.AnchorPoint = Vector2.new(0, 0.5)
			circle.BackgroundColor3 = Color3.fromRGB(220, 220, 230)
			circle.Parent = toggleBtn
			createRoundedCorner(circle, 10)
			
			-- Aimbot Mode Selection
			local modeFrame = Instance.new("Frame")
			modeFrame.Size = UDim2.new(1, 0, 0, 60)
			modeFrame.BackgroundColor3 = Theme.CardBackground
			modeFrame.Parent = tabFrame
			createRoundedCorner(modeFrame, 10)
			createPadding(modeFrame, 15)
			
			local modeLabel = createLabel(modeFrame, "Aimbot Mode", 14, Theme.TextPrimary, Enum.Font.GothamBold, UDim2.new(0, 0, 0, 0), Vector2.new(0, 0))
			modeLabel.Size = UDim2.new(0, 200, 1, 0)
			modeLabel.TextXAlignment = Enum.TextXAlignment.Left
			modeLabel.TextYAlignment = Enum.TextYAlignment.Top
			
			local modeDesc = createLabel(modeFrame, "Memory (Camera) or Mouse", 11, Theme.TextSecondary, Enum.Font.Gotham, UDim2.new(0, 0, 0, 22), Vector2.new(0, 0))
			modeDesc.Size = UDim2.new(0, 300, 0, 20)
			modeDesc.TextXAlignment = Enum.TextXAlignment.Left
			
			-- Mode buttons
			local memoryBtn = Instance.new("TextButton")
			memoryBtn.Text = "Memory"
			memoryBtn.Size = UDim2.new(0, 80, 0, 26)
			memoryBtn.Position = UDim2.new(1, -170, 0.5, 0)
			memoryBtn.AnchorPoint = Vector2.new(0, 0.5)
			memoryBtn.BackgroundColor3 = Theme.Accent
			memoryBtn.TextColor3 = Theme.TextPrimary
			memoryBtn.Font = Enum.Font.GothamBold
			memoryBtn.TextSize = 12
			memoryBtn.Parent = modeFrame
			createRoundedCorner(memoryBtn, 6)
			
			local mouseBtn = Instance.new("TextButton")
			mouseBtn.Text = "Mouse"
			mouseBtn.Size = UDim2.new(0, 80, 0, 26)
			mouseBtn.Position = UDim2.new(1, -80, 0.5, 0)
			mouseBtn.AnchorPoint = Vector2.new(0, 0.5)
			mouseBtn.BackgroundColor3 = Theme.CardBackground
			mouseBtn.TextColor3 = Theme.TextSecondary
			mouseBtn.Font = Enum.Font.GothamBold
			mouseBtn.TextSize = 12
			mouseBtn.Parent = modeFrame
			createRoundedCorner(mouseBtn, 6)
			
			aimbotSettings.mode = "memory" -- default
			
			memoryBtn.MouseButton1Click:Connect(function()
				aimbotSettings.mode = "memory"
				memoryBtn.BackgroundColor3 = Theme.Accent
				memoryBtn.TextColor3 = Theme.TextPrimary
				mouseBtn.BackgroundColor3 = Theme.CardBackground
				mouseBtn.TextColor3 = Theme.TextSecondary
			end)
			
			mouseBtn.MouseButton1Click:Connect(function()
				aimbotSettings.mode = "mouse"
				mouseBtn.BackgroundColor3 = Theme.Accent
				mouseBtn.TextColor3 = Theme.TextPrimary
				memoryBtn.BackgroundColor3 = Theme.CardBackground
				memoryBtn.TextColor3 = Theme.TextSecondary
			end)
			
			-- Team Check Toggle
			local teamFrame = Instance.new("Frame")
			teamFrame.Size = UDim2.new(1, 0, 0, 60)
			teamFrame.BackgroundColor3 = Theme.CardBackground
			teamFrame.Parent = tabFrame
			createRoundedCorner(teamFrame, 10)
			createPadding(teamFrame, 15)
			
			local teamLabel = createLabel(teamFrame, "Team Check", 15, Theme.TextPrimary, Enum.Font.GothamBold, UDim2.new(0, 0, 0, 0), Vector2.new(0, 0))
			teamLabel.Size = UDim2.new(0, 200, 1, 0)
			teamLabel.TextXAlignment = Enum.TextXAlignment.Left
			teamLabel.TextYAlignment = Enum.TextYAlignment.Top
			
			local teamDesc = createLabel(teamFrame, "Ignore teammates", 12, Theme.TextSecondary, Enum.Font.Gotham, UDim2.new(0, 0, 0, 22), Vector2.new(0, 0))
			teamDesc.Size = UDim2.new(0, 300, 0, 20)
			teamDesc.TextXAlignment = Enum.TextXAlignment.Left
			
			local teamToggleBtn = Instance.new("TextButton")
			teamToggleBtn.Text = ""
			teamToggleBtn.Size = UDim2.new(0, 50, 0, 26)
			teamToggleBtn.Position = UDim2.new(1, -50, 0.5, 0)
			teamToggleBtn.AnchorPoint = Vector2.new(0, 0.5)
			teamToggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
			teamToggleBtn.Parent = teamFrame
			createRoundedCorner(teamToggleBtn, 13)
			
			local teamCircle = Instance.new("Frame")
			teamCircle.Size = UDim2.new(0, 20, 0, 20)
			teamCircle.Position = UDim2.new(0, 3, 0.5, 0)
			teamCircle.AnchorPoint = Vector2.new(0, 0.5)
			teamCircle.BackgroundColor3 = Color3.fromRGB(220, 220, 230)
			teamCircle.Parent = teamToggleBtn
			createRoundedCorner(teamCircle, 10)
			
			-- FOV Slider
			local fovFrame = Instance.new("Frame")
			fovFrame.Size = UDim2.new(1, 0, 0, 80)
			fovFrame.BackgroundColor3 = Theme.CardBackground
			fovFrame.Parent = tabFrame
			createRoundedCorner(fovFrame, 10)
			createPadding(fovFrame, 15)
			
			local fovLabel = createLabel(fovFrame, "FOV: 400", 14, Theme.TextPrimary, Enum.Font.GothamBold, UDim2.new(0, 0, 0, 5), Vector2.new(0, 0))
			fovLabel.Size = UDim2.new(1, 0, 0, 20)
			fovLabel.TextXAlignment = Enum.TextXAlignment.Left
			
			local fovSliderBg = Instance.new("Frame")
			fovSliderBg.Size = UDim2.new(1, -30, 0, 8)
			fovSliderBg.Position = UDim2.new(0, 15, 0, 40)
			fovSliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
			fovSliderBg.Parent = fovFrame
			createRoundedCorner(fovSliderBg, 4)
			
			local fovSliderFill = Instance.new("Frame")
			fovSliderFill.Size = UDim2.new(0.5, 0, 1, 0)
			fovSliderFill.BackgroundColor3 = Theme.Accent
			fovSliderFill.Parent = fovSliderBg
			createRoundedCorner(fovSliderFill, 4)
			
			local fovDragging = false
			fovSliderBg.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					fovDragging = true
				end
			end)
			
			fovSliderBg.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					fovDragging = false
				end
			end)
			
			fovSliderBg.InputChanged:Connect(function(input)
				if fovDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
					local pos = (input.Position.X - fovSliderBg.AbsolutePosition.X) / fovSliderBg.AbsoluteSize.X
					pos = math.clamp(pos, 0, 1)
					fovSliderFill.Size = UDim2.new(pos, 0, 1, 0)
					aimbotSettings.fov = math.floor(50 + (pos * 750)) -- 50 to 800
					fovLabel.Text = "FOV: " .. aimbotSettings.fov
				end
			end)
			
			-- Smoothness Slider
			local smoothFrame = Instance.new("Frame")
			smoothFrame.Size = UDim2.new(1, 0, 0, 80)
			smoothFrame.BackgroundColor3 = Theme.CardBackground
			smoothFrame.Parent = tabFrame
			createRoundedCorner(smoothFrame, 10)
			createPadding(smoothFrame, 15)
			
			local smoothLabel = createLabel(smoothFrame, "Smoothness: 0.05", 14, Theme.TextPrimary, Enum.Font.GothamBold, UDim2.new(0, 0, 0, 5), Vector2.new(0, 0))
			smoothLabel.Size = UDim2.new(1, 0, 0, 20)
			smoothLabel.TextXAlignment = Enum.TextXAlignment.Left
			
			local smoothSliderBg = Instance.new("Frame")
			smoothSliderBg.Size = UDim2.new(1, -30, 0, 8)
			smoothSliderBg.Position = UDim2.new(0, 15, 0, 40)
			smoothSliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
			smoothSliderBg.Parent = smoothFrame
			createRoundedCorner(smoothSliderBg, 4)
			
			local smoothSliderFill = Instance.new("Frame")
			smoothSliderFill.Size = UDim2.new(0.25, 0, 1, 0)
			smoothSliderFill.BackgroundColor3 = Theme.Accent
			smoothSliderFill.Parent = smoothSliderBg
			createRoundedCorner(smoothSliderFill, 4)
			
			local smoothDragging = false
			smoothSliderBg.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					smoothDragging = true
				end
			end)
			
			smoothSliderBg.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					smoothDragging = false
				end
			end)
			
			smoothSliderBg.InputChanged:Connect(function(input)
				if smoothDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
					local pos = (input.Position.X - smoothSliderBg.AbsolutePosition.X) / smoothSliderBg.AbsoluteSize.X
					pos = math.clamp(pos, 0, 1)
					smoothSliderFill.Size = UDim2.new(pos, 0, 1, 0)
					aimbotSettings.smoothness = 0.01 + (pos * 0.49) -- 0.01 to 0.5
					smoothLabel.Text = string.format("Smoothness: %.2f", aimbotSettings.smoothness)
				end
			end)
			
			-- Aimbot Keybind Selector
			local keybindFrame = Instance.new("Frame")
			keybindFrame.Size = UDim2.new(1, 0, 0, 60)
			keybindFrame.BackgroundColor3 = Theme.CardBackground
			keybindFrame.Parent = tabFrame
			createRoundedCorner(keybindFrame, 10)
			createPadding(keybindFrame, 15)
			
			local keybindLabel = createLabel(keybindFrame, "Aimbot Keybind: E", 14, Theme.TextPrimary, Enum.Font.GothamBold, UDim2.new(0, 0, 0, 0), Vector2.new(0, 0))
			keybindLabel.Size = UDim2.new(0, 200, 1, 0)
			keybindLabel.TextXAlignment = Enum.TextXAlignment.Left
			keybindLabel.TextYAlignment = Enum.TextYAlignment.Top
			
			local keybindDesc = createLabel(keybindFrame, "Press to toggle aimbot", 11, Theme.TextSecondary, Enum.Font.Gotham, UDim2.new(0, 0, 0, 22), Vector2.new(0, 0))
			keybindDesc.Size = UDim2.new(0, 300, 0, 20)
			keybindDesc.TextXAlignment = Enum.TextXAlignment.Left
			
			local keybindBtn = Instance.new("TextButton")
			keybindBtn.Text = "Change"
			keybindBtn.Size = UDim2.new(0, 80, 0, 26)
			keybindBtn.Position = UDim2.new(1, -80, 0.5, 0)
			keybindBtn.AnchorPoint = Vector2.new(0, 0.5)
			keybindBtn.BackgroundColor3 = Theme.Accent
			keybindBtn.TextColor3 = Theme.TextPrimary
			keybindBtn.Font = Enum.Font.GothamBold
			keybindBtn.TextSize = 12
			keybindBtn.Parent = keybindFrame
			createRoundedCorner(keybindBtn, 6)
			
			local waitingForKey = false
			keybindBtn.MouseButton1Click:Connect(function()
				waitingForKey = true
				keybindBtn.Text = "Press Key..."
				local connection
				connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
					if waitingForKey and input.UserInputType == Enum.UserInputType.Keyboard then
						aimbotKeybind = input.KeyCode
						keybindLabel.Text = "Aimbot Keybind: " .. input.KeyCode.Name
						keybindBtn.Text = "Change"
						waitingForKey = false
						connection:Disconnect()
					end
				end)
			end)
			
			-- Aimbot Logic
			local RunService = game:GetService("RunService")
			local Camera = workspace.CurrentCamera
			local Mouse = LocalPlayer:GetMouse()
			
			local function getClosestPlayer()
				local closest = nil
				local shortestDistance = math.huge
				local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
				
				for _, player in pairs(Players:GetPlayers()) do
					if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
						if aimbotSettings.teamCheck and player.Team == LocalPlayer.Team then
							continue
						end
						
						local pos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
						if onScreen then
							local magnitude = (Vector2.new(pos.X, pos.Y) - screenCenter).Magnitude
							if magnitude < shortestDistance and magnitude < aimbotSettings.fov then
								closest = player
								shortestDistance = magnitude
							end
						end
					end
				end
				return closest
			end
			
			local aimLoop
			
			toggleBtn.MouseButton1Click:Connect(function()
				aimbotSettings.enabled = not aimbotSettings.enabled
				if aimbotSettings.enabled then
					TweenService:Create(toggleBtn, TweenInfo.new(0.25), {BackgroundColor3 = Theme.Accent}):Play()
					TweenService:Create(circle, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Position = UDim2.new(1, -23, 0.5, 0)}):Play()
					
					aimLoop = RunService.RenderStepped:Connect(function()
						if aimbotSettings.enabled then
							local target = getClosestPlayer()
							if target and target.Character and target.Character:FindFirstChild("Head") then
								if aimbotSettings.mode == "memory" then
									-- Memory mode - moves camera
									TweenService:Create(Camera, TweenInfo.new(aimbotSettings.smoothness, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)}):Play()
								elseif aimbotSettings.mode == "mouse" then
									-- Mouse mode - smoothly aims without locking mouse
									local targetPos, onScreen = Camera:WorldToViewportPoint(target.Character.Head.Position)
									if onScreen then
										local deltaX = (targetPos.X - Mouse.X) * aimbotSettings.smoothness
										local deltaY = (targetPos.Y - Mouse.Y) * aimbotSettings.smoothness
										mousemoverel(deltaX, deltaY)
									end
								end
							end
						end
					end)
				else
					TweenService:Create(toggleBtn, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(45, 45, 60)}):Play()
					TweenService:Create(circle, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Position = UDim2.new(0, 3, 0.5, 0)}):Play()
					
					if aimLoop then aimLoop:Disconnect() end
				end
			end)
			
			teamToggleBtn.MouseButton1Click:Connect(function()
				aimbotSettings.teamCheck = not aimbotSettings.teamCheck
				if aimbotSettings.teamCheck then
					TweenService:Create(teamToggleBtn, TweenInfo.new(0.25), {BackgroundColor3 = Theme.Accent}):Play()
					TweenService:Create(teamCircle, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Position = UDim2.new(1, -23, 0.5, 0)}):Play()
				else
					TweenService:Create(teamToggleBtn, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(45, 45, 60)}):Play()
					TweenService:Create(teamCircle, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Position = UDim2.new(0, 3, 0.5, 0)}):Play()
				end
			end)
			
			-- FOV Circle Visualization
			local fovCircle = Drawing.new("Circle")
			fovCircle.Color = Color3.fromRGB(255, 255, 255)
			fovCircle.Thickness = 2
			fovCircle.Transparency = 0.5
			fovCircle.Filled = false
			fovCircle.Visible = false
			fovCircle.Radius = aimbotSettings.fov
			
			-- FOV Circle Toggle
			local fovCircleFrame = Instance.new("Frame")
			fovCircleFrame.Size = UDim2.new(1, 0, 0, 60)
			fovCircleFrame.BackgroundColor3 = Theme.CardBackground
			fovCircleFrame.Parent = tabFrame
			createRoundedCorner(fovCircleFrame, 10)
			createPadding(fovCircleFrame, 15)
			
			local fovCircleLabel = createLabel(fovCircleFrame, "Show FOV Circle", 14, Theme.TextPrimary, Enum.Font.GothamBold, UDim2.new(0, 0, 0, 0), Vector2.new(0, 0))
			fovCircleLabel.Size = UDim2.new(0, 200, 1, 0)
			fovCircleLabel.TextXAlignment = Enum.TextXAlignment.Left
			fovCircleLabel.TextYAlignment = Enum.TextYAlignment.Top
			
			local fovCircleDesc = createLabel(fovCircleFrame, "Display FOV circle on screen", 11, Theme.TextSecondary, Enum.Font.Gotham, UDim2.new(0, 0, 0, 22), Vector2.new(0, 0))
			fovCircleDesc.Size = UDim2.new(0, 300, 0, 20)
			fovCircleDesc.TextXAlignment = Enum.TextXAlignment.Left
			
			local fovCircleToggleBtn = Instance.new("TextButton")
			fovCircleToggleBtn.Text = ""
			fovCircleToggleBtn.Size = UDim2.new(0, 50, 0, 26)
			fovCircleToggleBtn.Position = UDim2.new(1, -50, 0.5, 0)
			fovCircleToggleBtn.AnchorPoint = Vector2.new(0, 0.5)
			fovCircleToggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
			fovCircleToggleBtn.Parent = fovCircleFrame
			createRoundedCorner(fovCircleToggleBtn, 13)
			
			local fovCircleCircle = Instance.new("Frame")
			fovCircleCircle.Size = UDim2.new(0, 20, 0, 20)
			fovCircleCircle.Position = UDim2.new(0, 3, 0.5, 0)
			fovCircleCircle.AnchorPoint = Vector2.new(0, 0.5)
			fovCircleCircle.BackgroundColor3 = Color3.fromRGB(220, 220, 230)
			fovCircleCircle.Parent = fovCircleToggleBtn
			createRoundedCorner(fovCircleCircle, 10)
			
			local showFovCircle = false
			fovCircleToggleBtn.MouseButton1Click:Connect(function()
				showFovCircle = not showFovCircle
				fovCircle.Visible = showFovCircle
				if showFovCircle then
					TweenService:Create(fovCircleToggleBtn, TweenInfo.new(0.25), {BackgroundColor3 = Theme.Accent}):Play()
					TweenService:Create(fovCircleCircle, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Position = UDim2.new(1, -23, 0.5, 0)}):Play()
				else
					TweenService:Create(fovCircleToggleBtn, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(45, 45, 60)}):Play()
					TweenService:Create(fovCircleCircle, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Position = UDim2.new(0, 3, 0.5, 0)}):Play()
				end
			end)
			
			-- Update FOV circle position to center of screen and update radius
			RunService.RenderStepped:Connect(function()
				if showFovCircle then
					local screenSize = Camera.ViewportSize
					fovCircle.Position = Vector2.new(screenSize.X / 2, screenSize.Y / 2)
					fovCircle.Radius = aimbotSettings.fov
				end
			end)
			
			-- Aimbot Keybind Toggle
			UserInputService.InputBegan:Connect(function(input, gameProcessed)
				if not gameProcessed and input.KeyCode == aimbotKeybind then
					aimbotSettings.enabled = not aimbotSettings.enabled
					if aimbotSettings.enabled then
						TweenService:Create(toggleBtn, TweenInfo.new(0.25), {BackgroundColor3 = Theme.Accent}):Play()
						TweenService:Create(circle, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Position = UDim2.new(1, -23, 0.5, 0)}):Play()
						
						if not aimLoop then
							aimLoop = RunService.RenderStepped:Connect(function()
								if aimbotSettings.enabled then
									local target = getClosestPlayer()
									if target and target.Character and target.Character:FindFirstChild("Head") then
										if aimbotSettings.mode == "memory" then
											TweenService:Create(Camera, TweenInfo.new(aimbotSettings.smoothness, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)}):Play()
										elseif aimbotSettings.mode == "mouse" then
											local targetPos, onScreen = Camera:WorldToViewportPoint(target.Character.Head.Position)
											if onScreen then
												local deltaX = (targetPos.X - Mouse.X) * aimbotSettings.smoothness
												local deltaY = (targetPos.Y - Mouse.Y) * aimbotSettings.smoothness
												mousemoverel(deltaX, deltaY)
											end
										end
									end
								end
							end)
						end
					else
						TweenService:Create(toggleBtn, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(45, 45, 60)}):Play()
						TweenService:Create(circle, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Position = UDim2.new(0, 3, 0.5, 0)}):Play()
						
						if aimLoop then aimLoop:Disconnect() aimLoop = nil end
					end
				end
			end)
			
		elseif name == "ESP" then
			-- Section Title
			local titleLabel = createLabel(tabFrame, "ESP Settings", 18, Theme.TextPrimary, Enum.Font.GothamBlack)
			titleLabel.Size = UDim2.new(1, 0, 0, 30)
			titleLabel.TextXAlignment = Enum.TextXAlignment.Left
			
			-- ESP Functions moved to global scope
			
			local espLoop
			
			-- Create Radar
			local radarFrame = Instance.new("Frame")
			radarFrame.Size = UDim2.new(0, 200, 0, 200)
			radarFrame.Position = UDim2.new(1, -220, 0, 20)
			radarFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
			radarFrame.BorderSizePixel = 0
			radarFrame.Visible = false
			radarFrame.Parent = ScreenGui
			createRoundedCorner(radarFrame, 10)
			
			local radarBorder = Instance.new("UIStroke")
			radarBorder.Color = Theme.Accent
			radarBorder.Thickness = 2
			radarBorder.Parent = radarFrame
			
			local radarCenter = Instance.new("Frame")
			radarCenter.Size = UDim2.new(0, 4, 0, 4)
			radarCenter.Position = UDim2.new(0.5, -2, 0.5, -2)
			radarCenter.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
			radarCenter.Parent = radarFrame
			createRoundedCorner(radarCenter, 2)
			
			local radarDots = {}
			
			local function updateRadar()
				if not espEnabled.radar then return end
				
				-- Clear old dots
				for _, dot in pairs(radarDots) do
					dot:Destroy()
				end
				radarDots = {}
				
				local camera = workspace.CurrentCamera
				local localPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
				if not localPos then return end
				
				for _, player in pairs(Players:GetPlayers()) do
					if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
						local targetPos = player.Character.HumanoidRootPart.Position
						local distance = (targetPos - localPos.Position).Magnitude
						
						if distance < 200 then -- Only show within 200 studs
							local relativePos = localPos.CFrame:PointToObjectSpace(targetPos)
							local x = (relativePos.X / 200) * 100
							local z = (relativePos.Z / 200) * 100
							
							local dot = Instance.new("Frame")
							dot.Size = UDim2.new(0, 6, 0, 6)
							dot.Position = UDim2.new(0.5, x - 3, 0.5, z - 3)
							dot.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
							dot.Parent = radarFrame
							createRoundedCorner(dot, 3)
							
							table.insert(radarDots, dot)
						end
					end
				end
			end
			
			local espOptions = {
				{name = "Enable ESP", desc = "Master toggle for all ESP features", key = "master"},
				{name = "Boxes", desc = "Show boxes around players", key = "boxes"},
				{name = "Names", desc = "Display player names", key = "names"},
				{name = "Health Bars", desc = "Show health bars", key = "health"},
				{name = "Distance", desc = "Show distance in studs", key = "distance"},
				{name = "Tracers", desc = "Draw lines to players", key = "tracers"},
				{name = "Radar", desc = "Show minimap radar", key = "radar"}
			}
			
			-- Add radar to espEnabled
			espEnabled.master = false
			espEnabled.radar = false
			
			for _, option in ipairs(espOptions) do
				local optFrame = Instance.new("Frame")
				optFrame.Size = UDim2.new(1, 0, 0, 60)
				optFrame.BackgroundColor3 = Theme.CardBackground
				optFrame.Parent = tabFrame
				createRoundedCorner(optFrame, 10)
				createPadding(optFrame, 15)
				
				local optLabel = createLabel(optFrame, option.name, 15, Theme.TextPrimary, Enum.Font.GothamBold, UDim2.new(0, 0, 0, 0), Vector2.new(0, 0))
				optLabel.Size = UDim2.new(0, 200, 1, 0)
				optLabel.TextXAlignment = Enum.TextXAlignment.Left
				optLabel.TextYAlignment = Enum.TextYAlignment.Top
				
				local optDesc = createLabel(optFrame, option.desc, 12, Theme.TextSecondary, Enum.Font.Gotham, UDim2.new(0, 0, 0, 22), Vector2.new(0, 0))
				optDesc.Size = UDim2.new(0, 300, 0, 20)
				optDesc.TextXAlignment = Enum.TextXAlignment.Left
				
				local toggleBtn = Instance.new("TextButton")
				toggleBtn.Text = ""
				toggleBtn.Size = UDim2.new(0, 50, 0, 26)
				toggleBtn.Position = UDim2.new(1, -50, 0.5, 0)
				toggleBtn.AnchorPoint = Vector2.new(0, 0.5)
				toggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
				toggleBtn.Parent = optFrame
				createRoundedCorner(toggleBtn, 13)
				
				local circle = Instance.new("Frame")
				circle.Size = UDim2.new(0, 20, 0, 20)
				circle.Position = UDim2.new(0, 3, 0.5, 0)
				circle.AnchorPoint = Vector2.new(0, 0.5)
				circle.BackgroundColor3 = Color3.fromRGB(220, 220, 230)
				circle.Parent = toggleBtn
				createRoundedCorner(circle, 10)
				
				toggleBtn.MouseButton1Click:Connect(function()
					espEnabled[option.key] = not espEnabled[option.key]
					if espEnabled[option.key] then
						TweenService:Create(toggleBtn, TweenInfo.new(0.25), {BackgroundColor3 = Theme.Accent}):Play()
						TweenService:Create(circle, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Position = UDim2.new(1, -23, 0.5, 0)}):Play()
						
						if not espLoop then
							espLoop = RunService.RenderStepped:Connect(function()
								updateESP()
								updateRadar()
							end)
							
							for _, player in pairs(Players:GetPlayers()) do
								if player ~= LocalPlayer then
									createESP(player)
								end
							end
						end
						
						-- Show/hide radar
						if option.key == "radar" then
							radarFrame.Visible = true
						end
					else
						TweenService:Create(toggleBtn, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(45, 45, 60)}):Play()
						TweenService:Create(circle, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Position = UDim2.new(0, 3, 0.5, 0)}):Play()
						
						-- Hide radar
						if option.key == "radar" then
							radarFrame.Visible = false
						end
					end
				end)
			end
			
		elseif name == "Players" then
			-- Section Title
			local titleLabel = createLabel(tabFrame, "Player List", 18, Theme.TextPrimary, Enum.Font.GothamBlack)
			titleLabel.Size = UDim2.new(1, 0, 0, 30)
			titleLabel.TextXAlignment = Enum.TextXAlignment.Left
			
			local playerListScroll = Instance.new("ScrollingFrame")
			playerListScroll.Size = UDim2.new(1, 0, 1, -40)
			playerListScroll.Position = UDim2.new(0, 0, 0, 40)
			playerListScroll.BackgroundTransparency = 1
			playerListScroll.BorderSizePixel = 0
			playerListScroll.ScrollBarThickness = 4
			playerListScroll.ScrollBarImageColor3 = Theme.Accent
			playerListScroll.Parent = tabFrame
			
			local listLayout = Instance.new("UIListLayout")
			listLayout.Padding = UDim.new(0, 10)
			listLayout.SortOrder = Enum.SortOrder.LayoutOrder
			listLayout.Parent = playerListScroll
			
			updatePlayerList = function()
				-- Clear old list
				for _, child in pairs(playerListScroll:GetChildren()) do
					if child:IsA("Frame") then child:Destroy() end
				end
				
				for _, player in pairs(Players:GetPlayers()) do
					if player ~= LocalPlayer then
						local pFrame = Instance.new("Frame")
						pFrame.Size = UDim2.new(1, -10, 0, 60)
						pFrame.BackgroundColor3 = Theme.CardBackground
						pFrame.Parent = playerListScroll
						createRoundedCorner(pFrame, 8)
						createPadding(pFrame, 10)
						
						-- Player Icon
						local icon = Instance.new("ImageLabel")
						icon.Size = UDim2.new(0, 40, 0, 40)
						icon.Position = UDim2.new(0, 0, 0.5, 0)
						icon.AnchorPoint = Vector2.new(0, 0.5)
						icon.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
						icon.Image = "rbxassetid://0" -- Placeholder, requires API to get actual headshot
						-- Try to get thumbnail
						task.spawn(function()
							local content, isReady = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
							if isReady then icon.Image = content end
						end)
						icon.Parent = pFrame
						createRoundedCorner(icon, 20)
						
						-- Player Name
						local nameLabel = createLabel(pFrame, player.DisplayName, 14, Theme.TextPrimary, Enum.Font.GothamBold, UDim2.new(0, 50, 0, 5), Vector2.new(0, 0))
						local userLabel = createLabel(pFrame, "@" .. player.Name, 11, Theme.TextSecondary, Enum.Font.Gotham, UDim2.new(0, 50, 0, 22), Vector2.new(0, 0))
						
						-- Buttons
						local tpBtn = createButton(pFrame, "TP", UDim2.new(0, 50, 0, 26), UDim2.new(1, -110, 0.5, 0), Theme.Accent)
						tpBtn.AnchorPoint = Vector2.new(0, 0.5)
						tpBtn.TextSize = 11
						
						local viewBtn = createButton(pFrame, "View", UDim2.new(0, 50, 0, 26), UDim2.new(1, -50, 0.5, 0), Theme.CardBackground)
						viewBtn.AnchorPoint = Vector2.new(0, 0.5)
						viewBtn.TextSize = 11
						
						tpBtn.MouseButton1Click:Connect(function()
							if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
								LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 2, 3)
							end
						end)
						
						viewBtn.MouseButton1Click:Connect(function()
							if workspace.CurrentCamera.CameraSubject == player.Character.Humanoid then
								workspace.CurrentCamera.CameraSubject = LocalPlayer.Character.Humanoid
								viewBtn.Text = "View"
								viewBtn.BackgroundColor3 = Theme.CardBackground
							else
								if player.Character and player.Character:FindFirstChild("Humanoid") then
									workspace.CurrentCamera.CameraSubject = player.Character.Humanoid
									viewBtn.Text = "Unview"
									viewBtn.BackgroundColor3 = Theme.Accent
								end
							end
						end)
					end
				end
				
				playerListScroll.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
			end
			
			-- Initial load
			updatePlayerList()
			
		elseif name == "Execute" then
			-- Section Title
			local titleLabel = createLabel(tabFrame, "Script Executor", 18, Theme.TextPrimary, Enum.Font.GothamBlack)
			titleLabel.Size = UDim2.new(1, 0, 0, 30)
			titleLabel.TextXAlignment = Enum.TextXAlignment.Left
			
			-- Script Box
			local scriptFrame = Instance.new("Frame")
			scriptFrame.Size = UDim2.new(1, 0, 0, 200)
			scriptFrame.BackgroundColor3 = Theme.CardBackground
			scriptFrame.Parent = tabFrame
			createRoundedCorner(scriptFrame, 10)
			createPadding(scriptFrame, 15)
			
			local scriptBox = Instance.new("TextBox")
			scriptBox.Size = UDim2.new(1, 0, 1, -50)
			scriptBox.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
			scriptBox.TextColor3 = Theme.TextPrimary
			scriptBox.Font = Enum.Font.Code
			scriptBox.TextSize = 14
			scriptBox.TextXAlignment = Enum.TextXAlignment.Left
			scriptBox.TextYAlignment = Enum.TextYAlignment.Top
			scriptBox.PlaceholderText = "-- Enter your Lua script here"
			scriptBox.PlaceholderColor3 = Theme.TextSecondary
			scriptBox.Text = ""
			scriptBox.MultiLine = true
			scriptBox.ClearTextOnFocus = false
			scriptBox.Parent = scriptFrame
			createRoundedCorner(scriptBox, 8)
			createPadding(scriptBox, 10)
			
			-- Button Container
			local btnContainer = Instance.new("Frame")
			btnContainer.Size = UDim2.new(1, 0, 0, 35)
			btnContainer.Position = UDim2.new(0, 0, 1, -35)
			btnContainer.BackgroundTransparency = 1
			btnContainer.Parent = scriptFrame
			
			local executeBtn = createButton(btnContainer, "Execute", UDim2.new(0.48, 0, 1, 0), UDim2.new(0, 0, 0, 0), Theme.Accent)
			local clearBtn = createButton(btnContainer, "Clear", UDim2.new(0.48, 0, 1, 0), UDim2.new(0.52, 0, 0, 0), Theme.CardBackground)
			
			-- Debug Console
			local consoleFrame = Instance.new("Frame")
			consoleFrame.Size = UDim2.new(1, 0, 0, 180)
			consoleFrame.BackgroundColor3 = Theme.CardBackground
			consoleFrame.Parent = tabFrame
			createRoundedCorner(consoleFrame, 10)
			createPadding(consoleFrame, 15)
			
			local consoleLabel = createLabel(consoleFrame, "Console Output", 15, Theme.TextPrimary, Enum.Font.GothamBold, UDim2.new(0, 0, 0, 0), Vector2.new(0, 0))
			consoleLabel.Size = UDim2.new(1, 0, 0, 20)
			consoleLabel.TextXAlignment = Enum.TextXAlignment.Left
			
			local consoleScroll = Instance.new("ScrollingFrame")
			consoleScroll.Size = UDim2.new(1, 0, 1, -30)
			consoleScroll.Position = UDim2.new(0, 0, 0, 30)
			consoleScroll.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
			consoleScroll.BorderSizePixel = 0
			consoleScroll.ScrollBarThickness = 4
			consoleScroll.ScrollBarImageColor3 = Theme.Accent
			consoleScroll.Parent = consoleFrame
			createRoundedCorner(consoleScroll, 8)
			
			local consoleText = Instance.new("TextLabel")
			consoleText.Size = UDim2.new(1, -10, 1, 0)
			consoleText.BackgroundTransparency = 1
			consoleText.TextColor3 = Color3.fromRGB(180, 255, 180)
			consoleText.Font = Enum.Font.Code
			consoleText.TextSize = 12
			consoleText.TextXAlignment = Enum.TextXAlignment.Left
			consoleText.TextYAlignment = Enum.TextYAlignment.Top
			consoleText.Text = "> Console ready..."
			consoleText.TextWrapped = true
			consoleText.Parent = consoleScroll
			createPadding(consoleText, 5)
			
			local function addConsoleLog(message, isError)
				local timestamp = os.date("%H:%M:%S")
				local color = isError and "[ERROR]" or "[INFO]"
				local newText = string.format("%s %s %s", timestamp, color, tostring(message))
				consoleText.Text = consoleText.Text .. "\n" .. newText
				consoleScroll.CanvasSize = UDim2.new(0, 0, 0, consoleText.TextBounds.Y + 10)
				consoleScroll.CanvasPosition = Vector2.new(0, consoleScroll.CanvasSize.Y.Offset)
			end
			
			executeBtn.MouseButton1Click:Connect(function()
				local code = scriptBox.Text
				if code == "" then
					addConsoleLog("No script to execute", true)
					return
				end
				
				addConsoleLog("Executing script...")
				local success, err = pcall(function()
					loadstring(code)()
				end)
				
				if success then
					addConsoleLog("Script executed successfully!")
				else
					addConsoleLog("Execution failed: " .. tostring(err), true)
				end
			end)
			
			clearBtn.MouseButton1Click:Connect(function()
				scriptBox.Text = ""
				addConsoleLog("Script cleared")
			end)
		else
			-- Section Title
			local titleLabel = createLabel(tabFrame, name .. " Settings", 20, Theme.TextPrimary, Enum.Font.GothamBlack)
			titleLabel.Size = UDim2.new(1, 0, 0, 30)
			titleLabel.TextXAlignment = Enum.TextXAlignment.Left
			
			if name == "Extras" then
				-- Camera FOV Changer
				local fovChangerFrame = Instance.new("Frame")
				fovChangerFrame.Size = UDim2.new(1, 0, 0, 80)
				fovChangerFrame.BackgroundColor3 = Theme.CardBackground
				fovChangerFrame.Parent = tabFrame
				createRoundedCorner(fovChangerFrame, 10)
				createPadding(fovChangerFrame, 15)
				
				local fovChangerLabel = createLabel(fovChangerFrame, "Camera FOV: 70", 14, Theme.TextPrimary, Enum.Font.GothamBold, UDim2.new(0, 0, 0, 5), Vector2.new(0, 0))
				fovChangerLabel.Size = UDim2.new(1, 0, 0, 20)
				fovChangerLabel.TextXAlignment = Enum.TextXAlignment.Left
				
				local fovChangerSliderBg = Instance.new("Frame")
				fovChangerSliderBg.Size = UDim2.new(1, -30, 0, 8)
				fovChangerSliderBg.Position = UDim2.new(0, 15, 0, 40)
				fovChangerSliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
				fovChangerSliderBg.Parent = fovChangerFrame
				createRoundedCorner(fovChangerSliderBg, 4)
				
				local fovChangerSliderFill = Instance.new("Frame")
				fovChangerSliderFill.Size = UDim2.new(0.5, 0, 1, 0)
				fovChangerSliderFill.BackgroundColor3 = Theme.Accent
				fovChangerSliderFill.Parent = fovChangerSliderBg
				createRoundedCorner(fovChangerSliderFill, 4)
				
				local currentFOV = 70
				local fovChangerDragging = false
				
				fovChangerSliderBg.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						fovChangerDragging = true
					end
				end)
				
				fovChangerSliderBg.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						fovChangerDragging = false
					end
				end)
				
				fovChangerSliderBg.InputChanged:Connect(function(input)
					if fovChangerDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
						local pos = (input.Position.X - fovChangerSliderBg.AbsolutePosition.X) / fovChangerSliderBg.AbsoluteSize.X
						pos = math.clamp(pos, 0, 1)
						fovChangerSliderFill.Size = UDim2.new(pos, 0, 1, 0)
						currentFOV = math.floor(30 + (pos * 90)) -- 30 to 120
						fovChangerLabel.Text = "Camera FOV: " .. currentFOV
						workspace.CurrentCamera.FieldOfView = currentFOV
					end
				end)
				
				-- Kill Aura (NPCs)
				local kaFrame = Instance.new("Frame")
				kaFrame.Size = UDim2.new(1, 0, 0, 80)
				kaFrame.BackgroundColor3 = Theme.CardBackground
				kaFrame.Parent = tabFrame
				createRoundedCorner(kaFrame, 10)
				createPadding(kaFrame, 15)
				
				local kaLabel = createLabel(kaFrame, "Kill Aura (NPCs)", 14, Theme.TextPrimary, Enum.Font.GothamBold, UDim2.new(0, 0, 0, 0), Vector2.new(0, 0))
				kaLabel.Size = UDim2.new(0, 200, 1, 0)
				kaLabel.TextXAlignment = Enum.TextXAlignment.Left
				kaLabel.TextYAlignment = Enum.TextYAlignment.Top
				
				local kaDesc = createLabel(kaFrame, "Attack nearby NPCs", 11, Theme.TextSecondary, Enum.Font.Gotham, UDim2.new(0, 0, 0, 22), Vector2.new(0, 0))
				kaDesc.Size = UDim2.new(0, 300, 0, 20)
				kaDesc.TextXAlignment = Enum.TextXAlignment.Left
				
				local kaToggleBtn = Instance.new("TextButton")
				kaToggleBtn.Text = ""
				kaToggleBtn.Size = UDim2.new(0, 50, 0, 26)
				kaToggleBtn.Position = UDim2.new(1, -50, 0.5, -10)
				kaToggleBtn.AnchorPoint = Vector2.new(0, 0.5)
				kaToggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
				kaToggleBtn.Parent = kaFrame
				createRoundedCorner(kaToggleBtn, 13)
				
				local kaCircle = Instance.new("Frame")
				kaCircle.Size = UDim2.new(0, 20, 0, 20)
				kaCircle.Position = UDim2.new(0, 3, 0.5, 0)
				kaCircle.AnchorPoint = Vector2.new(0, 0.5)
				kaCircle.BackgroundColor3 = Color3.fromRGB(220, 220, 230)
				kaCircle.Parent = kaToggleBtn
				createRoundedCorner(kaCircle, 10)
				
				-- Range Slider
				local kaRangeLabel = createLabel(kaFrame, "Range: 15", 11, Theme.TextSecondary, Enum.Font.Gotham, UDim2.new(0, 0, 0, 45), Vector2.new(0, 0))
				kaRangeLabel.Size = UDim2.new(1, 0, 0, 20)
				kaRangeLabel.TextXAlignment = Enum.TextXAlignment.Left
				
				local kaSliderBg = Instance.new("Frame")
				kaSliderBg.Size = UDim2.new(1, -60, 0, 6)
				kaSliderBg.Position = UDim2.new(0, 60, 0, 52)
				kaSliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
				kaSliderBg.Parent = kaFrame
				createRoundedCorner(kaSliderBg, 3)
				
				local kaSliderFill = Instance.new("Frame")
				kaSliderFill.Size = UDim2.new(0.3, 0, 1, 0)
				kaSliderFill.BackgroundColor3 = Theme.Accent
				kaSliderFill.Parent = kaSliderBg
				createRoundedCorner(kaSliderFill, 3)
				
				local kaRange = 15
				local kaDragging = false
				
				kaSliderBg.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then kaDragging = true end
				end)
				
				kaSliderBg.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then kaDragging = false end
				end)
				
				kaSliderBg.InputChanged:Connect(function(input)
					if kaDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
						local pos = (input.Position.X - kaSliderBg.AbsolutePosition.X) / kaSliderBg.AbsoluteSize.X
						pos = math.clamp(pos, 0, 1)
						kaSliderFill.Size = UDim2.new(pos, 0, 1, 0)
						kaRange = math.floor(5 + (pos * 45)) -- 5 to 50
						kaRangeLabel.Text = "Range: " .. kaRange
					end
				end)
				
				local kaEnabled = false
				local kaLoop
				
				kaToggleBtn.MouseButton1Click:Connect(function()
					kaEnabled = not kaEnabled
					if kaEnabled then
						TweenService:Create(kaToggleBtn, TweenInfo.new(0.25), {BackgroundColor3 = Theme.Accent}):Play()
						TweenService:Create(kaCircle, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Position = UDim2.new(1, -23, 0.5, 0)}):Play()
						
						kaLoop = RunService.Heartbeat:Connect(function()
							local myChar = LocalPlayer.Character
							if not myChar then return end
							local myRoot = myChar:FindFirstChild("HumanoidRootPart")
							if not myRoot then return end
							
							-- Find tool
							local tool = myChar:FindFirstChildOfClass("Tool")
							if not tool then return end
							
							for _, v in pairs(workspace:GetDescendants()) do
								if v:IsA("Humanoid") and v.Parent ~= myChar and v.Health > 0 then
									local char = v.Parent
									local root = char:FindFirstChild("HumanoidRootPart")
									
									-- Check if it's a player
									local player = Players:GetPlayerFromCharacter(char)
									if not player and root then -- It's an NPC
										local dist = (root.Position - myRoot.Position).Magnitude
										if dist <= kaRange then
											tool:Activate()
											break -- Attack one at a time to avoid lag/detection issues
										end
									end
								end
							end
						end)
					else
						TweenService:Create(kaToggleBtn, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(45, 45, 60)}):Play()
						TweenService:Create(kaCircle, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Position = UDim2.new(0, 3, 0.5, 0)}):Play()
						if kaLoop then kaLoop:Disconnect() kaLoop = nil end
					end
				end)
				
				-- Fly Toggle
				local flyFrame = Instance.new("Frame")
				flyFrame.Size = UDim2.new(1, 0, 0, 60)
				flyFrame.BackgroundColor3 = Theme.CardBackground
				flyFrame.Parent = tabFrame
				createRoundedCorner(flyFrame, 10)
				createPadding(flyFrame, 15)
				
				local flyLabel = createLabel(flyFrame, "Enable Fly", 14, Theme.TextPrimary, Enum.Font.GothamBold, UDim2.new(0, 0, 0, 0), Vector2.new(0, 0))
				flyLabel.Size = UDim2.new(0, 200, 1, 0)
				flyLabel.TextXAlignment = Enum.TextXAlignment.Left
				flyLabel.TextYAlignment = Enum.TextYAlignment.Top
				
				local flyDesc = createLabel(flyFrame, "Fly around the map", 11, Theme.TextSecondary, Enum.Font.Gotham, UDim2.new(0, 0, 0, 22), Vector2.new(0, 0))
				flyDesc.Size = UDim2.new(0, 300, 0, 20)
				flyDesc.TextXAlignment = Enum.TextXAlignment.Left
				
				local flyToggleBtn = Instance.new("TextButton")
				flyToggleBtn.Text = ""
				flyToggleBtn.Size = UDim2.new(0, 50, 0, 26)
				flyToggleBtn.Position = UDim2.new(1, -50, 0.5, 0)
				flyToggleBtn.AnchorPoint = Vector2.new(0, 0.5)
				flyToggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
				flyToggleBtn.Parent = flyFrame
				createRoundedCorner(flyToggleBtn, 13)
				
				local flyCircle = Instance.new("Frame")
				flyCircle.Size = UDim2.new(0, 20, 0, 20)
				flyCircle.Position = UDim2.new(0, 3, 0.5, 0)
				flyCircle.AnchorPoint = Vector2.new(0, 0.5)
				flyCircle.BackgroundColor3 = Color3.fromRGB(220, 220, 230)
				flyCircle.Parent = flyToggleBtn
				createRoundedCorner(flyCircle, 10)
				
				-- Fly Mode Selection
				local flyModeFrame = Instance.new("Frame")
				flyModeFrame.Size = UDim2.new(1, 0, 0, 60)
				flyModeFrame.BackgroundColor3 = Theme.CardBackground
				flyModeFrame.Parent = tabFrame
				createRoundedCorner(flyModeFrame, 10)
				createPadding(flyModeFrame, 15)
				
				local flyModeLabel = createLabel(flyModeFrame, "Fly Mode", 14, Theme.TextPrimary, Enum.Font.GothamBold, UDim2.new(0, 0, 0, 0), Vector2.new(0, 0))
				flyModeLabel.Size = UDim2.new(0, 200, 1, 0)
				flyModeLabel.TextXAlignment = Enum.TextXAlignment.Left
				flyModeLabel.TextYAlignment = Enum.TextYAlignment.Top
				
				local flyModeDesc = createLabel(flyModeFrame, "Position (CFrame) or Speed (Velocity)", 11, Theme.TextSecondary, Enum.Font.Gotham, UDim2.new(0, 0, 0, 22), Vector2.new(0, 0))
				flyModeDesc.Size = UDim2.new(0, 300, 0, 20)
				flyModeDesc.TextXAlignment = Enum.TextXAlignment.Left
				
				-- Fly mode buttons
				local positionBtn = Instance.new("TextButton")
				positionBtn.Text = "Position"
				positionBtn.Size = UDim2.new(0, 80, 0, 26)
				positionBtn.Position = UDim2.new(1, -170, 0.5, 0)
				positionBtn.AnchorPoint = Vector2.new(0, 0.5)
				positionBtn.BackgroundColor3 = Theme.Accent
				positionBtn.TextColor3 = Theme.TextPrimary
				positionBtn.Font = Enum.Font.GothamBold
				positionBtn.TextSize = 12
				positionBtn.Parent = flyModeFrame
				createRoundedCorner(positionBtn, 6)
				
				local speedBtn = Instance.new("TextButton")
				speedBtn.Text = "Speed"
				speedBtn.Size = UDim2.new(0, 80, 0, 26)
				speedBtn.Position = UDim2.new(1, -80, 0.5, 0)
				speedBtn.AnchorPoint = Vector2.new(0, 0.5)
				speedBtn.BackgroundColor3 = Theme.CardBackground
				speedBtn.TextColor3 = Theme.TextSecondary
				speedBtn.Font = Enum.Font.GothamBold
				speedBtn.TextSize = 12
				speedBtn.Parent = flyModeFrame
				createRoundedCorner(speedBtn, 6)
				
				local flyMode = "position" -- default
				local flySpeed = 50
				
				positionBtn.MouseButton1Click:Connect(function()
					flyMode = "position"
					positionBtn.BackgroundColor3 = Theme.Accent
					positionBtn.TextColor3 = Theme.TextPrimary
					speedBtn.BackgroundColor3 = Theme.CardBackground
					speedBtn.TextColor3 = Theme.TextSecondary
				end)
				
				speedBtn.MouseButton1Click:Connect(function()
					flyMode = "speed"
					speedBtn.BackgroundColor3 = Theme.Accent
					speedBtn.TextColor3 = Theme.TextPrimary
					positionBtn.BackgroundColor3 = Theme.CardBackground
					positionBtn.TextColor3 = Theme.TextSecondary
				end)
				
				-- Fly Speed Slider
				local flySpeedFrame = Instance.new("Frame")
				flySpeedFrame.Size = UDim2.new(1, 0, 0, 80)
				flySpeedFrame.BackgroundColor3 = Theme.CardBackground
				flySpeedFrame.Parent = tabFrame
				createRoundedCorner(flySpeedFrame, 10)
				createPadding(flySpeedFrame, 15)
				
				local flySpeedLabel = createLabel(flySpeedFrame, "Fly Speed: 50", 14, Theme.TextPrimary, Enum.Font.GothamBold, UDim2.new(0, 0, 0, 5), Vector2.new(0, 0))
				flySpeedLabel.Size = UDim2.new(1, 0, 0, 20)
				flySpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
				
				local flySpeedSliderBg = Instance.new("Frame")
				flySpeedSliderBg.Size = UDim2.new(1, -30, 0, 8)
				flySpeedSliderBg.Position = UDim2.new(0, 15, 0, 40)
				flySpeedSliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
				flySpeedSliderBg.Parent = flySpeedFrame
				createRoundedCorner(flySpeedSliderBg, 4)
				
				local flySpeedSliderFill = Instance.new("Frame")
				flySpeedSliderFill.Size = UDim2.new(0.25, 0, 1, 0)
				flySpeedSliderFill.BackgroundColor3 = Theme.Accent
				flySpeedSliderFill.Parent = flySpeedSliderBg
				createRoundedCorner(flySpeedSliderFill, 4)
				
				local flySpeed = 50
				local flySpeedDragging = false
				
				flySpeedSliderBg.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						flySpeedDragging = true
					end
				end)
				
				flySpeedSliderBg.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						flySpeedDragging = false
					end
				end)
				
				flySpeedSliderBg.InputChanged:Connect(function(input)
					if flySpeedDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
						local pos = (input.Position.X - flySpeedSliderBg.AbsolutePosition.X) / flySpeedSliderBg.AbsoluteSize.X
						pos = math.clamp(pos, 0, 1)
						flySpeedSliderFill.Size = UDim2.new(pos, 0, 1, 0)
						flySpeed = math.floor(10 + (pos * 190)) -- 10 to 200
						flySpeedLabel.Text = "Fly Speed: " .. flySpeed
					end
				end)
				
				-- Fly Logic
				local flying = false
				local flyAttachment
				local flyLinearVelocity
				local flyAlignOrientation
				local flyConnection
				local noclipConnection
				
				flyToggleBtn.MouseButton1Click:Connect(function()
					flying = not flying
					if flying then
						TweenService:Create(flyToggleBtn, TweenInfo.new(0.25), {BackgroundColor3 = Theme.Accent}):Play()
						TweenService:Create(flyCircle, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Position = UDim2.new(1, -23, 0.5, 0)}):Play()
						
						local char = LocalPlayer.Character
						if char and char:FindFirstChild("HumanoidRootPart") then
							local hrp = char.HumanoidRootPart
							local camera = workspace.CurrentCamera
							local keys = {W = false, A = false, S = false, D = false, Space = false, LeftShift = false}
							
							UserInputService.InputBegan:Connect(function(input)
								if keys[input.KeyCode.Name] ~= nil then
									keys[input.KeyCode.Name] = true
								end
							end)
							
							UserInputService.InputEnded:Connect(function(input)
								if keys[input.KeyCode.Name] ~= nil then
									keys[input.KeyCode.Name] = false
								end
							end)
							
							-- Noclip Loop
							noclipConnection = RunService.Stepped:Connect(function()
								if flying and char then
									for _, part in pairs(char:GetDescendants()) do
										if part:IsA("BasePart") and part.CanCollide then
											part.CanCollide = false
										end
									end
								end
							end)
							
							if flyMode == "speed" then
								-- Speed mode - uses LinearVelocity (Modern Physics)
								flyAttachment = Instance.new("Attachment")
								flyAttachment.Parent = hrp
								
								flyLinearVelocity = Instance.new("LinearVelocity")
								flyLinearVelocity.Attachment0 = flyAttachment
								flyLinearVelocity.MaxForce = 9e9
								flyLinearVelocity.VectorVelocity = Vector3.new(0, 0, 0)
								flyLinearVelocity.Parent = hrp
								
								flyAlignOrientation = Instance.new("AlignOrientation")
								flyAlignOrientation.Attachment0 = flyAttachment
								flyAlignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
								flyAlignOrientation.MaxTorque = 9e9
								flyAlignOrientation.Responsiveness = 200
								flyAlignOrientation.Parent = hrp
								
								flyConnection = RunService.RenderStepped:Connect(function()
									if flying and flyLinearVelocity and flyAlignOrientation then
										local velocity = Vector3.new(0, 0, 0)
										
										if keys.W then velocity = velocity + camera.CFrame.LookVector end
										if keys.S then velocity = velocity - camera.CFrame.LookVector end
										if keys.A then velocity = velocity - camera.CFrame.RightVector end
										if keys.D then velocity = velocity + camera.CFrame.RightVector end
										if keys.Space then velocity = velocity + Vector3.new(0, 1, 0) end
										if keys.LeftShift then velocity = velocity - Vector3.new(0, 1, 0) end
										
										if velocity.Magnitude > 0 then
											flyLinearVelocity.VectorVelocity = velocity.Unit * flySpeed
										else
											flyLinearVelocity.VectorVelocity = Vector3.new(0, 0, 0)
										end
										flyAlignOrientation.CFrame = camera.CFrame
									end
								end)
							elseif flyMode == "position" then
								-- Position mode - uses CFrame manipulation
								-- Disable gravity for position mode
								local hum = char:FindFirstChild("Humanoid")
								if hum then hum.PlatformStand = true end
								
								flyConnection = RunService.RenderStepped:Connect(function()
									if flying and hrp then
										local velocity = Vector3.new(0, 0, 0)
										
										if keys.W then velocity = velocity + camera.CFrame.LookVector end
										if keys.S then velocity = velocity - camera.CFrame.LookVector end
										if keys.A then velocity = velocity - camera.CFrame.RightVector end
										if keys.D then velocity = velocity + camera.CFrame.RightVector end
										if keys.Space then velocity = velocity + Vector3.new(0, 1, 0) end
										if keys.LeftShift then velocity = velocity - Vector3.new(0, 1, 0) end
										
										if velocity.Magnitude > 0 then
											hrp.CFrame = hrp.CFrame + (velocity.Unit * (flySpeed / 50))
										end
										hrp.Velocity = Vector3.new(0, 0, 0) -- Stop physics velocity
									end
								end)
							end
						end
					else
						TweenService:Create(flyToggleBtn, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(45, 45, 60)}):Play()
						TweenService:Create(flyCircle, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Position = UDim2.new(0, 3, 0.5, 0)}):Play()
						
						if flyAttachment then flyAttachment:Destroy() end
						if flyLinearVelocity then flyLinearVelocity:Destroy() end
						if flyAlignOrientation then flyAlignOrientation:Destroy() end
						if flyConnection then flyConnection:Disconnect() end
						if noclipConnection then noclipConnection:Disconnect() end
						
						local char = LocalPlayer.Character
						if char then
							local hum = char:FindFirstChild("Humanoid")
							if hum then hum.PlatformStand = false end
						end
					end
				end)
				-- Fly Keybind Selector
				local flyKeybindFrame = Instance.new("Frame")
				flyKeybindFrame.Size = UDim2.new(1, 0, 0, 60)
				flyKeybindFrame.BackgroundColor3 = Theme.CardBackground
				flyKeybindFrame.Parent = tabFrame
				createRoundedCorner(flyKeybindFrame, 10)
				createPadding(flyKeybindFrame, 15)
				
				local flyKeyLabel = createLabel(flyKeybindFrame, "Fly Keybind: X", 14, Theme.TextPrimary, Enum.Font.GothamBold, UDim2.new(0, 0, 0, 0), Vector2.new(0, 0))
				flyKeyLabel.Size = UDim2.new(0, 200, 1, 0)
				flyKeyLabel.TextXAlignment = Enum.TextXAlignment.Left
				flyKeyLabel.TextYAlignment = Enum.TextYAlignment.Top
				
				local flyKeyDesc = createLabel(flyKeybindFrame, "Press to toggle fly", 11, Theme.TextSecondary, Enum.Font.Gotham, UDim2.new(0, 0, 0, 22), Vector2.new(0, 0))
				flyKeyDesc.Size = UDim2.new(0, 300, 0, 20)
				flyKeyDesc.TextXAlignment = Enum.TextXAlignment.Left
				
				local flyKeyBtn = Instance.new("TextButton")
				flyKeyBtn.Text = "Change"
				flyKeyBtn.Size = UDim2.new(0, 80, 0, 26)
				flyKeyBtn.Position = UDim2.new(1, -80, 0.5, 0)
				flyKeyBtn.AnchorPoint = Vector2.new(0, 0.5)
				flyKeyBtn.BackgroundColor3 = Theme.Accent
				flyKeyBtn.TextColor3 = Theme.TextPrimary
				flyKeyBtn.Font = Enum.Font.GothamBold
				flyKeyBtn.TextSize = 12
				flyKeyBtn.Parent = flyKeybindFrame
				createRoundedCorner(flyKeyBtn, 6)
				
				local waitingForFlyKey = false
				flyKeyBtn.MouseButton1Click:Connect(function()
					waitingForFlyKey = true
					flyKeyBtn.Text = "Press Key..."
					local connection
					connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
						if waitingForFlyKey and input.UserInputType == Enum.UserInputType.Keyboard then
							flyKeybind = input.KeyCode
							flyKeyLabel.Text = "Fly Keybind: " .. input.KeyCode.Name
							flyKeyBtn.Text = "Change"
							waitingForFlyKey = false
							connection:Disconnect()
						end
					end)
				end)
				
				-- Fly Keybind Logic
				UserInputService.InputBegan:Connect(function(input, gameProcessed)
					if not gameProcessed and input.KeyCode == flyKeybind then
						-- Trigger the fly toggle button click
						for _, connection in pairs(getconnections(flyToggleBtn.MouseButton1Click)) do
							connection:Fire()
						end
					end
				end)

				-- Fling Tool Button
				local toolFrame = Instance.new("Frame")
				toolFrame.Size = UDim2.new(1, 0, 0, 60)
				toolFrame.BackgroundColor3 = Theme.CardBackground
				toolFrame.Parent = tabFrame
				createRoundedCorner(toolFrame, 10)
				createPadding(toolFrame, 15)
				
				local toolLabel = createLabel(toolFrame, "Fling Tool", 14, Theme.TextPrimary, Enum.Font.GothamBold, UDim2.new(0, 0, 0, 0), Vector2.new(0, 0))
				toolLabel.Size = UDim2.new(0, 200, 1, 0)
				toolLabel.TextXAlignment = Enum.TextXAlignment.Left
				toolLabel.TextYAlignment = Enum.TextYAlignment.Top
				
				local toolDesc = createLabel(toolFrame, "Add 'Yeet Gun' to inventory", 11, Theme.TextSecondary, Enum.Font.Gotham, UDim2.new(0, 0, 0, 22), Vector2.new(0, 0))
				toolDesc.Size = UDim2.new(0, 300, 0, 20)
				toolDesc.TextXAlignment = Enum.TextXAlignment.Left
				
				local getToolBtn = Instance.new("TextButton")
				getToolBtn.Text = "Get Tool"
				getToolBtn.Size = UDim2.new(0, 80, 0, 26)
				getToolBtn.Position = UDim2.new(1, -80, 0.5, 0)
				getToolBtn.AnchorPoint = Vector2.new(0, 0.5)
				getToolBtn.BackgroundColor3 = Theme.Accent
				getToolBtn.TextColor3 = Theme.TextPrimary
				getToolBtn.Font = Enum.Font.GothamBold
				getToolBtn.TextSize = 12
				getToolBtn.Parent = toolFrame
				createRoundedCorner(getToolBtn, 6)
				
				getToolBtn.MouseButton1Click:Connect(function()
					local tool = Instance.new("Tool")
					tool.Name = "Yeet Gun"
					tool.RequiresHandle = false
					tool.Parent = LocalPlayer.Backpack
					
					tool.Activated:Connect(function()
						local mouse = LocalPlayer:GetMouse()
						local target = mouse.Target
						if target and target.Parent and target.Parent:FindFirstChild("Humanoid") then
							local targetChar = target.Parent
							local myChar = LocalPlayer.Character
							
							if myChar and myChar:FindFirstChild("HumanoidRootPart") then
								local hrp = myChar.HumanoidRootPart
								local oldPos = hrp.CFrame
								
								-- Create rotating force
								local bav = Instance.new("BodyAngularVelocity")
								bav.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
								bav.AngularVelocity = Vector3.new(0, 10000, 0)
								bav.Parent = hrp
								
								-- Fling logic
								local startTime = tick()
								local connection
								
								-- Disable physics state
								local hum = myChar:FindFirstChild("Humanoid")
								if hum then hum.PlatformStand = true end
								
								connection = game:GetService("RunService").Heartbeat:Connect(function()
									if tick() - startTime > 2 or not targetChar:FindFirstChild("HumanoidRootPart") then
										connection:Disconnect()
										if bav then bav:Destroy() end
										if hum then hum.PlatformStand = false end
										
										hrp.CFrame = oldPos
										hrp.Velocity = Vector3.new(0,0,0)
										hrp.RotVelocity = Vector3.new(0,0,0)
									else
										local tHrp = targetChar.HumanoidRootPart
										
										-- Force collision
										hrp.CanCollide = true
										
										-- Aggressive movement: Go through the target rapidly
										-- Oscillate up and down through the target's body
										local time = tick() * 20
										local offset = Vector3.new(math.sin(time)*2, math.cos(time)*2, math.sin(time)*2)
										
										hrp.CFrame = tHrp.CFrame * CFrame.new(0, 0, 0) + offset
										
										-- Apply massive force
										hrp.Velocity = Vector3.new(10000, 10000, 10000)
										hrp.RotVelocity = Vector3.new(10000, 10000, 10000)
									end
								end)
							end
						end
					end)
					
					addConsoleLog("Yeet Gun added to Backpack!")
				end)
				
				-- Bazooka Tool Button
				local bazookaFrame = Instance.new("Frame")
				bazookaFrame.Size = UDim2.new(1, 0, 0, 60)
				bazookaFrame.BackgroundColor3 = Theme.CardBackground
				bazookaFrame.Parent = tabFrame
				createRoundedCorner(bazookaFrame, 10)
				createPadding(bazookaFrame, 15)
				
				local bazookaLabel = createLabel(bazookaFrame, "Bazooka", 14, Theme.TextPrimary, Enum.Font.GothamBold, UDim2.new(0, 0, 0, 0), Vector2.new(0, 0))
				bazookaLabel.Size = UDim2.new(0, 200, 1, 0)
				bazookaLabel.TextXAlignment = Enum.TextXAlignment.Left
				bazookaLabel.TextYAlignment = Enum.TextYAlignment.Top
				
				local bazookaDesc = createLabel(bazookaFrame, "Explosive projectile launcher", 11, Theme.TextSecondary, Enum.Font.Gotham, UDim2.new(0, 0, 0, 22), Vector2.new(0, 0))
				bazookaDesc.Size = UDim2.new(0, 300, 0, 20)
				bazookaDesc.TextXAlignment = Enum.TextXAlignment.Left
				
				local getBazookaBtn = Instance.new("TextButton")
				getBazookaBtn.Text = "Get Bazooka"
				getBazookaBtn.Size = UDim2.new(0, 80, 0, 26)
				getBazookaBtn.Position = UDim2.new(1, -80, 0.5, 0)
				getBazookaBtn.AnchorPoint = Vector2.new(0, 0.5)
				getBazookaBtn.BackgroundColor3 = Theme.Accent
				getBazookaBtn.TextColor3 = Theme.TextPrimary
				getBazookaBtn.Font = Enum.Font.GothamBold
				getBazookaBtn.TextSize = 12
				getBazookaBtn.Parent = bazookaFrame
				createRoundedCorner(getBazookaBtn, 6)
				
				getBazookaBtn.MouseButton1Click:Connect(function()
					local tool = Instance.new("Tool")
					tool.Name = "Bazooka"
					tool.RequiresHandle = false
					tool.Parent = LocalPlayer.Backpack
					
					local Debris = game:GetService("Debris")
					
					tool.Activated:Connect(function()
						local mouse = LocalPlayer:GetMouse()
						local spawnPos = LocalPlayer.Character.Head.Position + (mouse.Hit.Position - LocalPlayer.Character.Head.Position).Unit * 5
						
						local rocket = Instance.new("Part")
						rocket.Size = Vector3.new(1, 1, 2)
						rocket.BrickColor = BrickColor.new("Bright red")
						rocket.Material = Enum.Material.Neon
						rocket.CFrame = CFrame.new(spawnPos, mouse.Hit.Position)
						rocket.CanCollide = false
						rocket.Parent = workspace
						
						local bv = Instance.new("BodyVelocity")
						bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
						bv.Velocity = rocket.CFrame.LookVector * 100
						bv.Parent = rocket
						
						rocket.Touched:Connect(function(hit)
							if hit.Parent ~= LocalPlayer.Character and hit.Parent.Parent ~= LocalPlayer.Character then
								local explosion = Instance.new("Explosion")
								explosion.Position = rocket.Position
								explosion.BlastRadius = 10
								explosion.BlastPressure = 500000
								explosion.Parent = workspace
								
								rocket:Destroy()
							end
						end)
						
						Debris:AddItem(rocket, 5)
					end)
					
					addConsoleLog("Bazooka added to Backpack!")
				end)
			elseif name == "Configuração" then
				-- Section Title
				local titleLabel = createLabel(tabFrame, "Configuration", 18, Theme.TextPrimary, Enum.Font.GothamBlack)
				titleLabel.Size = UDim2.new(1, 0, 0, 30)
				titleLabel.TextXAlignment = Enum.TextXAlignment.Left
				
				-- Unload Button
				local unloadFrame = Instance.new("Frame")
				unloadFrame.Size = UDim2.new(1, 0, 0, 60)
				unloadFrame.BackgroundColor3 = Theme.CardBackground
				unloadFrame.Parent = tabFrame
				createRoundedCorner(unloadFrame, 10)
				createPadding(unloadFrame, 15)
				
				local unloadLabel = createLabel(unloadFrame, "Unload GUI", 14, Theme.TextPrimary, Enum.Font.GothamBold, UDim2.new(0, 0, 0, 0), Vector2.new(0, 0))
				unloadLabel.Size = UDim2.new(0, 200, 1, 0)
				unloadLabel.TextXAlignment = Enum.TextXAlignment.Left
				unloadLabel.TextYAlignment = Enum.TextYAlignment.Top
				
				local unloadDesc = createLabel(unloadFrame, "Remove GUI from screen", 11, Theme.TextSecondary, Enum.Font.Gotham, UDim2.new(0, 0, 0, 22), Vector2.new(0, 0))
				unloadDesc.Size = UDim2.new(0, 300, 0, 20)
				unloadDesc.TextXAlignment = Enum.TextXAlignment.Left
				
				local unloadBtn = Instance.new("TextButton")
				unloadBtn.Text = "Unload"
				unloadBtn.Size = UDim2.new(0, 80, 0, 26)
				unloadBtn.Position = UDim2.new(1, -80, 0.5, 0)
				unloadBtn.AnchorPoint = Vector2.new(0, 0.5)
				unloadBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
				unloadBtn.TextColor3 = Theme.TextPrimary
				unloadBtn.Font = Enum.Font.GothamBold
				unloadBtn.TextSize = 12
				unloadBtn.Parent = unloadFrame
				createRoundedCorner(unloadBtn, 6)
				
				unloadBtn.MouseButton1Click:Connect(function()
					ScreenGui:Destroy()
				end)
			end
		end
	end

	-- Create Nav Buttons
	for i, item in ipairs(navItems) do
		local btn = Instance.new("TextButton")
		btn.Text = item
		btn.BackgroundTransparency = 1
		btn.TextColor3 = Theme.TextSecondary
		btn.Font = Enum.Font.GothamBold
		btn.TextSize = 15
		btn.Size = UDim2.new(0, 130, 0, 40)
		btn.Parent = NavBtnContainer
		
		createRoundedCorner(btn, 10)
		
		btn.MouseEnter:Connect(function()
			if not buttons[item] or btn.BackgroundTransparency == 1 then
				TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.95, BackgroundColor3 = Color3.fromRGB(50, 45, 70)}):Play()
			end
		end)
		
		btn.MouseLeave:Connect(function()
			if not buttons[item] or btn.BackgroundTransparency ~= 0 then
				TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
			end
		end)
		
		btn.MouseButton1Click:Connect(function()
			-- Reset all
			for _, b in pairs(buttons) do
				TweenService:Create(b, TweenInfo.new(0.2), {BackgroundTransparency = 1, TextColor3 = Theme.TextSecondary}):Play()
			end
			for _, t in pairs(tabs) do
				t.Visible = false
			end
			
			-- Activate current
			TweenService:Create(btn, TweenInfo.new(0.2), {
				BackgroundTransparency = 0,
				BackgroundColor3 = Color3.fromRGB(50, 45, 75),
				TextColor3 = Theme.Accent
			}):Play()
			
			if tabs[item] then
				tabs[item].Visible = true
			end
		end)
		
		buttons[item] = btn
	end
	
	-- Select first tab by default
	if buttons[navItems[1]] then
		local firstBtn = buttons[navItems[1]]
		TweenService:Create(firstBtn, TweenInfo.new(0.2), {
			BackgroundTransparency = 0,
			BackgroundColor3 = Color3.fromRGB(50, 45, 75),
			TextColor3 = Theme.Accent
		}):Play()
		if tabs[navItems[1]] then
			tabs[navItems[1]].Visible = true
		end
	end
	
	-- Centralized Player Event Listeners
	Players.PlayerAdded:Connect(function(player)
		task.wait(1) -- Wait for character to load potentially
		if player ~= LocalPlayer then
			createESP(player)
			if updatePlayerList then updatePlayerList() end
		end
	end)
	
	Players.PlayerRemoving:Connect(function(player)
		removeESP(player)
		if updatePlayerList then updatePlayerList() end
	end)
	
	-- Initial ESP Load
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			createESP(player)
		end
	end


	-- Draggable Logic
	local dragging, dragInput, dragStart, startPos
	local function update(input)
		local delta = input.Position - dragStart
		MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
	
	NavBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = MainFrame.Position
			
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	
	NavBar.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			if dragging then
				update(input)
			end
		end
	end)
	
	-- Toggle Keybind (Ctrl)
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
			MainFrame.Visible = not MainFrame.Visible
		end
	end)
end

-- Run
createGUI()
