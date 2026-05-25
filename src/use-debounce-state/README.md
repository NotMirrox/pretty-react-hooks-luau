## 🪝 `useDebounceState`

```luau
function useDebounceState<T>(
	initialState: T,
	options: UseDebounceOptions?
): (T, Debounced<(T | (T) -> T) -> ()>)
```

Delays updating `state` until after `wait` seconds have elapsed since the last time the debounced function was invoked. Set to the most recently passed `state` after the delay.

See [lodash.debounce](https://lodash.com/docs/4.17.15#debounce) for the function this hook is based on.

### 📕 Parameters

-   `initialState` - The initial state.
-   `options` - The options object.
    -   `wait` - The number of seconds to delay. Defaults to `0`.
    -   `leading` - Specify invoking on the leading edge of the timeout. Defaults to `false`.
    -   `trailing` - Specify invoking on the trailing edge of the timeout. Defaults to `true`.
    -   `maxWait` - The maximum time `state` is allowed to be delayed before invoking.

### 📗 Returns

-   The debounced state.
-   A function to update the debounced state.

### 📘 Example

Update the query after the user stops typing for 1 second.

```luau
local function SearchQuery()
	local query, setQuery = useDebounceState("", { wait = 1 })

	react.useEffect(function()
		print(query)
	end, { query })

	return react.createElement("TextBox", {
		Size = UDim2.new(1, 0, 0, 30),
		[react.Change.Text] = function(rbx)
			setQuery(rbx.Text)
		end,
	})
end
```
