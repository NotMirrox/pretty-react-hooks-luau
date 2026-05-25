local Promise = require(script.Parent.Parent.Promise)
local react = require(script.Parent.Parent.React)
local useAsyncCallback = require(script.Parent["use-async-callback"])

type Status = Promise.Status
type TypedPromise<T> = Promise.TypedPromise<T>

type EffectCallback<T> = (() -> T) | (() -> ())
type PromiseCallback<T> = () -> TypedPromise<T>

type Callback<T> = EffectCallback<T> | PromiseCallback<T>

--[[
	Runs an async callback whenever the dependencies change and returns its
	current state. Pending promises are cancelled and replaced on dependency
	change, so consumers always observe the latest run.

	Use `useAsyncCallback` instead when the promise should be triggered
	manually rather than reactively from deps.

	@param callback The async callback.
	@param deps The dependencies to watch. Defaults to an empty array.
	@return value The resolved value, or `nil` while pending/rejected/cancelled.
	@return status The promise status (`Started`, `Resolved`, `Cancelled`, or `Rejected`).
	@return message The rejection reason or cancellation message, if any.
]]
local function useAsync<T>(callback: Callback<T>, deps: { any }?): (T?, Status, any?)
	local state, asyncCallback = useAsyncCallback(callback)

	react.useEffect(function()
		asyncCallback()
	end, deps or {})

	return state.value, state.status, state.message
end

return useAsync
