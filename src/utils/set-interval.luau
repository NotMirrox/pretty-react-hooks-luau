local RunService = game:GetService("RunService")

--[[
	Schedules `callback` to run every `delay` seconds. Returns a function that
	cancels the interval.
	@param callback The callback to run.
	@param delay The delay in seconds between each call.
	@return A cleanup function.
]]
local function setInterval(callback: () -> (), delay: number): () -> ()
	local timer = 0
	local connection
	connection = RunService.Heartbeat:Connect(function(deltaTime: number)
		timer += deltaTime
		if timer >= delay then
			timer -= delay
			callback()
		end
	end)

	return function()
		connection:Disconnect()
	end
end

return setInterval
