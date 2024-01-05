return function (context, player, reason)
	local notifyService = require(game:GetService("ServerStorage").Knight.Services.NotifyService)
	local timeLeft = 15;
	local votes = {};
	local halfplr = math.round(#game:GetService("Players"):GetPlayers() / 2)

	notifyService.Notify(nil, "Vote Kick - Started by " .. context.Executor.UserId, "Type 'vote_yes' or 'vote_no' in chat to vote-kick " .. player.Name .. " for " .. reason, false, timeLeft)
	
	for i,v in pairs(game:GetService("Players"):GetPlayers()) do
		local c;
		c = v.Chatted:Connect(function(message)

			if message == "vote_yes" or message == "vote_no" then
				if v == player then 
					notifyService.Notify(v, "Vote Kick", "You cannot vote on yourself.", false, 3)
					return c:Disconnect() 
				end
			end
			
			if message == "vote_yes" then
				votes[v] = true
				notifyService.Notify(v, "Vote Kick", "Vote recorded", false, 3)
				c:Disconnect() 
			elseif message == "vote_no" then
				notifyService.Notify(v, "Vote Kick", "Vote recorded", false, 3)
				c:Disconnect() 
			end
		end)
	end
	
	task.delay(timeLeft, function()
		if #votes >= halfplr then
			notifyService.Notify(nil, "Vote Kick", "Player was kicked!", false, 5)
		else
			notifyService.Notify(nil, "Vote Kick", "Vote failed", false, 5)
		end
	end)
end