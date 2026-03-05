import SwiftUI

struct PasteboardCard: View {
    private let item: PasteboardItem
    
    init(_ item: PasteboardItem) {
        self.item = item
    }
    
    var body: some View {
        Button {
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString(item.content, forType: .string)
        } label: {
            VStack(alignment: .leading) {
                Text(item.content)
                    .lineLimit(1)
                
                Text(item.date, format: .dateTime)
                
                Text(item.app ?? "-")
            }
        }
        .buttonStyle(.plain)
    }
}

//#Preview {
//    PasteboardCard()
//}
