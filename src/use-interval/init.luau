local react = require(script.Parent.Parent.React)
local setInterval = require(script.Parent.utils["set-interval"])
local useLatestCallback = require(script.Parent["use-latest-callback"])

export type UseIntervalOptions = {
	--[[
		Whether the callback should run immediately when the interval is set.
		Defaults to `false`.
	]]
	immediate: boolean?,
}

--[[
	Sets an interval that runs the callback function every `delay` seconds. If
	`delay` is `nil`, the interval is cleared. If the delay changes, the
	interval is reset.

	@param callback The callback function to run.
	@param delay The delay in seconds between each interval.
	@param options The options for the interval.
	@return A function that clears the interval.
]]
local function useInterval(callback: () -> (), delay: number?, options: UseIntervalOptions?): () -> ()
	local resolvedOptions: UseIntervalOptions = options or {}
	local immediate = resolvedOptions.immediate or false

	local callbackMemo = useLatestCallback(callback)
	local cancel = react.useRef(nil :: (() -> ())?)

	local clear = react.useCallback(function()
		if cancel.current then
			cancel.current()
			cancel.current = nil
		end
	end, {})

	react.useEffect(function()
		if delay == nil then
			return
		end

		if immediate then
			callbackMemo()
		end

		cancel.current = setInterval(callbackMemo, delay)
		return clear
	end, { delay })

	return clear
end

return useInterval
