local RunService = game:GetService("RunService")

local testez = require(script.Parent.Parent.utils.testez)
local useDeferEffect = require(script.Parent)

local renderHook = testez.renderHook

return function()
	local it, expect = testez.globals().it, testez.globals().expect

	local function wait()
		RunService.Heartbeat:Wait()
		RunService.Heartbeat:Wait()
	end

	it("should run the effect on the next heartbeat", function()
		local calls = 0

		local hook = renderHook(function()
			useDeferEffect(function()
				calls += 1
			end)
			return nil
		end)

		expect(calls).to.equal(0)

		wait()
		expect(calls).to.equal(1)

		wait()
		expect(calls).to.equal(1)

		hook.rerender()
		expect(calls).to.equal(1)

		wait()
		expect(calls).to.equal(2)

		hook.unmount()
	end)

	it("should run the effect on dependency change", function()
		local calls = 0

		local hook = renderHook(function(props: { value: number })
			useDeferEffect(function()
				calls += 1
			end, { props.value })
			return nil
		end, { initialProps = { value = 0 } })

		expect(calls).to.equal(0)

		wait()
		expect(calls).to.equal(1)

		hook.rerender({ value = 1 })
		expect(calls).to.equal(1)

		wait()
		expect(calls).to.equal(2)

		hook.unmount()
	end)

	it("should cancel the effect on unmount", function()
		local calls = 0

		local hook = renderHook(function()
			useDeferEffect(function()
				calls += 1
			end)
			return nil
		end)

		expect(calls).to.equal(0)

		wait()
		expect(calls).to.equal(1)

		hook.rerender()
		hook.unmount()

		wait()
		expect(calls).to.equal(1)
	end)
end
