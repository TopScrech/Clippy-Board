import SwiftUI

class AutoLaunchAppDelegate: NSObject, NSApplicationDelegate {
    var pasteboardObserver: PasteboardVM!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        pasteboardObserver = PasteboardVM()
    }
}
