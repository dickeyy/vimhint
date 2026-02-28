import Foundation
import Combine

/// Shared observable state that bridges AppDelegate (AppKit) to SwiftUI views.
/// AppDelegate owns the SidebarWindow and populates the toggle closure on launch.
@MainActor
final class AppState: ObservableObject {

    static let shared = AppState()

    /// Called by menu bar views to toggle the sidebar panel.
    var toggleSidebar: () -> Void = {}

    /// Called by menu bar views to open the hotkey settings window.
    var openHotkeySettings: () -> Void = {}

    /// Reflects whether the sidebar is currently visible.
    /// AppDelegate must update this whenever the window shows or hides.
    @Published var isSidebarVisible: Bool = false

    /// Session-only menu bar visibility. Defaults to visible on each launch.
    @Published var showMenuBarIcon: Bool = true

    func setMenuBarIconVisible(_ isVisible: Bool) {
        guard showMenuBarIcon != isVisible else { return }
        showMenuBarIcon = isVisible
    }

    func setSidebarVisible(_ isVisible: Bool) {
        guard isSidebarVisible != isVisible else { return }
        isSidebarVisible = isVisible
    }

    private init() {}
}
