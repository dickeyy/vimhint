import AppKit
import Carbon.HIToolbox

final class HotkeyManager {
    static let fallbackShortcut = Shortcut(
        keyCode: UInt32(kVK_ANSI_V),
        modifiers: UInt32(controlKey)
    )

    struct Shortcut: Codable, Equatable {
        let keyCode: UInt32
        let modifiers: UInt32

        var displayString: String {
            var parts: [String] = []

            if modifiers & UInt32(controlKey) != 0 { parts.append("Ctrl") }
            if modifiers & UInt32(optionKey) != 0 { parts.append("Alt") }
            if modifiers & UInt32(shiftKey) != 0 { parts.append("Shift") }
            if modifiers & UInt32(cmdKey) != 0 { parts.append("Cmd") }

            parts.append(Self.keyName(for: keyCode))
            return parts.joined(separator: "+")
        }

        static func from(event: NSEvent) -> Shortcut? {
            let keyCode = UInt32(event.keyCode)
            guard !modifierOnlyKeyCodes.contains(keyCode) else { return nil }

            let flags = event.modifierFlags.intersection([.command, .option, .shift, .control])
            var carbonModifiers: UInt32 = 0

            if flags.contains(.control) { carbonModifiers |= UInt32(controlKey) }
            if flags.contains(.option) { carbonModifiers |= UInt32(optionKey) }
            if flags.contains(.shift) { carbonModifiers |= UInt32(shiftKey) }
            if flags.contains(.command) { carbonModifiers |= UInt32(cmdKey) }

            guard carbonModifiers != 0 else { return nil }

            return Shortcut(keyCode: keyCode, modifiers: carbonModifiers)
        }

        private static let modifierOnlyKeyCodes: Set<UInt32> = [
            UInt32(kVK_Shift),
            UInt32(kVK_RightShift),
            UInt32(kVK_Control),
            UInt32(kVK_RightControl),
            UInt32(kVK_Option),
            UInt32(kVK_RightOption),
            UInt32(kVK_Command),
            UInt32(kVK_RightCommand),
            UInt32(kVK_CapsLock),
            UInt32(kVK_Function),
        ]

        private static func keyName(for keyCode: UInt32) -> String {
            if let ansi = ansiKeyNames[keyCode] {
                return ansi
            }

            switch keyCode {
            case UInt32(kVK_Return): return "Return"
            case UInt32(kVK_Tab): return "Tab"
            case UInt32(kVK_Space): return "Space"
            case UInt32(kVK_Delete): return "Delete"
            case UInt32(kVK_ForwardDelete): return "ForwardDelete"
            case UInt32(kVK_Escape): return "Escape"
            case UInt32(kVK_Help): return "Help"
            case UInt32(kVK_Home): return "Home"
            case UInt32(kVK_End): return "End"
            case UInt32(kVK_PageUp): return "PageUp"
            case UInt32(kVK_PageDown): return "PageDown"
            case UInt32(kVK_LeftArrow): return "Left"
            case UInt32(kVK_RightArrow): return "Right"
            case UInt32(kVK_UpArrow): return "Up"
            case UInt32(kVK_DownArrow): return "Down"
            case UInt32(kVK_F1): return "F1"
            case UInt32(kVK_F2): return "F2"
            case UInt32(kVK_F3): return "F3"
            case UInt32(kVK_F4): return "F4"
            case UInt32(kVK_F5): return "F5"
            case UInt32(kVK_F6): return "F6"
            case UInt32(kVK_F7): return "F7"
            case UInt32(kVK_F8): return "F8"
            case UInt32(kVK_F9): return "F9"
            case UInt32(kVK_F10): return "F10"
            case UInt32(kVK_F11): return "F11"
            case UInt32(kVK_F12): return "F12"
            case UInt32(kVK_F13): return "F13"
            case UInt32(kVK_F14): return "F14"
            case UInt32(kVK_F15): return "F15"
            case UInt32(kVK_F16): return "F16"
            case UInt32(kVK_F17): return "F17"
            case UInt32(kVK_F18): return "F18"
            case UInt32(kVK_F19): return "F19"
            case UInt32(kVK_F20): return "F20"
            default:
                return "Key\(keyCode)"
            }
        }

