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
end
