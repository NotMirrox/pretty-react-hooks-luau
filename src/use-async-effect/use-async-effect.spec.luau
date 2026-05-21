local Promise = require(script.Parent.Parent.Parent.Parent.Packages.Promise)
local testez = require(script.Parent.Parent.utils.testez)
local useAsyncEffect = require(script.Parent)

local renderHook = testez.renderHook

return function()
	local describe, it, expect = testez.globals().describe, testez.globals().it, testez.globals().expect

	describe("promise-returning effect", function()
		it("should run the effect", function()
			local calls = 0

			renderHook(function()
				useAsyncEffect(function()
					calls += 1
					return Promise.resolve()
				end, {})
				return nil
			end)

			expect(calls).to.equal(1)
		end)

		it("should run the effect when the dependencies change", function()
			local calls = 0

			local hook = renderHook(function(deps: { any })
				useAsyncEffect(function()
					calls += 1
					return Promise.resolve()
				end, deps)
				return nil
			end, { initialProps = { 0 } })

			expect(calls).to.equal(1)
			hook.rerender({ 1 })
			expect(calls).to.equal(2)
		end)

		it("should cancel the effect when unmounting", function()
			local calls = 0

			local hook = renderHook(function()
				useAsyncEffect(function()
					calls += 1
					return Promise.delay(0):andThen(function()
						calls += 1
					end)
				end, {})
				return nil
			end)

			expect(calls).to.equal(1)
			hook.unmount()
			expect(calls).to.equal(1)
		end)

		it("should allow promises to complete", function()
			local calls = 0

			renderHook(function()
				useAsyncEffect(function()
					calls += 1
					return Promise.delay(0):andThen(function()
						calls += 1
					end)
				end, {})
				return nil
			end)

			expect(calls).to.equal(1)
			task.wait(0.04)
			expect(calls).to.equal(2)
		end)
	end)

	describe("plain effect (promisified)", function()
		it("should run the plain effect", function()
			local calls = 0

			renderHook(function()
				useAsyncEffect(function()
					calls += 1
				end, {})
				return nil
			end)

			expect(calls).to.equal(1)
		end)

		it("should run the plain effect when the dependencies change", function()
			local calls = 0

			local hook = renderHook(function(deps: { any })
				useAsyncEffect(function()
					calls += 1
				end, deps)
				return nil
			end, { initialProps = { 0 } })

			expect(calls).to.equal(1)
			hook.rerender({ 1 })
			expect(calls).to.equal(2)
		end)

		it("should not error when unmounting mid-effect", function()
			local hook = renderHook(function()
				useAsyncEffect(function()
					task.wait(0.05)
				end, {})
				return nil
			end)

			expect(function()
				hook.unmount()
			end).never.to.throw()
		end)
	end)
end
