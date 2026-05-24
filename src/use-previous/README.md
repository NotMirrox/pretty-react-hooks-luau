## 🪝 `usePrevious`

```luau
function usePrevious<T>(
	value: T,
	predicate: ((previous: T?, current: T) -> boolean)?
): T?
```

Returns a reference to the value from the previous render, or `nil` on the first render.

It takes an optional equality function to determine whether the values are equal. If false, the value will be updated.

### 📕 Parameters

-   `value` - The value to track.
-   `predicate?` - An equality function. Defaults to a strict equality check (`==`).

### 📗 Returns

-   The value from the previous render, or `nil` on the first render.

### 📘 Example

```luau
local function ShowPrevious(props: Props)
	local value = props.value
	local previousValue = usePrevious(value)

	return react.createElement("TextLabel", {
		Text = `{value} (previous: {previousValue or "none"})`,
	})
end 
```
