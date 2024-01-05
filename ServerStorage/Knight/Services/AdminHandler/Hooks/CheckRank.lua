local Perms = {
	["Help"] = 0,
	["Trusted"] = 243,
	["YouTube"] = 243,
	["QA"] = 244,
	["Wiki"] = 245,
	["Employee"] = 245,
	["Moderator"] = 248,
	["TrialMod"] = 248,
	["Mod"] = 248,
	["SrMod"] = 249,
	["Admin"] = 249,
	["Manager"] = 249,
	["DefaultAdmin"] = 249,
	["DefaultDebug"] = 249,
	["DefaultUtil"] = 249,
	["Dev"] = 249,
}

return function (registry)
	registry:RegisterHook("BeforeRun", function(context)
		if Perms[context.Group] then
			local noPerms = false
			
			if context.Executor:GetRankInGroup(9640975) < Perms[context.Group] then
				noPerms = true
			end
			
			if noPerms then
				return "You must be a " .. context.Group .. "+ in-order to run this command."
			end
		else
			return "Context group not found in data array."
		end
	end)
end