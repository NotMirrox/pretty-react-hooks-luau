## 🪝 `useKeyPress`

```luau
function useKeyPress(keyCodeCombos: { KeyCodes }, options: KeyPressOptions?): boolean
```

Returns `true` if any of the given keys or shortcuts are pressed. The hook expects one or more key codes, which can be:

-   A single key, like `"Space"`
-   A combination of keys, like `"Space+W"`
-   An array of keys, like `{ "Space", "W" }`

Each combination is treated as its own shortcut. If passed more than one combination, the hook will return `true` if any of the combinations are pressed.

### ⚙️ Options

-   `bindAction` - Whether to bind a `ContextActionService` action to the key press. Defaults to `false`.
-   `actionName` - The name of the action to bind. Defaults to a random GUID.
-   `actionPriority` - The priority of the action to bind. Defaults to `Enum.ContextActionPriority.High.Value`.
-   `actionInputTypes` - The input types to bind the action to. Defaults to `Keyboard` and `Gamepad1`.
-   `actionKeyCodes` - Additional key codes to bind the action to. Defaults to an empty list.

### 📕 Parameters

-   `keyCodeCombos` - One or more key codes.
-   `options` - Optional config for binding the action.

### 📗 Returns

-   Whether any of the given keys or shortcuts are pressed.

### 📘 Example

```luau
local function Keyboard()
	local spacePressed = useKeyPress({ "Space" })
	local ctrlAPressed = useKeyPress({ "LeftControl+A", "RightControl+A" })

	react.useEffect(function()
		print(`Space pressed: {spacePressed}`)
	end, { spacePressed })

	react.useEffect(function()
		print(`Ctrl+A pressed: {ctrlAPressed}`)
	end, { ctrlAPressed })

	return nil
end
```
