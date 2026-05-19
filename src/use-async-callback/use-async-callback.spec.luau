local Promise = require(script.Parent.Parent.Parent.Parent.Packages.Promise)
local testez = require(script.Parent.Parent.utils.testez)
local useAsyncCallback = require(script.Parent)

local renderHook = testez.renderHook

return function()
	local describe, it, expect = testez.globals().describe, testez.globals().it, testez.globals().expect

	describe("promise-returning callback", function()
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
	end)

	describe("plain callback (promisified)", function()
		it("should resolve with the return value", function()
			local hook = renderHook(function()
				local state, callback = useAsyncCallback(function()
					return "foo"
				end)
				return { state = state, callback = callback }
			end)

			hook.result.current.callback()
			expect(hook.result.current.state.status).to.equal(Promise.Status.Resolved)
			expect(hook.result.current.state.value).to.equal("foo")
			expect(hook.result.current.state.message).never.to.be.ok()
		end)

		it("should reject when the callback errors", function()
			local hook = renderHook(function()
				local state, callback = useAsyncCallback(function()
					error("boom")
				end)
				return { state = state, callback = callback }
			end)

			hook.result.current.callback()
			expect(hook.result.current.state.status).to.equal(Promise.Status.Rejected)
			expect(hook.result.current.state.value).never.to.be.ok()
			expect(hook.result.current.state.message).to.be.ok()
		end)

		it("should allow the callback to yield", function()
			local completions = 0
			local hook = renderHook(function()
				local state, callback = useAsyncCallback(function()
					task.wait(0.02)
					completions += 1
					return completions
				end)
				return { state = state, callback = callback }
			end)

			hook.result.current.callback()
			expect(completions).to.equal(0)
			expect(hook.result.current.state.status).to.equal(Promise.Status.Started)

			task.wait(0.04)
			expect(completions).to.equal(1)
			expect(hook.result.current.state.status).to.equal(Promise.Status.Resolved)
			expect(hook.result.current.state.value).to.equal(1)
		end)

		it("should not error when unmounting mid-callback", function()
			local hook = renderHook(function()
				local _, callback = useAsyncCallback(function()
					task.wait(0.05)
				end)
				return { callback = callback }
			end)

			hook.result.current.callback()
			expect(function()
				hook.unmount()
			end).never.to.throw()
		end)
	end)
end
