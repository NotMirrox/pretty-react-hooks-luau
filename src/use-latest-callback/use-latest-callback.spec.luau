local testez = require(script.Parent.Parent.utils.testez)
local useLatestCallback = require(script.Parent)

local renderHook = testez.renderHook

return function()
	local it, expect = testez.globals().it, testez.globals().expect

	it("should memoize the callback on mount", function()
		local callback = function() end
		local result = renderHook(function()
			return useLatestCallback(callback)
		end).result

		expect(result.current).to.be.a("function")
		expect(result.current).never.to.equal(callback)
	end)

	it("should return memoized callback after unrelated rerender", function()
		local hook = renderHook(function()
			return useLatestCallback(function() end)
		end)
		local memoizedCallback = hook.result.current

		hook.rerender()
		expect(hook.result.current).to.equal(memoizedCallback)
	end)

	it("should return memoized callback after passed callback changes", function()
		local hook = renderHook(function(props: { callback: () -> () })
			return useLatestCallback(props.callback)
		end, { initialProps = { callback = function() end } })
		local memoizedCallback = hook.result.current

		hook.rerender({ callback = function() end })
		expect(hook.result.current).to.equal(memoizedCallback)

		hook.rerender({ callback = function() end })
		expect(hook.result.current).to.equal(memoizedCallback)
	end)

	it("should memoize new callbacks", function()
		local hook = renderHook(function(props: { callback: (a: number, b: number) -> number })
			return useLatestCallback(props.callback)
		end, { initialProps = {
			callback = function(a: number, b: number)
				return a + b
			end,
		} })

		local memoizedCallback = hook.result.current
		expect(memoizedCallback(1, 2)).to.equal(3)

		hook.rerender({
			callback = function(a: number, b: number)
				return a - b
			end,
		})
		expect(memoizedCallback(1, 2)).to.equal(-1)
	end)
end
