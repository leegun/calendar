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

    func setViewController(dateCollection: DateCollection) {
        let vc = dateCollectionViewController
        vc.dateCollection = dateCollection
        self.didChangeHeight?(vc.height)
        setViewControllers([vc], direction: .forward, animated: false, completion: nil)
    }

    func changeDateCollection() {
        if let currentVC = self.viewControllers?[0] as? DateCollectionViewController {
            setViewController(dateCollection: currentVC.dateCollection.changeMode)
        }
    }
}

extension CalendarPageViewController: UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

        guard finished else { return }

        guard completed else { return }

        if let currentVC = pageViewController.viewControllers?[0] as? DateCollectionViewController {
            self.didChangeMonth?(currentVC.dateCollection.title)
            self.didChangeHeight?(currentVC.height)
            self.didChangeDate?(currentVC.dateCollection.selectedDate)
        }
    }
}

extension CalendarPageViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard let currentVC = pageViewController.viewControllers?[0] as? DateCollectionViewController else {
            return nil
        }

        let vc = dateCollectionViewController
        vc.dateCollection = currentVC.dateCollection?.prevDateCollection
        return vc
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        guard let currentVC = pageViewController.viewControllers?[0] as? DateCollectionViewController else {
            return nil
        }

        let vc = dateCollectionViewController
        vc.dateCollection = currentVC.dateCollection?.nextDateCollection
        return vc
    }
}
