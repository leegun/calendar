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
    var firstDate: Date { get }
    var daysPerWeek: Int { get }
    var weekCount: Int { get }
    var dayCount: Int { get }
    var dates: [Date] { get }
    var selectedDate: Date { get set }
    var todayComponents: DateComponents { get }
    var today: Date { get }
    var title: String { get }
    var prevDateCollection: DateCollection { get }
    var nextDateCollection: DateCollection { get }

    func isCurrentMonth(date: Date) -> Bool
    func conversionDateFormat(date: Date) -> String
}
