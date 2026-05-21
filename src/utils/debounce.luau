local setTimeout = require(script.Parent["set-timeout"])

export type DebounceOptions = {
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

export type Debounced<T> = T & {
	cancel: () -> (),
	flush: () -> any,
	pending: () -> boolean,
}

type AnyCallback = (...any) -> ...any

--[[
	Creates a debounced function that delays invoking `callback` until after `wait`
	seconds have elapsed since the last time the debounced function was invoked.
	The debounced function comes with a `cancel` method to cancel delayed
	`callback` invocations and a `flush` method to immediately invoke them.

	Provide `options` to indicate whether `callback` should be invoked on the
	leading and/or trailing edge of the `wait` timeout. The `callback` is invoked
	with the last arguments provided to the debounced function. Subsequent calls
	to the debounced function return the result of the last `callback` invocation.

	**Note:** If `leading` and `trailing` options are `true`, `callback` is
	invoked on the trailing edge of the timeout only if the debounced function
	is invoked more than once during the `wait` timeout.

	If `wait` is `0` and `leading` is `false`, `callback` invocation is deferred
	until the next tick, similar to `setTimeout` with a timeout of `0`.

	See [David Corbacho's article](https://css-tricks.com/debouncing-throttling-explained-examples/)
	for details over the differences between `debounce` and `throttle`.

	@param callback The function to debounce.
	@param wait The number of seconds to delay. Defaults to `0`.
	@param options The options object.
	@return The new debounced function.
	@see https://github.com/lodash/lodash/blob/master/debounce.js/
	@see https://css-tricks.com/debouncing-throttling-explained-examples/
]]
local function debounce<T>(callback: T & AnyCallback, wait: number?, options: DebounceOptions?): Debounced<T>
	local resolvedWait = wait or 0
	local resolvedOptions: DebounceOptions = options or {}
	local leading = resolvedOptions.leading or false
	local trailing = if resolvedOptions.trailing == nil then true else resolvedOptions.trailing
	local maxWait = resolvedOptions.maxWait
	local maxing = maxWait ~= nil

	local lastCallTime = 0
	local lastInvokeTime = 0
	local lastArgs: { any }? = nil
	local result: any = nil
	local cancelTimeout: (() -> ())? = nil

	local timerExpired
	local trailingEdge

	local function invoke(time: number)
		local args = lastArgs :: { any }
		lastArgs = nil
		lastInvokeTime = time
		result = (callback :: any)(table.unpack(args))
		return result
	end

	local function leadingEdge(time: number)
		-- Reset any `maxWait` timer.
		lastInvokeTime = time
		-- Start the timer for the trailing edge.
		cancelTimeout = setTimeout(function()
			timerExpired()
		end, resolvedWait)
		-- Invoke the leading edge.
		return if leading then invoke(time) else result
	end

	local function remainingWait(time: number)
		local timeSinceLastCall = time - lastCallTime
		local timeSinceLastInvoke = time - lastInvokeTime
		local timeWaiting = resolvedWait - timeSinceLastCall

		return if maxing then math.min(timeWaiting, (maxWait :: number) - timeSinceLastInvoke) else timeWaiting
	end

	local function shouldInvoke(time: number)
		local timeSinceLastCall = time - lastCallTime
		local timeSinceLastInvoke = time - lastInvokeTime

		-- Either this is the first call, activity has stopped and we're at the
		-- trailing edge, the system time has gone backwards and we're treating
		-- it as the trailing edge, or we've hit the `maxWait` limit.
		return timeSinceLastCall >= resolvedWait
			or timeSinceLastCall < 0
			or (maxing and timeSinceLastInvoke >= (maxWait :: number))
	end

	timerExpired = function()
		local time = os.clock()
		if shouldInvoke(time) then
			return trailingEdge(time)
		end
		-- Restart the timer.
		cancelTimeout = setTimeout(function()
			timerExpired()
		end, remainingWait(time))
		return nil
	end

	trailingEdge = function(time: number)
		cancelTimeout = nil
		-- Only invoke if we have `lastArgs` which means `invoke` was
		-- debounced at least once.
		if trailing and lastArgs then
			return invoke(time)
		end
		lastArgs = nil
		return result
	end

	local function cancel()
		if cancelTimeout then
			cancelTimeout()
		end
		cancelTimeout = nil
		lastInvokeTime = 0
		lastArgs = nil
		lastCallTime = 0
	end

	local function flush()
		return if cancelTimeout == nil then result else trailingEdge(os.clock())
	end

	local function pending()
		return cancelTimeout ~= nil
	end

	local function debounced(...)
		local time = os.clock()
		local isInvoking = shouldInvoke(time)

		lastArgs = { ... }
		lastCallTime = time

		if isInvoking then
			if cancelTimeout == nil then
				return leadingEdge(lastCallTime)
			end
			if maxing then
				-- Handle invocations in a tight loop.
				cancelTimeout = setTimeout(function()
					timerExpired()
				end, resolvedWait)
				return invoke(lastCallTime)
			end
		end
		if cancelTimeout == nil then
			cancelTimeout = setTimeout(function()
				timerExpired()
			end, resolvedWait)
		end
		return result
	end

	return setmetatable({
		cancel = cancel,
		flush = flush,
		pending = pending,
	}, {
		__call = function(_, ...)
			return debounced(...)
		end,
	}) :: any
end

return debounce
