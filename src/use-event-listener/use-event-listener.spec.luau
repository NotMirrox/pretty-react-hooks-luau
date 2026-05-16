local testez = require(script.Parent.Parent.utils.testez)
local useEventListener = require(script.Parent)

local renderHook = testez.renderHook

local function createSignal<T...>()
	local listenerSet: { [(T...) -> ()]: boolean } = {}
	local signal = {}

	function signal.listeners()
		return listenerSet
	end

	function signal.connect(listener: (T...) -> ())
		listenerSet[listener] = true

		return function()
			listenerSet[listener] = nil
		end
	end

	function signal.fire(...: T...)
		for listener in listenerSet do
			listener(...)
		end
	end

	return signal
end

local function countListeners(signal)
	local count = 0
	for _ in signal.listeners() do
		count += 1
	end

	return count
end

local function createFunctionEvent<T...>()
	local listenerSet: { [(T...) -> ()]: boolean } = {}

	local function event(listener: (T...) -> ())
		listenerSet[listener] = true
		return function()
			listenerSet[listener] = nil
		end
	end

	local function fire(...: T...)
		for listener in listenerSet do
			listener(...)
		end
	end

	local function listeners()
		return listenerSet
	end

	return event, fire, listeners
end

return function()
	local it, expect = testez.globals().it, testez.globals().expect

	it("should connect on mount", function()
		local signal = createSignal()

		local hook = renderHook(function()
			useEventListener(signal, function() end)
			return nil
		end)

		expect(countListeners(signal)).to.equal(1)
		hook.unmount()
	end)

	it("should disconnect on unmount", function()
		local signal = createSignal()
		local hook = renderHook(function()
			useEventListener(signal, function() end)
			return nil
		end)

		hook.unmount()
		expect(countListeners(signal)).to.equal(0)
	end)

	it("should clean up old connections", function()
		local signalA = createSignal()
		local signalB = createSignal()
		local hook = renderHook(function(props: { signal: typeof(signalA) })
			useEventListener(props.signal, function() end)
			return nil
		end, { initialProps = { signal = signalA } })

		hook.rerender({ signal = signalB })
		expect(countListeners(signalA)).to.equal(0)
		expect(countListeners(signalB)).to.equal(1)

		hook.rerender({ signal = signalA })
		expect(countListeners(signalA)).to.equal(1)
		expect(countListeners(signalB)).to.equal(0)

		hook.unmount()
		expect(countListeners(signalA)).to.equal(0)
		expect(countListeners(signalB)).to.equal(0)
	end)

	it("should call listener on event", function()
		local signal = createSignal()
		local result: number?

		local hook = renderHook(function()
			useEventListener(signal, function(value)
				result = value
			end)
			return nil
		end)

		signal.fire(0)
		expect(result).to.equal(0)

		signal.fire(1)
		expect(result).to.equal(1)

		hook.unmount()
	end)

	it("should receive a 'once' option", function()
		local signal = createSignal()
		local calls = 0

		local hook = renderHook(function()
			useEventListener(signal, function()
				calls += 1
			end, { once = true })
			return nil
		end)

		signal.fire()
		hook.rerender()
		signal.fire()
		hook.rerender()
		signal.fire()
		expect(calls).to.equal(1)
		hook.unmount()
	end)

	it("should accept an event as a function returning a cleanup", function()
		local event, fire, listeners = createFunctionEvent()
		local result: number?

		local hook = renderHook(function()
			useEventListener(event, function(value)
				result = value
			end)
			return nil
		end)

		local function countFunctionListeners()
			local count = 0
			for _ in listeners() do
				count += 1
			end

			return count
		end

		expect(countFunctionListeners()).to.equal(1)

		fire(7)
		expect(result).to.equal(7)

		hook.unmount()
		expect(countFunctionListeners()).to.equal(0)
	end)

	it("should disconnect a function event with the 'once' option", function()
		local event, fire, listeners = createFunctionEvent()
		local calls = 0

		local hook = renderHook(function()
			useEventListener(event, function()
				calls += 1
			end, { once = true })
			return nil
		end)

		local function countFunctionListeners()
			local count = 0
			for _ in listeners() do
				count += 1
			end

			return count
		end

		fire()
		expect(calls).to.equal(1)
		expect(countFunctionListeners()).to.equal(0)

		fire()
		expect(calls).to.equal(1)

		hook.unmount()
	end)

	it("should receive a 'connected' option", function()
		local signal = createSignal()
		local calls = 0

		local hook = renderHook(function(props: { connected: boolean })
			useEventListener(signal, function()
				calls += 1
			end, { connected = props.connected })
			return nil
		end, { initialProps = { connected = true } })

		signal.fire()
		hook.rerender({ connected = false })
		signal.fire()
		hook.rerender({ connected = true })
		signal.fire()
		expect(calls).to.equal(2)
		hook.unmount()
	end)
end
