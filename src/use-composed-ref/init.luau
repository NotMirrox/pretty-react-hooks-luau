local react = require(script.Parent.Parent.React)
local useLatestCallback = require(script.Parent["use-latest-callback"])

export type RefFunction<T> = (rbx: T?) -> ()

--[[
	Composes multiple ref functions into a single ref function.

	@param refs The ref functions to compose.
	@return A ref function that calls all of the ref functions passed in.
]]
local function composeRefs<T>(refs: { RefFunction<T>? }): RefFunction<T>
	return function(rbx: T?)
		for index = 1, #refs do
			local ref = refs[index]
			if ref then
				ref(rbx)
			end
		end
	end
end

--[[
	Composes multiple ref functions into a single ref function and memoizes
	the result.

	To prevent excess ref calls, the composed ref is only created once on mount.
	However, it will call the latest refs passed, so it is safe to pass in refs
	that might change.

	@param ... The ref functions to compose.
	@return A ref function that calls all of the ref functions passed in.
]]
local function useComposedRef<T>(...: RefFunction<T>?): RefFunction<T>
	local refs: { RefFunction<T>? } = { ... }

	local composedRef = react.useMemo(function()
		return composeRefs(refs)
	end, refs)

	return useLatestCallback(composedRef)
end

return useComposedRef
