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

	it("should respect the provided initial value", function()
		local hook = renderHook(function()
			return useTimer(5)
		end)

		expect(hook.result.current.value:getValue()).to.be.near(5, 0.05)

		local timePassed = task.wait(0.15)
		expect(hook.result.current.value:getValue()).to.be.near(5 + timePassed, 0.08)

		hook.unmount()
	end)

	it("should stop accumulating after unmount", function()
		local hook = renderHook(function()
			return useTimer()
		end)

		task.wait(0.1)
		local before = hook.result.current.value:getValue()
		hook.unmount()

		task.wait(0.1)
		expect(hook.result.current.value:getValue()).to.equal(before)
	end)

	it("should ignore extra start calls while already running", function()
		local hook = renderHook(function()
			return useTimer()
		end)

		hook.result.current.start()
		hook.result.current.start()
		hook.result.current.start()

		local timePassed = task.wait(0.15)
		expect(hook.result.current.value:getValue()).to.be.near(timePassed, 0.08)

		hook.unmount()
	end)

	it("should ignore extra stop calls while already stopped", function()
		local hook = renderHook(function()
			return useTimer()
		end)

		hook.result.current.stop()
		hook.result.current.stop()

		task.wait(0.1)
		expect(hook.result.current.value:getValue()).to.equal(0)

		hook.unmount()
	end)
end
