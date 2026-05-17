local Promise = require(script.Parent.Parent.Parent.Parent.DevPackages.Promise)
local testez = require(script.Parent.Parent.utils.testez)
local useAsyncCallback = require(script.Parent)

local renderHook = testez.renderHook

return function()
	local it, expect = testez.globals().it, testez.globals().expect

	it("should return the current state and a callback", function()
		local hook = renderHook(function()
			local state, callback = useAsyncCallback(function()
				return Promise.resolve("foo")
			end)
			return { state = state, callback = callback }
		end)

		expect(hook.result.current.state.status).to.equal(Promise.Status.Started)
		expect(hook.result.current.state.value).never.to.be.ok()
		expect(hook.result.current.state.message).never.to.be.ok()
		expect(hook.result.current.callback).to.be.a("function")
	end)

	it("should update the state when the promise resolves", function()
		local hook = renderHook(function()
			local state, callback = useAsyncCallback(function()
				return Promise.resolve("foo")
			end)
			return { state = state, callback = callback }
		end)

		hook.result.current.callback()
		expect(hook.result.current.state.status).to.equal(Promise.Status.Resolved)
		expect(hook.result.current.state.value).to.equal("foo")
		expect(hook.result.current.state.message).never.to.be.ok()
	end)

	it("should update the state when the promise rejects", function()
		local hook = renderHook(function()
			local state, callback = useAsyncCallback(function()
				return Promise.reject("foo")
			end)
			return { state = state, callback = callback }
		end)

		hook.result.current.callback()
		expect(hook.result.current.state.status).to.equal(Promise.Status.Rejected)
		expect(hook.result.current.state.value).never.to.be.ok()
		expect(hook.result.current.state.message).to.equal("foo")
	end)

	it("should cancel the previous promise", function()
		local completions = 0
		local hook = renderHook(function()
			local state, callback = useAsyncCallback(function()
				return Promise.delay(0):andThen(function()
					completions += 1
					return completions
				end)
			end)
			return { state = state, callback = callback }
		end)

		hook.result.current.callback()
		hook.result.current.callback()
		hook.result.current.callback()

		expect(completions).to.equal(0)
		expect(hook.result.current.state.status).to.equal(Promise.Status.Started)
		expect(hook.result.current.state.value).never.to.be.ok()
		expect(hook.result.current.state.message).never.to.be.ok()

		task.wait(0.04)
		expect(completions).to.equal(1)
		expect(hook.result.current.state.status).to.equal(Promise.Status.Resolved)
		expect(hook.result.current.state.value).to.equal(1)
		expect(hook.result.current.state.message).never.to.be.ok()
	end)

	it("should cancel when unmounting", function()
		local completions = 0
		local hook = renderHook(function()
			local state, callback = useAsyncCallback(function()
				return Promise.delay(0):andThen(function()
					completions += 1
				end)
			end)
			return { state = state, callback = callback }
		end)

		hook.result.current.callback()
		hook.unmount()
		task.wait(0.04)
		expect(completions).to.equal(0)
	end)
end
