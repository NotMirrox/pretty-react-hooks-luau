local RunService = game:GetService("RunService")

--[[
	Schedule a callback to be called once after `timeout` seconds. Returns a
	function that can be called to stop the timer.
	@param callback The callback to call after `timeout` seconds.
	@param timeout The timeout in seconds.
	@return A cleanup function.
]]
local function setTimeout(callback: () -> (), timeout: number): () -> ()
	local timer = 0
	local connection
	connection = RunService.Heartbeat:Connect(function(deltaTime: number)
		timer += deltaTime
		if timer >= timeout then
			connection:Disconnect()
			callback()
		end
	end)

	return function()
		connection:Disconnect()
	end
end

return setTimeout
