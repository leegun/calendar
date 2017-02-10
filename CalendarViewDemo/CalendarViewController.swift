//
//  CalendarViewController.swift
//  CalendarViewDemo
//
//  Created by g.lee on 2017/02/06.
//  Copyright © 2017年 g.lee. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController {

    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var containerHeight: NSLayoutConstraint!

    var calendarPageViewController: CalendarPageViewController!

    override func viewDidLoad() {

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CalendarViewController.tapContentView(_:)))
        contentView.addGestureRecognizer(tapGesture)

        guard let calendarPageViewController = self.childViewControllers[0] as? CalendarPageViewController else {
            return
        }
        self.calendarPageViewController = calendarPageViewController
        self.calendarPageViewController.didChangeHeight = { [weak self] height in
            self?.containerHeight.constant = height
            self?.view.layoutIfNeeded()
        }
        self.calendarPageViewController.didChangeMonth = { [weak self] title in
            self?.monthLabel.text = title
        }
        self.calendarPageViewController.didChangeDate = { [weak self] date in
            print(date)
        }
    }

    func tapContentView(_ gestureRecognizer: UITapGestureRecognizer) {
        calendarPageViewController.changeDateCollection()
    }
}
