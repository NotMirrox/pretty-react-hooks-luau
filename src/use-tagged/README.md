## 🪝 `useTagged`

```luau
function useTagged<T>(tag: string): { T }
```

Tracks and returns all instances assigned to the given [`CollectionService`](https://create.roblox.com/docs/reference/engine/classes/CollectionService) tag. Re-renders the component when tagged instances are added or removed from the data model.

### 📕 Parameters

-   `tag` - The [tag](https://create.roblox.com/docs/studio/properties#instance-tags) to filter instances for.

### 📗 Returns

-   A list of instances with the given tag.

### 📘 Example

Get all instances with the tag `"Zombie"`:

```luau
local function ZombieHealth()
	local zombies = useTagged("Zombie")

	return react.createElement(react.Fragment, nil, {
		zombies = react.createElement("Frame", nil, zombies),
	})
end
```
