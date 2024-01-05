local WORKSPACE = game:GetService("Workspace")

local CALLBACKRESULT 	= {}
CALLBACKRESULT.Continue = 1
CALLBACKRESULT.Finished = 2
CALLBACKRESULT.Fail 	= 3

local Raycast = {}
Raycast.CallBackResult = CALLBACKRESULT

--

function Raycast.FindPartOnRay(ray, ignore, terrainCellsAreCubes, ignoreWater)
	return WORKSPACE:FindPartOnRay(ray, ignore, terrainCellsAreCubes, ignoreWater)
end

function Raycast.FindPartOnRayWithIgnoreList(ray, ignoreList, terrainCellsAreCubes, ignoreWater)
	return WORKSPACE:FindPartOnRayWithIgnoreList(ray, ignoreList, terrainCellsAreCubes, ignoreWater)
end

function Raycast.FindPartOnRayWithWhiteList(ray, whiteList, terrainCellsAreCubes, ignoreWater)
	return WORKSPACE:FindPartOnRayWithWhitelist(ray, whiteList, terrainCellsAreCubes, ignoreWater)
end

--

function Raycast.FindPartOnRayWithCallbackWithIgnoreList(ray, list, terrainCellsAreCubes, ignoreWater, callbackFunc)
	local maxDistance = ray.Direction.Magnitude
	local direction = ray.Direction.Unit
	
	local lastPosition = ray.Origin
	local distance = 0
	
	local hit, position, normal, material
	
	repeat
		local r = Ray.new(lastPosition, direction * (maxDistance - distance))
		hit, position, normal, material = WORKSPACE:FindPartOnRayWithIgnoreList(ray, list, terrainCellsAreCubes, ignoreWater, true)
		local result = callbackFunc(hit, position, normal, material)
		
		if (result == CALLBACKRESULT.Continue) then
			distance = (ray.Origin - position).Magnitude
			lastPosition = position
		elseif (result == CALLBACKRESULT.Finished) then
			return hit, position, normal, material
		elseif (result == CALLBACKRESULT.Fail or result == nil) then
			break
		end
	until (distance >= maxDistance - 0.1)
	
	return
end

function Raycast.FindPartOnRayWithCallbackWithWhiteList(ray, list, terrainCellsAreCubes, ignoreWater, callbackFunc)
	local maxDistance = ray.Direction.Magnitude
	local direction = ray.Direction.Unit
	
	local lastPosition = ray.Origin
	local distance = 0
	
	local hit, position, normal, material
	
	repeat
		local r = Ray.new(lastPosition, direction * (maxDistance - distance))
		hit, position, normal, material = WORKSPACE:FindPartOnRayWithWhiteList(ray, list, terrainCellsAreCubes, ignoreWater, true)
		local result = callbackFunc(hit, position, normal, material)
		
		if (result == CALLBACKRESULT.Continue) then
			distance = (ray.Origin - position).Magnitude
			lastPosition = position
		elseif (result == CALLBACKRESULT.Finished) then
			return hit, position, normal, material
		elseif (result == CALLBACKRESULT.Fail or result == nil) then
			break
		end
	until (distance >= maxDistance - 0.1)
	
	return
end

function Raycast.FindPartOnRayWithCallback(ray, ignore, terrainCellsAreCubes, ignoreWater, callbackFunc)
	return Raycast.FindPartOnRayWithCallbackWithIgnoreList(ray, {ignore}, terrainCellsAreCubes, ignoreWater, callbackFunc)
end

--

return Raycast