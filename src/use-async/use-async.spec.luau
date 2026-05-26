local Promise = require(script.Parent.Parent.Parent.Parent.Packages.Promise)
local testez = require(script.Parent.Parent.utils.testez)
local useAsync = require(script.Parent)

local renderHook = testez.renderHook

return function()
	local it, expect = testez.globals().it, testez.globals().expect

	it("should run the promise on mount", function()
		local hook = renderHook(function()
			local value, status, message = useAsync(function()
				return Promise.resolve("foo")
			end)
			return { value = value, status = status, message = message }
		end)

		expect(hook.result.current.status).to.equal(Promise.Status.Resolved)
		expect(hook.result.current.value).to.equal("foo")
		expect(hook.result.current.message).never.to.be.ok()
	end)

	it("should run the promise when the dependencies change", function()
		local hook = renderHook(function(props)
			local value, status, message = useAsync(function()
				return Promise.resolve(props[1])
			end, { props })
			return { value = value, status = status, message = message }
		end, { initialProps = { 0 } })

		expect(hook.result.current.status).to.equal(Promise.Status.Resolved)
		expect(hook.result.current.value).to.equal(0)
		expect(hook.result.current.message).never.to.be.ok()

		hook.rerender({ 1 })
		expect(hook.result.current.status).to.equal(Promise.Status.Resolved)
		expect(hook.result.current.value).to.equal(1)
		expect(hook.result.current.message).never.to.be.ok()
	end)

	it("should cancel the previous promise", function()
		local completions = 0
		local hook = renderHook(function(props)
			local value, status, message = useAsync(function()
				return Promise.delay(0):andThen(function()
					completions += 1
					return completions
				end)
			end, { props })
			return { value = value, status = status, message = message }
		end, { initialProps = { 0 } })

		hook.rerender({ 1 })
		hook.rerender({ 2 })
		hook.rerender({ 3 })

		expect(completions).to.equal(0)
		expect(hook.result.current.status).to.equal(Promise.Status.Started)
		expect(hook.result.current.value).never.to.be.ok()
		expect(hook.result.current.message).never.to.be.ok()

		task.wait(0.04)
		expect(completions).to.equal(1)
		expect(hook.result.current.status).to.equal(Promise.Status.Resolved)
		expect(hook.result.current.value).to.equal(1)
		expect(hook.result.current.message).never.to.be.ok()
	end)

	it("should update the state when the promise resolves", function()
		local hook = renderHook(function()
			local value, status, message = useAsync(function()
				return Promise.delay(0):andThen(function()
					return "foo"
				end)
			end)
			return { value = value, status = status, message = message }
		end)

		expect(hook.result.current.status).to.equal(Promise.Status.Started)
		expect(hook.result.current.value).never.to.be.ok()
		expect(hook.result.current.message).never.to.be.ok()

		task.wait(0.04)
		expect(hook.result.current.status).to.equal(Promise.Status.Resolved)
		expect(hook.result.current.value).to.equal("foo")
		expect(hook.result.current.message).never.to.be.ok()
	end)

	it("should cancel the promise on unmount", function()
		local completions = 0
		local hook = renderHook(function()
			useAsync(function()
				return Promise.delay(0):andThen(function()
					completions += 1
				end)
			end)
			return nil
		end)

		hook.unmount()
		task.wait(0.04)
		expect(completions).to.equal(0)
	end)

	it("should expose Rejected status and rejection message", function()
		local hook = renderHook(function()
			local value, status, message = useAsync(function()
				return Promise.delay(0):andThen(function()
					return Promise.reject("boom")
				end)
			end)
			return { value = value, status = status, message = message }
		end)

		task.wait(0.04)
		expect(hook.result.current.status).to.equal(Promise.Status.Rejected)
		expect(hook.result.current.value).never.to.be.ok()
		expect(hook.result.current.message).to.equal("boom")
	end)

	it("should treat a thrown plain callback as a rejection", function()
		local hook = renderHook(function()
			local value, status, message = useAsync(function()
				error("oops")
			end)
			return { value = value, status = status, message = message }
		end)

		task.wait(0.04)
		expect(hook.result.current.status).to.equal(Promise.Status.Rejected)
		expect(hook.result.current.value).never.to.be.ok()
		expect(hook.result.current.message).to.be.ok()
	end)

	it("should default to running only on mount when deps are omitted", function()
		local runs = 0
		local hook = renderHook(function(props: { value: number })
			useAsync(function()
				runs += 1
				return Promise.resolve(props.value)
			end)
			return nil
		end, { initialProps = { value = 0 } })

		task.wait(0.04)
		expect(runs).to.equal(1)

		hook.rerender({ value = 1 })
		hook.rerender({ value = 2 })
		task.wait(0.04)
		expect(runs).to.equal(1)

		hook.unmount()
	end)

	it("should ignore stale resolutions after deps change", function()
		local hook = renderHook(function(props: { delay: number, value: number })
			local value, status, message = useAsync(function()
				return Promise.delay(props.delay):andThen(function()
					return props.value
				end)
			end, { props.delay, props.value })
			return { value = value, status = status, message = message }
		end, { initialProps = { delay = 0.04, value = 1 } })

		hook.rerender({ delay = 0, value = 2 })
		task.wait(0.08)
		expect(hook.result.current.status).to.equal(Promise.Status.Resolved)
		expect(hook.result.current.value).to.equal(2)
	end)
end
