local react = require(script.Parent.Parent.Parent.React)
local testez = require(script.Parent.Parent.utils.testez)
local useUpdate = require(script.Parent)

local renderHook = testez.renderHook

return function()
	local it, expect = testez.globals().it, testez.globals().expect

	it("should cause a rerender", function()
		local renders = 0

		renderHook(function()
			local rerender = useUpdate()

			react.useEffect(function()
				rerender()
			end, {})

			renders += 1
			return nil
		end)

		expect(renders).to.equal(2)
	end)

	it("should return a new function on each update", function()
		local rerender: () -> () = function() end
		local previousRerender: () -> () = function() end

		renderHook(function()
			previousRerender = rerender
			rerender = useUpdate()
			return nil
		end)

		expect(rerender).never.to.equal(previousRerender)

		rerender()
		expect(rerender).never.to.equal(previousRerender)
	end)
end
