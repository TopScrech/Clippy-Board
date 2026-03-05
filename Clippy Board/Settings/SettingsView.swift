import SwiftUI
import SwiftData
import LaunchAtLogin
import ServiceManagement

struct SettingsView: View {
    //    private var exporter = TextFileExporter()
    @Query private var items: [PasteboardItem]
    
    var body: some View {
        VStack {
#warning("Show status")
            LaunchAtLogin.Toggle()
            
            //            Button("Export") {
            //                let array = items.map {
            //                    $0.content
            //                }
            //
            //                exporter.exportToFile(array)
            //            }
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
