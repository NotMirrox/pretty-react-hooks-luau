local testez = require(script.Parent.Parent.utils.testez)
local useUnmountEffect = require(script.Parent)

local renderHook = testez.renderHook

return function()
	local it, expect = testez.globals().it, testez.globals().expect

	it("should call when component unmounts", function()
		local called = false

		local hook = renderHook(function()
			useUnmountEffect(function()
				called = true
			end)
			return nil
		end)

		expect(called).to.equal(false)
		hook.unmount()
		expect(called).to.equal(true)
	end)

	it("should not call on rerender", function()
		local called = false

		local hook = renderHook(function()
			useUnmountEffect(function()
				called = true
			end)
			return nil
		end)

		expect(called).to.equal(false)
		hook.rerender()
		expect(called).to.equal(false)
	end)

	it("should call the last callback on unmount", function()
		local called = 0

		local hook = renderHook(function(callback: () -> ())
			useUnmountEffect(callback)
			return nil
		end, {
			initialProps = function()
				called = 0
			end,
		})

		hook.rerender(function()
			called += 1
		end)
		hook.unmount()
		expect(called).to.equal(1)
	end)
end
