local react = require(script.Parent.Parent.React)

type Callback = () -> ()
type EffectCallback = (() -> Callback) | Callback

--[[
	Runs a callback when the component is mounted.

	@param callback The callback to run on mount. May return a cleanup function
	that runs on unmount.
]]
local function useMountEffect(callback: EffectCallback): ()
	react.useEffect(callback, {})
end

return useMountEffect
