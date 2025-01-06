import ScrechKit

@Observable
final class TextFileExporter {
    
    func exportToFile(_ array: [String]) {
        main {
            let panel = NSSavePanel()
            
            panel.allowedContentTypes = [.text]
            panel.nameFieldStringValue = "ExportedFile.txt"
            panel.directoryURL = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first
            
            if panel.runModal() == .OK {
                self.writeToFile(array, url: panel.url)
            }
        }
    }
    
    private func writeToFile(_ array: [String], url: URL?) {
        guard let url else {
            return
        }
        
        let text = array.joined(separator: "\n")
        
        do {
            try text.write(to: url, atomically: true, encoding: .utf8)
        } catch {
            print("Failed to write to file: \(error)")
        }
    }
}
