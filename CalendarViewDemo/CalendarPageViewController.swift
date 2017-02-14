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
    var didChangeMonth: ((String) -> Void)?
    var didChangeDate: ((Date) -> Void)?

    var currentVC: DateCollectionViewController {
        return self.viewControllers?[0] as! DateCollectionViewController
    }
    var height: CGFloat {
        return currentVC.height
    }
    var dateCollectionViewController: DateCollectionViewController {
        let vc = DateCollectionViewController.instantiate()
        vc.didChangeMonth = { [weak self] title in
            self?.didChangeMonth?(title)
        }
        vc.didChangeDate = { [weak self] date in
            self?.didChangeDate?(date)
        }
        return vc
    }

    override func viewDidLoad() {

        delegate = self
        dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        setViewController(dateManager: MonthlyDateManager(scheduledDates: scheduledDates))
    }

    func setViewController(dateManager: DateManager, direction: UIPageViewControllerNavigationDirection = .forward, animated: Bool = false, completion: ((Bool) -> Void)? = nil) {
        let vc = dateCollectionViewController
        vc.dateManager = dateManager
        didChangeHeight?(vc.height)
        setViewControllers([vc], direction: direction, animated: animated, completion: completion)
    }

    func changeMonthlyDateManager() {
        setViewController(dateManager: currentVC.dateManager.monthlyDateManager)
    }

    func changeWeeklyDateManager() {
        setViewController(dateManager: currentVC.dateManager.weeklyDateManager)
    }

    func prevCalendarDate() {
        let prevDate = currentVC.dateManager.prevDate
        if currentVC.dateManager.isCurrentMonth(date: prevDate) {
            changeCalendarDate(selectedDate: prevDate)
        } else {
            currentVC.dateManager = currentVC.dateManager.prevDateManager
            currentVC.dateManager.selectedDate = prevDate
            currentVC.dateManager = currentVC.dateManager.refreshDateManager
            setViewController(dateManager: currentVC.dateManager) { [weak self] completed in
                if completed { self?.executeDidChangies() }
            }
        }
    }

    func nextCalendarDate() {
        let nextDate = currentVC.dateManager.nextDate
        if currentVC.dateManager.isCurrentMonth(date: nextDate) {
            changeCalendarDate(selectedDate: nextDate)
        } else {
            currentVC.dateManager = currentVC.dateManager.nextDateManager
            currentVC.dateManager.selectedDate = nextDate
            currentVC.dateManager = currentVC.dateManager.refreshDateManager
            setViewController(dateManager: currentVC.dateManager) { [weak self] completed in
                if completed { self?.executeDidChangies() }
            }
        }
    }

    func changeCalendarDate(selectedDate: Date) {
        currentVC.reload(selectedDate: selectedDate)
    }

    func executeDidChangies() {
        didChangeMonth?(currentVC.dateManager.title)
        didChangeHeight?(currentVC.height)
        didChangeDate?(currentVC.dateManager.selectedDate)
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

        let vc = dateCollectionViewController
        vc.dateManager = currentVC.dateManager?.prevDateManager
        return vc
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        let vc = dateCollectionViewController
        vc.dateManager = currentVC.dateManager?.nextDateManager
        return vc
    }
}
