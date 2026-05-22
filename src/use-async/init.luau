local Promise = require(script.Parent.Parent.Promise)
local react = require(script.Parent.Parent.React)
local useAsyncCallback = require(script.Parent["use-async-callback"])

type Status = Promise.Status
type TypedPromise<T> = Promise.TypedPromise<T>

type EffectCallback<T> = (() -> T) | (() -> ())
type PromiseCallback<T> = () -> TypedPromise<T>

type Callback<T> = EffectCallback<T> | PromiseCallback<T>

--[[
	Returns a tuple containing the result and status of a promise. When the
	dependencies change, pending promises will be cancelled, and a new promise
	will be started.

	@param callback The async callback.
	@param deps The dependencies to watch. Defaults to an empty array.
	@return The result and status of the promise.
]]
local function useAsync<T>(callback: Callback<T>, deps: { any }?): (T?, Status, any?)
	local state, asyncCallback = useAsyncCallback(callback)

	react.useEffect(function()
		asyncCallback()
	end, deps or {})

	return state.value, state.status, state.message
end

return useAsync
