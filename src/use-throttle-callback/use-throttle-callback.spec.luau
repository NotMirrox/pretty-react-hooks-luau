local testez = require(script.Parent.Parent.utils.testez)
local useThrottleCallback = require(script.Parent)

local renderHook = testez.renderHook

return function()
	local it, expect = testez.globals().it, testez.globals().expect

	it("should return run, cancel, and flush", function()
		local count = 0
		local hook = renderHook(function()
			return useThrottleCallback(function(amount: number)
				count += amount
			end, { wait = 0.06 })
		end)

		hook.result.current.run(1)
		expect(count).to.equal(1)
		hook.result.current.run(1)
		hook.result.current.run(1)
		hook.result.current.run(1)
		expect(count).to.equal(1)

		task.wait(0.04)
		hook.result.current.run(2)
		expect(count).to.equal(1)

		task.wait(0.03)
		hook.result.current.run(2)
		expect(count).to.equal(3)
		hook.result.current.run(3)
		hook.result.current.run(3)

		task.wait(0.07)
		expect(count).to.equal(6)
		hook.result.current.run(1)
		hook.result.current.run(4)
		hook.result.current.cancel()

		task.wait(0.07)
		expect(count).to.equal(7)
		hook.result.current.run(1)
		hook.result.current.run(1)
		expect(count).to.equal(8)
		hook.result.current.flush()
		expect(count).to.equal(9)

		task.wait(0.07)
		expect(count).to.equal(9)

		hook.unmount()
	end)

	it("should skip the leading edge when leading is false", function()
		local count = 0
		local hook = renderHook(function()
			return useThrottleCallback(function()
				count += 1
			end, { wait = 0.05, leading = false })
		end)

		hook.result.current.run()
		expect(count).to.equal(0)

		task.wait(0.07)
		expect(count).to.equal(1)

		hook.unmount()
	end)

	it("should skip the trailing edge when trailing is false", function()
		local count = 0
		local hook = renderHook(function()
			return useThrottleCallback(function()
				count += 1
			end, { wait = 0.05, trailing = false })
		end)

		hook.result.current.run()
		expect(count).to.equal(1)
		hook.result.current.run()
		hook.result.current.run()
		expect(count).to.equal(1)

		task.wait(0.07)
		expect(count).to.equal(1)

		hook.result.current.run()
		expect(count).to.equal(2)

		hook.unmount()
	end)

	it("should report pending state through pending()", function()
		local hook = renderHook(function()
			return useThrottleCallback(function() end, { wait = 0.05 })
		end)

		expect(hook.result.current.pending()).to.equal(false)
		hook.result.current.run()
		expect(hook.result.current.pending()).to.equal(true)

		task.wait(0.07)
		expect(hook.result.current.pending()).to.equal(false)

		hook.unmount()
	end)

	it("should pass the latest arguments to the callback", function()
		local received: number?
		local hook = renderHook(function()
			return useThrottleCallback(function(value: number)
				received = value
			end, { wait = 0.05 })
		end)

		hook.result.current.run(1)
		hook.result.current.run(2)
		hook.result.current.run(3)
		expect(received).to.equal(1)

		task.wait(0.07)
		expect(received).to.equal(3)

		hook.unmount()
	end)

	it("should call the latest callback reference", function()
		local count = 0
		local hook = renderHook(function(props: { callback: () -> () })
			return useThrottleCallback(props.callback, { wait = 0.05 })
		end, { initialProps = { callback = function() end } })

		hook.rerender({
			callback = function()
				count += 1
			end,
		})

		hook.result.current.run()
		expect(count).to.equal(1)

		hook.unmount()
	end)

	it("should cancel pending invocations on unmount", function()
		local count = 0
		local hook = renderHook(function()
			return useThrottleCallback(function()
				count += 1
			end, { wait = 0.05 })
		end)

		hook.result.current.run()
		hook.result.current.run()
		expect(count).to.equal(1)
		hook.unmount()

		task.wait(0.07)
		expect(count).to.equal(1)
	end)
end
