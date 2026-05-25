local CollectionService = game:GetService("CollectionService")

local react = require(script.Parent.Parent.React)
local useEventListener = require(script.Parent["use-event-listener"])

--[[
	Wrapper around `CollectionService` that provides a list of `Instance` under
	the given `tag`.

	This list is updated as instances are added and removed.

	```luau
	local zombies = useTagged("Zombie")
	```

	@param tag The `CollectionService` tag name to filter against.
	@return A stateful list of instances matching the provided `tag`.
]]
local function useTagged<T>(tag: string): { T }
	local instances, setInstances = react.useState(function()
		return CollectionService:GetTagged(tag)
	end)

	useEventListener(CollectionService:GetInstanceAddedSignal(tag), function(instance: Instance)
		setInstances(function(previous)
			local nextInstances = table.clone(previous)
			table.insert(nextInstances, instance)
			return nextInstances
		end)
	end)

	useEventListener(CollectionService:GetInstanceRemovedSignal(tag), function(instance: Instance)
		setInstances(function(previous)
			local nextInstances = table.clone(previous)
			local index = table.find(nextInstances, instance)
			if index then
				table.remove(nextInstances, index)
			end
			return nextInstances
		end)
	end)

	return (instances :: any) :: { T }
end

return useTagged
