local react = require(script.Parent.Parent.React)
local useDebounceCallback = require(script.Parent["use-debounce-callback"])
local useUpdate = require(script.Parent["use-update"])
local useUpdateEffect = require(script.Parent["use-update-effect"])

type UseDebounceOptions = useDebounceCallback.UseDebounceOptions

type Callback = () -> ()
type EffectCallback = (() -> Callback) | Callback

--[[
	Like `useEffect`, but `effect` runs only after `deps` have remained stable
	for `wait` seconds. Each change to `deps` resets the timer. The pending
	invocation is cancelled when the component unmounts.

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
