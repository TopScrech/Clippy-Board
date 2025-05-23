import SwiftUI
import SwiftData

@Observable
final class PasteboardVM {
    var focusedAppName: String? = nil
    var clipboardContent: PasteboardItem? = nil
    private var workspaceObserver: NSObjectProtocol?
    
    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onPasteboardChanged),
            name: .NSPasteboardDidChange,
            object: nil
        )
        
        startObservingFocusedApp()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        
        stopObservingFocusedApp()
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
            guard !item.isEmpty else {
                return
            }
            
            print("Copied \(item.prefix(40))")
            
            if let app = self.focusedAppName {
                print("From \(app)")
                
                self.clipboardContent = PasteboardItem(
                    content: item,
                    app: app
                )
            } else {
                print("No app")
                
                self.clipboardContent = PasteboardItem(
                    content: item
                )
            }
        }
    }
    
    private func startObservingFocusedApp() {
        workspaceObserver = NSWorkspace.shared.notificationCenter.addObserver(
            forName: NSWorkspace.didActivateApplicationNotification,
            object: nil,
            queue: .main
        ) { notification in
            guard
                let app = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication,
                let appName = app.localizedName
            else {
                self.focusedAppName = nil
                return
            }
            
            self.focusedAppName = appName
        }
    }
    
    private func stopObservingFocusedApp() {
        guard let workspaceObserver else {
            return
        }
        
        NotificationCenter.default.removeObserver(workspaceObserver)
    }
}
