local react = require(script.Parent.Parent.React)
local useLatest = require(script.Parent["use-latest"])

--[[
	Calls the callback when the component unmounts.

	@param callback The callback to call.
]]
local function useUnmountEffect(callback: () -> ()): ()
	local callbackRef = useLatest(callback)

	react.useEffect(function()
		return function()
			callbackRef.current()
		end
	end, {})
end

return useUnmountEffect
