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

function Knight:GetDataStore(DatastoreName)
	return Knight.Priority.Master:GetDataStore(DatastoreName)
end

return Knight