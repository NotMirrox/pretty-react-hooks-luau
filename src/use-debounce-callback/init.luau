local debounceUtil = require(script.Parent.utils.debounce)
local react = require(script.Parent.Parent.React)
local useLatest = require(script.Parent["use-latest"])
local useUnmountEffect = require(script.Parent["use-unmount-effect"])

local debounce = debounceUtil

export type Debounced<T> = debounceUtil.Debounced<T>

export type UseDebounceOptions = {
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
	--[[
		The maximum time `callback` is allowed to be delayed before it's invoked.
	]]
	maxWait: number?,
}

export type UseDebounceResult<T> = {
	--[[
		The debounced function.
	]]
	run: Debounced<T>,
	--[[
		Cancels delayed invocations to the callback.
	]]
	cancel: () -> (),
	--[[
		Immediately invokes delayed callback invocations.
	]]
	flush: () -> (),
	--[[
		Returns whether any invocations are pending.
	]]
	pending: () -> boolean,
}

type AnyCallback = (...any) -> ...any

--[[
	Creates a debounced function that delays invoking `callback` until after `wait`
	seconds have elapsed since the last time the debounced function was invoked.
	The `callback` is invoked with the last arguments provided to the debounced
	function. Subsequent calls to the debounced function return the result of
	the last `callback` invocation.

	See [David Corbacho's article](https://css-tricks.com/debouncing-throttling-explained-examples/)
	for details over the differences between `debounce` and `throttle`.

	@param callback The function to debounce.
	@param options The options object.
	@return The new debounced function.
]]
local function useDebounceCallback<T>(callback: T & AnyCallback, options: UseDebounceOptions?): UseDebounceResult<T>
	local resolvedOptions: UseDebounceOptions = options or {}
	local callbackRef = useLatest(callback)

	local debounced = react.useMemo(function()
		return debounce(function(...)
			return (callbackRef.current :: any)(...)
		end, resolvedOptions.wait, resolvedOptions)
	end, {}) :: Debounced<T>

	useUnmountEffect(function()
		debounced.cancel()
	end)

	return {
		run = debounced,
		cancel = debounced.cancel,
		flush = debounced.flush,
		pending = debounced.pending,
	}
end

return useDebounceCallback
