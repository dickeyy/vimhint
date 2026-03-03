import SwiftUI

/// Menu bar icon matching the app icon's cursive "vh" lettering.
struct VimHintIcon: View {
    var body: some View {
        Text("vh")
            .font(.custom("Snell Roundhand", size: 13))
            .fontWeight(.bold)
            .baselineOffset(-1)
            .frame(width: 18, height: 18)
            .foregroundStyle(.primary)
            .accessibilityLabel("vimhint")
    }
}

#Preview {
    VimHintIcon()
        .padding()
}
