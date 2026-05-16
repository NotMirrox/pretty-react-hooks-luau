local testez = require(script.Parent.Parent.utils.testez)
local useLatest = require(script.Parent)

local renderHook = testez.renderHook

return function()
	local it, expect = testez.globals().it, testez.globals().expect

	it("should return a mutable ref", function()
		local result = renderHook(function()
			return useLatest(0)
		end).result

		expect(result.current.current).to.equal(0)
	end)

	it("should update the ref when the value changes", function()
		local hook = renderHook(function(props: { value: number })
			return useLatest(props.value)
		end, { initialProps = { value = 0 } })

		expect(hook.result.current.current).to.equal(0)

		hook.rerender({ value = 1 })
		expect(hook.result.current.current).to.equal(1)
	end)

	it("should receive a function that determines whether the value should be updated", function()
		type Value = { value: number }
		local value0: Value = { value = 0 }
		local value1: Value = { value = 0 }
		local value2: Value = { value = 1 }

		local hook = renderHook(function(props: { state: Value })
			return useLatest(props.state, function(a, b)
				return a ~= nil and a.value == b.value
			end)
		end, { initialProps = { state = value0 } })

		expect(hook.result.current.current).to.equal(value0)

		hook.rerender({ state = value1 })
		expect(hook.result.current.current).to.equal(value0)

		hook.rerender({ state = value2 })
		expect(hook.result.current.current).to.equal(value2)
	end)
end
