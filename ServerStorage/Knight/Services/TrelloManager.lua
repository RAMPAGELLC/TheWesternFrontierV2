-- Knight Init Service
local trello = {};
local Service = { -- Never Index Service, Data is packed into Knight. Correctly index example: Knight.ServiceName
	ServiceName = script.Name,
	ServiceData = {
		Author = "vq9o",
		Description = "Knight service"
	},
	Cache = {}
}

for i,v in pairs(Service) do
	trello[i] = v;
end

local key = nil
local token = nil
local http = game:GetService("HttpService")
local addon = "?key=".. key.."&token=".. token

-- Script
trello.createBoard = function(boardName, boardDesc)
	if not boardName then warn("Insufficient arguments to createBoard!") return end
	if not token then warn("Insufficient token!") return end

	local sendData = {
		name = boardName,
	}
	if boardDesc then sendData["desc"] = boardDesc end

	sendData = http:JSONEncode(sendData)

	local returnData

	local suc,msg = pcall(function()
		returnData = http:PostAsync("https://api.trello.com/1/boards"..addon, sendData)
	end) 
	if not suc then warn(msg) return end
	if not returnData then warn("Unable to get return data. The operation still may have completed.") return end

	return returnData
end

trello.getBoard = function(boardName, isIdOnly)
	if not boardName then warn("Insufficient arguments to getBoard!") return end

	local getData 

	local suc,msg = pcall(function()
		getData = http:GetAsync("https://api.trello.com/1/members/my/boards"..addon, true)
	end)
	if not suc then warn(msg) return end
	if not getData then warn("Unable to get board data.") return end

	getData = http:JSONDecode(getData)

	for _, board in pairs(getData) do
		if board.name == boardName then
			if isIdOnly then return board.id end
			return board
		end
	end

	warn("Board could not be found. Make sure the name is typed correctly.")
	return
end

-- LIST API

trello.createList = function(boardId, listName, listSource, listPosition)
	if not boardId then warn("Insufficient arguments to createList!") return end
	if not listName then warn("Insufficient arguments to createList!") return end
	if not token then warn("Insufficient token!") return end

	local sendData = {
		name = listName,
		idBoard = boardId
	}
	if listSource then sendData["idListSource"] = listSource end
	if listPosition then sendData["pos"] = listPosition end

	sendData = http:JSONEncode(sendData)

	local returnData

	local suc,msg = pcall(function()
		returnData = http:PostAsync("https://api.trello.com/1/lists"..addon, sendData)
	end) 
	if not suc then warn(msg) return end
	if not returnData then warn("Unable to get return data. The operation still may have completed.") return end

	return returnData
end

trello.getList = function(boardId, listName, isIdOnly)
	if not boardId then warn("Insufficient arguments to getList!") return end
	if not listName then warn("Insufficient arguments to getList!") return end

	local getData

	local suc,msg = pcall(function()
		getData = http:GetAsync("https://api.trello.com/1/boards/"..boardId.."/lists"..addon, true)
	end)
	if not suc then warn(msg) return end
	if not getData then warn("Unable to get list data.") return end

	getData = http:JSONDecode(getData)

	for _, list in pairs(getData) do
		if list.name == listName then
			if isIdOnly then return list.id end
			return list
		end
	end

	warn("List could not be found. Make sure the name is typed correctly.")
	return 
end

trello.getAllLists = function(boardId)
	if not boardId then warn("Insufficient arguments to getAllLists!") return end

	local getData

	local suc,msg = pcall(function()
		getData = http:GetAsync("https://api.trello.com/1/boards/"..boardId.."/lists"..addon, true)
	end)
	if not suc then warn(msg) return end
	if not getData then warn("Unable to get list data.") return end

	getData = http:JSONDecode(getData)

	return getData
end

-- CARD API

trello.createCard = function(listId, name, description, position, labels, toCopyId)
	if not listId then warn("Insufficient arguments to createCard!") return end
	if not name then warn("Insufficient arguments to createCard!") return end
	if not token then warn("Insufficient token!") return end

	local sendData = {
		idList = listId,
		name = name
	}
	if description then sendData["desc"] = description end
	if position then sendData["pos"] = position end
	if labels then sendData["idLabels"] = labels end
	if toCopyId then sendData["idCardSource"] = toCopyId end

	sendData = http:JSONEncode(sendData)

	local returnData

	local suc,msg = pcall(function()
		returnData = http:PostAsync("https://api.trello.com/1/cards"..addon, sendData)
	end) 
	if not suc then warn(msg) return end
	if not returnData then warn("Unable to get return data. The operation still may have completed.") return end

	return returnData
end

trello.getCard = function(listId, cardName, isIdOnly)
	if not listId then warn("Insufficient arguments to getCard!") return end
	if not cardName then warn("Insufficient arguments to getCard!") return end

	local getData

	local suc,msg = pcall(function()
		getData = http:GetAsync("https://api.trello.com/1/lists/"..listId.."/cards"..addon, true)
	end)
	if not suc then warn(msg) return end
	if not getData then warn("Unable to get card data.") return end

	getData = http:JSONDecode(getData)

	for _, card in pairs(getData) do
		if card.name == cardName then
			if isIdOnly then return card.id end
			return card
		end
	end

	warn("Card could not be found. Make sure the name is typed correctly.")
	return 
end

trello.getAllCardsInList = function(listId)
	if not listId then warn("Insufficient arguments to getAllCardsInList!") end

	local getData

	local suc,msg = pcall(function()
		getData = http:GetAsync("https://api.trello.com/1/lists/"..listId.."/cards"..addon, true)
	end)
	if not suc then warn(msg) return end
	if not getData then warn("Unable to get card data.") return end

	getData = http:JSONDecode(getData)

	return getData
end

trello.getAllCardsInBoard = function(boardId)
	if not boardId then warn("Insufficient arguments to getAllCardsInBoard!") end

	local cards = {}

	local lists = trello.getAllLists(boardId)

	if not lists then warn("Unable to get board lists.") return end

	for _, list in pairs(lists) do
		local listCards = trello.getAllCardsInList(list.id)
		if not listCards then warn("Unable to get list cards.") return end

		for _, card in pairs(listCards) do
			table.insert(cards, card)
		end
	end

	return cards
end

return trello