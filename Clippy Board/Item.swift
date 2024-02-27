//
//  Item.swift
//  Clippy Board
//
//  Created by Sergei Saliukov on 27/02/2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
