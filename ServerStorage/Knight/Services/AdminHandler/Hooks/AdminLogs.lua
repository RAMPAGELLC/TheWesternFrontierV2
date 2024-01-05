return function (registry)
	registry:RegisterHook("AfterRun", function(context)
		pcall(function()
			if context.Name == "var" or context.Group == "var" then return end -- Cmdr init

			require(game.ServerStorage.Knight.Services.DiscordProxy):SendEmbed("CmdrLogs", {
				title = 'TWF Admin',
				color = 15548997,
				fields = {
					{
						name = 'Admin',
						value = context.Executor.Name .." ("..context.Executor.UserId..")",
						inline = true
					},
					{
						name = 'Command',
						value = context.Name or "" .. " (" .. context.Group or "" .. ")",
						inline = true
					},
					{
						name = "Arguments",
						value = table.concat(context.RawArguments or {}, " ") or "",
						inline = true
					}
				}
			});
		end)
	end)
end