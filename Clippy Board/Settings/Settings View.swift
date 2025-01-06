import SwiftUI
import LaunchAtLogin
import ServiceManagement

struct SettingsView: View {
    var body: some View {
        VStack {
            LaunchAtLogin.Toggle {
                Text(LaunchAtLogin.isEnabled ? "Launch at login 🦄" : "Disable launch at login")
                
#warning("Show status")
                //                Text(serviceManagementStatus())
            }
        }
        .padding()
    }
    
    private func serviceManagementStatus() -> String {
        switch SMAppService.mainApp.status {
        case .notRegistered:
            "The service hasn’t registered with the Service Management framework, or the service attempted to reregister after it was already registered"
            
        case .enabled:
            "The service has been successfully registered and is eligible to run"
            
        case .requiresApproval:
            "The service has been successfully registered, but the user needs to take action in System Preferences"
            
        case .notFound:
            "An error occurred and the framework couldn’t find this service"
            
        default:
            "Unknown default"
        }
    }
}

#Preview {
    SettingsView()
}
