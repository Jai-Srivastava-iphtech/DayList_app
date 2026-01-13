//
//  WeekEvent.swift
//  DayList
//
//  Created by iPHTech4 on 1/13/26.
//

import Foundation
import UIKit
struct WeekEvent {
    let title: String
    let color: UIColor
}

private var weekEvents: [[WeekEvent]] = [
    [ WeekEvent(title: "Se..", color: .systemTeal),
      WeekEvent(title: "Sa..", color: .systemTeal) ],

    [ WeekEvent(title: "Co..", color: .systemYellow) ],

    [ WeekEvent(title: "Br..", color: .systemTeal) ],

    [ WeekEvent(title: "Bu..", color: .systemYellow) ],

    [], [], []
]
