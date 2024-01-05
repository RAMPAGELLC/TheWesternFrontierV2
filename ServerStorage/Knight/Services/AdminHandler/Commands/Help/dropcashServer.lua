return function (context, amount)
	local admin = context.Executor
	
	local CharacterManager = require(game:GetService("ServerStorage").Knight.Services.CharacterManager)
	local LawManager = require(game:GetService("ServerStorage").Knight.Services.LawManager)
	
	if amount > 0 then
		if amount > _G.PlayerData[admin.Name].Cash then
			return "You do not have that much to drop."
		end
		
		CharacterManager.RemoveCash(admin, amount)
		LawManager.DropMoneyBag(amount, admin.Character.Head.CFrame, true)
		return "Money dropped!"
	else
		return "Invalid amount."
	end
end
