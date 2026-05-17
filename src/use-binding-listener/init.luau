local binding = require(script.Parent.utils.binding)
local react = require(script.Parent.Parent.React)
local useLatestCallback = require(script.Parent["use-latest-callback"])

type Binding<T> = react.Binding<T>
type BindingOrValue<T> = binding.BindingOrValue<T>

--[[
	Subscribes to a binding and calls the given listener when the binding
	updates. If the value passed is not a binding, the listener will be called
	with the value.

	The `listener` function is safe to not be memoized, as it will only be
	called when the binding updates.

	@param value The binding to subscribe to.
	@param listener The function to call when the binding updates.
]]
local function useBindingListener<T>(value: BindingOrValue<T>, listener: (value: T) -> ()): ()
	local api = react.useMemo(function()
		if binding.isBinding(value) then
			return binding.getBindingApi(value :: Binding<T>)
		end

		return nil
	end, { value })

	local listenerCallback = useLatestCallback(listener)

	react.useEffect(function(): (() -> ())?
		if api then
			listenerCallback(api.getValue())
			return api.subscribe(listenerCallback)
		else
			listenerCallback(value :: T)
			return nil
		end
	end, { value })
end

return useBindingListener
