local m = {}
local Bans = game:GetService("DataStoreService"):GetDataStore("bans")
--local MenuSessionData = game:GetService("DataStoreService"):GetDataStore("MenuSessionData")
--local fingerprints = game:GetService("DataStoreService"):GetDataStore("fingerprints")

function plural(n)
	return n == 1 and "" or "s"
end

function Kick(p, reason)
	return p:Kick(reason)
	
	--[[local d = {
		LastPlay = os.time(),
		DisconnectToMenu = true,
		MenuMessage = reason
	}

	MenuSessionData:SetAsync(p.UserId, d)
	task.wait(.3)
	game:GetService("TeleportService"):Teleport(5629129812, p)]]
end

_G.Kick = Kick;

function m:getTimeString(seconds)
	local minutes = math.floor(seconds / 60)
	seconds = seconds % 60
	local hours = math.floor(minutes / 60)
	minutes = minutes % 60
	local days = math.floor(hours / 24)
	hours = hours % 24
	local s
	if days > 0 then
		s = days .. " day" .. plural(days)
		if hours > 0 then
			s = s .. ", " .. hours .. " hour" .. plural(hours)
		end
	elseif hours > 0 then
		s = hours .. " hour" .. plural(hours)
		if minutes > 0 then
			s = s .. ", " .. minutes .. " minute" .. plural(minutes)
		end
	elseif minutes > 0 then
		s = minutes .. " minute" .. plural(minutes)
		if seconds > 0 then
			s = s .. ", " .. seconds .. " second" .. plural(seconds)
		end
	else
		s = seconds .. " second" .. plural(seconds)
	end
	return s
end

function m:Unban(UserId, Admin, Reason)
	Bans:RemoveAsync(UserId)
	
	m.Services.DiscordProxy:SendEmbed("Admin", {
		title = 'TWF Admin - User Unbanned',
		color = 15548997,
		fields = {
			{
				name = 'UserId',
				value = UserId,
				inline = true
			},
			{
				name = 'Admin',
				value = Admin.Name.." ("..Admin.UserId..")",
				inline = true
			},
			{
				name = 'Action',
				value = 'Unban',
				inline = true
			},
			{
				name = "Reason",
				value = Reason,
				inline = true
			}
		}
	});
	
	return "User unbanned"
end

