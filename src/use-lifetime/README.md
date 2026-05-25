## 🪝 `useLifetime`

```luau
function useLifetime(deps: { any }?): Binding<number>
```

Returns the amount of time that has passed since the component mounted. The binding is updated every frame on Heartbeat.

If dependencies are provided, the binding will reset to `0` whenever any of the dependencies change.

Useful for mapping time to procedural animations and other time-based effects.

### 📕 Parameters

-   `deps` - An optional array of dependencies. If provided, the binding will reset to `0` whenever any of the dependencies change.

### 📗 Returns

-   A binding that will update with the amount of time that has passed since the component mounted.

### 📘 Example

```luau
local function Blink()
	local lifetime = useLifetime()
	local transparency = lifetime:map(function(t)
		return math.sin(t) * 0.5 + 0.5
	end)

	return react.createElement("Frame", {
		BackgroundTransparency = transparency,
	})
end
```
