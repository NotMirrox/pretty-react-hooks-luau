local RunService = game:GetService("RunService")

local react = require(script.Parent.Parent.React)
local useEventListener = require(script.Parent["use-event-listener"])

type Binding<T> = react.Binding<T>

--[[
	Returns a binding holding the number of seconds since the component
	mounted. The binding is updated each Heartbeat frame, so reading it
	through `useBinding` consumers does not re-render the component.

	If the dependency array is provided, the lifetime timer will reset to `0`
	when any of the dependencies change.

	@param deps An optional array of dependencies to reset the timer.
	@return A binding of the component's lifetime in seconds.
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
