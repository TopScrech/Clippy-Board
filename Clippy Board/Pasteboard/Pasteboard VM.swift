import SwiftUI
import SwiftData

@Observable
final class PasteboardVM {
    private var timer: Timer?
    var copiedItem: [String] = []
    
    init() {
        timer = Timer.scheduledTimer(withTimeInterval: SettingsStorage().detectionSpeed, repeats: true) { _ in
            self.checkCopyboard()
        }
    }
    
    deinit {
        timer?.invalidate()
    }
    
    private func checkCopyboard() {
        let currentItems = NSPasteboard.general.pasteboardItems?.compactMap {
            $0.string(forType: .string)
        } ?? []
        
        if !currentItems.isEmpty {
            copiedItem = currentItems
        }
    }
}
