import SwiftUI

struct MenuBarPasteboardCard: View {
    @EnvironmentObject private var settings: SettingsStorage
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
            
            if settings.showTime {
                Text(item.date, style: .time)
                    .footnote()
                    .foregroundStyle(.secondary)
            }
        }
        .buttonStyle(.accessoryBar)
        .contextMenu {
            Button {
                NSPasteboard.general.clearContents()
                NSPasteboard.general.setString(item.content, forType: .string)
            } label: {
                Label("Copy", systemImage: "doc.on.doc")
            }
            
            ShareLink(item: item.content) {
                Label("Share", systemImage: "square.and.arrow.up")
            }
            
            Section {
                Button(role: .destructive) {
                    modelContext.delete(item)
                } label: {
                    Label("Remove", systemImage: "trash")
                }
            }
        }
    }
}

#Preview {
    MenuBarPasteboardCard(.init(content: "Preview", date: Date()))
}
