local Workspace = game:GetService("Workspace")

local testez = require(script.Parent.Parent.utils.testez)
local useViewport = require(script.Parent)

local renderHook = testez.renderHook

return function()
	local it, expect = testez.globals().it, testez.globals().expect

	it("should return a binding to the viewport size", function()
		local hook = renderHook(function()
			return useViewport()
		end)

		expect(hook.result.current).to.be.a("table")
		expect(hook.result.current:getValue()).to.be.a("userdata")
		expect(hook.result.current:getValue()).to.equal(Workspace.CurrentCamera.ViewportSize)
		hook.unmount()
	end)

	it("should receive an optional listener", function()
		local viewport = Vector2.new(-1, -1)
		local hook = renderHook(function()
			return useViewport(function(v)
				viewport = v
			end)
		end)

		expect(viewport).never.to.equal(Vector2.new(-1, -1))
		expect(viewport).to.equal(Workspace.CurrentCamera.ViewportSize)
		hook.unmount()
	end)
end
