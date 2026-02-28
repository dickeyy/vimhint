import SwiftUI
import Carbon.HIToolbox

struct HotkeyRecorder: View {
    @Binding var shortcut: HotkeyManager.Shortcut?

    @State private var isRecording = false
    @State private var localMonitor: Any?

    private var title: String {
        if isRecording {
            return "Press shortcut..."
        }
        return shortcut?.displayString ?? "Record shortcut"
    }

    var body: some View {
        HStack(spacing: 8) {
            Text(title)
                .font(.system(size: 11, weight: .regular, design: .default))
                .lineLimit(1)
                .truncationMode(.tail)

            Spacer(minLength: 0)

            Button(isRecording ? "Stop" : "Record") {
                isRecording ? stopRecording() : startRecording()
            }
            .buttonStyle(.plain)
            .font(.system(size: 10, weight: .regular, design: .default))
            .foregroundStyle(.tertiary)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(.ultraThinMaterial.opacity(0.45), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        .onDisappear {
            stopRecording()
        }
    }

    private func startRecording() {
        guard localMonitor == nil else { return }
        HotkeyManager.shared.beginShortcutRecording()
        isRecording = true

        localMonitor = NSEvent.addLocalMonitorForEvents(matching: [.keyDown]) { event in
            if event.keyCode == UInt16(kVK_Escape) {
                stopRecording()
                return nil
            }

            if let newShortcut = HotkeyManager.Shortcut.from(event: event) {
                shortcut = newShortcut
                stopRecording()
                return nil
            }

            return nil
        }
    }

    private func stopRecording() {
        let wasRecording = isRecording

        if let localMonitor {
            NSEvent.removeMonitor(localMonitor)
            self.localMonitor = nil
        }
        isRecording = false

        if wasRecording {
            HotkeyManager.shared.endShortcutRecording()
        }
    }
}
