## 🪝 `useUnmountEffect`

```luau
function useUnmountEffect(callback: () -> ()): ()
```

Calls the callback when the component unmounts. This is useful for cleaning up side effects.

### 📕 Parameters

-   `callback` - The callback to call when the component unmounts.

### 📗 Returns

-   `void`

### 📘 Example

```luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.Packages.React)
local PrettyReactHooks = require(ReplicatedStorage.Packages.PrettyReactHooks)
local useUnmountEffect = PrettyReactHooks.useUnmountEffect

local function UnmountLogger()
	useUnmountEffect(function()
		print("Unmounting...")
	end)

	return React.createElement("Frame")
end
```
