import SwiftUI

final class SettingsStorage: ObservableObject {
    @AppStorage("show_time") var showTime = false
    @AppStorage("detection_speed") var detectionSpeed = 1.0
}
