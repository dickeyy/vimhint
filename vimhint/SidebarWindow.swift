import AppKit
import SwiftUI

// MARK: - SidebarWindow

/// A non-activating, floating NSPanel pinned to the right edge of the screen.
/// Slides in/out with animation and never steals keyboard focus.
final class SidebarWindow: NSPanel {

    // MARK: Constants

    private static let panelWidth: CGFloat = 320
    private static let animationDuration: TimeInterval = 0.28

    // MARK: State

    private(set) var isShown = false

    // MARK: Init

    init() {
        let initialFrame = SidebarWindow.hiddenFrame()

        super.init(
            contentRect: initialFrame,
            styleMask: [
                .nonactivatingPanel,    // does not activate app when shown
                .borderless,            // no title bar chrome
                .fullSizeContentView,   // content fills the entire frame
            ],
            backing: .buffered,
            defer: false
        )

        configure()
        buildContentStack()
    }

    // MARK: Configuration

    private func configure() {
        // Appearance
        backgroundColor = .clear
        isOpaque = false
        hasShadow = true

        // Floating behavior
        level = .floating
        collectionBehavior = [
            .canJoinAllSpaces,        // visible on every Space
            .stationary,              // doesn't move during Exposé/Mission Control
            .fullScreenAuxiliary,     // stays visible when another app goes full-screen
        ]

        // Focus behavior
        becomesKeyOnlyIfNeeded = true   // only takes key focus if clicked explicitly
        hidesOnDeactivate = false       // stays visible when you switch to another app
        isMovableByWindowBackground = false
        isReleasedWhenClosed = false    // we manage lifetime, not AppKit
    }

    private func buildContentStack() {
        // 1. Visual effect view provides the frosted-glass background
        let visualEffect = NSVisualEffectView(frame: .zero)
        visualEffect.material = .sidebar
        visualEffect.blendingMode = .behindWindow
        visualEffect.state = .active
        visualEffect.wantsLayer = true
        visualEffect.layer?.cornerRadius = 0   // flush with screen edge

        // 2. SwiftUI hosting view sits on top
        let hostingView = NSHostingView(rootView: CheatsheetView().environmentObject(AppState.shared))
        hostingView.translatesAutoresizingMaskIntoConstraints = false

        // 3. Stack them: visual effect is the root, hosting view fills it
        visualEffect.addSubview(hostingView)
        NSLayoutConstraint.activate([
            hostingView.topAnchor.constraint(equalTo: visualEffect.topAnchor),
            hostingView.bottomAnchor.constraint(equalTo: visualEffect.bottomAnchor),
            hostingView.leadingAnchor.constraint(equalTo: visualEffect.leadingAnchor),
            hostingView.trailingAnchor.constraint(equalTo: visualEffect.trailingAnchor),
        ])

        contentView = visualEffect

        // Position after the content view is set so screen geometry is ready
        reposition()
    }

    // MARK: Screen Geometry

    /// The on-screen frame: right edge of the visible area, full height.
    private static func shownFrame(for screen: NSScreen? = .main) -> NSRect {
        guard let screen = screen else { return .zero }
        let visible = screen.visibleFrame  // excludes menu bar and Dock
        return NSRect(
            x: visible.maxX - panelWidth,
            y: visible.minY,
            width: panelWidth,
            height: visible.height
        )
    }

    /// The off-screen frame: shifted one full panel-width to the right.
    private static func hiddenFrame(for screen: NSScreen? = .main) -> NSRect {
        var f = shownFrame(for: screen)
        f.origin.x += panelWidth
        return f
    }

    /// Call when the screen configuration changes (e.g. display arrangement, resolution).
    func reposition() {
        let target = isShown
            ? SidebarWindow.shownFrame()
            : SidebarWindow.hiddenFrame()
        setFrame(target, display: false)
    }

    // MARK: Show / Hide / Toggle

    func toggle() {
        isShown ? hide() : show()
    }

    func show() {
        guard !isShown else { return }
        isShown = true

        // Snap to the hidden position first (in case screen changed)
        setFrame(SidebarWindow.hiddenFrame(), display: false)
        orderFront(nil)

        NSAnimationContext.runAnimationGroup { ctx in
            ctx.duration = Self.animationDuration
            ctx.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            ctx.allowsImplicitAnimation = true
            animator().setFrame(SidebarWindow.shownFrame(), display: true)
        }
    }

    func hide() {
        guard isShown else { return }
        isShown = false

        NSAnimationContext.runAnimationGroup({ ctx in
            ctx.duration = Self.animationDuration
            ctx.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            ctx.allowsImplicitAnimation = true
            animator().setFrame(SidebarWindow.hiddenFrame(), display: true)
        }, completionHandler: { [weak self] in
            self?.orderOut(nil)
        })
    }

    // MARK: NSPanel overrides

    /// Allow key status only when needed (for controls like the search field).
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { false }
}
