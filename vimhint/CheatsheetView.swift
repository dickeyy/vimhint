import SwiftUI
import KeyboardShortcuts

// MARK: - Data

struct VimHint: Identifiable {
    let id = UUID()
    let key: String
    let description: String
}

struct VimSection {
    let title: String
    let hints: [VimHint]
}

private let sections: [VimSection] = [
    VimSection(title: "Motion", hints: [
        VimHint(key: "h / j / k / l", description: "Left / down / up / right"),
        VimHint(key: "w / b / e / ge", description: "Word motions"),
        VimHint(key: "0 / ^ / $", description: "Line start / first char / line end"),
        VimHint(key: "gg / G", description: "Top / bottom of file"),
        VimHint(key: "H / M / L", description: "Top / middle / bottom of screen"),
        VimHint(key: "{ / }", description: "Previous / next paragraph"),
        VimHint(key: "( / )", description: "Previous / next sentence"),
        VimHint(key: "%", description: "Jump matching bracket/paren"),
        VimHint(key: "f{c} / F{c}", description: "Find char forward / backward"),
        VimHint(key: "t{c} / T{c}", description: "Till char forward / backward"),
        VimHint(key: "; / ,", description: "Repeat last f/t forward / backward"),
        VimHint(key: "Ctrl+d / Ctrl+u", description: "Half page down / up"),
        VimHint(key: "Ctrl+f / Ctrl+b", description: "Page down / up"),
    ]),
    VimSection(title: "Insert & Change", hints: [
        VimHint(key: "i / I", description: "Insert at cursor / line start"),
        VimHint(key: "a / A", description: "Append after cursor / line end"),
        VimHint(key: "o / O", description: "Open line below / above"),
        VimHint(key: "s / S", description: "Substitute char / entire line"),
        VimHint(key: "c{motion}", description: "Change by motion"),
        VimHint(key: "cc / C", description: "Change line / to end of line"),
        VimHint(key: "r{c}", description: "Replace one character"),
        VimHint(key: "R", description: "Replace mode"),
        VimHint(key: "Esc", description: "Return to Normal mode"),
    ]),
    VimSection(title: "Delete, Yank, Paste", hints: [
        VimHint(key: "x / X", description: "Delete char / before cursor"),
        VimHint(key: "d{motion}", description: "Delete by motion"),
        VimHint(key: "dd / D", description: "Delete line / to line end"),
        VimHint(key: "y{motion}", description: "Yank by motion"),
        VimHint(key: "yy / Y", description: "Yank line"),
        VimHint(key: "p / P", description: "Paste after / before cursor"),
        VimHint(key: ">> / <<", description: "Indent / outdent line"),
        VimHint(key: ">{motion} / <{motion}", description: "Indent / outdent by motion"),
        VimHint(key: "J", description: "Join line below"),
    ]),
    VimSection(title: "Visual Mode", hints: [
        VimHint(key: "v / V / Ctrl+v", description: "Character / line / block visual"),
        VimHint(key: "o", description: "Jump to opposite side of selection"),
        VimHint(key: "gv", description: "Re-select previous visual area"),
        VimHint(key: "d / c / y", description: "Delete / change / yank selection"),
        VimHint(key: "> / <", description: "Indent / outdent selected text"),
        VimHint(key: "~", description: "Swap case in selection"),
    ]),
    VimSection(title: "Text Objects", hints: [
        VimHint(key: "iw / aw", description: "Inner word / around word"),
        VimHint(key: "iW / aW", description: "Inner WORD / around WORD"),
        VimHint(key: "ip / ap", description: "Inner paragraph / around paragraph"),
        VimHint(key: "i( / a(", description: "Inside / around parentheses"),
        VimHint(key: "i[ / a[", description: "Inside / around brackets"),
        VimHint(key: "i{ / a{", description: "Inside / around braces"),
        VimHint(key: "i\" / a\"", description: "Inside / around double quotes"),
        VimHint(key: "i' / a'", description: "Inside / around single quotes"),
        VimHint(key: "it / at", description: "Inside / around XML/HTML tag"),
    ]),
    VimSection(title: "Search & Replace", hints: [
        VimHint(key: "/{pattern}", description: "Search forward"),
        VimHint(key: "?{pattern}", description: "Search backward"),
        VimHint(key: "n / N", description: "Next / previous match"),
        VimHint(key: "* / #", description: "Search word under cursor fwd / back"),
        VimHint(key: "g* / g#", description: "Partial word search fwd / back"),
        VimHint(key: ":set hlsearch", description: "Highlight matches"),
        VimHint(key: ":nohlsearch", description: "Clear highlighted matches"),
        VimHint(key: ":%s/old/new/g", description: "Replace all in file"),
        VimHint(key: ":%s/old/new/gc", description: "Replace all with confirm"),
        VimHint(key: ":s/old/new/g", description: "Replace all in current line"),
    ]),
    VimSection(title: "Undo & Repeat", hints: [
        VimHint(key: "u", description: "Undo"),
        VimHint(key: "Ctrl+r", description: "Redo"),
        VimHint(key: ".", description: "Repeat last change"),
        VimHint(key: "@: ", description: "Repeat last Ex command"),
        VimHint(key: "q:", description: "Open command-line history"),
    ]),
    VimSection(title: "Marks & Jumps", hints: [
        VimHint(key: "m{a-z}", description: "Set local mark"),
        VimHint(key: "m{A-Z}", description: "Set global mark"),
        VimHint(key: "'{a} / `{a}", description: "Jump to mark line / exact column"),
        VimHint(key: "'' / ``", description: "Jump back to prior position"),
        VimHint(key: "Ctrl+o / Ctrl+i", description: "Jump back / forward list"),
        VimHint(key: "[{ / ]{", description: "Previous / next unmatched {"),
        VimHint(key: "[( / ](", description: "Previous / next unmatched ("),
    ]),
    VimSection(title: "Registers & Clipboard", hints: [
        VimHint(key: "\"{a-z}y", description: "Yank into named register"),
        VimHint(key: "\"{a-z}p", description: "Paste from named register"),
        VimHint(key: "\"+y / \"+p", description: "System clipboard yank / paste"),
        VimHint(key: "\"*y / \"*p", description: "Primary selection yank / paste"),
        VimHint(key: ":reg", description: "Show registers"),
        VimHint(key: "\"0", description: "Last yanked text register"),
        VimHint(key: "\".", description: "Last inserted text register"),
    ]),
    VimSection(title: "Macros", hints: [
        VimHint(key: "q{a-z}", description: "Start recording macro in register"),
        VimHint(key: "q", description: "Stop recording macro"),
        VimHint(key: "@{a-z}", description: "Play macro"),
        VimHint(key: "@@", description: "Repeat last macro"),
        VimHint(key: "{count}@{a-z}", description: "Run macro multiple times"),
    ]),
    VimSection(title: "Windows & Tabs", hints: [
        VimHint(key: "Ctrl+w s / v", description: "Split horizontal / vertical"),
        VimHint(key: "Ctrl+w h j k l", description: "Move between splits"),
        VimHint(key: "Ctrl+w w", description: "Cycle through windows"),
        VimHint(key: "Ctrl+w q / c", description: "Quit / close current split"),
        VimHint(key: "Ctrl+w =", description: "Equalize split sizes"),
        VimHint(key: "Ctrl+w _ / |", description: "Maximize height / width"),
        VimHint(key: ":tabnew", description: "Open new tab"),
        VimHint(key: "gt / gT", description: "Next / previous tab"),
        VimHint(key: ":tabclose", description: "Close current tab"),
    ]),
    VimSection(title: "Buffers", hints: [
        VimHint(key: ":ls", description: "List buffers"),
        VimHint(key: ":b {n}", description: "Go to buffer number"),
        VimHint(key: ":bn / :bp", description: "Next / previous buffer"),
        VimHint(key: ":bd", description: "Delete current buffer"),
        VimHint(key: ":e #", description: "Edit alternate file"),
        VimHint(key: "Ctrl+^", description: "Toggle alternate buffer"),
    ]),
    VimSection(title: "Folds", hints: [
        VimHint(key: "zc / zo", description: "Close / open fold"),
        VimHint(key: "za", description: "Toggle fold under cursor"),
        VimHint(key: "zM / zR", description: "Close all / open all folds"),
        VimHint(key: "zr / zm", description: "Reduce / increase fold level"),
        VimHint(key: ":set foldmethod=indent", description: "Fold by indentation"),
    ]),
    VimSection(title: "File & Quit", hints: [
        VimHint(key: ":w", description: "Write current file"),
        VimHint(key: ":wa", description: "Write all files"),
        VimHint(key: ":q / :q!", description: "Quit / force quit"),
        VimHint(key: ":wq / :x / ZZ", description: "Write and quit"),
        VimHint(key: ":e {file}", description: "Edit file"),
        VimHint(key: ":saveas {file}", description: "Save copy as file"),
        VimHint(key: ":!{cmd}", description: "Run shell command"),
    ]),
]

