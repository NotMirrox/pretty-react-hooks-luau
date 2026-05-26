local Lighting = game:GetService("Lighting")

local testez = require(script.Parent.Parent.utils.testez)
local useTagged = require(script.Parent)

local renderHook = testez.renderHook

local TEST_TAG = "TEST_TAG"

return function()
	local it, expect, afterEach = testez.globals().it, testez.globals().expect, testez.globals().afterEach

	local testInstances: { Instance } = {}

	local function addTaggedInstance(instanceType: string, tag: string): Instance
		local newInstance = Instance.new(instanceType)
		newInstance:AddTag(tag)
		newInstance.Parent = Lighting

		table.insert(testInstances, newInstance)
		task.wait()

		return newInstance
	end

	afterEach(function()
		for _, instance in testInstances do
			instance:Destroy()
		end
	end)

	it("should include existing instances", function()
		local addedInstance = addTaggedInstance("Model", TEST_TAG)

		local hook = renderHook(function()
			return useTagged(TEST_TAG)
		end)

		expect(#hook.result.current).to.equal(1)
		expect(hook.result.current[1]).to.equal(addedInstance)
		hook.unmount()
	end)

	it("should add new instances", function()
		local hook = renderHook(function()
			return useTagged(TEST_TAG)
		end)

		local addedInstance = addTaggedInstance("Model", TEST_TAG)

		expect(#hook.result.current).to.equal(1)
		expect(hook.result.current[1]).to.equal(addedInstance)
		hook.unmount()
	end)

	it("should delete removed instances", function()
		local hook = renderHook(function()
			return useTagged(TEST_TAG)
		end)

		local addedInstance = addTaggedInstance("Model", TEST_TAG)

		expect(#hook.result.current).to.equal(1)
		expect(hook.result.current[1]).to.equal(addedInstance)

		addedInstance:Destroy()
		task.wait()

		expect(#hook.result.current).to.equal(0)

		hook.unmount()
	end)

	it("should ONLY include instances of the provided tag", function()
		local hook = renderHook(function()
			return useTagged(TEST_TAG)
		end)

		local addedInstance = addTaggedInstance("Model", TEST_TAG)
		addTaggedInstance("Model", `NOT_{TEST_TAG}`)

		expect(#hook.result.current).to.equal(1)
		expect(hook.result.current[1]).to.equal(addedInstance)
		hook.unmount()
	end)

	it("should not duplicate instances", function()
		local addedInstance = addTaggedInstance("Model", TEST_TAG)

		local hook = renderHook(function()
			return useTagged(TEST_TAG)
		end)

		expect(#hook.result.current).to.equal(1)
		expect(hook.result.current[1]).to.equal(addedInstance)
		hook.unmount()
	end)

	it("should track multiple instances under the same tag", function()
		local hook = renderHook(function()
			return useTagged(TEST_TAG)
		end)

		local first = addTaggedInstance("Model", TEST_TAG)
		local second = addTaggedInstance("Model", TEST_TAG)
		local third = addTaggedInstance("Folder", TEST_TAG)

		expect(#hook.result.current).to.equal(3)
		expect(table.find(hook.result.current, first)).to.be.ok()
		expect(table.find(hook.result.current, second)).to.be.ok()
		expect(table.find(hook.result.current, third)).to.be.ok()

		hook.unmount()
	end)

	it("should produce a new array reference on change", function()
		local hook = renderHook(function()
			return useTagged(TEST_TAG)
		end)

		local first = hook.result.current
		addTaggedInstance("Model", TEST_TAG)
		expect(hook.result.current).never.to.equal(first)

		hook.unmount()
	end)

	it("should stop reacting to tag changes after unmount", function()
		local hook = renderHook(function()
			return useTagged(TEST_TAG)
		end)

		hook.unmount()

		expect(function()
			addTaggedInstance("Model", TEST_TAG)
		end).never.to.throw()
	end)
end
