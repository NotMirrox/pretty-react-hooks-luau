local testez = require(script.Parent.Parent.utils.testez)
local useDebounceEffect = require(script.Parent)

local renderHook = testez.renderHook
local act = testez.act

return function()
	local it, expect = testez.globals().it, testez.globals().expect

	it("should debounce the effect", function()
		local count = 0
		local hook = renderHook(function(props: { input: number })
			useDebounceEffect(function()
				count += 1
			end, { props.input }, { wait = 0.02 })
			return nil
		end, { initialProps = { input = 0 } })

		hook.rerender({ input = 0 })
		hook.rerender({ input = 1 })
		hook.rerender({ input = 0 })
		hook.rerender({ input = 1 })
		expect(count).to.equal(0)

		act(function()
			task.wait(0.04)
		end)
		expect(count).to.equal(1)
		hook.rerender({ input = 2 })
		expect(count).to.equal(1)

		act(function()
			task.wait(0.04)
		end)
		expect(count).to.equal(2)
		hook.rerender({ input = 2 })
		expect(count).to.equal(2)

		act(function()
			task.wait(0.04)
		end)
		expect(count).to.equal(2)
		hook.rerender({ input = 3 })
		expect(count).to.equal(2)
		hook.rerender({ input = 4 })
		expect(count).to.equal(2)

		act(function()
			task.wait(0.04)
		end)
		expect(count).to.equal(3)

		hook.unmount()
	end)

	it("should fire on the leading edge when leading is true", function()
		local count = 0
		local hook = renderHook(function(props: { input: number })
			useDebounceEffect(function()
				count += 1
			end, { props.input }, { wait = 0.04, leading = true, trailing = false })
			return nil
		end, { initialProps = { input = 0 } })

		expect(count).to.equal(1)

		hook.rerender({ input = 1 })
		hook.rerender({ input = 2 })
		expect(count).to.equal(1)

		act(function()
			task.wait(0.06)
		end)
		expect(count).to.equal(1)

		hook.rerender({ input = 3 })
		expect(count).to.equal(2)

		hook.unmount()
	end)

	it("should fire after maxWait even when deps keep changing", function()
		local count = 0
		local hook = renderHook(function(props: { input: number })
			useDebounceEffect(function()
				count += 1
			end, { props.input }, { wait = 0.05, maxWait = 0.08 })
			return nil
		end, { initialProps = { input = 0 } })

		for index = 1, 12 do
			hook.rerender({ input = index })
			act(function()
				task.wait(0.01)
			end)
		end

		expect(count >= 1).to.equal(true)
		hook.unmount()
	end)

	it("should cancel pending effect on unmount", function()
		local count = 0
		local hook = renderHook(function(props: { input: number })
			useDebounceEffect(function()
				count += 1
			end, { props.input }, { wait = 0.04 })
			return nil
		end, { initialProps = { input = 0 } })

		hook.rerender({ input = 1 })
		expect(count).to.equal(0)

		hook.unmount()
		act(function()
			task.wait(0.06)
		end)
		expect(count).to.equal(0)
	end)
end
