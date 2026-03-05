import SwiftUI
import SwiftData

struct PasteboardList: View {
    @Environment(PasteboardVM.self) private var vm
    
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [PasteboardItem]
    
    var body: some View {
        List {
            Section {
                HStack {
                    Button("Clear All", action: clearAll)
                    Button("Print All", action: printAll)
                }
            }
            
            ForEach(items) {
                PasteboardCard($0)
            }
        }
        .onChange(of: vm.clipboardContent) { _, newValue in
            guard let newValue else { return }
            
            guard let sameItem = items.first(where: {
                $0.content == newValue.content
            }) else {
                modelContext.insert(newValue)
                return
            }
            
            sameItem.date = Date()
            try? modelContext.save()
        }
    }
    
    private func clearAll() {
        for item in items {
            modelContext.delete(item)
        }
    }
    
    private func printAll() {
        for item in items {
            print("\(item.content) | \(item.date) | \(item.app ?? "-")")
        }
    }
}

#Preview {
    PasteboardList()
}
