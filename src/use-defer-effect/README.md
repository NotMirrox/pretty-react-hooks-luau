## 🪝 `useDeferEffect`

```luau
function useDeferEffect(callback: () -> (), deps: { any }?): ()
```

Like `useEffect`, but the callback will defer the update until the next Heartbeat frame. If multiple updates are scheduled, only the most recent will be applied.

### 📕 Parameters

-   `callback` - A function to run after the component renders.
-   `deps` - An array of values that the effect depends on. If any of the values change, the effect will run again.

### 📗 Returns

-   `()`

### 📘 Example

```luau
local function Counter()
	local count, setCount = react.useState(0)

	useDeferEffect(function()
		print(count)
	end, { count })

	return react.createElement("TextButton", {
		Text = `Count: {count}`,
		[react.Event.Activated] = function()
			setCount(count + 1)
		end,
	})
end
```
