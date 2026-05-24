## 🪝 `useLatest`

```luau
function useLatest<T>(
	value: T,
	predicate: ((previous: T?, current: T) -> boolean)?
): { current: T }
```

Returns a ref object whose `current` property points to the latest version of the value.

It takes an optional equality function to determine whether the values are equal. If `false`, the value will be updated.

### 📕 Parameters

-   `value` - The value to wrap in a ref.
-   `predicate?` - An equality function. Defaults to a strict equality check (`==`).

### 📗 Returns

-   A ref object.

### 📘 Example

```luau
local function Counter()
	local value, setValue = react.useState(0)
	local latestValue = useLatest(value)

	useEventListener(RunService.Heartbeat, function()
		print(latestValue.current)
	end)

	return react.createElement("TextButton", {
		Text = `Count: {value}`,
		[react.Event.Activated] = function()
			setValue(value + 1)
		end,
	})
end
```
