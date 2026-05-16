## 🪝 `useEventListener`

```luau
function useEventListener(
	event: any?,
	listener: ((...any) -> ())?,
	options: { connected: boolean?, once: boolean? }?
): ()
```

Connects an event listener to the given event. The event can be any object with a `Connect`, `connect`, or `subscribe` method that returns a connection object or a cleanup function.

The event may also be a plain function. In that case, the hook calls it with the listener and expects it to return either a cleanup function or a connection object. Useful for subscribe-style APIs like Ripple's `motion.onComplete`.

If the event or the listener is `nil`, the previous listener will be disconnected.

The `listener` parameter is memoized for you, and will not cause a reconnect if it changes.

### ⚙️ Options

-   `connected` - Whether the listener should be connected. Defaults to `true`.
-   `once` - Whether the listener should be disconnected after the first time it is called. Defaults to `false`.

### 📕 Parameters

-   `event` - The event to listen to.
-   `listener` - The listener to call when the event fires.
-   `options` - Optional config for the listener.

### 📗 Returns

-   `nil`

### 📘 Example

```luau
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.Packages.React)
local hooks = require(ReplicatedStorage.Packages.PrettyReactHooks)

local useEventListener = hooks.useEventListener

local function PlayerJoined()
	useEventListener(Players.PlayerAdded, function(player)
		print(`{player.DisplayName} joined!`)
	end)

	return React.createElement("Frame")
end
```

### 📘 Example: function-style event (ReactRipple)

```luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.Packages.React)
local ReactRipple = require(ReplicatedStorage.Packages.ReactRipple)
local hooks = require(ReplicatedStorage.Packages.PrettyReactHooks)

local useEventListener = hooks.useEventListener

local function FadingLabel()
	local motion = ReactRipple.useMotion(0)

	useEventListener(motion.onComplete, function()
		print("motion finished")
	end)

	return React.createElement("TextLabel", {
		TextTransparency = motion:get(),
	})
end
```
