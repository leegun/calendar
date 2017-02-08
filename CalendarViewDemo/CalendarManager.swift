//
//  CalendarManager.swift
//  CalendarViewDemo
//
//  Created by g.lee on 2017/02/06.
//  Copyright © 2017年 g.lee. All rights reserved.
//

import UIKit

struct CalendarManager {
    let calendar = Calendar(identifier: .gregorian)
    let firstDate: Date
    let daysPerWeek: Int = 7
    let weekCount: Int
    let dayCount: Int
    var dates: [Date]
    var selectedDate: Date
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

    init?(selectedDate: Date = Date()) {

        // selectedDate
        guard let tempDate = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: selectedDate)) else { return nil }
        self.selectedDate = tempDate

        // firstDate
        var components = calendar.dateComponents([.year, .month, .day], from: self.selectedDate)
        components.day = 1
        guard let firstDate = calendar.date(from: components) else { return nil }
        self.firstDate = firstDate

        // weekCount
        guard let rangeOfWeeks = calendar.range(of: .weekOfMonth, in: .month, for: firstDate) else { return nil }
        self.weekCount = rangeOfWeeks.count

        // dayCount
        self.dayCount = weekCount * daysPerWeek

        // dates
        dates = [Date]()
        guard let ordinalityOfFirstDay =  calendar.ordinality(of: .day, in: .weekOfMonth, for: firstDate) else { return nil }
        for day in 1...dayCount {
            var dateComponents = DateComponents()
            dateComponents.day = day - ordinalityOfFirstDay
            if let date = calendar.date(byAdding: dateComponents, to: firstDate) {
                dates.append(date)
            }
        }
    }

    func isToday(date: Date) -> Bool {
        return date == today
    }

    func isCurrentMonth(date: Date) -> Bool {
        let components = calendar.dateComponents([.year, .month], from: date)
        let currentComponents = calendar.dateComponents([.year, .month], from: firstDate)
        return (components.month == currentComponents.month) && (components.year == currentComponents.year)
    }

    func configure(cell: CalendarCell, indexPath: IndexPath) {

        let dateOfIndexPath = dates[indexPath.row]
        let selected = selectedDate == dateOfIndexPath
        let selectedDateIsToday = selectedDate == today
        let isToday = dateOfIndexPath == today
        cell.dayLabel.text = conversionDateFormat(date: dateOfIndexPath)

        isToday ? cell.todayLabel(selected: selectedDateIsToday) : cell.defaultLabel(selected: selected)

        if !isCurrentMonth(date: dateOfIndexPath) && !selected {
            cell.dayLabel.textColor = .lightGray
        }
    }

    func conversionDateFormat(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }

    func prevCalendar() -> CalendarManager? {
        var components = calendar.dateComponents([.year, .month, .day], from: self.selectedDate)
        guard let month = components.month else {
            return nil
        }
        components.month = month - 1
        components.day = components.month == todayComponents.month && components.year == todayComponents.year ? todayComponents.day : 1
        guard let date = calendar.date(from: components) else {
            return nil
        }
        return CalendarManager(selectedDate: date)
    }

    func nextCalendar() -> CalendarManager? {
        var components = calendar.dateComponents([.year, .month, .day], from: self.selectedDate)
        guard let month = components.month else {
            return nil
        }
        components.month = month + 1
        components.day = components.month == todayComponents.month && components.year == todayComponents.year ? todayComponents.day : 1
        guard let date = calendar.date(from: components) else {
            return nil
        }
        return CalendarManager(selectedDate: date)
    }
}
