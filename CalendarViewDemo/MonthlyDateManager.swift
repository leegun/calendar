//
//  MonthlyDateManager.swift
//  CalendarViewDemo
//
//  Created by g.lee on 2017/02/06.
//  Copyright © 2017年 g.lee. All rights reserved.
//

import Foundation

struct MonthlyDateManager: DateManager {

    let daysPerWeek: Int = 7
    let weekCount: Int
    let dayCount: Int
    let firstDate: Date
    var dates: [Date]
    var scheduledDates: [Date]
    var selectedDate: Date

    var prevDateManager: DateManager {
        let calendar = Calendar(identifier: .gregorian)
        var components = calendar.dateComponents([.year, .month, .day], from: self.selectedDate)
        components.month = components.month! - 1
        components.day = components.month == todayComponents.month && components.year == todayComponents.year ? todayComponents.day : 1
        let date = calendar.date(from: components)!
        return MonthlyDateManager(selectedDate: date, scheduledDates: scheduledDates)
    }

    var nextDateManager: DateManager {
        let calendar = Calendar(identifier: .gregorian)
        var components = calendar.dateComponents([.year, .month, .day], from: self.selectedDate)
        components.month = components.month! + 1
        components.day = components.month == todayComponents.month && components.year == todayComponents.year ? todayComponents.day : 1
        let date = calendar.date(from: components)!
        return MonthlyDateManager(selectedDate: date, scheduledDates: scheduledDates)
    }

    var refreshDateManager: DateManager {
        return MonthlyDateManager(selectedDate: selectedDate, scheduledDates: scheduledDates)
    }

    init(selectedDate: Date = Date(), scheduledDates: [Date] = [Date]()) {

        let calendar = Calendar(identifier: .gregorian)

        self.selectedDate = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: selectedDate))!

        var components = calendar.dateComponents([.year, .month, .day], from: self.selectedDate)
        components.day = 1
        firstDate = calendar.date(from: components)!

        let rangeOfWeeks = calendar.range(of: .weekOfMonth, in: .month, for: firstDate)!
        self.weekCount = rangeOfWeeks.count

        self.dayCount = weekCount * daysPerWeek

        dates = [Date]()
        let ordinalityOfFirstDay =  calendar.ordinality(of: .day, in: .weekOfMonth, for: firstDate)!
        for day in 1...dayCount {
            var dateComponents = DateComponents()
            dateComponents.day = day - ordinalityOfFirstDay
            if let date = calendar.date(byAdding: dateComponents, to: firstDate) {
                dates.append(date)
            }
        }

        self.scheduledDates = scheduledDates
    }

    func isCurrentMonth(date: Date) -> Bool {

        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: date)
        let currentComponents = calendar.dateComponents([.year, .month], from: firstDate)
        return (components.month == currentComponents.month) && (components.year == currentComponents.year)
    }
}
