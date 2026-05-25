local UserInputService = game:GetService("UserInputService")

local react = require(script.Parent.Parent.React)
local useEventListener = require(script.Parent["use-event-listener"])
local useMountEffect = require(script.Parent["use-mount-effect"])

type Binding<T> = react.Binding<T>

--[[
	Returns a binding to the mouse position. The binding updates whenever the
	mouse moves or a touch input is received.

	If a listener is provided, it is called when the mouse moves and once on
	mount with the current position.

	@param listener Optional listener called when the mouse position changes.
	@return A binding to the mouse position in pixels.
]]
local function useMouse(listener: ((mouse: Vector2) -> ())?): Binding<Vector2>
	local mouse, setMouse = react.useBinding(Vector2.one)

	useEventListener(UserInputService.InputChanged, function(input: InputObject)
		local inputType = input.UserInputType
		if inputType ~= Enum.UserInputType.MouseMovement and inputType ~= Enum.UserInputType.Touch then
			return
		end

		local mouseLocation = UserInputService:GetMouseLocation()
		setMouse(mouseLocation)

		if listener then
			listener(mouseLocation)
		end
	end)

	react.useMemo(function()
		setMouse(UserInputService:GetMouseLocation())
	end, {})

	useMountEffect(function()
		if listener then
			listener(mouse:getValue())
		end
	end)

	return mouse
end

return useMouse
