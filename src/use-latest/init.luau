local react = require(script.Parent.Parent.React)

type Predicate<T> = (previous: T?, current: T) -> boolean

local function isStrictEqual(previous: unknown?, current: unknown)
	return previous == current
end

--[[
	Returns a mutable ref that points to the latest value of the input.

	Takes an optional `predicate` function as the second argument that receives
	the previous and current value. If the predicate returns `false`, the values
	are not equal, and the previous value is updated.

	@param value The value to track.
	@param predicate Optional function to determine whether the value changed.
	Defaults to a strict equality check (`==`).
	@return A mutable reference to the value.
]]
local function useLatest<T>(value: T, predicate: Predicate<T>?): { current: T }
	local predicateFn: Predicate<T> = predicate or isStrictEqual
	local ref = react.useRef(value)

	react.useMemo(function()
		if not predicateFn(ref.current, value) then
			ref.current = value
		end
	end, { value })

	return ref
end

return useLatest
