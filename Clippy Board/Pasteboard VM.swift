import SwiftUI
import SwiftData

@Observable
final class PasteboardVM {
    private var focusedAppName: String? = nil
    private var workspaceObserver: NSObjectProtocol?
    var clipboardContent = ""
    
    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onPasteboardChanged),
            name: .NSPasteboardDidChange,
            object: nil
        )
    }
    
    @objc
    private func onPasteboardChanged(_ notification: Notification) {
        guard
            let pb = notification.object as? NSPasteboard,
            let items = pb.pasteboardItems,
            let item = items.first?.string(forType: .string)
        else {
            return
        }
        
        DispatchQueue.main.async {
            print(item)
            self.clipboardContent = item
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
