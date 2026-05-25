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
end
