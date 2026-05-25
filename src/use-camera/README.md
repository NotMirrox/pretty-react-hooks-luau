## 🪝 `useCamera`

```luau
function useCamera(): Camera
```

Returns the value of `Workspace.CurrentCamera`. If the current camera changes, it will trigger a re-render.

### 📗 Returns

-   A camera instance.

### 📘 Example

```luau
local function CameraPortal()
	local camera = useCamera()

	return createPortal(react.createElement("TextLabel", {
		Text = "Hello, World!",
	}), camera)
end
```
