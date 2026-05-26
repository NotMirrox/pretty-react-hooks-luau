local react = require(script.Parent.Parent.Parent.React)

export type Binding<T> = react.Binding<T>
export type BindingOrValue<T> = Binding<T> | T

export type BindingApi<T> = {
	subscribe: (callback: (newValue: T) -> ()) -> () -> (),
	update: (newValue: T) -> (),
	getValue: () -> T,
}

type Lerpable<T> = {
	Lerp: (self: T, to: T, alpha: number) -> T,
}

--[[
	Returns whether the given value is a binding.
	@param value The value to check.
	@return Whether the value is a binding.
]]
local function isBinding(value: any)
	return typeof(value) == "table" and value.getValue ~= nil and value.map ~= nil
end

--[[
	Converts a value to a binding. If the given value is already a binding, it
	will be returned as-is.
	@param value The value to convert.
	@return The converted binding.
]]
local function toBinding<T>(value: BindingOrValue<T>): Binding<T>
	if isBinding(value) then
		return value :: Binding<T>
	end

	local result = react.createBinding(value :: T)
	return result
end

--[[
	Returns the value of a binding. If the given value is not a binding, it will
	be returned as-is.
	@param binding The binding to get the value of.
	@return The value of the binding.
]]
local function getBindingValue<T>(binding: BindingOrValue<T>): T
	if isBinding(binding) then
		return (binding :: Binding<T>):getValue()
	end

	return binding :: T
end

--[[
	Maps a binding to a new binding. If the given value is not a binding, it will
	be passed to the mapper function and returned as a new binding.
	@param binding The binding to map.
	@param callback The mapper function.
	@return The mapped binding.
]]
local function mapBinding<T, U>(binding: BindingOrValue<T>, callback: (value: T) -> U): Binding<U>
	if isBinding(binding) then
		return (binding :: Binding<T>):map(callback)
	end

	local result = react.createBinding(callback(binding :: T))
	return result
end

--[[
	Joins a map of bindings into a single binding. If any of the given values
	are not bindings, they will be wrapped in a new binding.
	@param bindings The bindings to join.
	@return The joined binding.
]]
local function joinAnyBindings<K, V>(bindings: { [any]: any }): Binding<any>
	local bindingsToMap = {}

	for key, value in bindings do
		bindingsToMap[key] = toBinding(value)
	end

	return react.joinBindings(bindingsToMap)
end

--[[
	Gets the internal API of a binding. This is a hacky way to get access to the
	`BindingInternalApi` object of a binding, which is not exposed by React.
	@param binding The binding to get the internal API of.
	@return The binding's API.
]]
local function getBindingApi<T>(binding: Binding<T>): BindingApi<T>?
	for key, value in pairs(binding) do
		local name = tostring(key)

		if name:sub(1, 12) == "RoactBinding" or name == "Symbol(BindingImpl)" then
			return value
		end
	end

	return nil
end

--[[
	Returns a binding that lerps between two values using the given binding as
	the alpha.
	@param binding The binding to use as the alpha.
	@param from The value to lerp from.
	@param to The value to lerp to.
	@return A binding that lerps between two values.
]]
local function lerpBinding<T>(binding: BindingOrValue<number>, from: T, to: T): Binding<T>
	return mapBinding(binding, function(alpha): T
		if typeof(from) == "number" and typeof(to) == "number" then
			return math.lerp(from, to, alpha) :: any
		end

		return (from :: any).Lerp(from, to, alpha)
	end)
end

--[[
	Composes multiple bindings or values together into a single binding.
	Calls the combiner function with the values of the bindings when any
	of the bindings change.
	@param bindings A list of bindings or values.
	@param combiner The function that maps the bindings to a new value.
	@return A binding that returns the result of the combiner.
]]
local function composeBindings(...: any): Binding<any>
	local values = { ... }

	local length = #values
	local combiner = values[length]
	values[length] = nil

	local bindings = {}
	for index, value in ipairs(values) do
		bindings[index] = toBinding(value)
	end

	return react.joinBindings(bindings):map(function(boundValues)
		return combiner(table.unpack(boundValues))
	end)
end

return {
	isBinding = isBinding,
	toBinding = toBinding,
	getBindingValue = getBindingValue,
	mapBinding = mapBinding,
	joinAnyBindings = joinAnyBindings,
	getBindingApi = getBindingApi,
	lerpBinding = lerpBinding,
	composeBindings = composeBindings,
}
