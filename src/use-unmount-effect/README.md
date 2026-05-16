## 🪝 `useUnmountEffect`

```luau
function useUnmountEffect(callback: () -> ()): ()
```

Calls the callback when the component unmounts. This is useful for cleaning up side effects.

### 📕 Parameters

-   `callback` - The callback to call when the component unmounts.

### 📗 Returns

-   `()`

### 📘 Example

```luau
local function UnmountLogger()
	useUnmountEffect(function()
		print("Unmounting...")
	end)

	return react.createElement("Frame")
end
```
