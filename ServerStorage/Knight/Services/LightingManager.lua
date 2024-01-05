-- Knight Init Service
local Knight = {};
local Service = { -- Never Index Service, Data is packed into Knight. Correctly index example: Knight.ServiceName
	ServiceName = script.Name,
	ServiceData = {
		Author = "vq9o",
		Description = "Knight service"
	},
	Cache = {
		Settings = false,
	}
}

for i,v in pairs(Service) do
	Knight[i] = v;
end

-- Script
function Knight.Init()
	Knight.Cache.Settings = {}
	Knight.Cache.Settings = {
		weekdays = {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"},
		currentDay = 0,

		--time changer
		mam = nil, --minutes after midnight
		timeShift = 0.1, --how many minutes you shift every "tick"
		waitTime = 1/30 ,--legnth of the tick
		pi = math.pi,

		--brightness
		amplitudeB = 1,
		offsetB = 2,

		--outdoor ambieant
		var = nil,
		amplitudeO = 20,
		offsetO = 100,

		--shadow softness
		amplitudeS = .2,
		offsetS = .8,

		--color shift top
		pointer = nil,
		-- 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24
		rColorList = {000,000,000,000,000,255,255,255,255,255,255,255,255,255,255,255,255,255,255,000,000,000,000,000},
		gColorList = {165,165,165,165,165,255,215,230,255,255,255,255,255,255,255,245,230,215,255,165,165,165,165,165},
		bColorList = {255,255,255,255,255,255,110,135,255,255,255,255,255,255,255,215,135,110,255,255,255,255,255,255},
		r = nil,
		g = nil,
		b = nil
	}
end

function Knight.Start()
	task.spawn(function()
		repeat task.wait() until (Knight.Cache.Settings and Knight.Cache.Settings ~= {})
		
		while true do
			--time changer
			Knight.Cache.Settings.mam = Knight.Shared.Roblox.Lighting:GetMinutesAfterMidnight() + Knight.Cache.Settings.timeShift
			Knight.Shared.Roblox.Lighting:SetMinutesAfterMidnight(Knight.Cache.Settings.mam)
			
			local t = Knight.Cache.Settings.mam - Knight.Cache.Settings.timeShift
			if t == 0 or Knight.Cache.Settings.mam == 0 then
				Knight.Cache.Settings.currentDay = Knight.Cache.Settings.currentDay == 7 and 1 or Knight.Cache.Settings.currentDay + 1
				Knight.Shared.Roblox.Lighting.DayValue.Value = Knight.Cache.Settings.weekdays[Knight.Cache.Settings.currentDay]
			end
			
			Knight.Cache.Settings.mam = Knight.Cache.Settings.mam/60

			--brightness
	--		Knight.Shared.Roblox.Lighting.Brightness = Knight.Cache.Settings.amplitudeB*math.cos(Knight.Cache.Settings.mam*(Knight.Cache.Settings.pi/12)+Knight.Cache.Settings.pi)+Knight.Cache.Settings.offsetB

			--outdoor ambient
	--		Knight.Cache.Settings.var= Knight.Cache.Settings.amplitudeO*math.cos(Knight.Cache.Settings.mam*(Knight.Cache.Settings.pi/12)+Knight.Cache.Settings.pi)+Knight.Cache.Settings.offsetO
	--		Knight.Shared.Roblox.Lighting.OutdoorAmbient = Color3.fromRGB(Knight.Cache.Settings.var,Knight.Cache.Settings.var,Knight.Cache.Settings.var)

			--shadow softness
			Knight.Shared.Roblox.Lighting.ShadowSoftness = Knight.Cache.Settings.amplitudeS*math.cos(Knight.Cache.Settings.mam*(Knight.Cache.Settings.pi/6))+Knight.Cache.Settings.offsetS

			--color shift top
	--		Knight.Cache.Settings.pointer= math.clamp(math.ceil(Knight.Cache.Settings.mam), 1, 24)
	--		Knight.Cache.Settings.r=((Knight.Cache.Settings.rColorList[Knight.Cache.Settings.pointer%24+1]-Knight.Cache.Settings.rColorList[Knight.Cache.Settings.pointer])*(Knight.Cache.Settings.mam-Knight.Cache.Settings.pointer+1))+Knight.Cache.Settings.rColorList[Knight.Cache.Settings.pointer]
	--		Knight.Cache.Settings.g=((Knight.Cache.Settings.gColorList[Knight.Cache.Settings.pointer%24+1]-Knight.Cache.Settings.gColorList[Knight.Cache.Settings.pointer])*(Knight.Cache.Settings.mam-Knight.Cache.Settings.pointer+1))+Knight.Cache.Settings.gColorList[Knight.Cache.Settings.pointer]
	--		Knight.Cache.Settings.b=((Knight.Cache.Settings.bColorList[Knight.Cache.Settings.pointer%24+1]-Knight.Cache.Settings.bColorList[Knight.Cache.Settings.pointer])*(Knight.Cache.Settings.mam-Knight.Cache.Settings.pointer+1))+Knight.Cache.Settings.bColorList[Knight.Cache.Settings.pointer]
	--		Knight.Shared.Roblox.Lighting.ColorShift_Top=Color3.fromRGB(Knight.Cache.Settings.r,Knight.Cache.Settings.g,Knight.Cache.Settings.b)

			--tick
			task.wait(Knight.Cache.Settings.waitTime)
		end
	end)
end

return Knight