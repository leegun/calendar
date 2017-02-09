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

    override func viewDidLoad() {

        if let calendarPageViewController = self.childViewControllers[0] as? CalendarPageViewController {
            calendarPageViewController.didChangeHeight = { [weak self] height in
                self?.containerHeight.constant = height
                self?.view.layoutIfNeeded()
            }
            calendarPageViewController.didChangeMonth = { [weak self] title in
                self?.monthLabel.text = title
            }
        }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CalendarViewController.tapContentView(_:)))
        contentView.addGestureRecognizer(tapGesture)
    }

    func tapContentView(_ gestureRecognizer: UITapGestureRecognizer) {
    }
}
