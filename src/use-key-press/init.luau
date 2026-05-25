local ContextActionService = game:GetService("ContextActionService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local react = require(script.Parent.Parent.React)
local useEventListener = require(script.Parent["use-event-listener"])

export type KeyCode = string

export type KeyCodes = KeyCode | { KeyCode }

export type KeyPressOptions = {
	--[[
		Whether to bind a ContextActionService action to the key press. If `true`,
		the action will be bound with the lifecycle of the component. The action
		will sink the input, so the game will not process it.
	]]
	bindAction: boolean?,
	--[[
		The action priority to use when binding the action. Defaults to
		`Enum.ContextActionPriority.High.Value`.
	]]
	actionPriority: number?,
	--[[
		The action name to use when binding the action. Defaults to a random name.
	]]
	actionName: string?,
	--[[
		The input types to listen for. Defaults to `Enum.UserInputType.Keyboard`
		and `Enum.UserInputType.Gamepad1`.
	]]
	actionInputTypes: { Enum.UserInputType }?,
	--[[
		Additional key codes to listen for. Defaults to an empty list.
	]]
	actionKeyCodes: { Enum.KeyCode }?,
}

type ResolvedKeyPressOptions = {
	bindAction: boolean,
	actionPriority: number,
	actionName: string,
	actionInputTypes: { Enum.UserInputType },
	actionKeyCodes: { Enum.KeyCode },
}

local function resolveOptions(options: KeyPressOptions?): ResolvedKeyPressOptions
	local resolved: KeyPressOptions = options or {}
	local bindAction = resolved.bindAction or false

	return {
		bindAction = bindAction,
		actionPriority = resolved.actionPriority or Enum.ContextActionPriority.High.Value,
		actionName = resolved.actionName or (if bindAction then HttpService:GenerateGUID(false) else ""),
		actionInputTypes = resolved.actionInputTypes or { Enum.UserInputType.Keyboard, Enum.UserInputType.Gamepad1 },
		actionKeyCodes = resolved.actionKeyCodes or {},
	}
end

--[[
	Returns whether the passed key or shortcut is pressed. The hook expects one
	or more key codes, which can be:

	- A single key code `"W"`
	- A combination of key codes `"W+Space"`
	- An array of key codes `{ "W", "Space" }`

	Each combination is treated as its own shortcut. If passed more than one
	combination, the hook will return `true` if any of the combinations are
	pressed.

	@param keyCodeCombos The key code or combination of key codes to listen for.
	@param options Options for binding a ContextActionService action.
	@return Whether the key or combination of keys is pressed.
]]
local function useKeyPress(keyCodeCombos: { KeyCodes }, options: KeyPressOptions?): boolean
	local resolved = resolveOptions(options)

	local pressed, setPressed = react.useState(false)

	local keyCombos = react.useMemo(function()
		local combos: { { KeyCode } } = {}
		for index, keyCodes in keyCodeCombos do
			if typeof(keyCodes) == "string" then
				combos[index] = string.split(keyCodes, "+")
			else
				combos[index] = keyCodes
			end
		end

		return combos
	end, keyCodeCombos)

	local keySet = react.useMemo(function()
		local set: { [KeyCode]: true } = {}
		for _, keys in keyCombos do
			for _, key in keys do
				set[key] = true
			end
		end

		return set
	end, keyCombos)

	local keysDown = react.useMemo(function()
		return {}
	end, keyCodeCombos)

	local function updatePressed()
		for _, keys in keyCombos do
			local allDown = true

			for _, key in keys do
				if not keysDown[key] then
					allDown = false
					break
				end
			end

			if allDown then
				setPressed(true)
				return
			end
		end

		setPressed(false)
	end

	useEventListener(UserInputService.InputBegan, function(input: InputObject, gameProcessed: boolean)
		if not gameProcessed and keySet[input.KeyCode.Name] then
			keysDown[input.KeyCode.Name] = true
			updatePressed()
		end
	end)

	useEventListener(UserInputService.InputEnded, function(input: InputObject)
		if keySet[input.KeyCode.Name] then
			keysDown[input.KeyCode.Name] = nil
			updatePressed()
		end
	end)

	react.useEffect(function(): (() -> ())?
		if not resolved.bindAction then
			return
		end

		local extras: { Enum.UserInputType | Enum.KeyCode } = {}
		for _, inputType in resolved.actionInputTypes do
			table.insert(extras, inputType)
		end

		for _, keyCode in resolved.actionKeyCodes do
			table.insert(extras, keyCode)
		end

		ContextActionService:BindActionAtPriority(resolved.actionName, function(_, state, input)
			if not keySet[input.KeyCode.Name] then
				return Enum.ContextActionResult.Pass
			end

			if state == Enum.UserInputState.Begin then
				keysDown[input.KeyCode.Name] = true
			elseif state == Enum.UserInputState.End then
				keysDown[input.KeyCode.Name] = nil
			end

			updatePressed()

			return Enum.ContextActionResult.Sink
		end, false, resolved.actionPriority, table.unpack(extras))

		return function()
			ContextActionService:UnbindAction(resolved.actionName)
		end
	end, { resolved.bindAction, resolved.actionName, resolved.actionPriority } :: { any })

	return pressed
end

return useKeyPress
