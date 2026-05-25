## 🪝 `useThrottleCallback`

```luau
function useThrottleCallback<T>(
	callback: T,
	options: UseThrottleOptions?
): UseDebounceResult<T>
```

Creates a throttled function that only invokes `callback` at most once per every `wait` seconds.

The callback is invoked with the last arguments provided to the throttled function. Subsequent calls to the throttled function return the result of the last `callback` invocation.

See [lodash.throttle](https://lodash.com/docs/4.17.15#throttle) for the function this hook is based on.

### ⚙️ Options

-   `wait` - The number of seconds to throttle. Defaults to `0`.
-   `leading` - Specify invoking on the leading edge of the timeout. Defaults to `true`.
-   `trailing` - Specify invoking on the trailing edge of the timeout. Defaults to `true`.

### 📕 Parameters

-   `callback` - The function to throttle.
-   `options` - The options object.

### 📗 Returns

-   A `UseDebounceResult` object.
    -   `run` - The throttled function.
    -   `cancel` - Cancels any pending invocation.
    -   `flush` - Immediately invokes a pending invocation.
    -   `pending` - Whether there is a pending invocation.

### 📘 Example

Throttle viewport size updates to once per second.

```luau
local function ViewportProvider()
	local camera = useCamera()
	local viewport, setViewport = react.useState(camera.ViewportSize)

	local throttled = useThrottleCallback(function(size: Vector2)
		setViewport(size)
	end, { wait = 1 })

	useEventListener(camera:GetPropertyChangedSignal("ViewportSize"), function()
		throttled.run(camera.ViewportSize)
	end)

	return react.createElement(Viewport.Provider, { value = viewport })
end
```
