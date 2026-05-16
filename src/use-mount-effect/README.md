## 🪝 `useMountEffect`

```luau
function useMountEffect(callback: (() -> ()) | (() -> (() -> ()))): ()
```

Runs a callback when the component mounts. May return a cleanup function that runs on unmount.

### 📕 Parameters

-   `callback` - The callback to run on mount.

### 📗 Returns

-   `()`

### 📘 Example

```luau
local function MountLogger()
	useMountEffect(function()
		print("Mounted")
	end)

	return react.createElement("Frame")
end
```
