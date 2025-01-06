import SwiftUI

struct Pasteboard_Card: View {
    private let item: PasteboardItem
    
    init(_ item: PasteboardItem) {
        self.item = item
    }
    
    var body: some View {
        Button {
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString(item.content, forType: .string)
        } label: {
            Text(item.content)
                .lineLimit(1)
        }
        .buttonStyle(.plain)
    }
}

//#Preview {
//    PasteboardCard()
//}
