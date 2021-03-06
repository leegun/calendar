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
        self.calendarPageViewController.didChangeCalendarTitle = { [weak self] title in
            self?.monthLabel.text = title
        }
        self.calendarPageViewController.didChangeDate = { [weak self] selectedDate in
            self?.updateContent(selectedDate: selectedDate)
        }

        calendarView.layer.shadowColor = UIColor.black.cgColor
        calendarView.layer.shadowOffset = CGSize(width: 0, height: 10)
        calendarView.layer.shadowRadius = 5
        calendarView.layer.shadowOpacity = 1
        self.view.bringSubview(toFront: calendarView)

        beforeHeight = self.calendarHeightConstraint.constant
    }

    @IBAction func prevDay(_ sender: Any) {
        calendarPageViewController.prevCalendarDate()
    }

    @IBAction func nextDay(_ sender: Any) {
        calendarPageViewController.nextCalendarDate()
    }

    @IBAction func today(_ sender: Any) {
        calendarPageViewController.changeTodayMonthly()
    }

    @IBAction func didPanGustureRecognizer(_ sender: UIPanGestureRecognizer) {

        if sender.state == .cancelled || sender.state == .ended {
            if isUpDirection {
                calendarPageViewController.changeWeekly()
            } else {
                calendarPageViewController.changeMonthly()
            }
            return
        }
        let calendarHeight = calendarPageViewController.calendarHeight + sender.translation(in: self.view).y
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
