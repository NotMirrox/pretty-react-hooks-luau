local RunService = game:GetService("RunService")

local react = require(script.Parent.Parent.React)
local useEventListener = require(script.Parent["use-event-listener"])

type Binding<T> = react.Binding<T>

export type Timer = {
	--[[
		A binding that represents the current value of the timer.
	]]
	value: Binding<number>,
	--[[
		Starts the timer if it is not already running.
	]]
	start: () -> (),
	--[[
		Pauses the timer if it is running.
	]]
	stop: () -> (),
	--[[
		Resets the timer to 0.
	]]
	reset: () -> (),
	--[[
		Sets the timer to a specific value.
	]]
	set: (value: number) -> (),
}

--[[
	Creates a timer that can be used to track a value over time.

	@param initialValue The initial value of the timer.
	@return A timer object.
]]
local function useTimer(initialValue: number?): Timer
	local value, setValue = react.useBinding(initialValue or 0)

	local started = react.useRef(true)

	useEventListener(RunService.Heartbeat, function(deltaTime: number)
		if started.current then
			setValue(value:getValue() + deltaTime)
		end
	end)

	local start = react.useCallback(function()
		started.current = true
	end, {})

	local stop = react.useCallback(function()
		started.current = false
	end, {})

	local reset = react.useCallback(function()
		setValue(0)
	end, {})

	local set = react.useCallback(function(newValue: number)
		setValue(newValue)
	end, {})

	return {
		value = value,
		start = start,
		stop = stop,
		reset = reset,
		set = set,
	}
end

return useTimer
