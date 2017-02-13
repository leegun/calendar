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
    @IBOutlet weak var contentTitle: RoundLabel!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var calendarView: UIView!

    var calendarPageViewController: CalendarPageViewController!
    let contents: [Content] = Content.dummy
    var isUpDirection: Bool = true
    var beforeHeight: CGFloat!

    override func viewDidLoad() {

        guard let calendarPageViewController = self.childViewControllers[0] as? CalendarPageViewController else {
            return
        }
        self.calendarPageViewController = calendarPageViewController
        self.calendarPageViewController.scheduledDates = contents.map { return $0.calendarDate }
        self.calendarPageViewController.didChangeHeight = { [weak self] height in
            self?.calendarHeightConstraint.constant = height
            self?.calendarView.layoutIfNeeded()
        }
        self.calendarPageViewController.didChangeMonth = { [weak self] title in
            self?.monthLabel.text = title
        }
        self.calendarPageViewController.didChangeDate = { [weak self] selectedDate in
            self?.updateContent(selectedDate: selectedDate)
        }

        beforeHeight = self.calendarHeightConstraint.constant
    }

    @IBAction func prevDay(_ sender: Any) {
        calendarPageViewController.prevCalendarDate()
    }

    @IBAction func nextDay(_ sender: Any) {
        calendarPageViewController.nextCalendarDate()
    }

    @IBAction func didPanGustureRecognizer(_ sender: UIPanGestureRecognizer) {

        if sender.state == .cancelled || sender.state == .ended {
            if isUpDirection {
                calendarPageViewController.changeWeeklyDateManager()
            } else {
                calendarPageViewController.changeMonthlyDateManager()
            }
            return
        }
        let calendarHeight = calendarPageViewController.height + sender.translation(in: self.view).y
        isUpDirection = calendarHeight < beforeHeight ? true : false
        beforeHeight = calendarHeight
        self.calendarHeightConstraint.constant = calendarHeight
        self.calendarView.layoutIfNeeded()
    }

    func updateContent(selectedDate: Date) {
        for content in contents {
            if Calendar(identifier: .gregorian).isDate(content.calendarDate, inSameDayAs: selectedDate) {
                contentTitle.text = content.title
                return
            }
        }
        contentTitle.text = "予定はありません。"
    }
}
