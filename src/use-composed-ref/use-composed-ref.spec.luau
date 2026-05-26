local shallowEqual = require(script.Parent.Parent.utils["shallow-equal"])
local testez = require(script.Parent.Parent.utils.testez)
local useComposedRef = require(script.Parent)

local renderHook = testez.renderHook

type RefFunction<T> = (rbx: T?) -> ()

return function()
	local it, expect = testez.globals().it, testez.globals().expect

	it("should call all refs passed in", function()
		local results: { string } = {}

		local hook = renderHook(function()
			return useComposedRef(function(value: string?)
				results[1] = value or ""
			end, function(value: string?)
				results[2] = value or ""
			end, function(value: string?)
				results[3] = value or ""
			end)
		end)

		expect(shallowEqual(results, {})).to.equal(true)

		hook.rerender()
		expect(shallowEqual(results, {})).to.equal(true)

		hook.result.current("foo")
		expect(shallowEqual(results, { "foo", "foo", "foo" })).to.equal(true)
	end)

	it("should skip refs that are nil", function()
		local results: { string? } = {}

		local hook = renderHook(function()
			return useComposedRef(
				function(value: string?)
					results[1] = value
				end,
				nil,
				function(value: string?)
					results[2] = value
				end,
				nil,
				function(value: string?)
					results[3] = value
				end
			)
		end)

		expect(shallowEqual(results, {})).to.equal(true)

		hook.rerender()
		expect(shallowEqual(results, {})).to.equal(true)

		hook.result.current("foo")
		expect(shallowEqual(results, { "foo", "foo", "foo" })).to.equal(true)
	end)

	it("should call the latest refs", function()
		local calls = { a = 0, b = 0 }

		local hook = renderHook(function(refs: { RefFunction<string> })
			return useComposedRef(table.unpack(refs))
		end, { initialProps = {} :: { RefFunction<string> } })

		hook.rerender({
			function(key: string?)
				calls[key or "a"] += 1
			end,
			function(key: string?)
				calls[key or "a"] += 1
			end,
		})
		hook.result.current("a")
		expect(calls.a).to.equal(2)
		expect(calls.b).to.equal(0)

		hook.rerender({
			function(key: string?)
				calls[key or "b"] += 1
			end,
			function(key: string?)
				calls[key or "b"] += 1
			end,
		})
		hook.result.current("b")
		expect(calls.a).to.equal(2)
		expect(calls.b).to.equal(2)
	end)

	it("should return the same composed ref function across rerenders", function()
		local hook = renderHook(function()
			return useComposedRef(function() end, function() end)
		end)

		local first = hook.result.current
		hook.rerender()
		expect(hook.result.current).to.equal(first)

		hook.unmount()
	end)

	it("should handle being called with no refs at all", function()
		local hook = renderHook(function()
			return useComposedRef()
		end)

		expect(function()
			hook.result.current("anything")
		end).never.to.throw()

		hook.unmount()
	end)

	it("should handle being called with only nil refs", function()
		local hook = renderHook(function()
			return useComposedRef(nil, nil, nil)
		end)

		expect(function()
			hook.result.current("anything")
		end).never.to.throw()

		hook.unmount()
	end)

	it("should forward a nil value to each ref (cleanup path)", function()
		local received: { string? } = {}

		local hook = renderHook(function()
			return useComposedRef(function(value: string?)
				received[1] = value
			end, function(value: string?)
				received[2] = value
			end)
		end)

		hook.result.current("attached")
		expect(received[1]).to.equal("attached")
		expect(received[2]).to.equal("attached")

		hook.result.current(nil)
		expect(received[1]).to.equal(nil)
		expect(received[2]).to.equal(nil)

		hook.unmount()
	end)
end
