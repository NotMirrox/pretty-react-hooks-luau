## 🪝 `useDeferCallback`

```luau
function useDeferCallback<T...>(
	callback: (T...) -> ()
): (execute: (T...) -> (), cancel: () -> ())
```

Defers a callback until the next Heartbeat frame. Consecutive calls to the returned `execute` function will cancel the previous call.

### 📕 Parameters

-   `callback` - The function to defer.

### 📗 Returns

-   `execute` - The deferred function.
-   `cancel` - A function that will cancel a scheduled update.

### 📘 Example

```luau
local function Counter()
	local count, setCount = react.useState(0)
	local deferredSetCount, cancel = useDeferCallback(setCount)

	useEventListener(UserInputService.InputBegan, function(input)
		if input.KeyCode == Enum.KeyCode.E then
			deferredSetCount(count + 1)
		end
	end)

	useUnmountEffect(cancel)

	return react.createElement("TextButton", {
		Text = `Count: {count}`,
	})
end
```
