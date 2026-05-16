local react = require(script.Parent.Parent.React)

type Predicate<T> = (previous: T?, current: T) -> boolean

local function isStrictEqual(previous: unknown?, current: unknown)
	return previous == current
end

--[[
	Returns the most recent value from the previous render. Returns `nil`
	on the first render.

	Takes an optional `predicate` function as the second argument that receives
	the previous and current value. If the predicate returns `false`, the values
	are not equal, and the previous value is updated.

	@param value The value to return on the next render if it changes.
	@param predicate Optional function to determine whether the value changed.
	Defaults to a strict equality check (`==`).
	@return The previous value.
]]
local function usePrevious<T>(value: T, predicate: Predicate<T>?): T?
	local predicateFn: Predicate<T> = predicate or isStrictEqual
	local previousRef = react.useRef(nil :: T?)
	local currentRef = react.useRef(nil :: T?)

	react.useMemo(function()
		if not predicateFn(currentRef.current, value) then
			previousRef.current = currentRef.current
			currentRef.current = value
		end
	end, { value })

	return previousRef.current
end

return usePrevious
