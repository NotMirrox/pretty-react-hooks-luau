local testez = require(script.Parent.Parent.utils.testez)
local useUpdateEffect = require(script.Parent)

local renderHook = testez.renderHook

return function()
	local it, expect = testez.globals().it, testez.globals().expect

	it("should call effect on update only", function()
		local renders = 0

		local hook = renderHook(function()
			useUpdateEffect(function()
				renders += 1
				return nil
			end)

			return nil
		end)

		expect(renders).to.equal(0)

		hook.rerender()
		expect(renders).to.equal(1)
	end)

	it("should call effect with dependencies", function()
		local renders = 0

		local hook = renderHook(function(value: string?)
			useUpdateEffect(function()
				renders += 1
				return nil
			end, { value })

			return nil
		end)

		expect(renders).to.equal(0)

		hook.rerender("test")
		expect(renders).to.equal(1)

		hook.rerender("test")
		expect(renders).to.equal(1)

		hook.rerender("test2")
		expect(renders).to.equal(2)
	end)

	it("should run cleanup before the next effect invocation", function()
		local cleanups = 0
		local effects = 0

		local hook = renderHook(function(props: { value: number })
			useUpdateEffect(function()
				effects += 1
				return function()
					cleanups += 1
				end
			end, { props.value })
			return nil
		end, { initialProps = { value = 0 } })

		expect(effects).to.equal(0)
		expect(cleanups).to.equal(0)

		hook.rerender({ value = 1 })
		expect(effects).to.equal(1)
		expect(cleanups).to.equal(0)

		hook.rerender({ value = 2 })
		expect(effects).to.equal(2)
		expect(cleanups).to.equal(1)

		hook.unmount()
		expect(cleanups).to.equal(2)
	end)

	it("should run on every update when deps are omitted", function()
		local effects = 0

		local hook = renderHook(function()
			useUpdateEffect(function()
				effects += 1
				return nil
			end)
			return nil
		end)

		expect(effects).to.equal(0)

		hook.rerender()
		hook.rerender()
		hook.rerender()
		expect(effects).to.equal(3)

		hook.unmount()
	end)

	it("should not invoke the cleanup if the effect did not run", function()
		local cleanups = 0

		local hook = renderHook(function()
			useUpdateEffect(function()
				return function()
					cleanups += 1
				end
			end, {})
			return nil
		end)

		hook.unmount()
		expect(cleanups).to.equal(0)
	end)
end
