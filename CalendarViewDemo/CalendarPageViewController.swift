//
//  CalendarPageViewController.swift
//  CalendarViewDemo
//
//  Created by g.lee on 2017/02/08.
//  Copyright © 2017年 g.lee. All rights reserved.
//


import UIKit

class CalendarPageViewController: UIPageViewController {

    var dateCollection: DateCollection!
    var didChangeHeight: ((CGFloat) -> Void)?
    var didChangeMonth: ((String) -> Void)?

    override func viewDidLoad() {

        delegate = self
        dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        let vc = DateCollectionViewController.instantiate()
        self.dateCollection = MonthlyDateCollection()
        vc.dateCollection = self.dateCollection
        vc.didChangeMonth = { [weak self] title in
            self?.didChangeMonth?(title)
        }
        self.didChangeHeight?(vc.height)
        setViewControllers([vc], direction: .forward, animated: false, completion: nil)
    }

    func changeDateCollection() {
        let vc = DateCollectionViewController.instantiate()
        self.dateCollection = dateCollection.changeMode
        vc.dateCollection = self.dateCollection
        vc.didChangeMonth = { [weak self] title in
            self?.didChangeMonth?(title)
        }
        self.didChangeHeight?(vc.height)
        setViewControllers([vc], direction: .forward, animated: false, completion: nil)
    }
}

extension CalendarPageViewController: UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

        guard finished else { return }

        guard completed else { return }

        if let currentVC = pageViewController.viewControllers?[0] as? DateCollectionViewController {
            self.dateCollection = currentVC.dateCollection
            self.didChangeMonth?(currentVC.dateCollection.title)
            self.didChangeHeight?(currentVC.height)
        }
    }
}

extension CalendarPageViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        let vc = DateCollectionViewController.instantiate()
        vc.dateCollection = dateCollection?.prevDateCollection
        vc.didChangeMonth = { [weak self] title in
            self?.didChangeMonth?(title)
        }
        return vc
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        let vc = DateCollectionViewController.instantiate()
        vc.dateCollection = dateCollection?.nextDateCollection
        vc.didChangeMonth = { [weak self] title in
            self?.didChangeMonth?(title)
        }
        return vc
    }
}
