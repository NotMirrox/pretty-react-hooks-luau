## 🪝 `useUpdateEffect`

```luau
function useUpdateEffect(effect: () -> (() -> ())?, dependencies: { any }?): ()
```

Runs an effect when the component updates. Does not run on mount.

### 📕 Parameters

-   `effect` - The effect to run on update. May return a cleanup function.
-   `dependencies` - Optional dependencies to watch for changes.

### 📗 Returns

-   `()`

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
