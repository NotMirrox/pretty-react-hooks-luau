## 🪝 `useUpdate`

```luau
function useUpdate(): () -> ()
```

Returns a function that can be called to force an update of the component.

The function returned by `useUpdate` is recreated when it causes an update, making it useful to track re-renders caused by this hook.

### 📕 Parameters

### 📗 Returns

-   A function that can be called to force an update of the component.

### 📘 Example

```luau
local function RenderLogger()
	local update = useUpdate()

	react.useEffect(function()
		local handle = task.delay(0, function()
			update()
		end)
		return function()
			task.cancel(handle)
		end
	end, {})

	react.useEffect(function()
		print("Rendered because of useUpdate")
	end, { update })

	print("Rendered")

	return react.createElement("Frame")
end
```
