local react = require(script.Parent.Parent.React)

--[[
	Returns a function that can be used to force a component to update. The
	function is recreated on the next render if called. This makes it useful as
	a dependency for other hooks.

	@return A function that forces a rerender.
]]
local function useUpdate(): () -> ()
	local state, setState = react.useState({})

	return react.useCallback(function()
		setState({})
	end, { state })
end

return useUpdate
