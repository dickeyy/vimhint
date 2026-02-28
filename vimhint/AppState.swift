import Foundation
import Combine

/// Shared observable state that bridges AppDelegate (AppKit) to SwiftUI views.
/// AppDelegate owns the SidebarWindow and populates the toggle closure on launch.
final class AppState: ObservableObject {

    static let shared = AppState()

    /// Called by menu bar views to toggle the sidebar panel.
    var toggleSidebar: () -> Void = {}

    /// Reflects whether the sidebar is currently visible.
    /// AppDelegate must update this whenever the window shows or hides.
    @Published var isSidebarVisible: Bool = false

    /// Session-only menu bar visibility. Defaults to visible on each launch.
    @Published var showMenuBarIcon: Bool = true

    func setMenuBarIconVisible(_ isVisible: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.showMenuBarIcon = isVisible
        }
    }

    func setSidebarVisible(_ isVisible: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.isSidebarVisible = isVisible
        }
    }

    private init() {}
}
