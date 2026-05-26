local react = require(script.Parent.Parent.Parent.React)
local testez = require(script.Parent.Parent.utils.testez)
local useBindingListener = require(script.Parent)

local renderHook = testez.renderHook

return function()
	local it, expect = testez.globals().it, testez.globals().expect

	it("should call listener on mount", function()
		local binding = react.createBinding(0)
		local result: number?

		renderHook(function(props: { listener: (value: number) -> () })
			useBindingListener(binding, props.listener)
			return nil
		end, { initialProps = {
			listener = function(value: number)
				result = value
			end,
		} })

		expect(result).to.equal(0)
	end)

	it("should call listener when the binding updates", function()
		local binding, setBinding = react.createBinding(0)
		local result: number?

		local hook = renderHook(function(props: { listener: (value: number) -> () })
			useBindingListener(binding, props.listener)
			return nil
		end, { initialProps = {
			listener = function(value: number)
				result = value
			end,
		} })

		expect(result).to.equal(0)

		setBinding(1)
		hook.rerender()
		expect(result).to.equal(1)
	end)

	it("should not call listener after unrelated rerender", function()
		local binding = react.createBinding(0)

		local hook = renderHook(function(props: { listener: (value: number) -> () })
			useBindingListener(binding, props.listener)
			return nil
		end, { initialProps = { listener = function() end } })

		hook.rerender({
			listener = function()
				error("listener was called when the binding did not update")
			end,
		})

		hook.rerender()
	end)

	it("should not call listener if the listener changes", function()
		local binding = react.createBinding(0)

		local hook = renderHook(function(props: { listener: (value: number) -> () })
			useBindingListener(binding, props.listener)
			return nil
		end, { initialProps = { listener = function() end } })

		hook.rerender({
			listener = function()
				error("listener was called when the listener changed")
			end,
		})

		hook.rerender()
	end)

	it("should call listener if the passed binding changes", function()
		local bindingA = react.createBinding(0)
		local bindingB = react.createBinding(1)
		local result: number?

		local hook = renderHook(function(props: { binding: typeof(bindingA) })
			useBindingListener(props.binding, function(value: number)
				result = value
			end)
			return nil
		end, { initialProps = { binding = bindingA } })

		expect(result).to.equal(0)

		hook.rerender({ binding = bindingB })
		expect(result).to.equal(1)
	end)

	it("should call listener if passed value changes", function()
		local result: number?

		local hook = renderHook(function(props: { value: number })
			useBindingListener(props.value, function(value: number)
				result = value
			end)
			return nil
		end, { initialProps = { value = 0 } })

		expect(result).to.equal(0)

		hook.rerender({ value = 1 })
		expect(result).to.equal(1)
	end)

	it("should stop reacting to the previous binding after the binding prop changes", function()
		local bindingA, setBindingA = react.createBinding(0)
		local bindingB = react.createBinding(99)
		local calls = 0

		local hook = renderHook(function(props: { binding: typeof(bindingA) })
			useBindingListener(props.binding, function()
				calls += 1
			end)
			return nil
		end, { initialProps = { binding = bindingA } })

		local baseline = calls

		hook.rerender({ binding = bindingB })
		local afterSwap = calls

		setBindingA(42)
		expect(calls).to.equal(afterSwap)

		hook.unmount()
		expect(baseline > 0).to.equal(true)
	end)

	it("should stop reacting to the binding after unmount", function()
		local binding, setBinding = react.createBinding(0)
		local calls = 0

		local hook = renderHook(function()
			useBindingListener(binding, function()
				calls += 1
			end)
			return nil
		end)

		hook.unmount()

		local afterUnmount = calls
		setBinding(7)
		expect(calls).to.equal(afterUnmount)
	end)

	it("should call the latest listener after a rerender", function()
		local binding, setBinding = react.createBinding(0)
		local first, second = 0, 0

		local hook = renderHook(function(props: { listener: (value: number) -> () })
			useBindingListener(binding, props.listener)
			return nil
		end, { initialProps = {
			listener = function()
				first += 1
			end,
		} })

		hook.rerender({
			listener = function()
				second += 1
			end,
		})

		setBinding(1)
		expect(second >= 1).to.equal(true)

		hook.unmount()
	end)
end
