//
//  DateCollectionViewController.swift
//  CalendarViewDemo
//
//  Created by g.lee on 2017/02/08.
//  Copyright © 2017年 g.lee. All rights reserved.
//

import UIKit

enum CalendarMode {
    case monthly
    case weekly

    func weekCount(_ selectedDate: Date) -> Int {
        switch self {
        case .monthly:
            let calendar = Calendar(identifier: .gregorian)
            let rangeOfWeeks = calendar.range(of: .weekOfMonth, in: .month, for: selectedDate)!
            return rangeOfWeeks.count
        case .weekly:
            return 1
        }
    }

    func firstWeekDate(selectedDate: Date) -> Date {
        switch self {
        case .monthly:
            return selectedDate.firstDate
        case .weekly:
            return selectedDate
        }
    }

    func prev(_ selectedDate: Date) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        var components = calendar.dateComponents([.year, .month, .day], from: selectedDate)
        
        switch self {
        case .monthly:
            components.month = components.month! - 1
        case .weekly:
            let dateCount =  calendar.ordinality(of: .day, in: .weekOfMonth, for: selectedDate)!
            components.day = components.day! - dateCount
        }

        let todayComponents = Date().todayComponents
        components.day = components.month == todayComponents.month && components.year == todayComponents.year ? todayComponents.day : 1
        return calendar.date(from: components)!
    }

    func next(_ selectedDate: Date) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        var components = calendar.dateComponents([.year, .month, .day], from: selectedDate)

        switch self {
        case .monthly:
            components.month = components.month! + 1
        case .weekly:
            let dateCount =  (7 + 1) - calendar.ordinality(of: .day, in: .weekOfMonth, for: selectedDate)!
            components.day = components.day! - dateCount
        }

        let todayComponents = Date().todayComponents
        components.day = components.month == todayComponents.month && components.year == todayComponents.year ? todayComponents.day : 1
        return calendar.date(from: components)!
    }
}

class DateCollectionViewController: UIViewController, StoryboardInstantiatable {

    @IBOutlet weak var collectionView: UICollectionView!

    var scheduledDates: [Date]!
    
    var calendarDates: [CalendarDate]!

    var calendarMode: CalendarMode = .monthly

    var selectedDate: Date = Date()

    var prevDate: Date {
        return calendarMode.prev(selectedDate)
    }

    var nextDate: Date {
        return calendarMode.next(selectedDate)
    }

    var height: CGFloat {
        let weekDayHeight = 17
        let cellHeight = 50
        return CGFloat(calendarMode.weekCount(selectedDate.firstDate) * cellHeight + weekDayHeight)
    }

    var didChangeDate: ((Date) -> Void)?

    override func viewDidLoad() {

        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        reload()
    }

    func reload() {
        didChangeDate?(selectedDate)
        calendarDates = CalendarDate.createCalendarDates(selectedDate: selectedDate, scheduledDates: scheduledDates, calendarMode: calendarMode)
        collectionView.reloadData()
    }
}

extension DateCollectionViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        selectedDate = calendarDates[indexPath.row].date
        reload()
    }
}

extension DateCollectionViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.frame.size.width / CGFloat(7), height: CGFloat(50))
    }
}

extension DateCollectionViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return calendarDates.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCell", for: indexPath) as! DateCell

        let calendarDate = calendarDates[indexPath.row]
        let isSelected = selectedDate == calendarDate.date
        let isCurrentMonth = calendarDate.date.isSameMonth(date: selectedDate)
        cell.configure(calendarDate: calendarDate, isSelected: isSelected, isCurrentMonth: isCurrentMonth)

        return cell
    }
}
