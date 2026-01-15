//
//  Task.swift
//  DayList
//

import UIKit

struct Task {
    let id: String
    let title: String?
    let description: String?
    let dateText: String?
    let subtaskCount: Int
    let subtaskCountText: String?
    let listName: String?
    let tagColorHex: String?
    let tagColor: UIColor?
    var isCompleted: Bool
    
    // MARK: - Init from Core Data
    init(from entity: TaskEntity) {
        self.id = entity.taskId ?? UUID().uuidString
        self.title = entity.title
        self.description = entity.taskDescription
        self.dateText = entity.dateText
        self.subtaskCount = Int(entity.subtaskCount)
        self.listName = entity.listName
        self.tagColorHex = entity.tagColorHex
        self.isCompleted = entity.isCompleted
        
        // Compute subtaskCountText
        if entity.subtaskCount > 0 {
            self.subtaskCountText = "\(entity.subtaskCount)"
        } else {
            self.subtaskCountText = nil
        }
        
        // Convert hex color string to UIColor
        if let hex = entity.tagColorHex {
            self.tagColor = UIColor(hex: hex)
        } else {
            self.tagColor = nil
        }
    }
    
    // MARK: - Init for Dummy Data (NEW)
    init(
        id: String = UUID().uuidString,
        title: String,
        description: String? = nil,
        dateText: String? = nil,
        subtaskCountText: String? = nil,
        listName: String? = nil,
        tagColor: UIColor? = nil,
        isCompleted: Bool = false
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.dateText = dateText
        self.subtaskCountText = subtaskCountText
        self.listName = listName
        self.tagColor = tagColor
        self.isCompleted = isCompleted
        
        // Compute subtaskCount from text
        if let countText = subtaskCountText, let count = Int(countText) {
            self.subtaskCount = count
        } else {
            self.subtaskCount = 0
        }
        
        // Convert color to hex
        self.tagColorHex = tagColor?.hexString
    }
}

// MARK: - UIColor Hex Conversion

extension UIColor {
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let b = CGFloat((rgb & 0x0000FF)) / 255.0
        
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    var hexString: String {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: nil)
        return String(format: "#%02X%02X%02X",
                      Int(r * 255), Int(g * 255), Int(b * 255))
    }
}
