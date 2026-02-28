import AppKit
import SwiftUI

// MARK: - SidebarWindow

/// A non-activating, right-side panel with a floating card treatment.
/// Slides in/out with animation and stays lightweight while reading.
final class SidebarWindow: NSPanel {

    // MARK: Constants

    private static let panelWidth: CGFloat = 360
    private static let minHeight: CGFloat = 620
    private static let edgeInset: CGFloat = 8
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
        visualEffect.material = .hudWindow
        visualEffect.blendingMode = .behindWindow
        visualEffect.state = .active
        visualEffect.wantsLayer = true
        visualEffect.layer?.cornerRadius = 16
        visualEffect.layer?.masksToBounds = true
        visualEffect.layer?.borderWidth = 1
        visualEffect.layer?.borderColor = NSColor.separatorColor.withAlphaComponent(0.28).cgColor

        // 2. SwiftUI hosting view sits on top
        let hostingView = NSHostingView(rootView: CheatsheetView().environmentObject(AppState.shared))
        hostingView.translatesAutoresizingMaskIntoConstraints = false

        // 3. Stack them: visual effect is the root, hosting view fills it with subtle insets
        visualEffect.addSubview(hostingView)
        NSLayoutConstraint.activate([
            hostingView.topAnchor.constraint(equalTo: visualEffect.topAnchor, constant: 6),
            hostingView.bottomAnchor.constraint(equalTo: visualEffect.bottomAnchor, constant: -6),
            hostingView.leadingAnchor.constraint(equalTo: visualEffect.leadingAnchor, constant: 6),
            hostingView.trailingAnchor.constraint(equalTo: visualEffect.trailingAnchor, constant: -6),
        ])

        contentView = visualEffect

        // Position after the content view is set so screen geometry is ready
        reposition()
    }

    // MARK: Screen Geometry

    /// The on-screen frame: right edge with a near-full-height card.
    private static func shownFrame(for screen: NSScreen? = .main) -> NSRect {
        guard let screen = screen else { return .zero }
        let visible = screen.visibleFrame

        let height = max(minHeight, visible.height - (edgeInset * 2))
        let y = visible.minY + edgeInset

        return NSRect(
            x: visible.maxX - panelWidth - edgeInset,
            y: y,
            width: panelWidth,
            height: height
        )
    }

    /// The off-screen frame: shifted one full panel-width to the right.
    private static func hiddenFrame(for screen: NSScreen? = .main) -> NSRect {
        var f = shownFrame(for: screen)
        f.origin.x += panelWidth + edgeInset + 12
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
