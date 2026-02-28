# vimhint

A lightweight macOS menu bar app that shows a Vim cheatsheet in a right-side floating panel.

## Install (from GitHub Releases)

1. Download the latest `vimhint-<version>.dmg` from the Releases page.
2. Open the DMG and drag `vimhint.app` into `Applications`.
3. Launch `vimhint.app`.

Because releases are currently unsigned/not notarized, macOS Gatekeeper may block first launch.

If that happens, either:

- Right-click `vimhint.app` in `Applications` and choose `Open`.
- Or remove quarantine from Terminal:

```bash
xattr -dr com.apple.quarantine /Applications/vimhint.app
```

## Local development

Open `vimhint.xcodeproj` in Xcode and run the `vimhint` scheme on `My Mac`.

## Release process (GitHub Actions)

This repo includes `.github/workflows/release.yml`.

Pushing a tag that starts with `v` triggers a release build on macOS and uploads:

- `vimhint-<version>.dmg`
- `vimhint-<version>.dmg.sha256`

### Create a release

```bash
git tag v0.1.0
git push origin v0.1.0
```

After the workflow completes, the release appears in GitHub Releases.

## Notes

- Current release builds are unsigned (`CODE_SIGNING_ALLOWED=NO`) for easy GitHub distribution.
- Later, you can add Developer ID signing + notarization in the same workflow for smoother installs.
