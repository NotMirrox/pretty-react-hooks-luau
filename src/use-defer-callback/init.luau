local RunService = game:GetService("RunService")

local react = require(script.Parent.Parent.React)
local useLatest = require(script.Parent["use-latest"])

--[[
	Defers a callback to be executed on the next Heartbeat frame. Consecutive
	calls to the returned `execute` function will cancel the previous call, so
	only the most recent invocation in a frame runs.

	Useful for collapsing bursts of synchronous calls (e.g. rapid input
	events) into a single batched update and for avoiding state writes during
	the current frame's render.

	@param callback The callback to defer.
	@return execute The deferred function.
	@return cancel A function that will cancel a scheduled update.
]]
local function useDeferCallback<T...>(callback: (T...) -> ()): ((T...) -> (), () -> ())
	local callbackRef = useLatest(callback)
	local connectionRef = react.useRef(nil :: RBXScriptConnection?)

	local cancel = react.useCallback(function()
		if connectionRef.current then
			connectionRef.current:Disconnect()
			connectionRef.current = nil
		end
	end, {})

	local execute = react.useCallback(function(...: T...)
		cancel()

		local args: { [number]: any } = table.pack(...)
		connectionRef.current = RunService.Heartbeat:Once(function()
			connectionRef.current = nil
			callbackRef.current(table.unpack(args))
		end)
	end, {})

	return execute, cancel
end

return useDeferCallback
