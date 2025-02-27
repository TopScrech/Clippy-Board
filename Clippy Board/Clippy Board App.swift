import ScrechKit
import SwiftData

@main
struct MyApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @State private var vm = PasteboardVM()
    @StateObject private var settings = SettingsStorage()
    
    private let container: ModelContainer
    
    init() {
        let schema = Schema([PasteboardItem.self])
        
        do {
            container = try ModelContainer(for: schema)
        } catch {
            fatalError("Failed to create model container")
        }
    }
    
    var body: some Scene {
        MenuBarExtra("Menu Bar Extra", systemImage: "hammer") {
            MenuBarExtraView()
                .environment(vm)
                .modelContainer(container)
                .environmentObject(settings)
        }
        .menuBarExtraStyle(.window)
        
        WindowGroup("Pasteboard", id: "pasteboard") {
            PasteboardList()
                .environment(vm)
                .modelContainer(container)
                .environmentObject(settings)
        }
        
        Settings {
            SettingsView()
        }
    }
}
