local RUNSERVICE = game:GetService("RunService")

--

local Timer = {}
Timer.__index = Timer

--

function Timer.new(startTime)
	local self = setmetatable({}, Timer)
	
	self.Active = false
	self.StartTime = startTime
	self.Time = startTime
	self.Events = {}
	
	self.TimerEvent = RUNSERVICE.RenderStepped:Connect(function(dt)
		if (self.Active) then
			self.Time = self.Time + dt
			
			local events = self.Events
			for i = #events, 1, -1 do
				if (self.Time >= events[i][1]) then
					events[i][2](self.Time)
					table.remove(events, i)
				end
			end
		end
	end)
	
	return self
end

--

function Timer:SetActive(bool)
	self.Active = bool
end

function Timer:FireOnTimeReached(t, f)
	table.insert(self.Events, {t, f})
end

function Timer:Destroy()
	self.TimerEvent:Disconnect()
end

--

return Timer