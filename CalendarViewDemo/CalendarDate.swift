//
//  CalendarDate.swift
//  CalendarViewDemo
//
//  Created by g.lee on 2017/02/16.
//  Copyright © 2017年 g.lee. All rights reserved.
//

import Foundation

struct CalendarDate: Equatable {
    let date: Date
    let isScheduled: Bool

    var createDateComponents: DateComponents? {

        let calendar = Calendar(identifier: .gregorian)
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        dateComponents.calendar = calendar
        return dateComponents
    }

    static func createCalendarDates(selectedDate: Date, scheduledDates: [Date], calendarMode: CalendarMode) -> [CalendarDate] {

        var calendarDates = [CalendarDate]()
        let calendar = Calendar(identifier: .gregorian)
        let dayCount = calendarMode.weekCount(selectedDate) * 7
        let firstWeekDate = calendarMode.firstWeekDate(selectedDate: selectedDate)
        let ordinalityOfFirstDay =  calendar.ordinality(of: .day, in: .weekOfMonth, for: firstWeekDate)!
        for day in 1...dayCount {
            var dateComponents = DateComponents()
            dateComponents.day = day - ordinalityOfFirstDay
            if let date = calendar.date(byAdding: dateComponents, to: firstWeekDate) {
                var isScheduled = false
                for scheduledDate in scheduledDates {
                    if date == scheduledDate {
                        isScheduled = true
                        break
                    }
                }
                let calendarDate = CalendarDate(date: date, isScheduled: isScheduled)
                calendarDates.append(calendarDate)
            }
        }
        return calendarDates
    }

    static func == (lhs: CalendarDate, rhs: CalendarDate) -> Bool {
        let lhsDateComponents = lhs.createDateComponents
        let rhsDateComponents = rhs.createDateComponents
        return lhsDateComponents?.year == rhsDateComponents?.year &&
            lhsDateComponents?.month == rhsDateComponents?.month &&
            lhsDateComponents?.day == rhsDateComponents?.day
    }
}
