//
//  DateCell.swift
//  CalendarViewDemo
//
//  Created by g.lee on 2017/02/06.
//  Copyright © 2017年 g.lee. All rights reserved.
//

import UIKit

class DateCell: UICollectionViewCell {

    @IBOutlet weak var dayLabel: RoundLabel!
    @IBOutlet weak var activeView: RoundView!

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    func configure(dateManager: DateManager, indexPath: IndexPath) {

        let indexPathDate = dateManager.dates[indexPath.row]

        dayLabel.text = dateManager.conversionDateFormat(date: indexPathDate)

        if dateManager.isToday(date: indexPathDate) {
            if dateManager.isSelectedDate(date: dateManager.today) {
                dayLabel.backgroundColor = .red
                dayLabel.textColor = .white
            } else {
                dayLabel.backgroundColor = .clear
                dayLabel.textColor = .red
            }
        } else {
            if dateManager.isSelectedDate(date: indexPathDate) {
                dayLabel.backgroundColor = .darkGray
                dayLabel.textColor = .white
            } else {
                dayLabel.backgroundColor = .clear
                dayLabel.textColor = .darkGray
            }
        }

        if !dateManager.isCurrentMonth(date: indexPathDate) && !dateManager.isSelectedDate(date: indexPathDate) {
            dayLabel.textColor = .lightGray
        }

        for activeDate in dateManager.activeDates {
            if activeDate == indexPathDate {
                activeView.alpha = 1
                break
            } else {
                activeView.alpha = 0
            }
        }
    }
}
