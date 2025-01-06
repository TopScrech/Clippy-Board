import SwiftUI
import SwiftData

@Observable
final class PasteboardVM {
    private var timer: Timer?
    var copiedItems: [String] = []
    
    private var focusedAppName: String? = nil
    private var workspaceObserver: NSObjectProtocol?
    
    init() {
        timer = Timer.scheduledTimer(withTimeInterval: SettingsStorage().detectionSpeed, repeats: true) { _ in
            self.checkCopyboard()
        }
        
        startObservingFocusedApp()
    }
    
    deinit {
        timer?.invalidate()
        
        stopObservingFocusedApp()
    }
    
    private func checkCopyboard() {
        let currentItems = NSPasteboard.general.pasteboardItems?.compactMap {
            $0.string(forType: .string)
        } ?? []
        
        if !currentItems.isEmpty {
            copiedItems = currentItems
        }
    }
    
    private func stopObservingFocusedApp() {
        guard let workspaceObserver else {
            return
        }
        
        NotificationCenter.default.removeObserver(workspaceObserver)
    }
    
    private func startObservingFocusedApp() {
        workspaceObserver = NSWorkspace.shared.notificationCenter.addObserver(
            forName: NSWorkspace.didActivateApplicationNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard
                let app = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication,
                let appName = app.localizedName
            else {
                self?.focusedAppName = nil
                return
            }
            
            self?.focusedAppName = appName
        }
    }
}
