local react = require(script.Parent.Parent.React)
local useDeferCallback = require(script.Parent["use-defer-callback"])

--[[
	Like `useEffect`, but the callback is deferred to the next Heartbeat frame.

	@param callback The callback to run.
	@param deps Optional dependencies to trigger the effect.
]]
local function useDeferEffect(callback: () -> (), deps: { any }?): ()
	local deferredCallback, cancel = useDeferCallback(callback)

	react.useEffect(function()
		deferredCallback()
		return cancel
	end, deps)
end

return useDeferEffect
