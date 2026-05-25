local RunService = game:GetService("RunService")

local react = require(script.Parent.Parent.React)
local useEventListener = require(script.Parent["use-event-listener"])

export type Binding<T> = react.Binding<T>

--[[
	Returns the lifetime of the component in seconds. Updates every frame on
	the Heartbeat event.

	If the dependency array is provided, the lifetime timer will reset when
	any of the dependencies change.

	@param deps An optional array of dependencies to reset the timer.
	@return A binding of the component's lifetime.
]]
local function useLifetime(deps: { any }?): Binding<number>
	local resolvedDependencies = deps or {}
	local lifetime, setLifetime = react.useBinding(0)

	useEventListener(RunService.Heartbeat, function(deltaTime: number)
		setLifetime(lifetime:getValue() + deltaTime)
	end)

	react.useEffect(function()
		setLifetime(0)
	end, resolvedDependencies)

	return lifetime
end

return useLifetime
