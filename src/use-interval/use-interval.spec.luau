local testez = require(script.Parent.Parent.utils.testez)
local useInterval = require(script.Parent)

local renderHook = testez.renderHook

return function()
	local it, expect = testez.globals().it, testez.globals().expect

	it("should run the callback after the delay", function()
		local count = 0
		local hook = renderHook(function()
			useInterval(function()
				count += 1
			end, 0.03)
			return nil
		end)

		expect(count).to.equal(0)

		task.wait(0.04)
		expect(count).to.equal(1)

		task.wait(0.04)
		expect(count).to.equal(2)
		hook.unmount()
	end)

	it("should clear when delay is undefined", function()
		local count = 0
		local hook = renderHook(function(props: { delay: number? })
			useInterval(function()
				count += 1
			end, props.delay)
			return nil
		end, { initialProps = { delay = 0.06 :: number? } })

		expect(count).to.equal(0)

		task.wait(0.02)
		expect(count).to.equal(0)
		hook.rerender({ delay = nil })

		task.wait(0.08)
		expect(count).to.equal(0)
		hook.unmount()
	end)

	it("should clear on unmount", function()
		local count = 0
		local hook = renderHook(function()
			useInterval(function()
				count += 1
			end, 0.06)
			return nil
		end)

		expect(count).to.equal(0)

		task.wait(0.02)
		expect(count).to.equal(0)
		hook.unmount()

		task.wait(0.08)
		expect(count).to.equal(0)
	end)

	it("should reset when delay updates", function()
		local count = 0
		local hook = renderHook(function(props: { delay: number? })
			useInterval(function()
				count += 1
			end, props.delay)
			return nil
		end, { initialProps = { delay = 0.06 :: number? } })

		expect(count).to.equal(0)

		task.wait(0.02)
		expect(count).to.equal(0)
		hook.rerender({ delay = 0.05 })

		task.wait(0.02)
		expect(count).to.equal(0)

		task.wait(0.04)
		expect(count).to.equal(1)
		hook.unmount()
	end)

	it("should return a clear function", function()
		local count = 0
		local hook = renderHook(function()
			return useInterval(function()
				count += 1
			end, 0.06)
		end)

		expect(count).to.equal(0)

		task.wait(0.02)
		expect(count).to.equal(0)
		hook.result.current()

		task.wait(0.08)
		expect(count).to.equal(0)
		hook.unmount()
	end)
end
