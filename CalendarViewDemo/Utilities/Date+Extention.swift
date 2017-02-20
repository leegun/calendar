//
//  Date+Extention.swift
//  CalendarViewDemo
//
//  Created by g.lee on 2017/02/16.
//  Copyright © 2017年 g.lee. All rights reserved.
//

import Foundation

extension Date {

    var todayComponents: DateComponents {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
        return components
    }

    var today: Date {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
        let today = calendar.date(from: components)
        return today!
    }

    var isToday: Bool {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.isDateInToday(self)
    }

    var prevDate: Date {
        let calendar = Calendar(identifier: .gregorian)
        var components = calendar.dateComponents([.year, .month, .day], from: self)
        components.day = components.day! - 1
        return calendar.date(from: components)!
    }

    var nextDate: Date {
        let calendar = Calendar(identifier: .gregorian)
        var components = calendar.dateComponents([.year, .month, .day], from: self)
        components.day = components.day! + 1
        return calendar.date(from: components)!
    }

    var firstDate: Date {
        let calendar = Calendar(identifier: .gregorian)
        var components = calendar.dateComponents([.year, .month, .day], from: self)
        components.day = 1
        return calendar.date(from: components)!
    }
    
    func isSameMonth(date: Date) -> Bool {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)
        let argComponents = calendar.dateComponents([.year, .month], from: date)
        return (components.month == argComponents.month) && (components.year == argComponents.year)
    }
}
