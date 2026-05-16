local react = require(script.Parent.Parent.React)
local useLatest = require(script.Parent["use-latest"])

export type EventListenerOptions = {
	--[[
		Whether the event should be connected or not. Defaults to `true`.
	]]
	connected: boolean?,
	--[[
		Whether the event should be disconnected after the first invocation.
		Defaults to `false`.
	]]
	once: boolean?,
}

type ConnectionLike = RBXScriptConnection | { Disconnect: () -> () } | { disconnect: () -> () } | () -> ()

type EventLike<T...> =
	RBXScriptSignal<T...>
	| { Connect: (callback: (T...) -> ()) -> ConnectionLike }
	| { connect: (callback: (T...) -> ()) -> ConnectionLike }
	| { subscribe: (callback: (T...) -> ()) -> ConnectionLike }
	| (callback: (T...) -> ()) -> ConnectionLike

local function connect<T...>(event: EventLike<T...>, callback: (T...) -> ()): ConnectionLike
	if typeof(event) == "RBXScriptSignal" then
		-- With deferred events, a "hard disconnect" is necessary to avoid
		-- causing state updates after a component unmounts. Use 'Connected' to
		-- check if the connection is still valid before invoking the callback.
		-- https://devforum.roblox.com/t/deferred-engine-events/2276564/99
		local connection
		connection = event:Connect(function(...)
			if connection.Connected then
				return callback(...)
			end
			return nil
		end)
		return connection
	elseif typeof(event) == "function" then
		return event(callback)
	elseif typeof(event) == "table" then
		if event.Connect then
			return event.Connect(callback)
		elseif event.connect then
			return event.connect(callback)
		elseif event.subscribe then
			return event.subscribe(callback)
		end
	end

	error("Event-like object does not have a supported connect method.")
end

local function disconnect(connection: ConnectionLike)
	if typeof(connection) == "function" then
		connection()
	elseif typeof(connection) == "RBXScriptConnection" then
		connection:Disconnect()
	elseif typeof(connection) == "table" then
		local connWithUpper = connection :: { Disconnect: () -> () }
		local connWithLower = connection :: { disconnect: () -> () }

		if connWithUpper.Disconnect then
			connWithUpper.Disconnect()
		elseif connWithLower.disconnect then
			connWithLower.disconnect()
		end
	else
		error("Connection-like object does not have a supported disconnect method.")
	end
end

--[[
	Subscribes to an event-like object. The subscription is automatically
	disconnected when the component unmounts.

	If the event or listener is `nil`, the event will not be subscribed to,
	and the subscription will be disconnected if it was previously connected.

	The listener is memoized, so it is safe to pass a callback that is recreated
	on every render.

	@param event The event-like object to subscribe to.
	@param listener The listener to subscribe with.
	@param options Options for the subscription.
]]
local function useEventListener<T...>(event: EventLike<T...>?, listener: ((T...) -> ())?, options: EventListenerOptions?): ()
	local resolvedOptions: EventListenerOptions = options or {}
	local once = resolvedOptions.once or false
	local connected = if resolvedOptions.connected == nil then true else resolvedOptions.connected

	local listenerRef = useLatest(listener)

	react.useEffect(function()
		if event == nil or listener == nil or not connected then
			return
		end

		local canDisconnect = true
		local connection
		connection = connect(event, function(...)
			if once then
				disconnect(connection)
				canDisconnect = false
			end

			if listenerRef.current then
				listenerRef.current(...)
			end
		end)

		return function()
			if canDisconnect then
				disconnect(connection)
			end
		end
	end, { event, connected, listener ~= nil } :: { any })
end

return useEventListener
