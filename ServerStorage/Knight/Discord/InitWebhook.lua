local InitWebhook = {};

function InitWebhook.custom(url)
	return InitWebhook.Discord.WebhookClient(url)
end

function InitWebhook.hook(name)
	return InitWebhook.Discord.WebhookClient(InitWebhook.Discord.WebhookRegistar.Proxy .. "/" .. InitWebhook.Discord.WebhookRegistar.Hooks[name])
end

return InitWebhook