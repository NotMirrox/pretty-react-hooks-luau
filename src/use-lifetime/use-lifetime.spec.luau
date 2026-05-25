local testez = require(script.Parent.Parent.utils.testez)
local useLifetime = require(script.Parent)

local renderHook = testez.renderHook

return function()
	local it, expect = testez.globals().it, testez.globals().expect

	it("should return the lifetime of the component", function()
		local hook = renderHook(function()
			return useLifetime()
		end)

		expect(hook.result.current:getValue()).to.equal(0)

		local timePassed = task.wait(0.1)
		expect(hook.result.current:getValue()).to.be.near(timePassed, 0.05)

		hook.unmount()
	end)

	it("should reset when dependencies change", function()
		local hook = renderHook(function(props: { value: number })
			return useLifetime({ props.value })
		end, { initialProps = { value = 0 } })

		expect(hook.result.current:getValue()).to.equal(0)

		local timePassed = task.wait(0.1)
		hook.rerender({ value = 0 })
		expect(hook.result.current:getValue()).to.be.near(timePassed, 0.05)

		hook.rerender({ value = 1 })
		expect(hook.result.current:getValue()).to.equal(0)

		hook.unmount()
	end)
end
