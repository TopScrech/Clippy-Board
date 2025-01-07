import SwiftUI
import SwiftData

struct PasteboardList: View {
    @Environment(PasteboardVM.self) private var pasteboardObserver
    
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
        //        .onChange(of: pasteboardObserver.copiedItem) { _, newValue in
        //            guard let newValue else {
        //                return
        //            }
        //
        //            print("Copied: \(newValue)")
        //        }
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
