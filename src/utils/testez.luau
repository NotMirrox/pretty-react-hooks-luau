--!nolint DeprecatedApi
local react = require(script.Parent.Parent.Parent.React)
local reactRoblox = require(script.Parent.Parent.Parent.Parent.DevPackages.ReactRoblox)

export type TestezContext = { [string]: any }
export type TestezCallback = (context: TestezContext) -> ()

export type ExpectChain = {
	to: ExpectChain,
	be: ExpectChain,
	never: ExpectChain,
	a: (typeName: string) -> ExpectChain,
	an: (typeName: string) -> ExpectChain,
	ok: () -> ExpectChain,
	equal: (value: any) -> ExpectChain,
	near: (value: number, limit: number?) -> ExpectChain,
	throw: (messageSubstring: string?) -> ExpectChain,
}

export type TestezGlobals = {
	describe: (phrase: string, callback: TestezCallback) -> (),
	describeFOCUS: (phrase: string, callback: TestezCallback) -> (),
	fdescribe: (phrase: string, callback: TestezCallback) -> (),
	describeSKIP: (phrase: string, callback: TestezCallback) -> (),
	xdescribe: (phrase: string, callback: TestezCallback) -> (),
	it: (phrase: string, callback: TestezCallback) -> (),
	itFOCUS: (phrase: string, callback: TestezCallback) -> (),
	fit: (phrase: string, callback: TestezCallback) -> (),
	itSKIP: (phrase: string, callback: TestezCallback) -> (),
	xit: (phrase: string, callback: TestezCallback) -> (),
	itFIXME: (phrase: string, callback: TestezCallback) -> (),
	FOCUS: () -> (),
	SKIP: () -> (),
	FIXME: (optionalMessage: string?) -> (),
	expect: (value: any) -> ExpectChain,
	beforeAll: (callback: TestezCallback) -> (),
	beforeEach: (callback: TestezCallback) -> (),
	afterEach: (callback: TestezCallback) -> (),
	afterAll: (callback: TestezCallback) -> (),
}

--[[
	Returns the TestEZ globals (`it`, `expect`, `describe`, lifecycle hooks)
	injected into the calling spec function's environment by `setfenv`. Must be
	called from inside the function returned by a spec module.
]]
local function globals(): TestezGlobals
	return getfenv(2)
end

export type RenderHookResult<Result, Props> = {
	--[[
		Triggers a re-render. The props will be passed to your renderHook callback.
	]]
	rerender: (props: Props?) -> (),
	--[[
		A stable reference to the latest value returned by your renderHook callback.
	]]
	result: {
		--[[
			The value returned by your renderHook callback.
		]]
		current: Result,
	},
	--[[
		Unmounts the test component. This is useful for when you need to test any
		cleanup your useEffects have.
	]]
	unmount: () -> (),
}

export type RenderHookOptions<Props> = {
	--[[
		The container to render into. Defaults to nil, which means the component
		will not be mounted to a Roblox instance.
	]]
	container: Instance?,
	--[[
		The argument passed to the renderHook callback. Can be useful if you plan
		to use the rerender utility to change the values passed to your hook.
	]]
	initialProps: Props?,
}

--[[
	Allows you to render a hook within a test React component without having to
	create that component yourself.
	@see https://github.com/testing-library/react-testing-library
]]
local function renderHook<Result, Props>(
	render: (initialProps: Props) -> Result,
	options: RenderHookOptions<Props>?
): RenderHookResult<Result, Props>
	local resolvedOptions: RenderHookOptions<Props> = options or {}
	local result = { current = nil :: any }

	local function TestComponent(props: { initialProps: Props? })
		local previousProps = react.useRef(props.initialProps)
		local pendingResult = render(props.initialProps or previousProps.current or {} :: any)

		previousProps.current = props.initialProps
		result.current = pendingResult

		return nil
	end

	local root = reactRoblox.createLegacyRoot(resolvedOptions.container or Instance.new("Folder"))

	reactRoblox.act(function()
		root:render(react.createElement(TestComponent, { initialProps = resolvedOptions.initialProps }))
	end)

	local function rerender(props: Props?)
		reactRoblox.act(function()
			root:render(react.createElement(TestComponent, { initialProps = props }))
		end)
	end

	local function unmount()
		reactRoblox.act(function()
			root:unmount()
		end)
	end

	return {
		rerender = rerender,
		result = result,
		unmount = unmount,
	}
end

return {
	globals = globals,
	renderHook = renderHook,
	act = reactRoblox.act,
}
