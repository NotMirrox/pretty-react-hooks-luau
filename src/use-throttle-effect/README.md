## 🪝 `useThrottleEffect`

```luau
function useThrottleEffect(
	effect: () -> (() -> ())?,
	dependencies: { any }?,
	options: UseThrottleOptions?
): ()
```

Creates a throttled effect that only runs at most once per every `wait` seconds.

See [lodash.throttle](https://lodash.com/docs/4.17.15#throttle) for the function this hook is based on.

### ⚙️ Options

-   `wait` - The number of seconds to throttle. Defaults to `0`.
-   `leading` - Specify invoking on the leading edge of the timeout. Defaults to `true`.
-   `trailing` - Specify invoking on the trailing edge of the timeout. Defaults to `true`.

### 📕 Parameters

-   `effect` - The effect to throttle.
-   `dependencies` - The dependencies array.
-   `options` - The options object.

### 📗 Returns

-   `()`

### 📘 Example

Throttle viewport size updates to once per second.

```luau
local function ResizeLogger()
	local camera = useCamera()
	local viewport, setViewport = react.useState(camera.ViewportSize)

	useEventListener(camera:GetPropertyChangedSignal("ViewportSize"), function()
		setViewport(camera.ViewportSize)
	end)

	useThrottleEffect(function()
		print("Viewport size updated:", viewport)
	end, { viewport }, { wait = 1 })

	return react.createElement("Frame")
end
```
