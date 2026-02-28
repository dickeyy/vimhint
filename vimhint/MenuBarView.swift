import SwiftUI

struct MenuBarView: View {
    @EnvironmentObject private var appState: AppState
    @State private var isEditingHotkey = false
    @State private var draftShortcut: HotkeyManager.Shortcut?
    @State private var hotkeyText = "Set keybind"

    private func refreshHotkeyText() {
        hotkeyText = HotkeyManager.shared.shortcut?.displayString ?? "Set keybind"
    }

    private func beginEditingHotkey() {
        draftShortcut = HotkeyManager.shared.shortcut
        isEditingHotkey = true
    }

    private func finishEditingHotkey() {
        if HotkeyManager.shared.shortcut != draftShortcut {
            HotkeyManager.shared.shortcut = draftShortcut
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
            .buttonStyle(.borderedProminent)
            .controlSize(.regular)
            .padding(.horizontal, 14)
            .padding(.vertical, 6)

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
                        HotkeyRecorder(shortcut: $draftShortcut)
                            .frame(width: 150)

                        Button("Done") {
                            finishEditingHotkey()
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.small)
                    }
                } else {
                    Button(hotkeyText) {
                        beginEditingHotkey()
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
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
            .buttonStyle(.bordered)
            .controlSize(.regular)
            .padding(.horizontal, 14)
            .padding(.vertical, 6)

            Divider()
                .padding(.vertical, 4)

            // Quit
            Button {
                NSApp.terminate(nil)
            } label: {
                Label("Quit vimhint", systemImage: "power")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(.bordered)
            .controlSize(.regular)
            .padding(.horizontal, 14)
            .padding(.vertical, 6)
        }
        .padding(.bottom, 10)
        .frame(width: 240)
        .onAppear {
            refreshHotkeyText()
        }
        .onReceive(NotificationCenter.default.publisher(for: HotkeyManager.shortcutDidChangeNotification)) { _ in
            refreshHotkeyText()
        }
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