        private static let ansiKeyNames: [UInt32: String] = [
            UInt32(kVK_ANSI_A): "A",
            UInt32(kVK_ANSI_B): "B",
            UInt32(kVK_ANSI_C): "C",
            UInt32(kVK_ANSI_D): "D",
            UInt32(kVK_ANSI_E): "E",
            UInt32(kVK_ANSI_F): "F",
            UInt32(kVK_ANSI_G): "G",
            UInt32(kVK_ANSI_H): "H",
            UInt32(kVK_ANSI_I): "I",
            UInt32(kVK_ANSI_J): "J",
            UInt32(kVK_ANSI_K): "K",
            UInt32(kVK_ANSI_L): "L",
            UInt32(kVK_ANSI_M): "M",
            UInt32(kVK_ANSI_N): "N",
            UInt32(kVK_ANSI_O): "O",
            UInt32(kVK_ANSI_P): "P",
            UInt32(kVK_ANSI_Q): "Q",
            UInt32(kVK_ANSI_R): "R",
            UInt32(kVK_ANSI_S): "S",
            UInt32(kVK_ANSI_T): "T",
            UInt32(kVK_ANSI_U): "U",
            UInt32(kVK_ANSI_V): "V",
            UInt32(kVK_ANSI_W): "W",
            UInt32(kVK_ANSI_X): "X",
            UInt32(kVK_ANSI_Y): "Y",
            UInt32(kVK_ANSI_Z): "Z",
            UInt32(kVK_ANSI_0): "0",
            UInt32(kVK_ANSI_1): "1",
            UInt32(kVK_ANSI_2): "2",
            UInt32(kVK_ANSI_3): "3",
            UInt32(kVK_ANSI_4): "4",
            UInt32(kVK_ANSI_5): "5",
            UInt32(kVK_ANSI_6): "6",
            UInt32(kVK_ANSI_7): "7",
            UInt32(kVK_ANSI_8): "8",
            UInt32(kVK_ANSI_9): "9",
            UInt32(kVK_ANSI_Equal): "=",
            UInt32(kVK_ANSI_Minus): "-",
            UInt32(kVK_ANSI_RightBracket): "]",
            UInt32(kVK_ANSI_LeftBracket): "[",
            UInt32(kVK_ANSI_Quote): "'",
            UInt32(kVK_ANSI_Semicolon): ";",
            UInt32(kVK_ANSI_Backslash): "\\",
            UInt32(kVK_ANSI_Comma): ",",
            UInt32(kVK_ANSI_Slash): "/",
            UInt32(kVK_ANSI_Period): ".",
            UInt32(kVK_ANSI_Grave): "`",
            UInt32(kVK_ANSI_KeypadDecimal): "Num.",
            UInt32(kVK_ANSI_KeypadMultiply): "Num*",
            UInt32(kVK_ANSI_KeypadPlus): "Num+",
            UInt32(kVK_ANSI_KeypadClear): "NumClear",
            UInt32(kVK_ANSI_KeypadDivide): "Num/",
            UInt32(kVK_ANSI_KeypadEnter): "NumEnter",
            UInt32(kVK_ANSI_KeypadMinus): "Num-",
            UInt32(kVK_ANSI_KeypadEquals): "Num=",
            UInt32(kVK_ANSI_Keypad0): "Num0",
            UInt32(kVK_ANSI_Keypad1): "Num1",
            UInt32(kVK_ANSI_Keypad2): "Num2",
            UInt32(kVK_ANSI_Keypad3): "Num3",
            UInt32(kVK_ANSI_Keypad4): "Num4",
            UInt32(kVK_ANSI_Keypad5): "Num5",
            UInt32(kVK_ANSI_Keypad6): "Num6",
            UInt32(kVK_ANSI_Keypad7): "Num7",
            UInt32(kVK_ANSI_Keypad8): "Num8",
            UInt32(kVK_ANSI_Keypad9): "Num9",
        ]
    }

