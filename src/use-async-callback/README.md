## 🪝 `useAsyncCallback`

```luau
function useAsyncCallback<T, U...>(callback: AsyncCallback<T, U...>): (AsyncState<T>, AsyncCallback<T, U...>)
```

A hook that wraps an async function and returns the current state and an executor.

Calling the executor will cancel any pending promises and start a new one.

If you want the callback to run on mount or with dependencies, see [`useAsync`](../use-async).

> **Warning:**
> Cancelling a promise that yielded using `:await()` does not prevent the thread from resuming.
> Avoid pairing `:await()` with functions that update state, as it might resume after unmount:
>
> ```luau
> useAsyncCallback(function()
> 	return Promise.delay(5):andThen(function()
> 		setState("Hello World!") -- unsafe
> 	end)
> end)
> ```

### 📕 Parameters

-   `callback` - The async function to call.

### 📗 Returns

-   The current state of the async function.
    -   `status` - The status of the last promise.
    -   `value` - The value if the promise resolved.
    -   `message` - The error message if the promise rejected.
-   A function that calls the async function.

### 📘 Example

```luau
local function GetBaseplate()
	local state, getBaseplate = useAsyncCallback(function()
		return Promise.new(function(resolve)
			resolve(Workspace:WaitForChild("Baseplate"))
		end)
	end)

	react.useEffect(function()
		print("Baseplate", state.status, state.value)
	end, { state })

	return react.createElement("TextButton", {
		Text = `Baseplate status: {state.status}`,
		[react.Event.Activated] = function()
			getBaseplate()
		end,
	})
end
```
