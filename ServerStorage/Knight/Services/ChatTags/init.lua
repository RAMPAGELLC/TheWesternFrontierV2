-- Knight Init Service
local Knight = {};
local Service = { -- Never Index Service, Data is packed into Knight. Correctly index example: Knight.ServiceName
	ServiceName = script.Name,
	ServiceData = {
		Author = "vq9o",
		Description = "Knight service"
	},
	Cache = {}
}

for i,v in pairs(Service) do
	Knight[i] = v;
end

-- Script
function Knight.Init()
	for i,v in pairs (script.ChatModule:GetChildren()) do
		v.Parent = game.Chat:WaitForChild('ChatModules')
	end
end

return Knight