//
//  MenuItem.swift
//  DayList
//

import UIKit

struct MenuItem {
    let title: String
    let systemIconName: String  // Fallback system icon
    let customIcon: UIImage?    // Custom icon (optional)
    let count: Int?
    let destination: MenuDestination
    
    // Convenience initializer with custom icon
    init(title: String, customIconName: String, systemIcon: String, count: Int? = nil, destination: MenuDestination) {
        self.title = title
        self.systemIconName = systemIcon
        self.customIcon = UIImage(named: customIconName)
        self.count = count
        self.destination = destination
    }
    
    // Initializer without custom icon
    init(title: String, systemIcon: String, count: Int? = nil, destination: MenuDestination) {
        self.title = title
        self.systemIconName = systemIcon
        self.customIcon = nil
        self.count = count
        self.destination = destination
    }
}

enum MenuDestination {
    case today
    case upcoming
    case calendar
    case stickyWall
}
