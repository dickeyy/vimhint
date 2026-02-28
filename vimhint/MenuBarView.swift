import SwiftUI
import KeyboardShortcuts

struct MenuBarView: View {
    @EnvironmentObject private var appState: AppState
    @State private var isEditingHotkey = false
    @State private var previousShortcut: KeyboardShortcuts.Shortcut?

    private var hotkeyText: String {
        if let shortcut = KeyboardShortcuts.getShortcut(for: .toggleSidebar) {
            return shortcut.description
        }
        return "Set keybind"
    }

    private func beginEditingHotkey() {
        previousShortcut = KeyboardShortcuts.getShortcut(for: .toggleSidebar)
        isEditingHotkey = true
    }

    private func finishEditingHotkey() {
        if KeyboardShortcuts.getShortcut(for: .toggleSidebar) == nil,
           let previousShortcut {
            KeyboardShortcuts.setShortcut(previousShortcut, for: .toggleSidebar)
        }
        isEditingHotkey = false
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack {
                VimHintIcon()
                    .foregroundStyle(.secondary)
                Text("vimhint")
                    .font(.headline)
            }
            .padding(.horizontal, 14)
            .padding(.top, 14)
            .padding(.bottom, 10)

            Divider()

            // Toggle sidebar button
            Button {
                appState.toggleSidebar()
                // Close the popover after toggling
                NSApp.keyWindow?.close()
            } label: {
                Label(
                    appState.isSidebarVisible ? "Hide Sidebar" : "Show Sidebar",
                    systemImage: appState.isSidebarVisible ? "sidebar.right" : "sidebar.right"
                )
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .contentShape(Rectangle())

            Divider()
                .padding(.vertical, 4)

            // Hotkey recorder
            HStack {
                Text("Hotkey")
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
                Spacer()

                if isEditingHotkey {
                    HStack(spacing: 6) {
                        KeyboardShortcuts.Recorder("", name: .toggleSidebar)
                        Button("Done") {
                            finishEditingHotkey()
                        }
                        .font(.system(size: 10, weight: .regular, design: .default))
                        .foregroundStyle(.tertiary)
                        .buttonStyle(.plain)
                    }
                } else {
                    Button(hotkeyText) {
                        beginEditingHotkey()
                    }
                    .buttonStyle(.plain)
                    .font(.system(size: 11, weight: .regular, design: .default))
                    .foregroundStyle(.tertiary)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 6)

            Divider()
                .padding(.vertical, 4)

            // Hide menu bar icon
            Button {
                appState.setMenuBarIconVisible(false)
            } label: {
                Label("Hide menu bar icon", systemImage: "eye.slash")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .contentShape(Rectangle())

            Divider()
                .padding(.vertical, 4)

            // Quit
            Button {
                NSApp.terminate(nil)
            } label: {
                Label("Quit vimhint", systemImage: "power")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .contentShape(Rectangle())
        }
        .padding(.bottom, 10)
        .frame(width: 240)
        .onDisappear {
            if isEditingHotkey {
                finishEditingHotkey()
            }
        }
    }
}

#Preview {
    MenuBarView()
        .environmentObject(AppState.shared)
}
