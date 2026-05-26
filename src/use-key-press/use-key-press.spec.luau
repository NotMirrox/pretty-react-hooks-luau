local ContextActionService = game:GetService("ContextActionService")

local testez = require(script.Parent.Parent.utils.testez)
local useKeyPress = require(script.Parent)

local renderHook = testez.renderHook
local act = testez.act

local function isBound(actionName: string): boolean
	return next(ContextActionService:GetBoundActionInfo(actionName)) ~= nil
end

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

	it("should accept a combination string", function()
		local hook = renderHook(function()
			return useKeyPress({ "W+Space" })
		end)
		expect(hook.result.current).to.equal(false)
		hook.unmount()
	end)

	it("should accept an array of key codes per combo", function()
		local hook = renderHook(function()
			return useKeyPress({ { "LeftControl", "C" } })
		end)
		expect(hook.result.current).to.equal(false)
		hook.unmount()
	end)

	it("should accept a mix of strings and arrays", function()
		local hook = renderHook(function()
			return useKeyPress({ "W", "A+D", { "LeftShift", "Tab" } })
		end)
		expect(hook.result.current).to.equal(false)
		hook.unmount()
	end)

	it("should not bind a ContextAction unless bindAction is true", function()
		local actionName = "useKeyPress_noBind_" .. tostring(os.clock())

		local hook = renderHook(function()
			return useKeyPress({ "W" }, { actionName = actionName })
		end)

		expect(isBound(actionName)).to.equal(false)

		hook.unmount()
	end)

	it("should bind a ContextAction when bindAction is true", function()
		local actionName = "useKeyPress_bind_" .. tostring(os.clock())

		local hook = renderHook(function()
			return useKeyPress({ "W", "Space" }, {
				bindAction = true,
				actionName = actionName,
			})
		end)

		expect(isBound(actionName)).to.equal(true)
		expect(ContextActionService:GetBoundActionInfo(actionName).priorityLevel).to.be.a("number")

		hook.unmount()
		expect(isBound(actionName)).to.equal(false)
	end)

	it("should apply a custom action priority", function()
		local actionName = "useKeyPress_priority_" .. tostring(os.clock())

		local hook = renderHook(function()
			return useKeyPress({ "Q" }, {
				bindAction = true,
				actionName = actionName,
				actionPriority = 4242,
			})
		end)

		expect(isBound(actionName)).to.equal(true)
		expect(ContextActionService:GetBoundActionInfo(actionName).priorityLevel).to.equal(4242)

		hook.unmount()
	end)

	it("should rebind when the action name changes", function()
		local firstName = "useKeyPress_rebindA_" .. tostring(os.clock())
		local secondName = "useKeyPress_rebindB_" .. tostring(os.clock())

		local hook = renderHook(function(props: { name: string })
			return useKeyPress({ "Q" }, {
				bindAction = true,
				actionName = props.name,
			})
		end, { initialProps = { name = firstName } })

		expect(isBound(firstName)).to.equal(true)

		hook.rerender({ name = secondName })
		act(function()
			task.wait()
		end)
		expect(isBound(firstName)).to.equal(false)
		expect(isBound(secondName)).to.equal(true)

		hook.unmount()
		act(function()
			task.wait()
		end)
		expect(isBound(secondName)).to.equal(false)
	end)

	it("should not error when key combos change between renders", function()
		local hook = renderHook(function(props: { combos: { string } })
			return useKeyPress(props.combos)
		end, { initialProps = { combos = { "W" } } })

		expect(hook.result.current).to.equal(false)

		hook.rerender({ combos = { "A", "S+D" } })
		expect(hook.result.current).to.equal(false)

		hook.rerender({ combos = {} })
		expect(hook.result.current).to.equal(false)

		hook.unmount()
	end)

	it("should not error when unmounting with no input", function()
		local hook = renderHook(function()
			return useKeyPress({ "W", "Space" })
		end)
		hook.unmount()
	end)
end
