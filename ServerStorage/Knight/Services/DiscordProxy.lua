-- Services
local HttpService = game:GetService("HttpService")


-- Variables
local m = {}

function m:SendEmbed(Endpoint, ...)
	local d = {
		embeds = {}};
	local embeds = {...};
	for i,v in pairs(embeds) do
		table.insert(d.embeds, v);
	end
	
	local Data = HttpService:JSONEncode(d)

	local s,e = pcall(function()
		return HttpService:PostAsync(m.Info.Webhooks["ProxyURL"] .. "/" .. m.Info.Webhooks[Endpoint], Data, Enum.HttpContentType.ApplicationJson)
	end)

	return s
end


return m