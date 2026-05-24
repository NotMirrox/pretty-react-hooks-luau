## 🪝 `useBindingListener`

```luau
function useBindingListener<T>(
	value: T | Binding<T>,
	listener: (value: T) -> ()
): ()
```

Subscribes the given listener to binding updates. The listener will be called with the current value of the binding when the component is mounted, and then again whenever the binding updates.

If not passed a valid binding, the listener will be called with the value passed to the hook.

The `listener` parameter is memoized for you, and will only be called when the binding updates.

### 📕 Parameters

-   `value` - The binding to subscribe to.
-   `listener` - The listener to call when the binding updates.

### 📗 Returns

-   `()`

### 📘 Example

```luau
type Props = {
	transparency: number | react.Binding<number>,
}

local function TransparentFrame(props: Props)
	useBindingListener(props.transparency, function(value)
		print("Binding updated to", value)
	end)

	return react.createElement("Frame", {
		BackgroundTransparency = props.transparency,
	})
end
```
