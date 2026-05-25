local testez = require(script.Parent.Parent.utils.testez)
local useDebounceState = require(script.Parent)

local renderHook = testez.renderHook

return function()
	local it, expect = testez.globals().it, testez.globals().expect

	it("should debounce the state", function()
		local hook = renderHook(function()
			local state, setState = useDebounceState(0, { wait = 0.02 })
			return { state = state, setState = setState }
		end)

		expect(hook.result.current.state).to.equal(0)
		hook.result.current.setState(0)
		hook.result.current.setState(1)
		hook.result.current.setState(0)
		hook.result.current.setState(1)
		expect(hook.result.current.state).to.equal(0)

		task.wait(0.04)
		expect(hook.result.current.state).to.equal(1)
		hook.result.current.setState(2)
		expect(hook.result.current.state).to.equal(1)

		task.wait(0.04)
		expect(hook.result.current.state).to.equal(2)
		hook.result.current.setState(2)
		expect(hook.result.current.state).to.equal(2)

		task.wait(0.04)
		expect(hook.result.current.state).to.equal(2)
		hook.result.current.setState(3)
		expect(hook.result.current.state).to.equal(2)
		hook.result.current.setState(4)
		expect(hook.result.current.state).to.equal(2)

		task.wait(0.04)
		expect(hook.result.current.state).to.equal(4)

		hook.unmount()
	end)
end
