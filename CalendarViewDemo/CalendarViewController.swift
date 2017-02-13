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
    @IBOutlet weak var contentTitle: RounedLabel!
    @IBOutlet weak var containerHeight: NSLayoutConstraint!

    var calendarPageViewController: CalendarPageViewController!
    let contents: [Content] = Content.dummy

    override func viewDidLoad() {

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CalendarViewController.tapContentView(_:)))
        contentView.addGestureRecognizer(tapGesture)

        guard let calendarPageViewController = self.childViewControllers[0] as? CalendarPageViewController else {
            return
        }
        self.calendarPageViewController = calendarPageViewController
        self.calendarPageViewController.activeDates = contents.map { return $0.calendarDate }
        self.calendarPageViewController.didChangeHeight = { [weak self] height in
            self?.containerHeight.constant = height
            self?.view.layoutIfNeeded()
        }
        self.calendarPageViewController.didChangeMonth = { [weak self] title in
            self?.monthLabel.text = title
        }
        self.calendarPageViewController.didChangeDate = { [weak self] selectedDate in
            self?.updateContent(selectedDate: selectedDate)
        }
    }
    
    @IBAction func prevDay(_ sender: Any) {
        calendarPageViewController.prevCalendarDate()
    }

    @IBAction func nextDay(_ sender: Any) {
        calendarPageViewController.nextCalendarDate()
    }

    func tapContentView(_ gestureRecognizer: UITapGestureRecognizer) {
        calendarPageViewController.changeDateManager()
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
