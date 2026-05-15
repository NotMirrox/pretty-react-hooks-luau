## 🪝 `useUpdateEffect`

```luau
function useUpdateEffect(callback: () -> (() -> ())?, dependencies: { unknown }?): ()
```

Runs a callback when the component updates. Does not run on mount.

### 📕 Parameters

-   `callback` - The callback to run on update. Supports returning a cleanup function.
-   `dependencies` - Optional dependencies to watch for changes.

### 📗 Returns

-   `void`

### 📘 Example

```luau
local function RenderLogger()
	local state, setState = react.useState(0)

	useUpdateEffect(function()
		print("Updated")
	end)

	return react.createElement("TextButton", {
		Text = `Pressed {state} times`,
		[react.Event.Activated] = function()
			setState(state + 1)
		end,
	})
end
```
