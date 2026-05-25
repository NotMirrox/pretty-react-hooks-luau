local react = require(script.Parent.Parent.React)
local useCamera = require(script.Parent["use-camera"])
local useEventListener = require(script.Parent["use-event-listener"])

type Binding<T> = react.Binding<T>

--[[
	Returns the current viewport size of the camera.

	@param listener Optional listener to be called when the viewport changes.
	@return A binding to the viewport size.
]]
local function useViewport(listener: ((viewport: Vector2) -> ())?): Binding<Vector2>
	local camera = useCamera()
	local viewport, setViewport = react.useBinding(camera.ViewportSize)

	useEventListener(camera:GetPropertyChangedSignal("ViewportSize"), function()
		setViewport(camera.ViewportSize)
		if listener then
			listener(camera.ViewportSize)
		end
	end)

	react.useEffect(function()
		setViewport(camera.ViewportSize)
		if listener then
			listener(camera.ViewportSize)
		end
	end, { camera })

	return viewport
end

return useViewport
