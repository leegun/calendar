//
//  CalendarPageViewController.swift
//  CalendarViewDemo
//
//  Created by g.lee on 2017/02/08.
//  Copyright © 2017年 g.lee. All rights reserved.
//

import UIKit

class CalendarPageViewController: UIPageViewController {

    var activeDates = [Date]()

    var didChangeHeight: ((CGFloat) -> Void)?
    var didChangeMonth: ((String) -> Void)?
    var didChangeDate: ((Date) -> Void)?

    var currentVC: DateCollectionViewController {
        return self.viewControllers?[0] as! DateCollectionViewController
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
        setViewController(dateCollection: MonthlyDateCollection(activeDates: activeDates))
    }

    func setViewController(dateCollection: DateCollection, direction: UIPageViewControllerNavigationDirection = .forward, animated: Bool = false, completion: ((Bool) -> Void)? = nil) {
        let vc = dateCollectionViewController
        vc.dateCollection = dateCollection
        didChangeHeight?(vc.height)
        setViewControllers([vc], direction: direction, animated: animated, completion: completion)
    }

    func changeDateCollection() {
        setViewController(dateCollection: currentVC.dateCollection.changeMode)
    }

    func prevCalendarDate() {
        let prevDate = currentVC.dateCollection.prevDate
        if currentVC.dateCollection.isCurrentMonth(date: prevDate) {
            changeCalendarDate(selectedDate: prevDate)
        } else {
            currentVC.dateCollection = currentVC.dateCollection.prevDateCollection
            currentVC.dateCollection.selectedDate = prevDate
            setViewController(dateCollection: currentVC.dateCollection) { [weak self] completed in
                if completed { self?.executeDidChangies() }
            }
        }
    }

    func nextCalendarDate() {
        let nextDate = currentVC.dateCollection.nextDate
        if currentVC.dateCollection.isCurrentMonth(date: nextDate) {
            changeCalendarDate(selectedDate: nextDate)
        } else {
            currentVC.dateCollection = currentVC.dateCollection.nextDateCollection
            currentVC.dateCollection.selectedDate = nextDate
            setViewController(dateCollection: currentVC.dateCollection) { [weak self] completed in
                if completed { self?.executeDidChangies() }
            }
        }
    }

    func changeCalendarDate(selectedDate: Date) {
        currentVC.reload(selectedDate: selectedDate)
    }

    func executeDidChangies() {
        didChangeMonth?(currentVC.dateCollection.title)
        didChangeHeight?(currentVC.height)
        didChangeDate?(currentVC.dateCollection.selectedDate)
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
        vc.dateCollection = currentVC.dateCollection?.prevDateCollection
        return vc
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        let vc = dateCollectionViewController
        vc.dateCollection = currentVC.dateCollection?.nextDateCollection
        return vc
    }
}
