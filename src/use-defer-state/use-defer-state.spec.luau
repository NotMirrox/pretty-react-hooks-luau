local RunService = game:GetService("RunService")

local testez = require(script.Parent.Parent.utils.testez)
local useDeferState = require(script.Parent)

local renderHook = testez.renderHook

return function()
	local it, expect = testez.globals().it, testez.globals().expect

	local function wait()
		RunService.Heartbeat:Wait()
		RunService.Heartbeat:Wait()
	end

	it("should return the state and a setter", function()
		local hook = renderHook(function()
			local state, setState = useDeferState(0)
			return { state = state, setState = setState }
		end)

		expect(hook.result.current.state).to.equal(0)
		expect(hook.result.current.setState).to.be.a("function")

		hook.unmount()
	end)

	it("should update the state on heartbeat", function()
		local hook = renderHook(function()
			local state, setState = useDeferState(0)
			return { state = state, setState = setState }
		end)

		hook.result.current.setState(1)
		expect(hook.result.current.state).to.equal(0)

		wait()
		expect(hook.result.current.state).to.equal(1)

		hook.unmount()
	end)

	it("should only update the state once per frame", function()
		local hook = renderHook(function()
			local state, setState = useDeferState(0)
			return { state = state, setState = setState }
		end)

		hook.result.current.setState(1)
		hook.result.current.setState(2)
		hook.result.current.setState(3)
		expect(hook.result.current.state).to.equal(0)

		wait()
		expect(hook.result.current.state).to.equal(3)

		hook.unmount()
	end)

	it("should receive a function to update state", function()
		local hook = renderHook(function()
			local state, setState = useDeferState(0)
			return { state = state, setState = setState }
		end)

		hook.result.current.setState(function(state)
			return state + 1
		end)
		hook.result.current.setState(function(state)
			return state + 1
		end)
		hook.result.current.setState(function(state)
			return state + 1
		end)
		expect(hook.result.current.state).to.equal(0)

		wait()
		expect(hook.result.current.state).to.equal(3)

		hook.unmount()
	end)

	it("should only rerender once per frame", function()
		local renderCount = 0

		local hook = renderHook(function()
			local state, setState = useDeferState(0)
			renderCount += 1
			return { state = state, setState = setState }
		end)

		expect(renderCount).to.equal(1)

		hook.result.current.setState(function(state)
			return state + 1
		end)
		hook.result.current.setState(function(state)
			return state + 1
		end)
		hook.result.current.setState(function(state)
			return state + 1
		end)
		expect(renderCount).to.equal(1)

		wait()
		expect(renderCount).to.equal(2)

		hook.unmount()
	end)

	it("should cancel the update on unmount", function()
		local hook = renderHook(function()
			local state, setState = useDeferState(0)
			return { state = state, setState = setState }
		end)

		hook.result.current.setState(1)
		expect(hook.result.current.state).to.equal(0)

		hook.unmount()
		wait()
		expect(hook.result.current.state).to.equal(0)
	end)
end
