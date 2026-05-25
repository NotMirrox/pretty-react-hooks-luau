local testez = require(script.Parent.Parent.utils.testez)
local useTimer = require(script.Parent)

local renderHook = testez.renderHook

return function()
	local it, expect = testez.globals().it, testez.globals().expect

	it("should start the timer on mount", function()
		local hook = renderHook(function()
			return useTimer()
		end)

		expect(hook.result.current.value:getValue()).to.equal(0)

		local timePassed = task.wait(0.2)
		expect(hook.result.current.value:getValue()).to.be.near(timePassed, 0.08)

		hook.unmount()
	end)

	it("should return functions to start and stop the timer", function()
		local hook = renderHook(function()
			return useTimer()
		end)

		expect(hook.result.current.value:getValue()).to.equal(0)

		local timePassed = task.wait(0.2)
		local timerValue = hook.result.current.value:getValue()
		expect(timerValue).to.be.near(timePassed, 0.08)

		hook.result.current.stop()

		task.wait(0.2)
		expect(hook.result.current.value:getValue()).to.equal(timerValue)

		hook.result.current.start()

		local timePassedAfterStart = task.wait(0.2)
		expect(hook.result.current.value:getValue()).to.be.near(timePassed + timePassedAfterStart, 0.08)

		hook.unmount()
	end)

	it("should return a function to set the timer", function()
		local hook = renderHook(function()
			return useTimer()
		end)

		expect(hook.result.current.value:getValue()).to.equal(0)

		local timePassed = task.wait(0.2)
		expect(hook.result.current.value:getValue()).to.be.near(timePassed, 0.08)

		hook.result.current.reset()
		expect(hook.result.current.value:getValue()).to.equal(0)

		hook.result.current.set(1)
		expect(hook.result.current.value:getValue()).to.equal(1)

		local timePassedAfterSet = task.wait(0.2)
		expect(hook.result.current.value:getValue()).to.be.near(timePassedAfterSet + 1, 0.08)

		hook.unmount()
	end)
end