    static let shared = HotkeyManager()
    static let shortcutDidChangeNotification = Notification.Name("HotkeyManagerShortcutDidChange")

    var shortcut: Shortcut? {
        didSet {
            saveShortcut(shortcut)
            reRegisterHotKey()
            NotificationCenter.default.post(name: Self.shortcutDidChangeNotification, object: nil)
        }
    }

    private var handler: (() -> Void)?
    private var hotKeyRef: EventHotKeyRef?
    private var eventHandlerRef: EventHandlerRef?
    private let storageKey = "vimhint.toggleSidebarShortcut"
    private let hotKeyID = EventHotKeyID(signature: OSType(0x56484B59), id: 1)
    private var isRecordingShortcut = false
    private var suppressTriggerUntil: CFAbsoluteTime = 0

    private init() {
        installEventHandlerIfNeeded()
        shortcut = loadShortcut()
        reRegisterHotKey()
    }

    func onTrigger(_ handler: @escaping () -> Void) {
        self.handler = handler
    }

    func beginShortcutRecording() {
        isRecordingShortcut = true
        suppressTriggerUntil = CFAbsoluteTimeGetCurrent() + 0.8
    }

    func endShortcutRecording() {
        isRecordingShortcut = false
        suppressTriggerUntil = CFAbsoluteTimeGetCurrent() + 0.5
    }

    private func installEventHandlerIfNeeded() {
        guard eventHandlerRef == nil else { return }

        var eventSpec = EventTypeSpec(
            eventClass: OSType(kEventClassKeyboard),
            eventKind: UInt32(kEventHotKeyPressed)
        )

        InstallEventHandler(
            GetApplicationEventTarget(),
            Self.eventHandler,
            1,
            &eventSpec,
            UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()),
            &eventHandlerRef
        )
    }

    private func reRegisterHotKey() {
        if let hotKeyRef {
            UnregisterEventHotKey(hotKeyRef)
            self.hotKeyRef = nil
        }

        guard let shortcut else { return }

        RegisterEventHotKey(
            shortcut.keyCode,
            shortcut.modifiers,
            hotKeyID,
            GetApplicationEventTarget(),
            0,
            &hotKeyRef
        )
    }

    private func saveShortcut(_ shortcut: Shortcut?) {
        guard let shortcut else {
            UserDefaults.standard.removeObject(forKey: storageKey)
            return
        }

        guard let data = try? JSONEncoder().encode(shortcut) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }

    private func loadShortcut() -> Shortcut? {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else { return nil }
        return try? JSONDecoder().decode(Shortcut.self, from: data)
    }

    private static let eventHandler: EventHandlerUPP = { _, eventRef, userData in
        guard let eventRef, let userData else { return OSStatus(eventNotHandledErr) }

        var incomingID = EventHotKeyID()
        let status = GetEventParameter(
            eventRef,
            EventParamName(kEventParamDirectObject),
            EventParamType(typeEventHotKeyID),
            nil,
            MemoryLayout<EventHotKeyID>.size,
            nil,
            &incomingID
        )

        guard status == noErr else { return status }

        let manager = Unmanaged<HotkeyManager>.fromOpaque(userData).takeUnretainedValue()
        guard incomingID.signature == manager.hotKeyID.signature, incomingID.id == manager.hotKeyID.id else {
            return OSStatus(eventNotHandledErr)
        }

        let now = CFAbsoluteTimeGetCurrent()
        guard !manager.isRecordingShortcut, now >= manager.suppressTriggerUntil else {
            return noErr
        }

        manager.handler?()
        return noErr
    }
}
