local RunService = game:GetService("RunService")

--[[
	Schedules `callback` to run once after `delay` seconds. Returns a function
	that cancels the timeout.
	@param callback The callback to run.
	@param delay The delay in seconds before the callback runs.
	@return A cleanup function.
]]
local function setTimeout(callback: () -> (), delay: number): () -> ()
	local timer = 0
	local connection
	connection = RunService.Heartbeat:Connect(function(deltaTime: number)
		timer += deltaTime
		if timer >= delay then
			connection:Disconnect()
			callback()
		end
	end)

	return function()
		connection:Disconnect()
	end
end

return setTimeout
