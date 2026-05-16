local testez = require(script.Parent.Parent.utils.testez)
local useMountEffect = require(script.Parent)

local renderHook = testez.renderHook

return function()
	local it, expect = testez.globals().it, testez.globals().expect

	it("should run callback on mount", function()
		local renders = 0
		local mounted = false

		local hook = renderHook(function()
			useMountEffect(function()
				mounted = not mounted
			end)

			renders += 1
			return nil
		end)

		expect(renders).to.equal(1)
		expect(mounted).to.equal(true)

		hook.rerender()
		expect(renders).to.equal(2)
		expect(mounted).to.equal(true)
	end)

	it("should run cleanup on unmount", function()
		local cleaned = false

		local hook = renderHook(function()
			useMountEffect(function()
				return function()
					cleaned = true
				end
			end)
			return nil
		end)

		expect(cleaned).to.equal(false)
		hook.unmount()
		expect(cleaned).to.equal(true)
	end)
end
