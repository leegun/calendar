//
//  DateManager.swift
//  CalendarViewDemo
//
//  Created by g.lee on 2017/02/09.
//  Copyright © 2017年 g.lee. All rights reserved.
//

import Foundation

protocol DateManager {

    var daysPerWeek: Int { get }
    var weekCount: Int { get }
    var dayCount: Int { get }
    var firstDate: Date { get }
    var dates: [Date] { get }
    var scheduledDates: [Date] { get }
    var selectedDate: Date { get set }
    var todayComponents: DateComponents { get }
    var today: Date { get }
    var title: String { get }
    var prevDate: Date { get }
    var nextDate: Date { get }
    var todayMonthlyDateManager: DateManager { get }
    var prevDateManager: DateManager { get }
    var nextDateManager: DateManager { get }
    var monthlyDateManager: DateManager { get }
    var weeklyDateManager: DateManager { get }
    var refreshDateManager: DateManager { get }

    func isToday(date: Date) -> Bool
    func isSelectedDate(date: Date) -> Bool
    func isCurrentMonth(date: Date) -> Bool
    func isScheduledDate(date: Date) -> Bool
}

extension DateManager {

    var todayComponents: DateComponents {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
        return components
    }

    var today: Date {
        let calendar = Calendar(identifier: .gregorian)
        let today = calendar.date(from: todayComponents)
        return today!
    }

    var title: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/yyyy"
        return formatter.string(from: selectedDate)
    }

    var prevDate: Date {
        let calendar = Calendar(identifier: .gregorian)
        var components = calendar.dateComponents([.year, .month, .day], from: selectedDate)
        components.day = components.day! - 2 // １日戻るのになぜか２日分引く必要があった
        return calendar.date(from: components)!
    }

    var nextDate: Date {
        let calendar = Calendar(identifier: .gregorian)
        var components = calendar.dateComponents([.year, .month, .day], from: selectedDate)
        components.day = components.day! + 1
        return calendar.date(from: components)!
    }

    var todayMonthlyDateManager: DateManager {
        return MonthlyDateManager(selectedDate: today, scheduledDates: scheduledDates)
    }

    var monthlyDateManager: DateManager {
        return MonthlyDateManager(selectedDate: selectedDate, scheduledDates: scheduledDates)
    }

    var weeklyDateManager: DateManager {
        return WeeklyDateManager(selectedDate: selectedDate, scheduledDates: scheduledDates)
    }

    func isToday(date: Date) -> Bool {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.isDateInToday(date)
    }

    func isSelectedDate(date: Date) -> Bool {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.isDate(selectedDate, inSameDayAs: date)
    }

    func isScheduledDate(date: Date) -> Bool {
        for scheduledDate in scheduledDates {
            if date == scheduledDate {
                return true
            }
        }
        return false
    }
}
