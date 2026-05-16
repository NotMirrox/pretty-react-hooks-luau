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
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local React = require(ReplicatedStorage.Packages.React)
local hooks = require(ReplicatedStorage.Packages.PrettyReactHooks)

local useDeferCallback = hooks.useDeferCallback
local useEventListener = hooks.useEventListener
local useUnmountEffect = hooks.useUnmountEffect

local function Counter()
	local count, setCount = React.useState(0)

	local deferredSetCount, cancel = useDeferCallback(setCount)

	useEventListener(UserInputService.InputBegan, function(input)
		if input.KeyCode == Enum.KeyCode.E then
			deferredSetCount(count + 1)
		end
	end)

	useUnmountEffect(cancel)

	return React.createElement("TextButton", {
		Text = `Count: {count}`,
	})
end
```
