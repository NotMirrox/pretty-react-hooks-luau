local react = require(script.Parent.Parent.React)
local useThrottleCallback = require(script.Parent["use-throttle-callback"])
local useUpdate = require(script.Parent["use-update"])
local useUpdateEffect = require(script.Parent["use-update-effect"])

type UseThrottleOptions = useThrottleCallback.UseThrottleOptions

type Callback = () -> ()
type EffectCallback = (() -> Callback) | Callback

--[[
	Like `useEffect`, but `effect` runs at most once per `wait` seconds no
	matter how often `deps` change. Unlike `useDebounceEffect`, intermediate
	changes are not lost — the latest deps within a window flush at the end
	of it. The pending invocation is cancelled when the component unmounts.

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
