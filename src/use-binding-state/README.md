## 🪝 `useBindingState`

```luau
function useBindingState<T>(value: T | Binding<T>): T
```

Returns the value of the given binding. When the binding updates, the component will be re-rendered with the new value.

If not passed a valid binding, the value passed to the hook will be returned.

### 📕 Parameters

-   `value` - The binding to subscribe to.

### 📗 Returns

-   The value of the binding.

### 📘 Example

```luau
type Props = {
	visible: boolean | react.Binding<boolean>,
}

local function ToggleFrame(props: Props)
	local isVisible = useBindingState(props.visible)

	react.useEffect(function()
		print("Visible changed to", isVisible)
	end, { isVisible })

	return react.createElement("Frame", {
		Visible = props.visible,
	})
end
```
