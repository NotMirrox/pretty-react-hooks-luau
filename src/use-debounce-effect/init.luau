local react = require(script.Parent.Parent.React)
local useDebounceCallback = require(script.Parent["use-debounce-callback"])
local useUpdate = require(script.Parent["use-update"])
local useUpdateEffect = require(script.Parent["use-update-effect"])

type UseDebounceOptions = useDebounceCallback.UseDebounceOptions

type Callback = () -> ()
type EffectCallback = (() -> Callback) | Callback

--[[
	Creates a debounced effect that delays invoking `effect` until after `wait`
	seconds have elapsed since the last time the debounced function was invoked.

	See [David Corbacho's article](https://css-tricks.com/debouncing-throttling-explained-examples/)
	for details over the differences between `debounce` and `throttle`.

	@param effect The effect to debounce.
	@param deps The dependencies array.
	@param options The options object.
]]
local function useDebounceEffect(effect: EffectCallback, deps: { any }?, options: UseDebounceOptions?): ()
	local update = useUpdate()
	local debounced = useDebounceCallback(update, options)

	react.useEffect(function()
		return debounced.run()
	end, deps)

	useUpdateEffect(effect, { update })
end

return useDebounceEffect
