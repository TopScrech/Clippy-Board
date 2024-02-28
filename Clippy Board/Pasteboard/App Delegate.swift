import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var pasteboardObserver: PasteboardVM!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        pasteboardObserver = PasteboardVM()
    }
}
