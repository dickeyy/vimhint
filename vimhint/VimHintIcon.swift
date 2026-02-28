import SwiftUI

/// Minimal template icon for the menu bar and popover header.
/// Visual language: vim-style chevrons with a cursor bar in the middle.
struct VimHintIcon: View {
    var body: some View {
        HStack(spacing: 2) {
            Image(systemName: "chevron.left")
            Rectangle()
                .frame(width: 1.2, height: 8)
            Image(systemName: "chevron.right")
        }
        .font(.system(size: 7.5, weight: .semibold))
        .frame(width: 14, height: 14)
        .foregroundStyle(.primary)
        .accessibilityLabel("vimhint")
    }
}

#Preview {
    VimHintIcon()
        .padding()
}
