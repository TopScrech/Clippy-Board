import ScrechKit
import SwiftData

struct MenuBarExtraView: View {
    @EnvironmentObject private var settings: SettingsStorage
    @Environment(PasteboardVM.self) private var pasteboardObserver
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow
    
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [PasteboardItem]
    
    @State private var document = TextFile()
    @State private var search = ""
    
    var founditems: [PasteboardItem] {
        if search.isEmpty {
            items
        } else {
            items.filter {
                $0.content.contains(search)
            }
        }
    }
    
    var body: some View {
        VStack {
            List {
                TextField("Search", text: $search)
                    .autocorrectionDisabled()
                    .textFieldStyle(.roundedBorder)
                
                if founditems.isEmpty {
                    ContentUnavailableView.search(text: search)
                } else {
                    ForEach(founditems.reversed()) { item in
                        PasteboardCard(item)
                    }
                }
            }
            .scrollIndicators(.never)
            .frame(minHeight: 200)
            //            .overlay {
            //                if founditems.isEmpty {
            //                    ContentUnavailableView.search(text: search)
            //                }
            //            }
            
            Toggle("Show time", isOn: $settings.showTime)
            
            Picker("Detection speed", selection: $settings.detectionSpeed) {
                Text("Slow")
                    .tag(5)
                
                Text("Fast")
                    .tag(1)
                
                Text("Very fast")
                    .tag(0.1)
            }
            .padding(.horizontal)
            
            HStack {
                Button("Clear All") {
                    clearAll()
                }
                                
                Button("Quit", role: .destructive) {
                    NSApplication.shared.terminate(nil)
                }
            }
            
            HStack {
                Button("Dismiss window") {
                    dismissWindow(id: "pasteboard")
                }
                
                Button("Open window") {
                    openWindow(id: "pasteboard")
                }
            }
            .padding(.bottom)
        }
    }
    
    private func clearAll() {
        for item in items {
            modelContext.delete(item)
        }
    }
}

#Preview {
    MenuBarExtraView()
        .environment(PasteboardVM())
        .environmentObject(SettingsStorage())
}
