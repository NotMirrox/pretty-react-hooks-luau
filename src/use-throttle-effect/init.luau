local react = require(script.Parent.Parent.React)
local useThrottleCallback = require(script.Parent["use-throttle-callback"])
local useUpdate = require(script.Parent["use-update"])
local useUpdateEffect = require(script.Parent["use-update-effect"])

type UseThrottleOptions = useThrottleCallback.UseThrottleOptions

type Callback = () -> ()
type EffectCallback = (() -> Callback) | Callback

--[[
	Creates a throttled effect that only runs at most once per every `wait`
	seconds.

	See [David Corbacho's article](https://css-tricks.com/debouncing-throttling-explained-examples/)
	for details over the differences between `debounce` and `throttle`.

	@param effect The effect to throttle.
	@param deps The dependencies array.
	@param options The options object.
]]
local function useThrottleEffect(effect: EffectCallback, deps: { any }?, options: UseThrottleOptions?): ()
	local update = useUpdate()
	local throttled = useThrottleCallback(update, options)

	react.useEffect(function()
		return throttled.run()
	end, deps)

	useUpdateEffect(effect, { update })
end

return useThrottleEffect
