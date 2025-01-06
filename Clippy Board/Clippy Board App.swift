import ScrechKit
import SwiftData

@main
struct MyApp: App {
    @StateObject private var settings = SettingsStorage()
    @State private var boardObserver = PasteboardVM()
    
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
#warning("MenuBarExtra")
        //        MenuBarExtra("Test", systemImage: "hammer") {
        //            MenuBarExtraView()
        //                .modelContainer(container)
        //                .environmentObject(settings)
        //                .environment(boardObserver)
        //        }
        //        .menuBarExtraStyle(.window)
        
        WindowGroup("Pasteboard", id: "pasteboard") {
            PasteboardList()
                .modelContainer(container)
                .environment(boardObserver)
                .environmentObject(settings)
        }
        
        Settings {
            SettingsView()
        }
    }
}
