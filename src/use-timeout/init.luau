local react = require(script.Parent.Parent.React)
local setTimeout = require(script.Parent.utils["set-timeout"])
local useLatestCallback = require(script.Parent["use-latest-callback"])

--[[
	Sets a timeout that runs the callback function after `delay` seconds. If
	`delay` is `nil`, the timeout is cleared. If the delay changes, the
	timeout is reset.

	@param callback The callback function to run.
	@param delay The delay in seconds before the timeout.
	@return A function that clears the timeout.
]]
local function useTimeout(callback: () -> (), delay: number?): () -> ()
	local callbackMemo = useLatestCallback(callback)
	local cancel = react.useRef(nil :: (() -> ())?)

	local clear = react.useCallback(function()
		if cancel.current then
			cancel.current()
			cancel.current = nil
		end
	end, {})

	react.useEffect(function()
		if delay == nil then
			return
		end

		cancel.current = setTimeout(callbackMemo, delay)
		return clear
	end, { delay })

	return clear
end

return useTimeout
