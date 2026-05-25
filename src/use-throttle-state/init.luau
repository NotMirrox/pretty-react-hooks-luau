local react = require(script.Parent.Parent.React)
local useThrottleCallback = require(script.Parent["use-throttle-callback"])

type UseThrottleOptions = useThrottleCallback.UseThrottleOptions
type Debounced<T> = useThrottleCallback.Debounced<T>
type SetState<T> = (newValue: T | (prev: T) -> T) -> ()

--[[
	Creates a throttled state that only updates at most once per every `wait`
	seconds. Set to the most recently passed `state` after each interval.

	Use `useDebounceState` instead when state should wait for a burst of
	updates to settle before applying the latest value.

	See [David Corbacho's article](https://css-tricks.com/debouncing-throttling-explained-examples/)
	for details over the differences between `debounce` and `throttle`.

	@param initialState The value to throttle.
	@param options The options object.
	@return A tuple containing the throttled value and a function to update it.
]]
local function useThrottleState<T>(initialState: T, options: UseThrottleOptions?): (T, Debounced<SetState<T>>)
	local state, setState = react.useState(initialState)

	return state, useThrottleCallback(setState, options).run
end

return useThrottleState
