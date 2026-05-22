## 🪝 `useAsync`

```luau
function useAsync<T>(
	callback: (() -> T) | (() -> Promise<T>),
	deps: { any }?
): (T?, Promise.Status, any?)
```

A hook that runs an async function and returns the result and status. Similar to [`useAsyncCallback`](../use-async-callback), but the callback is run on mount and whenever the dependencies change.

Changing the dependencies will cancel any pending promises and start a new one.

> **Warning:**
> Cancelling a promise that yielded using `:await()` does not prevent the thread from resuming.
> Avoid pairing `:await()` with functions that update state, as it might resume after unmount:
>
> ```luau
> useAsync(function()
> 	return Promise.delay(5):andThen(function()
> 		setState("Hello World!") -- unsafe
> 	end)
> end)
> ```

### 📕 Parameters

-   `callback` - The async function to run. Either a function returning a `Promise`, or a plain function that gets promisified via `Promise.try`.
-   `deps` - The dependencies to watch for changes. Defaults to an empty array.

### 📗 Returns

-   The result if the promise resolved.
-   The status of the promise.
-   The error message if the promise rejected or cancelled.

### 📘 Example

```luau
local function BaseplatePortal(props: { children: react.ReactNode })
	local baseplate = useAsync(function()
		return Promise.new(function(resolve)
			resolve(Workspace:WaitForChild("Baseplate"))
		end)
	end)

	if not baseplate then
		return nil
	end

	return ReactRoblox.createPortal(props.children, baseplate)
end
```