// MARK: - Views

struct CheatsheetView: View {
    @EnvironmentObject private var appState: AppState
    @State private var query = ""
    @State private var isEditingHotkey = false
    @State private var previousShortcut: KeyboardShortcuts.Shortcut?

    private var hotkeyText: String {
        if let shortcut = KeyboardShortcuts.getShortcut(for: .toggleSidebar) {
            return shortcut.description
        }
        return "Set keybind"
    }

    private func beginEditingHotkey() {
        previousShortcut = KeyboardShortcuts.getShortcut(for: .toggleSidebar)
        isEditingHotkey = true
    }

    private func finishEditingHotkey() {
        if KeyboardShortcuts.getShortcut(for: .toggleSidebar) == nil,
           let previousShortcut {
            KeyboardShortcuts.setShortcut(previousShortcut, for: .toggleSidebar)
        }
        isEditingHotkey = false
    }

    private var filteredSections: [VimSection] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return sections }

        let needle = trimmed.lowercased()

        return sections.compactMap { section in
            let titleMatch = section.title.lowercased().contains(needle)
            let hints = section.hints.filter {
                $0.key.lowercased().contains(needle)
                    || $0.description.lowercased().contains(needle)
            }

            if titleMatch {
                return section
            }

            guard !hints.isEmpty else { return nil }
            return VimSection(title: section.title, hints: hints)
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                HStack(spacing: 6) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(.tertiary)

                    TextField("Search", text: $query)
                        .textFieldStyle(.plain)
                        .font(.system(size: 11, weight: .regular, design: .default))
                        .autocorrectionDisabled(true)

                    if !query.isEmpty {
                        Button {
                            query = ""
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 8, weight: .semibold))
                                .foregroundStyle(.tertiary)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 5)
                .background(.ultraThinMaterial.opacity(0.45), in: Capsule())

                Spacer(minLength: 0)

                HStack(spacing: 4) {
                    VimHintIcon()
                        .scaleEffect(0.72)
                    Text("vimhint")
                        .font(.system(size: 9, weight: .medium, design: .monospaced))
                        .tracking(0.4)
                        .foregroundStyle(.tertiary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 12)
            .padding(.top, 6)
            .padding(.bottom, 6)

            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(filteredSections, id: \.title) { section in
                        SectionBlock(title: section.title, hints: section.hints)
                    }

                    if filteredSections.isEmpty {
                        Text("No matches")
                            .font(.system(size: 11, weight: .regular, design: .default))
                            .foregroundStyle(.tertiary)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 20)
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 16)
            }

            // Restore bar — only visible when the menu bar icon is hidden
            if !appState.showMenuBarIcon {
                HStack {
                    Button(hotkeyText) {
                        beginEditingHotkey()
                    }
                    .font(.system(size: 10, weight: .regular, design: .default))
                    .foregroundStyle(.tertiary)
                    .buttonStyle(.plain)
                    .popover(isPresented: $isEditingHotkey, arrowEdge: .top) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Set sidebar hotkey")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundStyle(.secondary)

                            KeyboardShortcuts.Recorder("", name: .toggleSidebar)
                                .frame(width: 128, alignment: .leading)

                            HStack {
                                Spacer()
                                Button("Done") {
                                    finishEditingHotkey()
                                }
                                .buttonStyle(.plain)
                                .font(.system(size: 11, weight: .regular))
                            }
                        }
                        .padding(10)
                        .frame(width: 180)
                    }

                    Spacer()

                    Button {
                        appState.setMenuBarIconVisible(true)
                    } label: {
                        Label("Show menu icon", systemImage: "eye")
                            .font(.system(size: 10, weight: .regular, design: .default))
                            .foregroundStyle(.tertiary)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
            }
        }
        .background(.clear)
        .onDisappear {
            if isEditingHotkey {
                finishEditingHotkey()
            }
        }
        .onChange(of: isEditingHotkey) { _, editing in
            if !editing {
                finishEditingHotkey()
            }
        }
    }
}

private struct SectionBlock: View {
    let title: String
    let hints: [VimHint]

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title.uppercased())
                .font(.system(size: 10, weight: .semibold, design: .monospaced))
                .foregroundStyle(.secondary)
                .padding(.bottom, 2)

            ForEach(hints) { hint in
                HintRow(hint: hint)
            }
        }
    }
}

private struct HintRow: View {
    let hint: VimHint

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            Text(hint.key)
                .font(.system(size: 12, weight: .medium, design: .monospaced))
                .foregroundStyle(.primary)
                .frame(width: 110, alignment: .leading)
                .lineLimit(1)
                .minimumScaleFactor(0.8)

            Text(hint.description)
                .font(.system(size: 12, weight: .regular, design: .default))
                .foregroundStyle(.secondary)
                .lineLimit(2)

            Spacer(minLength: 0)
        }
        .padding(.vertical, 1)
    }
}

#Preview {
    CheatsheetView()
        .environmentObject(AppState.shared)
        .frame(width: 320, height: 600)
}
