local Promise = require(script.Parent.Parent.Promise)
local react = require(script.Parent.Parent.React)
local useUnmountEffect = require(script.Parent["use-unmount-effect"])

type Promise = Promise.Promise
type TypedPromise<T...> = Promise.TypedPromise<T...>
type Status = Promise.Status

export type AsyncState<T> =
	{ status: "Started", message: nil, value: nil }
	| { status: "Resolved", message: nil, value: T }
	| { status: "Cancelled" | "Rejected", message: any, value: nil }

type AnyAsyncState<T> = {
	status: Status,
	message: any?,
	value: T?,
}

type EffectCallback<T, U...> = ((U...) -> T) | ((U...) -> ())
type PromiseCallback<T, U...> = (U...) -> TypedPromise<T>

type Callback<T, U...> = EffectCallback<T, U...> | PromiseCallback<T, U...>

--[[
	Returns the current state of the latest promise and an `execute` function
	to start a new one. Calling `execute` cancels any in-flight promise from a
	previous call. The pending promise is also cancelled on unmount.

	The `status` field walks through `Started` → `Resolved` | `Rejected` |
	`Cancelled`. Match on it to render loading/error/value states.

	Use `useAsync` instead when the promise should re-run automatically as
	dependencies change.

	@param callback The async callback.
	@return state The current `AsyncState<T>` (status, value, message).
	@return execute Starts a new promise, cancelling any previous one.
]]
local function useAsyncCallback<T, U...>(callback: Callback<T, U...>): (AsyncState<T>, PromiseCallback<T, U...>)
	local currentPromise = react.useRef(nil :: TypedPromise<T>?)

	local state, setState = react.useState({ status = "Started" } :: AnyAsyncState<T>)

	local execute = react.useCallback(function(...: U...)
		if currentPromise.current then
			currentPromise.current:cancel()
		end

		if state.status ~= "Started" then
			setState({ status = "Started" })
		end

		local promise: TypedPromise<T>
		if Promise.is(callback) then
			promise = (callback :: PromiseCallback<T, U...>)(...)
		else
			promise = Promise.try(callback, ...)
		end

		promise:andThen(function(value)
			setState({ status = promise:getStatus(), value = value })
		end, function(message)
			setState({ status = promise:getStatus(), message = message })
		end)

		currentPromise.current = promise
		return promise
	end, { callback })

	useUnmountEffect(function()
		if currentPromise.current then
			currentPromise.current:cancel()
		end
	end)

	return state :: AsyncState<T>, execute
end

return useAsyncCallback
