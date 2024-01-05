-- Knight Init Service
local KnightServer = {};
local Service = {
	ServiceName = script.Name,
	ServiceData = {
		Author = "vq9o",
		Description = "Interaction creation system"
	},
	Cache = {
		Registry = {},
		LastInteraction = {},
	},
}


for i,v in pairs(Service) do
	KnightServer[i] = v;
end

local CollectionService = game:GetService("CollectionService")

function KnightServer.DeleteInteraction(Part)
	Part:ClearAllChildren()
	CollectionService:RemoveTag(Part, "Interactable")
end

_G.DeleteInteraction = KnightServer.DeleteInteraction

function KnightServer.RegisterInteraction(Part, Info, Time, Callback)
	local InteractionEvent = script.InteractionEvent:Clone()
	local InteractionInfo = script.InteractionInfo:Clone()
	local InteractionTime = script.InteractionTime:Clone()

	InteractionEvent.Parent = Part;
	InteractionInfo.Parent = Part;
	InteractionTime.Parent = Part;
	
	InteractionInfo.Value = Info;
	InteractionTime.Value = Time;

	InteractionEvent.OnServerEvent:Connect(function(TriggerPlayer)
		if KnightServer.Cache.LastInteraction[TriggerPlayer] ~= nil and KnightServer.Cache.LastInteraction[TriggerPlayer] - os.time() >= 3 or KnightServer.Cache.LastInteraction[TriggerPlayer] == nil then
			KnightServer.Cache.LastInteraction[TriggerPlayer] = os.time()
			task.spawn(function()
				local s,e = pcall(function()
					Callback(TriggerPlayer)
				end)
				if not s then warn(e) end
			end)
			task.delay(3.1, function()
				KnightServer.Cache.LastInteraction[TriggerPlayer] = nil
			end)
		else
			KnightServer.Shared.Roblox.ReplicatedStorage.Events.RemoteEvent:FireClient(TriggerPlayer, "Notify", "ERROR_INTERACTION_COOLDOWN", Color3.fromRGB(255, 53, 53))
		end
	end)

	CollectionService:AddTag(Part, "Interactable")
end

_G.RegisterInteraction = KnightServer.RegisterInteraction

return KnightServer