local Workspace = game:GetService("Workspace")

local react = require(script.Parent.Parent.React)
local useEventListener = require(script.Parent["use-event-listener"])

--[[
	Returns the current camera. Updates when the current camera changes.

	@return A camera instance.
]]
local function useCamera(): Camera
	local camera, setCamera = react.useState(Workspace.CurrentCamera)

	useEventListener(Workspace:GetPropertyChangedSignal("CurrentCamera"), function()
		if Workspace.CurrentCamera then
			setCamera(Workspace.CurrentCamera)
		end
	end)

	return camera
end

return useCamera
