//
//  DateCollection.swift
//  CalendarViewDemo
//
//  Created by g.lee on 2017/02/09.
//  Copyright © 2017年 g.lee. All rights reserved.
//

import Foundation

protocol DateCollection {

    var calendar: Calendar { get }
    var daysPerWeek: Int { get }
    var weekCount: Int { get }
    var dayCount: Int { get }
    var dates: [Date] { get }
    var activeDates: [Date] { get }
    var selectedDate: Date { get set }
    var todayComponents: DateComponents { get }
    var today: Date { get }
    var title: String { get }
    var prevDateCollection: DateCollection { get }
    var nextDateCollection: DateCollection { get }
    var changeMode: DateCollection { get }

    func isToday(date: Date) -> Bool
    func isSelectedDate(date: Date) -> Bool
    func isCurrentMonth(date: Date) -> Bool
    func conversionDateFormat(date: Date) -> String
}

extension DateCollection {

    var todayComponents: DateComponents {
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
        return components
    }

    var today: Date {
        let today = calendar.date(from: todayComponents)
        return today!
    }

    var title: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/yyyy"
        return formatter.string(from: selectedDate)
    }

    func isToday(date: Date) -> Bool {
        return calendar.isDateInToday(date)
    }

    func isSelectedDate(date: Date) -> Bool {
        return calendar.isDate(selectedDate, inSameDayAs: date)
    }

    func conversionDateFormat(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
}
