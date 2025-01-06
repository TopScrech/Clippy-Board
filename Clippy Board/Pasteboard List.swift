import SwiftUI
import SwiftData

struct PasteboardList: View {
    @Environment(PasteboardVM.self) private var pasteboardObserver
    
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [PasteboardItem]
    
    var body: some View {
        List {
            ForEach(items) { item in
                PasteboardCard(item)
            }
        }
        .onChange(of: pasteboardObserver.copiedItems) { _, newValue in
            if items.last?.content != newValue.first {
                appendNewItems(newValue)
            }
        }
    }
    
    private func appendNewItems(_ newItems: [String]) {
        for item in newItems {
            modelContext.insert(PasteboardItem(content: item, date: Date()))
        }
    }
    
    private func clearAll() {
        for item in items {
            modelContext.delete(item)
        }
    }
}

#Preview {
    PasteboardList()
}
