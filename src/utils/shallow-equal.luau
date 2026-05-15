--[[
	Compares two objects to see if they are shallowly equal.
	@param objectA The first object to compare.
	@param objectB The second object to compare.
	@return Whether or not the two objects are shallowly equal.
]]
local function shallowEqual(objectA: { [any]: any }?, objectB: { [any]: any }?)
	if objectA == objectB then
		return true
	end

	if objectA == nil or objectB == nil then
		return false
	end

	for key, value in pairs(objectA) do
		if objectB[key] ~= value then
			return false
		end
	end

	for key, value in pairs(objectB) do
		if objectA[key] ~= value then
			return false
		end
	end

	return true
end

return shallowEqual
