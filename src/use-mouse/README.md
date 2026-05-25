## 🪝 `useMouse`

```luau
function useMouse(listener: ((mouse: Vector2) -> ())?): Binding<Vector2>
```

Returns a binding to the position of the mouse.

If a listener is provided, it will be called when the mouse moves and once on mount.

### 📕 Parameters

-   `listener` - An optional listener to be called when the mouse moves.

### 📗 Returns

-   The position of the mouse in pixels.

### 📘 Example

```luau
local function MouseTracker()
	local mouse = useMouse()

	return react.createElement("Frame", {
		AnchorPoint = Vector2.new(1, 1),
		Size = UDim2.fromOffset(16, 16),
		Position = mouse:map(function(p)
			return UDim2.fromOffset(p.X, p.Y)
		end),
	})
end
```
