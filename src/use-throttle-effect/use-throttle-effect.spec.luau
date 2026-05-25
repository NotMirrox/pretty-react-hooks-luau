local testez = require(script.Parent.Parent.utils.testez)
local useThrottleEffect = require(script.Parent)

local renderHook = testez.renderHook
local act = testez.act

return function()
	local it, expect = testez.globals().it, testez.globals().expect

	it("should throttle the effect", function()
		local count = 0
		local hook = renderHook(function(props: { input: number })
			useThrottleEffect(function()
				count += 1
			end, { props.input }, { wait = 0.06 })
			return nil
		end, { initialProps = { input = 0 } })

		hook.rerender({ input = 1 })
		expect(count).to.equal(1)
		hook.rerender({ input = 1 })
		hook.rerender({ input = 1 })
		hook.rerender({ input = 1 })
		expect(count).to.equal(1)

		act(function()
			task.wait(0.04)
		end)
		hook.rerender({ input = 2 })
		expect(count).to.equal(1)

		act(function()
			task.wait(0.03)
		end)
		hook.rerender({ input = 2 })
		expect(count).to.equal(2)
		hook.rerender({ input = 3 })
		hook.rerender({ input = 3 })

		act(function()
			task.wait(0.065)
		end)
		expect(count).to.equal(3)

		hook.unmount()
	end)
end
