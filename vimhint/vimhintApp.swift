//
//  vimhintApp.swift
//  vimhint
//
//  Created by Kyle Dickey on 2/28/26.
//

import SwiftUI

@main
struct vimhintApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @ObservedObject private var appState = AppState.shared

    var body: some Scene {
        // Menu bar icon visibility is session-only (resets every launch).
        MenuBarExtra(isInserted: Binding(
            get: { appState.showMenuBarIcon },
            set: { appState.setMenuBarIconVisible($0) }
        )) {
            MenuBarView()
                .environmentObject(appState)
        } label: {
            VimHintIcon()
        }
        .menuBarExtraStyle(.window)

        // Required to satisfy SwiftUI's App protocol on macOS.
        Settings {
            EmptyView()
        }
    }
}

// MARK: - AppDelegate

final class AppDelegate: NSObject, NSApplicationDelegate {

    private var sidebarWindow: SidebarWindow?

    func applicationDidFinishLaunching(_ notification: Notification) {
        setupSidebarWindow()
        registerHotkeys()
        observeScreenChanges()
    }

    // MARK: Setup

    private func setupSidebarWindow() {
        sidebarWindow = SidebarWindow()

        // Give AppState a closure so SwiftUI views can trigger the toggle.
        AppState.shared.toggleSidebar = { [weak self] in
            guard let self, let window = self.sidebarWindow else { return }
            window.toggle()
            AppState.shared.setSidebarVisible(window.isShown)
        }
    }

    private func registerHotkeys() {
        HotkeyManager.shared.onTrigger { [weak self] in
            DispatchQueue.main.async {
                guard let self, let window = self.sidebarWindow else { return }
                window.toggle()
                AppState.shared.setSidebarVisible(window.isShown)
            }
        }
    }

    /// Reposition the panel if the user changes display arrangement or resolution.
    private func observeScreenChanges() {
        NotificationCenter.default.addObserver(
            forName: NSApplication.didChangeScreenParametersNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.sidebarWindow?.reposition()
        }
    }
}
