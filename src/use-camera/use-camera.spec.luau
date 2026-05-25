local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local testez = require(script.Parent.Parent.utils.testez)
local useCamera = require(script.Parent)

local renderHook = testez.renderHook

return function()
	local it, expect = testez.globals().it, testez.globals().expect

	it("should return current camera", function()
		local hook = renderHook(function()
			return useCamera()
		end)

		expect(hook.result.current).to.equal(Workspace.CurrentCamera)
		hook.unmount()
	end)

	it("should update when current camera changes", function()
		local hook = renderHook(function()
			return useCamera()
		end)

		expect(hook.result.current).to.equal(Workspace.CurrentCamera)

		local oldCamera = Workspace.CurrentCamera
		if oldCamera then
			oldCamera:Destroy()
		end
		RunService.Heartbeat:Wait()
		hook.rerender()

		expect(hook.result.current).to.equal(Workspace.CurrentCamera)
		hook.unmount()
	end)
end
