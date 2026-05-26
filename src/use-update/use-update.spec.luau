local react = require(script.Parent.Parent.Parent.React)
local testez = require(script.Parent.Parent.utils.testez)
local useUpdate = require(script.Parent)

local renderHook = testez.renderHook

return function()
	local it, expect = testez.globals().it, testez.globals().expect

	it("should cause a rerender", function()
		local renders = 0

		renderHook(function()
			local rerender = useUpdate()

			react.useEffect(function()
				rerender()
			end, {})

			renders += 1
			return nil
		end)

		expect(renders).to.equal(2)
	end)

	it("should return a new function on each update", function()
		local rerender: () -> () = function() end
		local previousRerender: () -> () = function() end

		renderHook(function()
			previousRerender = rerender
			rerender = useUpdate()
			return nil
		end)

		expect(rerender).never.to.equal(previousRerender)

		rerender()
		expect(rerender).never.to.equal(previousRerender)
	end)

	it("should return the same function across unrelated rerenders", function()
		local capturedRerender: () -> () = function() end
		local seen: { () -> () } = {}

		local hook = renderHook(function()
			capturedRerender = useUpdate()
			table.insert(seen, capturedRerender)
			return nil
		end)

		hook.rerender()
		hook.rerender()

		expect(seen[1]).to.equal(seen[2])
		expect(seen[2]).to.equal(seen[3])
		hook.unmount()
	end)

	it("should cause one extra render per call from outside", function()
		local renders = 0
		local rerender: () -> () = function() end

		local hook = renderHook(function()
			rerender = useUpdate()
			renders += 1
			return nil
		end)

		expect(renders).to.equal(1)

		rerender()
		expect(renders).to.equal(2)

		rerender()
		expect(renders).to.equal(3)

		hook.unmount()
	end)

	it("should not error when the rerender function is called after unmount", function()
		local rerender: () -> () = function() end

		local hook = renderHook(function()
			rerender = useUpdate()
			return nil
		end)

		hook.unmount()
		expect(function()
			rerender()
		end).never.to.throw()
	end)
end
