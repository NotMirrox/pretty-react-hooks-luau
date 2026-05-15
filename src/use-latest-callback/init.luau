local react = require(script.Parent.Parent.React)

type AnyCallback = (...any) -> ...any

--[[
	Returns a memoized callback that wraps the latest version of the input
	callback.

	@param callback The callback to memoize.
	@return The memoized callback.
]]
local function useLatestCallback<T>(callback: T & AnyCallback): T
	local callbackRef = react.useRef(callback)
	callbackRef.current = callback

	local memoized = react.useCallback(function(...)
		return (callbackRef.current :: any)(...)
	end, {})

	return memoized :: any
end

return useLatestCallback
