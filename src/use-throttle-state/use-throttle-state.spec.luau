local testez = require(script.Parent.Parent.utils.testez)
local useThrottleState = require(script.Parent)

local renderHook = testez.renderHook

return function()
	local it, expect = testez.globals().it, testez.globals().expect

	it("should throttle the state", function()
		local hook = renderHook(function()
			local state, setState = useThrottleState(0, { wait = 0.06 })
			return { state = state, setState = setState }
		end)

		hook.result.current.setState(1)
		expect(hook.result.current.state).to.equal(1)
		hook.result.current.setState(1)
		hook.result.current.setState(1)
		hook.result.current.setState(1)
		expect(hook.result.current.state).to.equal(1)

		task.wait(0.04)
		hook.result.current.setState(2)
		expect(hook.result.current.state).to.equal(1)

		task.wait(0.03)
		hook.result.current.setState(2)
		expect(hook.result.current.state).to.equal(2)
		hook.result.current.setState(3)
		hook.result.current.setState(3)

		task.wait(0.065)
		expect(hook.result.current.state).to.equal(3)

		hook.unmount()
	end)
end
