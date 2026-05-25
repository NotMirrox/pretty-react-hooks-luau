## 🌺 [pretty-react-hooks-luau](https://wally.run/package/notmirrox/pretty-react-hooks)

[![GitHub license](https://img.shields.io/github/license/NotMirrox/pretty-react-hooks-luau?style=for-the-badge)](LICENSE.md)

An opinionated collection of useful hooks and utilities for [React](https://github.com/jsdotlua/react-lua) on Roblox, ported to **Luau**.

This is a Luau port of [littensy/pretty-react-hooks](https://github.com/littensy/pretty-react-hooks) (originally written for [roblox-ts](https://roblox-ts.com)). If you are on roblox-ts, use the original `@rbxts/pretty-react-hooks` package.

If you find a bug or have a feature request, please [open an issue](https://github.com/NotMirrox/pretty-react-hooks-luau/issues/new/).

&nbsp;

## 📦 Installation

This package is published to [Wally](https://wally.run). Add it to your `wally.toml`:

```toml
[dependencies]
PrettyReactHooks = "notmirrox/pretty-react-hooks@0.1.0"
```

Then run:

```sh
wally install
```

Wally packages are also consumable from [pesde](https://pesde.dev) via its wally compatibility index, so you can depend on this package from either toolchain.

&nbsp;

## 📊 Port Status

**✅ Ported:** [`useAsync`](src/use-async/), [`useAsyncCallback`](src/use-async-callback/), [`useAsyncEffect`](src/use-async-effect/), [`useBindingListener`](src/use-binding-listener/), [`useBindingState`](src/use-binding-state/), [`useCamera`](src/use-camera/), [`useComposedRef`](src/use-composed-ref/), [`useDebounceCallback`](src/use-debounce-callback/), [`useDebounceEffect`](src/use-debounce-effect/), [`useDebounceState`](src/use-debounce-state/), [`useDeferCallback`](src/use-defer-callback/), [`useDeferEffect`](src/use-defer-effect/), [`useDeferState`](src/use-defer-state/), [`useEventListener`](src/use-event-listener/), [`useInterval`](src/use-interval/), [`useKeyPress`](src/use-key-press/), [`useLatest`](src/use-latest/), [`useLatestCallback`](src/use-latest-callback/), [`useLifetime`](src/use-lifetime/), [`useMountEffect`](src/use-mount-effect/), [`useMouse`](src/use-mouse/), [`usePrevious`](src/use-previous/), [`useTagged`](src/use-tagged/), [`useThrottleCallback`](src/use-throttle-callback/), [`useThrottleEffect`](src/use-throttle-effect/), [`useThrottleState`](src/use-throttle-state/), [`useTimeout`](src/use-timeout/), [`useTimer`](src/use-timer/), [`useUnmountEffect`](src/use-unmount-effect/), [`useUpdate`](src/use-update/), [`useUpdateEffect`](src/use-update-effect/), [`useViewport`](src/use-viewport/), [`binding`](src/utils/binding.luau) util.

**⏳ Pending:** `hoarcekat` util.

**🚫 Skipped:** `useMotion`, `useSpring` — use [`react-ripple`](https://github.com/littensy/ripple/tree/main/packages/react-ripple) instead.

&nbsp;

## 🌻 Contributing

Contributions are welcome. If you change a hook, update its tests and documentation as well.

To get started:

1. Install the toolchain with [Rokit](https://github.com/rojo-rbx/rokit):
   ```sh
   rokit install
   ```
   This installs `rojo`, `wally`, `wally-package-types`, `selene`, and `stylua` at the versions pinned in [`rokit.toml`](rokit.toml).
2. Install dependencies and inject Luau types into the resolved packages:
   ```sh
   wally install
   wally-package-types --sourcemap sourcemap.json Packages
   wally-package-types --sourcemap sourcemap.json DevPackages
   ```
   Regenerate `sourcemap.json` with `rojo sourcemap default.project.json -o sourcemap.json` whenever the project structure changes.
3. Lint and format:
   ```sh
   selene src
   stylua src
   ```
4. Serve the project to Roblox Studio:
   ```sh
   rojo serve
   ```
5. Run tests with [TestEZ](https://github.com/Roblox/testez). The recommended workflow is the [TestEZ Companion](https://marketplace.visualstudio.com/items?itemName=tacheometrist.testez-companion) VS Code extension, which discovers and runs `*.spec.luau` files inside Roblox Studio while `rojo serve` is connected.

Recommended VS Code extensions:

-   [Rojo](https://marketplace.visualstudio.com/items?itemName=evaera.vscode-rojo)
-   [Luau Language Server](https://marketplace.visualstudio.com/items?itemName=JohnnyMorganz.luau-lsp)
-   [StyLua](https://marketplace.visualstudio.com/items?itemName=JohnnyMorganz.stylua)
-   [Selene](https://marketplace.visualstudio.com/items?itemName=Kampfkarren.selene-vscode)
-   [TestEZ Companion](https://marketplace.visualstudio.com/items?itemName=tacheometrist.testez-companion)

&nbsp;

## 🙏 Credits

Originally created by [@littensy](https://github.com/littensy) as [pretty-react-hooks](https://github.com/littensy/pretty-react-hooks) for roblox-ts. Ported to native Luau by [@NotMirrox](https://github.com/NotMirrox).

&nbsp;

## 📝 License

pretty-react-hooks-luau is licensed under the [MIT License](LICENSE.md).
