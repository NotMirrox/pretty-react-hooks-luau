## 🪝 `useInterval`

```luau
function useInterval(
	callback: () -> (),
	delay: number?,
	options: UseIntervalOptions?
): () -> ()
```

Sets an interval that runs a callback function every `delay` seconds. Returns a function that clears the interval.

If `delay` is `nil`, the interval is cleared. If the delay updates, the interval is reset.

The callback is memoized for you and will not reset the interval if it changes.

### 📕 Parameters

-   `callback` - The function to run every `delay` seconds.
-   `delay` - The number of seconds to wait between each call to `callback`. If `nil`, the interval is cleared.
-   `options` - Options for the interval.
    -   `immediate` - If `true`, the callback is called immediately when the interval is set. Defaults to `false`.

### 📗 Returns

-   A function that clears the interval.

### 📘 Example

```luau
local function Interval()
	local count, setCount = react.useState(0)

	useInterval(function()
		setCount(count + 1)
	end, 1)

	return react.createElement("TextLabel", {
		Text = `Count: {count}`,
	})
end
```