function m:Ban(length, reason, plr, Admin, IsRAC)
	local Data = {
		reason = reason,
		TimestampEnd = m:GetTimestampFromString(length),
		TimestampStarted = os.time()
	}
	
	if IsRAC == nil then IsRAC = false end

	local HistoryData = {
		Type = "Ban",
		Reason = reason,
		End = Data.TimestampEnd,
		Start = Data.TimestampStarted,
		Moderator = Admin.Name.." - "..Admin.UserId
	}
	
	if type(plr) == "number" then
		Bans:SetAsync(plr, Data)
		m.Services.DiscordProxy:SendEmbed("Admin", {
			title = 'TWF Admin - User Banned',
			color = 15548997,
			fields = {
				{
					name = 'Target',
					value = plr,
					inline = true
				},
				{
					name = 'Admin',
					value = Admin.Name.." ("..Admin.UserId..")",
					inline = true
				},
				{
					name = 'Action',
					value = 'Ban',
					inline = true
				},
				{
					name = 'Length',
					value = length,
					inline = true
				},
				{
					name = "Reason",
					value = reason,
					inline = true
				}
			}
		});
		
		_G.BannerAlert(false, "Player Banned", plr .. " was offline banned by " .. Admin.Name .. " for " .. reason, 7, "GreenSafety")
		m.Services.NotifyService.Notify(nil, "Player Offline Banned", plr .. " was offline banned by " .. Admin.Name .. " for " .. reason)

		return plr.. " was banned for ".. reason .." by "..Admin.Name ..". (Offline ban)"
	else
		Bans:SetAsync(plr.UserId, Data)
		m.Services.DiscordProxy:SendEmbed("Admin", {
			title = 'TWF Admin - User Banned',
			color = 15548997,
			fields = {
				{
					name = 'Target',
					value = plr.Name.." ("..plr.UserId..")",
					inline = true
				},
				{
					name = 'Admin',
					value = Admin.Name.." ("..Admin.UserId..")",
					inline = true
				},
				{
					name = 'Action',
					value = 'Ban',
					inline = true
				},
				{
					name = 'Length',
					value = length,
					inline = true
				},
				{
					name = "Reason",
					value = reason,
					inline = true
				}
			}
		});
		
		if plr == Admin or IsRAC then
			_G.BannerAlert(false, "Player RAC Banned", plr.Name.. " was RAC Banned for ".. reason ..". Expires NEVER.", 7, "GreenSafety")
			m.Services.NotifyService.Notify(nil, "Player RAC Banned", plr.Name.. " was RAC banned for ".. reason ..". Expires NEVER.")
			
			Kick(plr, "You have been RAC Banned for " .. reason .. ", this ban cannot be appealed without evidence clearly defending yourself.")
			
			return plr.Name .. " has been RAC Banned."
		end
		
		if Data.TimestampEnd ~= "perm" then
			_G.BannerAlert(false, "Player Banned", plr.Name.. " was banned for ".. reason .." by "..Admin.Name ..". Expires on "..m:getTimeString(Data.TimestampEnd - Data.TimestampStarted), 7, "GreenSafety")
			m.Services.NotifyService.Notify(nil, "Player Banned", plr.Name.. " was banned for ".. reason .." by "..Admin.Name ..". Expires on "..m:getTimeString(Data.TimestampEnd - Data.TimestampStarted))
			if reason then
				Kick(plr, "You were banned for " .. m:getTimeString(Data.TimestampEnd - Data.TimestampStarted) .. " for " .. reason)
			else
				Kick(plr, "You were banned for " .. m:getTimeString(Data.TimestampEnd - Data.TimestampStarted))
			end
			
			return plr.Name.. " was banned for ".. reason .." by "..Admin.Name ..". Expires on "..m:getTimeString(Data.TimestampEnd - Data.TimestampStarted)
		else
			_G.BannerAlert(false, "Player Banned", plr.Name.. " was banned for ".. reason .." by "..Admin.Name ..". Permenant ban.", 7, "GreenSafety")
			m.Services.NotifyService.Notify(nil, "Player Banned", plr.Name.. " was banned for ".. reason .." by "..Admin.Name ..". Permenant ban")
			
			if reason then
				Kick(plr, "You are permanently banned for " .. reason) 
			else
				Kick(plr, "You are permanently banned")
			end
			
			return plr.Name.. " was banned for ".. reason .." by "..Admin.Name ..". Permenant ban"
		end
	end
end

function m:GetTimestampFromString(str)
	--suffixes sec seconds, min minutes, hrs hours, d days, w weeks, m months, y years, p permanant
	local now = os.time()

	if string.sub(str, -3) == "sec" then
		return now + tonumber(string.sub(str,0,-4))
	end
	if string.sub(str, -3) == "min" then
		return now + (tonumber(string.sub(str,0,-4)) * 60)
	end
	if string.sub(str, -3) == "hrs" then
		return now + (tonumber(string.sub(str,0,-4)) * 60 * 60)
	end
	if string.sub(str, -1) == "d" then
		return now + (tonumber(string.sub(str,0,-2)) * 60 * 60 * 24)
	end
	if string.sub(str, -1) == "w" then
		return now + (tonumber(string.sub(str,0,-2)) * 60 * 60 * 24 * 7)
	end
	if string.sub(str, -1) == "y" then
		return now + (tonumber(string.sub(str,0,-2)) * 60 * 60 * 24 * 7 * 52)
	end
	if string.sub(str, -1) == "p" then
		return "Perm"
	end
end

function m:TestBanned(plr)
	local Data = Bans:GetAsync(plr.UserId)
	
	if Data then
		if Data.TimestampEnd == "Perm" or Data.TimestampEnd > os.time() then
			if Data.TimestampEnd ~= "Perm" then
				if Data.reason then
					Kick(plr, "You are banned for " .. m:getTimeString(Data.TimestampEnd - os.time()) .. " for " .. Data.reason)
				else
					Kick(plr, "You are banned for " .. m:getTimeString(Data.TimestampEnd - os.time()))
				end
			else
				if Data.reason then
					Kick(plr, "You are permanently banned for " .. Data.reason) 
				else
					Kick(plr, "You are permanently banned")
				end
			end
		end
	end
end


function m:Start()
	game.Players.PlayerAdded:Connect(function(p)
		m:TestBanned(p)
	end)
	
	task.spawn(function()
		while true and task.wait(120) do
			for i, p in pairs(game:GetService("Players"):GetPlayers()) do
				m:TestBanned(p)
			end
		end
	end)
end

return m
