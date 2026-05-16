local react = require(script.Parent.Parent.React)

type EffectCallback = () -> (() -> ())?

--[[
	Runs a callback when the component is re-rendered. Does not run on the
	first render.

	@param effect The callback to run.
	@param dependencies The dependencies to watch for changes.
]]
local function useUpdateEffect(effect: EffectCallback, dependencies: { any }?): ()
	local isMounted = react.useRef(false)

	react.useEffect(function()
		if isMounted.current then
			return effect()
		else
			isMounted.current = true
			return nil
		end
	end, dependencies)
end

return useUpdateEffect
