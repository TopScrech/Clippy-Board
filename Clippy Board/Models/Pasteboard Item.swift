import Foundation
import SwiftData

@Model
final class PasteboardItem {
    var content = ""
    var date = Date()
    
    init(content: String, date: Date) {
        self.content = content
        self.date = date
    }
}
