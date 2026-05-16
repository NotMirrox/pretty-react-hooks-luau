local testez = require(script.Parent.Parent.utils.testez)
local usePrevious = require(script.Parent)

local renderHook = testez.renderHook

return function()
	local it, expect = testez.globals().it, testez.globals().expect

	it("should return nil on the first render", function()
		local hook = renderHook(function()
			return usePrevious(0)
		end).result

		expect(hook.current).to.equal(nil)
	end)

	it("should return the previous value on rerender", function()
		local hook = renderHook(function(props: { state: number })
			return usePrevious(props.state)
		end, { initialProps = { state = 0 } })

		expect(hook.result.current).to.equal(nil)

		hook.rerender({ state = 1 })
		expect(hook.result.current).to.equal(0)

		hook.rerender({ state = 2 })
		expect(hook.result.current).to.equal(1)

		hook.rerender({ state = 3 })
		expect(hook.result.current).to.equal(2)
	end)

	it("should return the correct value despite being nil", function()
		local hook = renderHook(function(props: { state: number? })
			return usePrevious(props.state)
		end, { initialProps = { state = nil } })

		expect(hook.result.current).to.equal(nil)

		hook.rerender({ state = nil })
		expect(hook.result.current).to.equal(nil)

		hook.rerender({ state = 0 })
		expect(hook.result.current).to.equal(nil)

		hook.rerender({ state = nil })
		expect(hook.result.current).to.equal(0)
	end)

	it("should not return passed value after unrelated rerender", function()
		local hook = renderHook(function(props: { state: number })
			return usePrevious(props.state)
		end, { initialProps = { state = 0 } })

		expect(hook.result.current).to.equal(nil)
		hook.rerender()

		expect(hook.result.current).never.to.equal(0)
		expect(hook.result.current).to.equal(nil)
	end)

	it("should receive a function that determines whether the value should be updated", function()
		type Value = { value: number }
		local value0: Value = { value = 0 }
		local value1: Value = { value = 1 }
		local value2: Value = { value = 2 }

		local hook = renderHook(function(props: { state: Value })
			return usePrevious(props.state, function(a, b)
				return a ~= nil and a.value == b.value
			end)
		end, { initialProps = { state = value0 } })

		expect(hook.result.current).to.equal(nil)

		hook.rerender({ state = { value = value0.value } })
		expect(hook.result.current).to.equal(nil)

		hook.rerender({ state = value1 })
		expect(hook.result.current).to.equal(value0)

		hook.rerender({ state = value2 })
		expect(hook.result.current).to.equal(value1)

		hook.rerender({ state = value1 })
		expect(hook.result.current).to.equal(value2)
	end)
end
