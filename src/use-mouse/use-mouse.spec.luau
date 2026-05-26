local UserInputService = game:GetService("UserInputService")

local testez = require(script.Parent.Parent.utils.testez)
local useMouse = require(script.Parent)

local renderHook = testez.renderHook

return function()
	local it, expect = testez.globals().it, testez.globals().expect

	it("should return a binding to the mouse position", function()
		local hook = renderHook(function()
			return useMouse()
		end)

		expect(hook.result.current).to.be.a("table")
		expect(hook.result.current:getValue()).to.be.a("userdata")
		expect(hook.result.current:getValue()).to.equal(UserInputService:GetMouseLocation())
		hook.unmount()
	end)

	it("should receive an optional listener", function()
		local mouse = Vector2.new(-1, -1)
		local hook = renderHook(function()
			return useMouse(function(m)
				mouse = m
			end)
		end)

		expect(mouse).never.to.equal(Vector2.new(-1, -1))
		expect(mouse).to.equal(UserInputService:GetMouseLocation())
		hook.unmount()
	end)

	it("should keep the binding identity stable across rerenders", function()
		local hook = renderHook(function()
			return useMouse()
		end)

		local first = hook.result.current
		hook.rerender()
		expect(hook.result.current).to.equal(first)

		hook.unmount()
	end)

	it("should give independent bindings to independent components", function()
		local hookA = renderHook(function()
			return useMouse()
		end)
		local hookB = renderHook(function()
			return useMouse()
		end)

		expect(hookA.result.current).never.to.equal(hookB.result.current)
		expect(hookA.result.current:getValue()).to.equal(hookB.result.current:getValue())

		hookA.unmount()
		hookB.unmount()
	end)

	it("should not error when unmounting without a listener", function()
		local hook = renderHook(function()
			return useMouse()
		end)
		hook.unmount()
	end)
end
