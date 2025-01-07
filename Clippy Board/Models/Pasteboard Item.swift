import Foundation
import SwiftData

@Model
final class PasteboardItem {
    var content = ""
    var app: String?
    var date = Date()
    
    init(content: String, app: String? = nil, date: Date = Date()) {
        self.content = content
        self.date = date
    }
}
