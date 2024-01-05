local tweenService = game:GetService("TweenService")

local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)

local damageForColours = {
	[25] = Color3.fromRGB(255, 140, 0),
	[50] = Color3.fromRGB(255, 96, 96),
	[75] = Color3.fromRGB(255, 60, 60),
	[100] = Color3.fromRGB(255, 0, 0),
}

game.Players.PlayerAdded:Connect(function(plr)

	plr.CharacterAdded:Connect(function(char)

		local humanoid = char:WaitForChild("Humanoid")
		local currentHealth = humanoid.Health

		humanoid.HealthChanged:Connect(function(health)

			if health < currentHealth and humanoid:GetState() ~= Enum.HumanoidStateType.Dead then

				local healthLost = math.floor(currentHealth - health)


				local damageIndicatorGui = Instance.new("BillboardGui")
				damageIndicatorGui.AlwaysOnTop = true

				damageIndicatorGui.Size = UDim2.new(1.5, 0, 1.5, 0)

				local offsetX = math.random(-10, 10)/10
				local offsetY = math.random(-10, 10)/10
				local offsetZ = math.random(-10, 10)/10
				damageIndicatorGui.StudsOffset = Vector3.new(offsetX, offsetY, offsetZ)

				local damageIndicatorLabel = Instance.new("TextLabel")

				damageIndicatorLabel.AnchorPoint = Vector2.new(0.5, 0.5)
				damageIndicatorLabel.Position = UDim2.new(0.5, 0, 0.5, 0)

				damageIndicatorLabel.TextScaled = true
				damageIndicatorLabel.BackgroundTransparency = 1
				damageIndicatorLabel.Font = Enum.Font.GothamBlack

				damageIndicatorLabel.Text = healthLost

				damageIndicatorLabel.Size = UDim2.new(0, 0, 0, 0)

				for damage, colour in pairs(damageForColours) do

					if healthLost <= damage then 

						damageIndicatorLabel.TextColor3 = colour
						damage = 100
					end
				end

				damageIndicatorLabel.Parent = damageIndicatorGui

				damageIndicatorGui.Parent = char.HumanoidRootPart

				damageIndicatorLabel:TweenSize(UDim2.new(1, 0, 1, 0), "InOut", "Quint", 0.3)


				wait(0.3)

				local guiUpTween = tweenService:Create(damageIndicatorGui, tweenInfo, {StudsOffset = damageIndicatorGui.StudsOffset + Vector3.new(0, 1, 0)})

				local textFadeTween = tweenService:Create(damageIndicatorLabel, tweenInfo, {TextTransparency = 1})

				guiUpTween:Play()
				textFadeTween:Play()

				game:GetService("Debris"):AddItem(damageIndicatorGui, 0.3)
			end

			currentHealth = humanoid.Health
		end)
	end)
end)