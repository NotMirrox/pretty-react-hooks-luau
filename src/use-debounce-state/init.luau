local react = require(script.Parent.Parent.React)
local useDebounceCallback = require(script.Parent["use-debounce-callback"])

type UseDebounceOptions = useDebounceCallback.UseDebounceOptions
type Debounced<T> = useDebounceCallback.Debounced<T>
type SetState<T> = (newValue: T | (prev: T) -> T) -> ()

--[[
	Delays updating `state` until after `wait` seconds have elapsed since the
	last time the debounced function was invoked. Set to the most recently
	passed `state` after the delay.

	See [David Corbacho's article](https://css-tricks.com/debouncing-throttling-explained-examples/)
	for details over the differences between `debounce` and `throttle`.

	@param initialState The value to debounce.
	@param options The options object.
	@return A tuple containing the debounced value and a function to update it.
]]
local function useDebounceState<T>(initialState: T, options: UseDebounceOptions?): (T, Debounced<SetState<T>>)
	local state, setState = react.useState(initialState)

	return state, useDebounceCallback(setState, options).run
end

return useDebounceState
