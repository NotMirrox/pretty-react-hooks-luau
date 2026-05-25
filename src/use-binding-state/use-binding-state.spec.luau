local react = require(script.Parent.Parent.Parent.React)
local testez = require(script.Parent.Parent.utils.testez)
local useBindingState = require(script.Parent)

local renderHook = testez.renderHook

return function()
	local it, expect = testez.globals().it, testez.globals().expect

	it("should return the current value", function()
		local bindingValue = react.createBinding(0)
		local hook = renderHook(function()
			return useBindingState(bindingValue)
		end).result

		expect(hook.current).to.equal(0)
	end)

	it("should update the value when the binding updates", function()
		local bindingValue, setBinding = react.createBinding(0)
		local hook = renderHook(function()
			return useBindingState(bindingValue)
		end)

		expect(hook.result.current).to.equal(0)

		setBinding(1)
		hook.rerender()
		expect(hook.result.current).to.equal(1)
	end)

	it("should not update the value after unrelated rerender", function()
		local bindingValue = react.createBinding(0)
		local hook = renderHook(function()
			return useBindingState(bindingValue)
		end)

		expect(hook.result.current).to.equal(0)
		hook.rerender()
		expect(hook.result.current).to.equal(0)
	end)

	it("should update the value if the binding changes", function()
		local bindingA = react.createBinding(0)
		local bindingB = react.createBinding(1)

		local hook = renderHook(function(props: { binding: typeof(bindingA) })
			return useBindingState(props.binding)
		end, { initialProps = { binding = bindingA } })

		expect(hook.result.current).to.equal(0)

		hook.rerender({ binding = bindingB })
		expect(hook.result.current).to.equal(1)
	end)
end
