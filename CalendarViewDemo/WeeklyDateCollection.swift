//
//  WeeklyDateCollection.swift
//  CalendarViewDemo
//
//  Created by g.lee on 2017/02/09.
//  Copyright © 2017年 g.lee. All rights reserved.
//

import Foundation

struct WeeklyDateCollection: DateCollection {
    
    let calendar = Calendar(identifier: .gregorian)
    let daysPerWeek: Int = 7
    let weekCount: Int = 1
    let dayCount: Int = 7
    let firstDate: Date
    var dates: [Date]
    var activeDates: [Date]
    var selectedDate: Date

    var prevDateCollection: DateCollection {
        var components = calendar.dateComponents([.year, .month, .day], from: selectedDate)
        let dateCount =  calendar.ordinality(of: .day, in: .weekOfMonth, for: selectedDate)!
        components.day = components.day! - dateCount
        let date = calendar.date(from: components)!
        return WeeklyDateCollection(selectedDate: date, activeDates: activeDates)
    }

    var nextDateCollection: DateCollection {
        var components = calendar.dateComponents([.year, .month, .day], from: self.selectedDate)
        let dateCount =  (daysPerWeek + 1) - calendar.ordinality(of: .day, in: .weekOfMonth, for: selectedDate)!
        components.day = components.day! + dateCount
        let date = calendar.date(from: components)!
        return WeeklyDateCollection(selectedDate: date, activeDates: activeDates)
    }

    var changeMode: DateCollection {
        return MonthlyDateCollection(selectedDate: selectedDate, activeDates: activeDates)
    }

    init(selectedDate: Date = Date(), activeDates: [Date] = [Date]()) {
        
        // selectedDate
        self.selectedDate = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: selectedDate))!

        // firstDate
        var components = calendar.dateComponents([.year, .month, .day], from: self.selectedDate)
        components.day = 1
        firstDate = calendar.date(from: components)!

        // dates
        dates = [Date]()
        let ordinalityOfFirstDay =  calendar.ordinality(of: .day, in: .weekOfMonth, for: selectedDate)!
        for day in 1...dayCount {
            var dateComponents = DateComponents()
            dateComponents.day = day - ordinalityOfFirstDay
            if let date = calendar.date(byAdding: dateComponents, to: selectedDate) {
                let appendDate = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: date))!
                dates.append(appendDate)
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
