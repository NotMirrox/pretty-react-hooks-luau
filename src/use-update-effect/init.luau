local react = require(script.Parent.Parent.React)

type Callback = () -> ()
type EffectCallback = (() -> Callback) | Callback

--[[
	Runs a callback when the component is re-rendered. Does not run on the
	first render.

	@param effect The callback to run.
	@param deps The dependencies to watch for changes.
]]
local function useUpdateEffect(effect: EffectCallback, deps: { any }?): ()
	local isMounted = react.useRef(false)

	react.useEffect(function()
		if isMounted.current then
			return (effect :: Callback)()
		else
			isMounted.current = true
			return nil
		end
	end, deps)
end

return useUpdateEffect
