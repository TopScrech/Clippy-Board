import ScrechKit
import SwiftData

struct MenuBarExtraView: View {
    @StateObject private var exporter = TextFileExporter()
    @EnvironmentObject private var settings: SettingsStorage
    @Environment(PasteboardVM.self) private var pasteboardObserver
    @Environment(\.openWindow) var openWindow
    @Environment(\.dismissWindow) var dismissWindow
    
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
            //            .overlay {
            //                if founditems.isEmpty {
            //                    ContentUnavailableView.search(text: search)
            //                }
            //            }
            
            Toggle("Show time", isOn: $settings.showTime)
            
            Picker("Detection speed", selection: $settings.detectionSpeed) {
                Text("Slow")
                    .tag(5.0)
                
                Text("Fast")
                    .tag(1.0)
                
                Text("Very fast")
                    .tag(0.1)
            }
            .padding(.horizontal)
            
            HStack {
                Button("Clear All") {
                    clearAll()
                }
                
                Button("Export") {
                    let array = items.map {
                        $0.content
                    }
                    
                    exporter.exportToFile(array)
                }
                
                Button("Quit", role: .destructive) {
                    NSApplication.shared.terminate(nil)
                }
            }
            
            HStack {
                Button("Open window") {
                    openWindow(id: "pasteboard")
                }
                
                Button("Dismiss window") {
                    dismissWindow(id: "pasteboard")
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

final class TextFileExporter: ObservableObject {
    private let panel = NSSavePanel()
    
    func exportToFile(_ array: [String]) {
        main {
            self.setupSavePanel()
            
            if self.panel.runModal() == .OK {
                self.writeToFile(array, url: self.panel.url)
            }
        }
    }
    
    private func setupSavePanel() {
        panel.allowedContentTypes = [.text]
        panel.directoryURL = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first
        panel.nameFieldStringValue = "ExportedFile.txt"
    }
    
    private func writeToFile(_ array: [String], url: URL?) {
        guard let url else { return }
        
        let text = array.joined(separator: "\n")
        
        do {
            try text.write(to: url, atomically: true, encoding: .utf8)
        } catch {
            print("Failed to write to file: \(error)")
        }
    }
}

#Preview {
    MenuBarExtraView()
        .environment(PasteboardVM())
        .environmentObject(SettingsStorage())
}
