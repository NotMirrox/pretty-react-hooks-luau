local binding = require(script.Parent.utils.binding)
local react = require(script.Parent.Parent.React)
local useBindingListener = require(script.Parent["use-binding-listener"])

type BindingOrValue<T> = binding.BindingOrValue<T>

--[[
	Returns the value of a binding. If the binding updates, the component will
	be re-rendered. Non-binding values will be returned as-is.

	@param value The binding to get the value of.
	@return The value of the binding.
]]
local function useBindingState<T>(value: BindingOrValue<T>): T
	local state, setState = react.useState(function()
		return binding.getBindingValue(value)
	end)

	useBindingListener(value, setState)

	return state
end

return useBindingState
