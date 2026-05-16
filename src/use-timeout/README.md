## 🪝 `useTimeout`

```luau
function useTimeout(callback: () -> (), delay: number?): () -> ()
```

Sets a timeout that runs the callback after `delay` seconds. Returns a function that clears the timeout.

If `delay` is `nil`, the timeout is cleared. If the delay updates, the timeout is reset.

The callback is memoized for you and will not reset the timeout if it changes.

### 📕 Parameters

-   `callback` - The function to run after `delay` seconds.
-   `delay` - The number of seconds to wait before calling `callback`. If `nil`, the timeout is cleared.

### 📗 Returns

-   A function that clears the timeout.

### 📘 Example

A text label that displays the number `1` after one second.

```luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.Packages.React)
local hooks = require(ReplicatedStorage.Packages.PrettyReactHooks)

local useTimeout = hooks.useTimeout

local function CountOne()
	local count, setCount = React.useState(0)

	useTimeout(function()
		setCount(count + 1)
	end, 1)

	return React.createElement("TextLabel", {
		Text = `Count: {count}`,
	})
end
```
