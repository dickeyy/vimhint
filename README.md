# vimhint

`vimhint` is a tiny macOS menu bar app that gives you a fast, searchable Vim cheatsheet in a right-edge sidebar panel.

Use it while coding without leaving your editor.

<img width="1234" height="998" alt="CleanShot 2026-03-02 at 15 58 20@2x" src="https://github.com/user-attachments/assets/86f7c954-b907-4321-8245-d4d0b8dd0c24" />

## Features

- Global hotkey to show/hide the sidebar
- Searchable Vim command cheatsheet
- Non-intrusive right-edge sidebar card
- Menu bar app (no Dock icon clutter)

## Install

1. Download the latest `.dmg` from [Releases](../../releases).
2. Open the DMG and drag `vimhint.app` into `Applications`.
3. Launch `vimhint.app`.

## macOS security note

If macOS blocks the app on first launch, remove quarantine:

```bash
xattr -dr com.apple.quarantine /Applications/vimhint.app
```

Or right-click `vimhint.app` in `Applications` and choose `Open`.

## First launch

1. Click the menu bar icon.
2. Set your hotkey.
3. Press the hotkey to toggle the sidebar.

You can hide the menu bar icon for the current session and bring it back from the sidebar.

## Local development

Open `vimhint.xcodeproj` in Xcode, choose the `vimhint` scheme, and run on `My Mac`.

## License

MIT License. See [LICENSE](LICENSE) for details.
