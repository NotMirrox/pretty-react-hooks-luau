local promiseTypes = require(script.Parent.utils["promise-types"])
local react = require(script.Parent.Parent.React)
local useUnmountEffect = require(script.Parent["use-unmount-effect"])

type Promise<T...> = promiseTypes.TypedPromise<T...>
type Status = promiseTypes.Status

export type AsyncState<T> =
	{ status: "Started", message: nil, value: nil }
	| { status: "Resolved", message: nil, value: T }
	| { status: "Cancelled" | "Rejected", message: any, value: nil }

type AnyAsyncState<T> = {
	status: Status,
	message: any?,
	value: T?,
}

export type AsyncCallback<T, U...> = (U...) -> Promise<T>

--[[
	Returns a tuple containing the current state of the promise and a callback
	to start a new promise. Calling it will cancel any previous promise.

	@param callback The async callback.
	@return The state and a new callback.
]]
local function useAsyncCallback<T, U...>(callback: AsyncCallback<T, U...>): (AsyncState<T>, AsyncCallback<T, U...>)
	local currentPromise = react.useRef(nil :: Promise<T>?)

	local state, setState = react.useState({ status = "Started" } :: AnyAsyncState<T>)

	local execute = react.useCallback(function(...: U...)
		if currentPromise.current then
			currentPromise.current:cancel()
		end

		if state.status ~= "Started" then
			setState({ status = "Started" })
		end

		local promise = callback(...)

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
