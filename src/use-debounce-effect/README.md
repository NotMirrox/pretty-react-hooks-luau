## 🪝 `useDebounceEffect`

```luau
function useDebounceEffect(
	effect: () -> (() -> ())?,
	dependencies: { any }?,
	options: UseDebounceOptions?
): ()
```

Creates a debounced effect that delays invoking `effect` until after `wait` seconds have elapsed since the last time the debounced function was invoked.

See [lodash.debounce](https://lodash.com/docs/4.17.15#debounce) for the function this hook is based on.

### ⚙️ Options

-   `wait` - The number of seconds to delay. Defaults to `0`.
-   `leading` - Specify invoking on the leading edge of the timeout. Defaults to `false`.
-   `trailing` - Specify invoking on the trailing edge of the timeout. Defaults to `true`.
-   `maxWait` - The maximum time the effect is allowed to be delayed before invoking.

### 📕 Parameters

-   `effect` - The effect to debounce.
-   `dependencies` - The dependencies array.
-   `options` - The options object.

### 📗 Returns

-   `()`

### 📘 Example

Update the query after the user stops typing for 1 second.

```luau
local function SearchQuery()
	local query, setQuery = react.useState("")

	useDebounceEffect(function()
		print(query)
	end, { query }, { wait = 1 })

	return react.createElement("TextBox", {
		Size = UDim2.new(1, 0, 0, 30),
		[react.Change.Text] = function(rbx)
			setQuery(rbx.Text)
		end,
	})
end
```
