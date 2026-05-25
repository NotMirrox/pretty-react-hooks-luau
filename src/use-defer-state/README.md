## 🪝 `useDeferState`

```luau
function useDeferState<T>(
	initialState: T | (() -> T)
): (T, (value: T | (state: T) -> T) -> ())
```

Like `useState`, but the updater function will defer the update until the next Heartbeat frame. Only the result of the most recent state update will be applied.

When passing a function to `setState`, it will receive the most recent value passed to `setState`, so they can be chained.

This is useful for improving performance when updating state in response to events that fire rapidly in succession.

### 📕 Parameters

-   `initialState` - State used during the initial render.

### 📗 Returns

-   A stateful value.
-   A function which schedules a state update.

### 📘 Example

```luau
local function Counter()
	local keysDown, setKeysDown = useDeferState({} :: { string })

	useEventListener(UserInputService.InputBegan, function(input)
		setKeysDown(function(keysDown)
			local next = {}
			for _, key in keysDown do
				table.insert(next, key)
			end
			table.insert(next, input.KeyCode.Name)
			return next
		end)
	end)

	useEventListener(UserInputService.InputEnded, function(input)
		setKeysDown(function(keysDown)
			local next = {}
			for _, key in keysDown do
				if key ~= input.KeyCode.Name then
					table.insert(next, key)
				end
			end
			return next
		end)
	end)

	react.useEffect(function()
		print(keysDown)
	end, { keysDown })

	return react.createElement("TextLabel", {
		Text = `Keys down: {table.concat(keysDown, ", ")}`,
	})
end
```
