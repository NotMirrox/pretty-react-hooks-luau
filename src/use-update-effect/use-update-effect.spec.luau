local testez = require(script.Parent.Parent.utils.testez)
local useUpdateEffect = require(script.Parent)

local renderHook = testez.renderHook

return function()
	local it, expect = testez.globals().it, testez.globals().expect

	it("should call effect on update only", function()
		local renders = 0

		local result = renderHook(function()
			useUpdateEffect(function()
				renders += 1
				return nil
			end)

			return nil
		end)

		expect(renders).to.equal(0)

		result.rerender()
		expect(renders).to.equal(1)
	end)

	it("should call effect with dependencies", function()
		local renders = 0

		local result = renderHook(function(value: string?)
			useUpdateEffect(function()
				renders += 1
				return nil
			end, { value })

			return nil
		end)

		expect(renders).to.equal(0)

		result.rerender("test")
		expect(renders).to.equal(1)

		result.rerender("test")
		expect(renders).to.equal(1)

		result.rerender("test2")
		expect(renders).to.equal(2)
	end)
end
