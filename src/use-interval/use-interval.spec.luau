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
			end, 0.1)
			return nil
		end)

		expect(count).to.equal(0)

		task.wait(0.13)
		expect(count).to.equal(1)

		task.wait(0.13)
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

	it("should fire immediately when immediate is true", function()
		local count = 0
		local hook = renderHook(function()
			useInterval(function()
				count += 1
			end, 0.2, { immediate = true })
			return nil
		end)

		expect(count).to.equal(1)
		hook.unmount()
	end)

	it("should not fire immediately when immediate is false", function()
		local count = 0
		local hook = renderHook(function()
			useInterval(function()
				count += 1
			end, 0.2)
			return nil
		end)

		expect(count).to.equal(0)
		hook.unmount()
	end)

	it("should be safe to call clear more than once", function()
		local count = 0
		local hook = renderHook(function()
			return useInterval(function()
				count += 1
			end, 0.06)
		end)

		hook.result.current()
		hook.result.current()
		hook.result.current()

		task.wait(0.08)
		expect(count).to.equal(0)
		hook.unmount()
	end)

	it("should call the latest callback after a rerender", function()
		local first, second = 0, 0
		local hook = renderHook(function(props: { callback: () -> () })
			useInterval(props.callback, 0.04)
			return nil
		end, { initialProps = {
			callback = function()
				first += 1
			end,
		} })

		hook.rerender({
			callback = function()
				second += 1
			end,
		})

		task.wait(0.06)
		expect(second >= 1).to.equal(true)
		expect(first).to.equal(0)
		hook.unmount()
	end)
end
