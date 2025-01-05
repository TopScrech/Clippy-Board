import ScrechKit
import SwiftData
import ServiceManagement

@main
struct MyApp: App {
    @NSApplicationDelegateAdaptor(AutoLaunchAppDelegate.self) var appDelegate
    @StateObject private var settings = SettingsStorage()
    private var boardObserver = PasteboardVM()
    
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
                .task {
                    do {
                        try SMAppService.mainApp.register()
                    } catch {
                        print("Fuf")
                    }
                }
        }
    }
}

//extension Notification.Name {
//    static let killLauncher = Notification.Name("killLauncher")
//}

//@NSApplicationMain
//class AppDelegate: NSObject {}

//extension AppDelegate: NSApplicationDelegate {
//    func applicationDidFinishLaunching(_ aNotification: Notification) {
//
//        let launcherAppId = "com.tiborbodecs.LauncherApplication"
//        let runningApps = NSWorkspace.shared.runningApplications
//
//        let isRunning = !runningApps.filter {
//            $0.bundleIdentifier == launcherAppId
//        }.isEmpty
//
//        SMLoginItemSetEnabled(launcherAppId as CFString, true)
//
//        if isRunning {
//            DistributedNotificationCenter.default().post(
//                name: .killLauncher,
//                object: Bundle.main.bundleIdentifier!
//            )
//        }
//    }
//}
