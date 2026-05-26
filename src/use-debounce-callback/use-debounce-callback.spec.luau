local testez = require(script.Parent.Parent.utils.testez)
local useDebounceCallback = require(script.Parent)

local renderHook = testez.renderHook

return function()
	local it, expect = testez.globals().it, testez.globals().expect

	it("should return run, cancel, and flush", function()
		local count = 0
		local hook = renderHook(function()
			return useDebounceCallback(function(amount: number)
				count += amount
			end, { wait = 0.02 })
		end)

		hook.result.current.run(1)
		hook.result.current.run(1)
		hook.result.current.run(4)
		hook.result.current.run(2)
		expect(count).to.equal(0)

		task.wait(0.04)
		expect(count).to.equal(2)
		hook.result.current.run(4)
		expect(count).to.equal(2)

		task.wait(0.04)
		expect(count).to.equal(6)
		hook.result.current.run(4)
		expect(count).to.equal(6)
		hook.result.current.cancel()
		expect(count).to.equal(6)

		task.wait(0.04)
		expect(count).to.equal(6)
		hook.result.current.run(1)
		expect(count).to.equal(6)
		hook.result.current.flush()
		expect(count).to.equal(7)
		task.wait(0.04)
		expect(count).to.equal(7)

		hook.unmount()
	end)

	it("should invoke on the leading edge when leading is true", function()
		local count = 0
		local hook = renderHook(function()
			return useDebounceCallback(function()
				count += 1
			end, { wait = 0.04, leading = true })
		end)

		hook.result.current.run()
		expect(count).to.equal(1)

		hook.result.current.run()
		hook.result.current.run()
		expect(count).to.equal(1)

		task.wait(0.06)
		expect(count).to.equal(2)

		hook.unmount()
	end)

	it("should skip the trailing edge when trailing is false", function()
		local count = 0
		local hook = renderHook(function()
			return useDebounceCallback(function()
				count += 1
			end, { wait = 0.04, leading = true, trailing = false })
		end)

		hook.result.current.run()
		hook.result.current.run()
		hook.result.current.run()
		expect(count).to.equal(1)

		task.wait(0.06)
		expect(count).to.equal(1)

		hook.result.current.run()
		expect(count).to.equal(2)

		hook.unmount()
	end)

	it("should fire after maxWait even while calls keep coming in", function()
		local count = 0
		local hook = renderHook(function()
			return useDebounceCallback(function()
				count += 1
			end, { wait = 0.05, maxWait = 0.08 })
		end)

		local stopAt = os.clock() + 0.12
		while os.clock() < stopAt do
			hook.result.current.run()
			task.wait(0.01)
		end

		expect(count >= 1).to.equal(true)
		hook.unmount()
	end)

	it("should report pending state through pending()", function()
		local hook = renderHook(function()
			return useDebounceCallback(function() end, { wait = 0.04 })
		end)

		expect(hook.result.current.pending()).to.equal(false)
		hook.result.current.run()
		expect(hook.result.current.pending()).to.equal(true)

		hook.result.current.cancel()
		expect(hook.result.current.pending()).to.equal(false)

		hook.result.current.run()
		expect(hook.result.current.pending()).to.equal(true)
		task.wait(0.06)
		expect(hook.result.current.pending()).to.equal(false)

		hook.unmount()
	end)

	it("should pass the latest arguments to the callback", function()
		local received: number?
		local hook = renderHook(function()
			return useDebounceCallback(function(value: number)
				received = value
			end, { wait = 0.03 })
		end)

		hook.result.current.run(1)
		hook.result.current.run(2)
		hook.result.current.run(3)
		task.wait(0.05)
		expect(received).to.equal(3)

		hook.unmount()
	end)

	it("should call the latest callback reference", function()
		local count = 0
		local hook = renderHook(function(props: { callback: () -> () })
			return useDebounceCallback(props.callback, { wait = 0.03 })
		end, { initialProps = { callback = function() end } })

		hook.result.current.run()
		hook.rerender({
			callback = function()
				count += 1
			end,
		})

		task.wait(0.05)
		expect(count).to.equal(1)
		hook.unmount()
	end)

	it("should cancel pending invocations on unmount", function()
		local count = 0
		local hook = renderHook(function()
			return useDebounceCallback(function()
				count += 1
			end, { wait = 0.04 })
		end)

		hook.result.current.run()
		hook.unmount()

		task.wait(0.06)
		expect(count).to.equal(0)
	end)
end
