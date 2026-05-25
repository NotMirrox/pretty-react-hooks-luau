## 🪝 `useViewport`

```luau
function useViewport(listener: ((viewport: Vector2) -> ())?): Binding<Vector2>
```

Returns a binding to the size of the viewport.

If a listener is provided, it will be called when the viewport changes and once on mount.

### 📕 Parameters

-   `listener` - An optional listener to be called when the viewport size changes.

### 📗 Returns

-   The size of the viewport in pixels.

### 📘 Example

```luau
local function TextSize()
	local viewport = useViewport()
	local textSize = viewport:map(function(size)
		return math.min(size.X / 1920, size.Y / 1080) * 14
	end)

	return react.createElement("TextLabel", {
		TextSize = textSize,
	})
end
```
