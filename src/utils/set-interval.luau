local RunService = game:GetService("RunService")

--[[
	Schedule a callback to be called every `interval` seconds. Returns a
	function that can be called to stop the timer.
	@param callback The callback to call every `interval` seconds.
	@param interval The interval in seconds.
	@return A cleanup function.
]]
local function setInterval(callback: () -> (), interval: number): () -> ()
	local timer = 0
	local connection
	connection = RunService.Heartbeat:Connect(function(deltaTime: number)
		timer += deltaTime
		if timer >= interval then
			timer -= interval
			callback()
		end
	end)

	return function()
		connection:Disconnect()
	end
end

return setInterval
