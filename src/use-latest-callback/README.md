## 🪝 `useLatestCallback`

```luau
function useLatestCallback<T>(callback: T): T
```

Returns a memoized callback that always points to the latest version of the callback.

When passed a new callback, the return value will not change, but calling it will invoke the new callback.

### 📕 Parameters

-   `callback` - The callback to memoize.

### 📗 Returns

-   The memoized callback.

### 📘 Example

```luau
type Props = {
	onStep: () -> (),
}

local function Stepper(props: Props)
	local onStepCallback = useLatestCallback(props.onStep)

	react.useEffect(function()
		-- Will always call the latest version of `onStep`
		local connection = RunService.RenderStepped:Connect(onStepCallback)

		return function()
			connection:Disconnect()
		end
	end, {})

	return nil
end
```
