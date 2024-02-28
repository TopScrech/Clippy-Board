import SwiftUI
import ServiceManagement

struct DebugView: View {
    var body: some View {
        List {
            Button {
                serviceManagementStatus()
            } label: {
                Text("Launch at login")
            }
        }
    }
    
    private func serviceManagementStatus() {
        switch SMAppService.mainApp.status {
        case .notRegistered:
            print("The service hasn’t registered with the Service Management framework, or the service attempted to reregister after it was already registered")
            
        case .enabled:
            print("The service has been successfully registered and is eligible to run")
            
        case .requiresApproval:
            print("The service has been successfully registered, but the user needs to take action in System Preferences")
            
        case .notFound:
            print("An error occurred and the framework couldn’t find this service")
            
        @unknown default:
            print("Unknown default")
        }
    }
}

#Preview {
    DebugView()
}
