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
        .menuBarExtraStyle(.menu)

        Settings {
            EmptyView()
        }
    }
}

// MARK: - AppDelegate

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {

    private var sidebarWindow: SidebarWindow?
    private var hotkeyWindowController: HotkeyWindowController?

    func applicationDidFinishLaunching(_ notification: Notification) {
        setupSidebarWindow()
        setupHotkeyWindow()
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
                if self?.hotkeyWindowController?.isVisible == true {
                    return
                }
                guard let self, let window = self.sidebarWindow else { return }
                window.toggle()
                AppState.shared.setSidebarVisible(window.isShown)
            }
        }
    }

    private func setupHotkeyWindow() {
        hotkeyWindowController = HotkeyWindowController()

        AppState.shared.openHotkeySettings = { [weak self] in
            self?.hotkeyWindowController?.show()
        }
    }

    /// Reposition the panel if the user changes display arrangement or resolution.
    private func observeScreenChanges() {
        NotificationCenter.default.addObserver(
            forName: NSApplication.didChangeScreenParametersNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.sidebarWindow?.reposition()
            }
        }
    }
}

@MainActor
final class HotkeyWindowController: NSObject, NSWindowDelegate {
    private var window: NSWindow?
    var isVisible: Bool { window?.isVisible == true }

    func show() {
        if window == nil {
            let contentController = NSHostingController(rootView: HotkeySettingsView())
            let window = NSWindow(contentViewController: contentController)
            window.styleMask = [.titled, .closable]
            window.title = "vimhint - Set Hotkey"
            window.setContentSize(NSSize(width: 360, height: 200))
            window.isReleasedWhenClosed = false
            window.level = .floating
            window.collectionBehavior = [.moveToActiveSpace]
            window.delegate = self
            self.window = window
        }

        guard let window else { return }
        NSApp.setActivationPolicy(.accessory)
        NSApp.activate(ignoringOtherApps: true)
        window.center()
        window.makeKeyAndOrderFront(nil)
        window.orderFrontRegardless()
    }

    func windowWillClose(_ notification: Notification) {
        NSApp.setActivationPolicy(.prohibited)
    }
}
