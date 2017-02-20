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

    func configure(calendarDate: CalendarDate, isSelected: Bool, isCurrentMonth: Bool) {

        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        dayLabel.text = formatter.string(from: calendarDate.date)

        if calendarDate.date.isToday {
            if isSelected {
                dayLabel.backgroundColor = .red
                dayLabel.textColor = .white
            } else {
                dayLabel.backgroundColor = .clear
                dayLabel.textColor = .red
            }
        } else {
            if isSelected {
                dayLabel.backgroundColor = .darkGray
                dayLabel.textColor = .white
            } else {
                dayLabel.backgroundColor = .clear
                dayLabel.textColor = .darkGray
            }
        }

        if !isCurrentMonth && !isSelected {
            dayLabel.textColor = .lightGray
        }

        activeView.alpha = calendarDate.isScheduled ? 1 : 0
    }
}
