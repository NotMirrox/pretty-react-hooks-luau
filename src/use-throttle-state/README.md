## 🪝 `useThrottleState`

```luau
function useThrottleState<T>(
	initialState: T,
	options: UseThrottleOptions?
): (T, Debounced<(T | (T) -> T) -> ()>)
```

Creates a throttled state that only updates at most once per every `wait` seconds. Set to the most recently passed `state` after each interval.

See [lodash.throttle](https://lodash.com/docs/4.17.15#throttle) for the function this hook is based on.

### 📕 Parameters

-   `initialState` - The initial state.
-   `options` - The options object.
    -   `wait` - The number of seconds to throttle. Defaults to `0`.
    -   `leading` - Specify invoking on the leading edge of the timeout. Defaults to `true`.
    -   `trailing` - Specify invoking on the trailing edge of the timeout. Defaults to `true`.

### 📗 Returns

-   The throttled state.
-   A function to update the throttled state.

### 📘 Example

Throttle viewport size updates to once per second.

```luau
local function ViewportProvider()
	local camera = useCamera()
	local viewport, setViewport = useThrottleState(camera.ViewportSize, { wait = 1 })

	useEventListener(camera:GetPropertyChangedSignal("ViewportSize"), function()
		setViewport(camera.ViewportSize)
	end)

	return react.createElement(Viewport.Provider, { value = viewport })
end
```
