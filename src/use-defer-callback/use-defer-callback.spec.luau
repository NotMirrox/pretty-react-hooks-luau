local RunService = game:GetService("RunService")

local testez = require(script.Parent.Parent.utils.testez)
local useDeferCallback = require(script.Parent)

local renderHook = testez.renderHook

return function()
	local it, expect = testez.globals().it, testez.globals().expect

	local function wait()
		RunService.Heartbeat:Wait()
		RunService.Heartbeat:Wait()
	end

	it("should return a callback and a cancel function", function()
		local result = renderHook(function()
			local callback, cancel = useDeferCallback(function() end)
			return { callback = callback, cancel = cancel }
		end).result

		expect(result.current.callback).to.be.a("function")
		expect(result.current.cancel).to.be.a("function")
	end)

	it("should execute the callback on the next heartbeat", function()
		local calls = 0

		local result = renderHook(function()
			local callback = useDeferCallback(function()
				calls += 1
			end)
			return { callback = callback }
		end).result

		result.current.callback()
		expect(calls).to.equal(0)

		wait()
		expect(calls).to.equal(1)
	end)

	it("should return a function that cancels the callback", function()
		local calls = 0

		local result = renderHook(function()
			local callback, cancel = useDeferCallback(function()
				calls += 1
			end)
			return { callback = callback, cancel = cancel }
		end).result

		result.current.callback()
		expect(calls).to.equal(0)

		result.current.cancel()
		wait()
		expect(calls).to.equal(0)
	end)

	it("should cancel the previous callback when called again", function()
		local calls = 0

		local result = renderHook(function()
			local callback = useDeferCallback(function()
				calls += 1
			end)
			return { callback = callback }
		end).result

		result.current.callback()
		result.current.callback()
		result.current.callback()
		expect(calls).to.equal(0)

		wait()
		expect(calls).to.equal(1)
	end)

	it("should execute the callback with the latest arguments", function()
		local calls = 0

		local result = renderHook(function()
			local callback = useDeferCallback(function(value: number)
				calls += value
			end)
			return { callback = callback }
		end).result

		result.current.callback(1)
		result.current.callback(2)
		result.current.callback(3)
		expect(calls).to.equal(0)

		wait()
		expect(calls).to.equal(3)
	end)
end
