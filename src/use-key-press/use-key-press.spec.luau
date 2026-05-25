local testez = require(script.Parent.Parent.utils.testez)
local useKeyPress = require(script.Parent)

local renderHook = testez.renderHook

return function()
	local it, expect = testez.globals().it, testez.globals().expect

	it("should return a boolean", function()
		local hook = renderHook(function()
			return useKeyPress({ "W", "B" })
		end)
		expect(hook.result.current).to.be.a("boolean")
		expect(hook.result.current).to.equal(false)
		hook.unmount()
	end)
end
