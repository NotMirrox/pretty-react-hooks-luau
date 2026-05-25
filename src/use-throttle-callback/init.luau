local react = require(script.Parent.Parent.React)
local throttle = require(script.Parent.utils.throttle)
local useDebounceCallback = require(script.Parent["use-debounce-callback"])
local useLatest = require(script.Parent["use-latest"])
local useUnmountEffect = require(script.Parent["use-unmount-effect"])

export type UseThrottleOptions = {
	--[[
		The amount of time to wait before the first call.
	]]
	wait: number?,
	--[[
		The leading edge of the timeout.
	]]
	leading: boolean?,
	--[[
		The trailing edge of the timeout.
	]]
	trailing: boolean?,
}

export type UseDebounceResult<T> = useDebounceCallback.UseDebounceResult<T>
export type Debounced<T> = useDebounceCallback.Debounced<T>

type AnyCallback = (...any) -> ...any

--[[
	Creates a throttled function that only invokes `callback` at most once per
	every `wait` seconds. The `callback` is invoked with the most recent arguments
	provided to the throttled function. Subsequent calls to the throttled function
	return the result of the last `callback` invocation.

	See [David Corbacho's article](https://css-tricks.com/debouncing-throttling-explained-examples/)
	for details over the differences between `throttle` and `debounce`.

	@param callback The function to throttle.
	@param options The options object.
	@return The new throttled function.
]]
local function useThrottleCallback<T>(callback: T & AnyCallback, options: UseThrottleOptions?): UseDebounceResult<T>
	local resolvedOptions: UseThrottleOptions = options or {}
	local callbackRef = useLatest(callback)

	local throttled = react.useMemo(function()
		return throttle(function(...)
			return (callbackRef.current :: any)(...)
		end, resolvedOptions.wait, resolvedOptions)
	end, {})

	useUnmountEffect(function()
		throttled.cancel()
	end)

	return {
		run = throttled,
		cancel = throttled.cancel,
		flush = throttled.flush,
		pending = throttled.pending,
	}
end

return useThrottleCallback
