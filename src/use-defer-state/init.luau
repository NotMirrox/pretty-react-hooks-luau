local react = require(script.Parent.Parent.React)
local useDeferCallback = require(script.Parent["use-defer-callback"])
local useLatest = require(script.Parent["use-latest"])
local useUnmountEffect = require(script.Parent["use-unmount-effect"])

type SetStateAction<T> = T | (state: T) -> T
type SetState<T> = (value: SetStateAction<T>) -> ()

local function resolve<T>(value: SetStateAction<T>, state: T): T
	if typeof(value) == "function" then
		return value(state)
	end

	return value
end

--[[
	Like `useState`, but `setState` will update the state on the next Heartbeat
	frame. Only the latest update in a frame will run.

	This is useful for improving performance when updating state in response to
	events that fire rapidly in succession.

	@param initialState Optional initial state.
	@return A tuple containing the state and a function to update it.
]]
local function useDeferState<T>(initialState: T | (() -> T)): (T, SetState<T>)
	local state, innerSetState = react.useState(initialState)
	local deferredSetState, cancel = useDeferCallback(innerSetState)

	local latestState = useLatest(state)

	local setState = react.useCallback(function(value: SetStateAction<T>)
		latestState.current = resolve(value, latestState.current)
		deferredSetState(latestState.current)
	end, {})

	useUnmountEffect(cancel)

	return state, setState
end

return useDeferState
