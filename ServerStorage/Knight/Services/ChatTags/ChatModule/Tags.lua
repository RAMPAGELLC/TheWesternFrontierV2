local a = {
	Groups = {

	},
	Players = {
	}
}

local function b(c)
	local function d(e, f)
		local g = false
		local e =
			type(e) == "number" and game:GetService("Players"):GetPlayerByUserId(e) or type(e) == "userdata" and e or
			nil
		if type(e) == "userdata" and type(f) == "number" then
			warn("Succesfully got an Player and a valid ID.")
			local h, i =
				pcall(
					function()
					return game:GetService("MarketplaceService"):PlayerOwnsAsset(e, f)
				end
				)
			if h then
				print("Player " .. e.Name .. " has gamepass with ID " .. f)
				g = i
			else
				error(i)
			end
		end
		return g
	end
	local function j(k, l)
		assert(type(l) == "nil" or type(l) == "number", "requiredRank must be a number or nil")
		return function(m)
			if m and m.UserId then
				local n = m.UserId
				local o = false
				local p, q =
					pcall(
						function()
						if l then
							o = m:GetRankInGroup(k) == l
						else
							o = m:IsInGroup(k)
						end
					end
					)
				if not p and q then
					print("Error checking in group: " .. q)
				end
				return o
			end
			return false
		end
	end
	local function r()
		if a.Groups then
			for s, t in pairs(a.Groups) do
				t.IsInGroup = j(t.GroupId, t.Rank)
			end
		end
	end
	r()

	local u = game:GetService("Players")
	local Database = require(game.ReplicatedStorage.Knight.Services.Database).Content
	
	local function hsvToRgb(h, s, v)
		local r, g, b

		local i = math.floor(h * 6)
		local f = h * 6 - i
		local p = v * (1 - s)
		local q = v * (1 - f * s)
		local t = v * (1 - (1 - f) * s)

		i = i % 6

		if i == 0 then r, g, b = v, t, p
		elseif i == 1 then r, g, b = q, v, p
		elseif i == 2 then r, g, b = p, v, t
		elseif i == 3 then r, g, b = p, q, v
		elseif i == 4 then r, g, b = t, p, v
		elseif i == 5 then r, g, b = v, p, q
		end

		return Color3.fromRGB(r * 255, g * 255, b * 255)
	end
	
	local function GetSpecialChatColor(w)
		local x = u:FindFirstChild(w)
		local tags = {}
		local color = nil
		local customcolor = false
		local bubblecolor = Color3.fromRGB(188, 194, 200)

		if a.Players then
			if x then
				for s, m in pairs(a.Players) do
					if x.UserId == m.UserId then
						customcolor = true
						color =  m.ChatColor
						table.insert(tags, m.TagText)
						--return m.ChatColor, m.TagText
					end
				end
			end
		end

		if a.Groups then
			for s, t in pairs(a.Groups) do
				if t.IsInGroup(x) then
					customcolor = true
					color =  t.ChatColor
					table.insert(tags, t.TagText)
					--return t.ChatColor, t.TagText
				end
			end
		end

		local Data = _G.PlayerData[x.Name]

		--[[if Data then
			for i,v in pairs(Database.Tags.Ranks) do
				if Data.Moderation.Rank == i then
					customcolor = true
					color = v.ChatColor
					bubblecolor = v.ChatColor
					table.insert(tags, v.TagText)
					break
				end
			end
		end
]]
		
		for i,v in pairs(Database.Tags.JobTitles) do
			if x.Team == v.Team then
				if v.ChatColor ~= nil then
					customcolor = true
					color = v.ChatColor
					bubblecolor = v.ChatColor
				end
				
				table.insert(tags, v.TagText)
				break
			end
		end

		if Data then
			for i,v in pairs(Database.Tags.Titles) do
				if Data.SelectedRankTitle == i then
					if v.ChatColor ~= nil then
						customcolor = true
						color = v.ChatColor
						bubblecolor = v.ChatColor
					end
					
					table.insert(tags, v.TagText)
					break
				end
			end
		end

		wait()

		return tags, customcolor and color or false, bubblecolor
		--	local y = d(x, 383714071)
		--	if y == true then
		--		return nil, v
		--	end
	end
	local z = function(w, A)
		local x = u:FindFirstChild(w)
		repeat wait() until _G.PlayerData[x.Name] ~= nil

		local B = c:GetSpeaker(w)
		local E, D, H = GetSpecialChatColor(w)

		if D ~= false then
			B:SetExtraData("ChatColor", D)
		end

		x:SetAttribute("BubbleChatTextColor", H)

		if E then
			B:SetExtraData("Tags", E)
		end
	end
	local F = {ChatColor = Color3.fromRGB(245, 50, 50)}
	local G = {ChatColor = Color3.fromRGB(85, 255, 127)}
	local H = function(I, J, K)
		local B = c:GetSpeaker(I)
		if not B:GetExtraData("ChatColor") then
			return false
		end

		if string.sub(J, 1, 4):lower() == "/tog " or J:lower() == "/tog" then
			if B:GetExtraData("ChatColor") == Color3.new(1, 1, 1) then
				z(I, true)
				B:SendSystemMessage("Chat Tag is toggled on!", "All", G)
			else
				B:SetExtraData("ChatColor", Color3.new(1, 1, 1))
				B:SetExtraData("Tags", {})
				local x = u:FindFirstChild(I)
				x:SetAttribute("BubbleChatTextColor", Color3.fromRGB(188, 194, 200))
				B:SendSystemMessage("Chat Tag is toggled off, Run command again to re enabled!", "All", F)
			end
			return true
		end
		return false
	end

	game.ReplicatedStorage.Events.Titles.Event:Connect(function(Player, ...)
		local args = {...};

		if args[1] == "Refresh" then
			z(Player.Name, true)
		end
	end)

	c.SpeakerAdded:Connect(z)
	c:RegisterProcessCommandsFunction("Staff_commands", H)
end
return b
