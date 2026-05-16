## 🪝 `useComposedRef`

```luau
function useComposedRef<T>(...: ((rbx: T?) -> ())?): (rbx: T?) -> ()
```

Combines multiple ref functions into a single ref function and memoizes the result.

To prevent excess ref calls, the composed ref is only created once on mount. It will call the latest refs passed, though, so it is safe to pass in refs that might change.

### 📕 Parameters

-   `...` - The ref functions to compose. `nil` entries are skipped.

### 📗 Returns

-   A ref function that calls all of the given ref functions.

### 📘 Example

```luau
type Props = {
	frameRef: ((rbx: Frame?) -> ())?,
}
local function DraggableFrame(props: Props)
	local frame, setFrame = react.useState(nil :: Frame?)
	local composedRef = useComposedRef(props.frameRef, setFrame)

	react.useEffect(function()
		if frame == nil then
			return
		end

		local handle = makeDraggable(frame)

		return function()
			handle:Disconnect()
		end
	end, { frame })

	return react.createElement("Frame", {
		ref = composedRef,
	})
end
```
