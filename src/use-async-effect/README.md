## 🪝 `useAsyncEffect`

```luau
function useAsyncEffect(effect: Callback, deps: { any }): ()
```

Runs an async effect and cancels the promise when unmounting the effect or when
the dependencies change.

`effect` may be either:

-   A function that returns a `Promise` — called directly, the returned promise is tracked.
-   A plain (possibly yielding) function — wrapped with `Promise.try` so it may yield without blocking the render.

If you want to use the result or status of the callback, see [`useAsync`](../use-async).

> **Warning:**
> Cancelling a promise that yielded using `:await()` does not prevent the thread from resuming.
> Avoid pairing `:await()` with functions that update state, as it might resume after unmount:
>
> ```luau
> useAsyncEffect(function()
> 	return Promise.delay(5):andThen(function()
> 		setState("Hello World!") -- unsafe
> 	end)
> end, {})
> ```

### 📕 Parameters

-   `effect` - The async effect to run. Either a function returning a `Promise`, or a plain function that gets promisified via `Promise.try`.
-   `deps` - The dependencies to watch for changes.

### 📗 Returns

-   `()`

### 📘 Example

```luau
local function Countdown()
	local counter, setCounter = react.useState(0)

	useAsyncEffect(function()
		return setCountdown(function(countdown)
			setCounter(countdown)
		end, 10)
	end, {})

	return react.createElement("TextLabel", {
		Text = `Countdown: {counter}`,
	})
end
```
