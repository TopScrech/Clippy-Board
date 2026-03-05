import SwiftUI

struct MenuBarPasteboardCard: View {
    @EnvironmentObject private var store: ValueStore
    @Environment(\.modelContext) private var modelContext
    
    @Bindable private var item: PasteboardItem
    
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
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if store.showTime {
                Text(item.date, style: .time)
                    .footnote()
                    .foregroundStyle(.secondary)
            }
        }
        .buttonStyle(.accessoryBar)
        .contextMenu {
            Button("Copy", systemImage: "doc.on.doc") {
                NSPasteboard.general.clearContents()
                NSPasteboard.general.setString(item.content, forType: .string)
            }
            
            ShareLink(item: item.content) {
                Label("Share", systemImage: "square.and.arrow.up")
            }
            
            Section {
                Button("Remove", systemImage: "trash", role: .destructive) {
                    modelContext.delete(item)
                }
            }
        }
    }
}

#Preview {
    MenuBarPasteboardCard(.init(content: "Preview", date: Date()))
}
