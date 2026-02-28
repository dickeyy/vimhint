import SwiftUI

struct MenuBarView: View {
    @EnvironmentObject private var appState: AppState
    @Environment(\.openSettings) private var openSettings
    @State private var hotkeyText = "Not set"

    private func refreshHotkeyText() {
        hotkeyText = HotkeyManager.shared.shortcut?.displayString ?? "Not set"
    }

    private var toggleSidebarTitle: String {
        let baseTitle = appState.isSidebarVisible ? "Hide Sidebar" : "Show Sidebar"
        guard hotkeyText != "Not set" else { return baseTitle }
        return "\(baseTitle) (\(hotkeyText))"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                appState.toggleSidebar()
            } label: {
                Text(toggleSidebarTitle)
            }

            Divider()

            Button("Set Hotkey...") {
                openSettings()
            }

            Button("Hide Menu Bar Icon") {
                appState.setMenuBarIconVisible(false)
            }

            Divider()

            Button {
                NSApp.terminate(nil)
            } label: {
                Text("Quit vimhint")
            }
        }
        .onAppear {
            refreshHotkeyText()
        }
        .onReceive(NotificationCenter.default.publisher(for: HotkeyManager.shortcutDidChangeNotification)) { _ in
            refreshHotkeyText()
        }
    }
}

struct HotkeySettingsView: View {
    @State private var shortcut: HotkeyManager.Shortcut? = HotkeyManager.shared.shortcut

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Sidebar Hotkey")
                .font(.headline)

            Text("Record a shortcut to toggle the sidebar from anywhere.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HotkeyRecorder(shortcut: $shortcut)
                .frame(width: 300)

            Button("Clear Shortcut") {
                shortcut = nil
            }
            .disabled(shortcut == nil)
        }
        .padding(20)
        .frame(minWidth: 360)
        .onChange(of: shortcut) { _, newValue in
            if HotkeyManager.shared.shortcut != newValue {
                HotkeyManager.shared.shortcut = newValue
            }
        }
    }
}

#Preview {
    MenuBarView()
        .environmentObject(AppState.shared)
}
