//
//  CalendarPageViewController.swift
//  CalendarViewDemo
//
//  Created by g.lee on 2017/02/08.
//  Copyright © 2017年 g.lee. All rights reserved.
//

import UIKit

class CalendarPageViewController: UIPageViewController {

    var scheduledDates = [Date]()

    var didChangeHeight: ((CGFloat) -> Void)?
    var didChangeCalendarTitle: ((String) -> Void)?
    var didChangeDate: ((Date) -> Void)?

    var currentVC: DateCollectionViewController {
        return self.viewControllers?[0] as! DateCollectionViewController
    }

    var calendarTitle: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/yyyy"
        return formatter.string(from: currentVC.selectedDate)
    }

    var calendarHeight: CGFloat {
        return currentVC.height
    }

    func createDateCollectionVC(selectedDate: Date, calendarMode: CalendarMode, scheduledDates: [Date]) -> DateCollectionViewController {
        let vc = DateCollectionViewController.instantiate()
        vc.scheduledDates = scheduledDates
        vc.calendarMode = calendarMode
        vc.selectedDate = selectedDate
        vc.calendarDates = CalendarDate.createCalendarDates(selectedDate: selectedDate, scheduledDates: scheduledDates, calendarMode: calendarMode)
        vc.didChangeDate = { [weak self] date in
            guard let _self = self else { return }
            _self.didChangeCalendarTitle?(_self.calendarTitle)
            _self.didChangeDate?(date)
        }
        return vc
    }

    override func viewDidLoad() {

        delegate = self
        dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        changeTodayMonthly()
    }

    func setViewController(_ vc: DateCollectionViewController) {
        setViewControllers([vc], direction: .forward, animated: false) { [weak self] completed in
            if completed { self?.executeDidChangies() }
        }
    }

    func changeTodayMonthly() {
        setViewController(createDateCollectionVC(selectedDate: Date().today, calendarMode: .monthly, scheduledDates: scheduledDates))
    }

    func changeMonthly() {
        setViewController(createDateCollectionVC(selectedDate: currentVC.selectedDate, calendarMode: .monthly, scheduledDates: scheduledDates))
    }

    func changeWeekly() {
        setViewController(createDateCollectionVC(selectedDate: currentVC.selectedDate, calendarMode: .weekly, scheduledDates: scheduledDates))
    }

    func prevCalendarDate() {
        let prevDate = currentVC.selectedDate.prevDate
        if prevDate.isSameMonth(date: currentVC.selectedDate) {
            currentVC.selectedDate = prevDate
            currentVC.reload()
        } else {
            setViewController(createDateCollectionVC(selectedDate: prevDate, calendarMode: currentVC.calendarMode, scheduledDates: scheduledDates))
        }
    }

    func nextCalendarDate() {
        let nextDate = currentVC.selectedDate.nextDate
        if nextDate.isSameMonth(date: currentVC.selectedDate) {
            currentVC.selectedDate = nextDate
            currentVC.reload()
        } else {
            setViewController(createDateCollectionVC(selectedDate: nextDate, calendarMode: currentVC.calendarMode, scheduledDates: scheduledDates))
        }
    }

    func executeDidChangies() {
        didChangeCalendarTitle?(calendarTitle)
        didChangeHeight?(calendarHeight)
        didChangeDate?(currentVC.selectedDate)
    }
}

extension CalendarPageViewController: UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

        guard finished else { return }

        guard completed else { return }

        executeDidChangies()
    }
}

extension CalendarPageViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        return createDateCollectionVC(selectedDate:currentVC.prevDate, calendarMode: currentVC.calendarMode, scheduledDates: scheduledDates)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        return createDateCollectionVC(selectedDate:currentVC.nextDate, calendarMode: currentVC.calendarMode, scheduledDates: scheduledDates)
    }
}
