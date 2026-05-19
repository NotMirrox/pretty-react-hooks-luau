local Promise = require(script.Parent.Parent.Promise)
local react = require(script.Parent.Parent.React)

type Promise = Promise.Promise

--[[
	Runs an async effect and cancels the promise when unmounting the effect.
	Note that effects paused by `:await()` still run while cancelled, so prefer
	to use promise chaining instead.

	@param effect The async effect to run.
	@param deps The dependencies to run the effect on.
]]
local function useAsyncEffect(effect: () -> Promise, deps: { any }?): ()
	react.useEffect(function()
		local promise = effect()

		return function()
			promise:cancel()
		end
	end, deps)
end

return useAsyncEffect
