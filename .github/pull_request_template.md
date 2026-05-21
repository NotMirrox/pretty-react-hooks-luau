<!--
PR title must follow Conventional Commits:
  <type>(<optional-scope>)!: <subject>
Types: feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert
Examples:
  feat(use-debounce): port useDebounce from upstream
  fix(use-async-effect): stop double-invoke on rerender
  chore!: drop Roblox-CLI 0.6 support
-->

## Summary

<!-- What changed and why. 1-3 sentences. -->

## Upstream parity

<!-- If porting from littensy/pretty-react-hooks, link the upstream file/commit. Delete if N/A. -->

- Upstream:
- Notes on deviations:

## Test plan

- [ ] `wally install`
- [ ] `rojo build`
- [ ] tests pass: `<command>`
- [ ] manual check in Studio (if behavior change)
