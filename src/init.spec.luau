_G.__ROACT_17_MOCK_SCHEDULER__ = true

local testez = require(script.Parent.utils.testez)

return function()
	local afterAll = testez.globals().afterAll
	afterAll(function()
		_G.__ROACT_17_MOCK_SCHEDULER__ = nil
	end)
end
