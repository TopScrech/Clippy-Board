import SwiftUI
import SwiftData

@Observable
final class PasteboardVM {
    private var timer: Timer?
    var copiedItem: String? = nil
    
    private var focusedAppName: String? = nil
    private var workspaceObserver: NSObjectProtocol?
    let pasteboard: NSPasteboard = .general
    var lastChangeCount: Int = 0
    
//    init() {
//        timer = Timer.scheduledTimer(withTimeInterval: SettingsStorage().detectionSpeed, repeats: true) { _ in
//            self.checkCopyboard()
//        }
//        
//        startObservingFocusedApp()
//    }
    
//    deinit {
//        timer?.invalidate()
//        
//        stopObservingFocusedApp()
//    }
    
    private func checkCopyboard() {
        //        guard let newCopiedItem = NSPasteboard.general.pasteboardItems?.last?.string(forType: .string) else {
        //            return
        //        }
        //
        //        if newCopiedItem != lastCopiedItem {
        //            lastCopiedItem = newCopiedItem
        //            copiedItem = newCopiedItem // Notify observers
        //
        //            if let app = focusedAppName {
        //                print("Copied \(newCopiedItem) from \(app)")
        //            }
        //
        //            saveToModelContext(newCopiedItem) // Save to database or context
        //        }
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

@Observable
final class ClipboardObserver {
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
}
