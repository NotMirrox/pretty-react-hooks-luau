local debounce = require(script.Parent.debounce)

export type ThrottleOptions = {
	--[[
		The leading edge of the timeout.
	]]
	leading: boolean?,
	--[[
		The trailing edge of the timeout.
	]]
	trailing: boolean?,
}

type AnyCallback = (...any) -> ...any

--[[
	Creates a throttled function that only invokes `callback` at most once per
	every `wait` seconds. The throttled function comes with a `cancel` method to
	cancel delayed `callback` invocations and a `flush` method to immediately
	invoke them.

	Provide `options` to indicate whether `callback` should be invoked on the
	leading and/or trailing edge of the `wait` timeout. The `callback` is invoked
	with the most recent arguments provided to the throttled function. Subsequent
	calls to the throttled function return the result of the last `callback`
	invocation.

	**Note:** If `leading` and `trailing` options are `true`, `callback` is
	invoked on the trailing edge of the timeout only if the throttled function
	is invoked more than once during the `wait` timeout.

	If `wait` is `0` and `leading` is `false`, `callback` invocation is deferred
	until the next tick, similar to `setTimeout` with a timeout of `0`.

	See [David Corbacho's article](https://css-tricks.com/debouncing-throttling-explained-examples/)
	for details over the differences between `throttle` and `debounce`.

	@param callback The function to throttle.
	@param wait The number of seconds to throttle invocations to. Defaults to `0`.
	@param options The options object.
	@return The new throttled function.
	@see https://github.com/lodash/lodash/blob/master/throttle.js/
	@see https://css-tricks.com/debouncing-throttling-explained-examples/
]]
local function throttle<T>(callback: T & AnyCallback, wait: number?, options: ThrottleOptions?): debounce.Debounced<T>
	local resolvedWait = wait or 0
	local resolvedOptions: ThrottleOptions = options or {}
	local leading = if resolvedOptions.leading == nil then true else resolvedOptions.leading
	local trailing = if resolvedOptions.trailing == nil then true else resolvedOptions.trailing

	return debounce(callback, resolvedWait, {
		leading = leading,
		trailing = trailing,
		maxWait = resolvedWait,
	})
end

return throttle
