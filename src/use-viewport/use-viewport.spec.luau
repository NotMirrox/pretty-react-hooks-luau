local RunService = game:GetService("RunService")
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
			return useViewport(function(currentViewport)
				viewport = currentViewport
			end)
		end)

		expect(viewport).never.to.equal(Vector2.new(-1, -1))
		expect(viewport).to.equal(Workspace.CurrentCamera.ViewportSize)
		hook.unmount()
	end)

	it("should call the listener again when the camera changes", function()
		local calls = 0
		local last: Vector2?
		local hook = renderHook(function()
			return useViewport(function(viewport)
				calls += 1
				last = viewport
			end)
		end)

		local initialCalls = calls
		expect(initialCalls > 0).to.equal(true)

		local replacement = Instance.new("Camera")
		replacement.Parent = Workspace
		local original = Workspace.CurrentCamera
		Workspace.CurrentCamera = replacement
		RunService.Heartbeat:Wait()
		hook.rerender()

		expect(calls > initialCalls).to.equal(true)
		expect(last).to.equal(replacement.ViewportSize)

		Workspace.CurrentCamera = original
		replacement:Destroy()
		hook.unmount()
	end)

	it("should not error without a listener", function()
		local hook = renderHook(function()
			return useViewport()
		end)

		expect(hook.result.current:getValue()).to.equal(Workspace.CurrentCamera.ViewportSize)
		hook.unmount()
	end)
end
