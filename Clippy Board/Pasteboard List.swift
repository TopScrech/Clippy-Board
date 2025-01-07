import SwiftUI
import SwiftData

struct PasteboardList: View {
    @Environment(PasteboardVM.self) private var vm
    
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [PasteboardItem]
    
    var body: some View {
        List {
            Section {
                Button("Clear All") {
                    clearAll()
                }
            }
            
            ForEach(items) { item in
                PasteboardCard(item)
            }
        }
        .onChange(of: vm.clipboardContent) { _, newValue in
            guard let newValue else {
                return
            }
            
            let newItem = PasteboardItem(
                content: newValue,
                app: vm.focusedAppName
            )
            
            guard let sameItem = items.first(where: {
                $0.content == newItem.content
            }) else {
                modelContext.insert(newItem)
                return
            }
            
            sameItem.date = Date()
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
