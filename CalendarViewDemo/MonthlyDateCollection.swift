//
//  MonthlyDateCollection.swift
//  CalendarViewDemo
//
//  Created by g.lee on 2017/02/06.
//  Copyright © 2017年 g.lee. All rights reserved.
//

import Foundation

struct MonthlyDateCollection: DateCollection {

    let calendar = Calendar(identifier: .gregorian)
    let firstDate: Date
    let daysPerWeek: Int = 7
    let weekCount: Int
    let dayCount: Int
    var dates: [Date]
    var activeDates: [Date]
    var selectedDate: Date

    var prevDateCollection: DateCollection {
        var components = calendar.dateComponents([.year, .month, .day], from: self.selectedDate)
        components.month = components.month! - 1
        components.day = components.month == todayComponents.month && components.year == todayComponents.year ? todayComponents.day : 1
        let date = calendar.date(from: components)!
        return MonthlyDateCollection(selectedDate: date)
    }

    var nextDateCollection: DateCollection {
        var components = calendar.dateComponents([.year, .month, .day], from: self.selectedDate)
        components.month = components.month! + 1
        components.day = components.month == todayComponents.month && components.year == todayComponents.year ? todayComponents.day : 1
        let date = calendar.date(from: components)!
        return MonthlyDateCollection(selectedDate: date)
    }

    var changeMode: DateCollection {
        return WeeklyDateCollection(selectedDate: selectedDate)
    }

    init(selectedDate: Date = Date(), activeDates: [Date] = [Date]()) {

        // selectedDate
        self.selectedDate = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: selectedDate))!

        // firstDate
        var components = calendar.dateComponents([.year, .month, .day], from: self.selectedDate)
        components.day = 1
        let firstDate = calendar.date(from: components)!
        self.firstDate = firstDate

        // weekCount
        let rangeOfWeeks = calendar.range(of: .weekOfMonth, in: .month, for: firstDate)!
        self.weekCount = rangeOfWeeks.count

        // dayCount
        self.dayCount = weekCount * daysPerWeek

        // dates
        dates = [Date]()
        let ordinalityOfFirstDay =  calendar.ordinality(of: .day, in: .weekOfMonth, for: firstDate)!
        for day in 1...dayCount {
            var dateComponents = DateComponents()
            dateComponents.day = day - ordinalityOfFirstDay
            if let date = calendar.date(byAdding: dateComponents, to: firstDate) {
                dates.append(date)
            }
        }

        // activeDates
        self.activeDates = activeDates
    }

    func isCurrentMonth(date: Date) -> Bool {
        let components = calendar.dateComponents([.year, .month], from: date)
        let currentComponents = calendar.dateComponents([.year, .month], from: firstDate)
        return (components.month == currentComponents.month) && (components.year == currentComponents.year)
    }
}