import SwiftUI
import LaunchAtLogin

struct SettingsView: View {
    var body: some View {
        VStack {
            LaunchAtLogin.Toggle {
                Text(LaunchAtLogin.isEnabled ? "Launch at login 🦄" : "Disable launch at login")
            }
        }
    }
}

#Preview {
    SettingsView()
}
