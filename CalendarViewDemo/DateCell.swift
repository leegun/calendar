//
//  DateCell.swift
//  CalendarViewDemo
//
//  Created by g.lee on 2017/02/06.
//  Copyright © 2017年 g.lee. All rights reserved.
//

import UIKit

class DateCell: UICollectionViewCell {

    @IBOutlet weak var dayLabel: RounedLabel!
    @IBOutlet weak var activeView: RounedView!

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    func configure(dateCollection: DateCollection, indexPath: IndexPath) {

        let indexPathDate = dateCollection.dates[indexPath.row]

        dayLabel.text = dateCollection.conversionDateFormat(date: indexPathDate)

        if dateCollection.isToday(date: indexPathDate) {
            if dateCollection.isSelectedDate(date: dateCollection.today) {
                dayLabel.backgroundColor = .red
                dayLabel.textColor = .white
            } else {
                dayLabel.backgroundColor = .clear
                dayLabel.textColor = .red
            }
        } else {
            if dateCollection.isSelectedDate(date: indexPathDate) {
                dayLabel.backgroundColor = .darkGray
                dayLabel.textColor = .white
            } else {
                dayLabel.backgroundColor = .clear
                dayLabel.textColor = .darkGray
            }
        }

        if !dateCollection.isCurrentMonth(date: indexPathDate) && !dateCollection.isSelectedDate(date: indexPathDate) {
            dayLabel.textColor = .lightGray
        }

        for activeDate in dateCollection.activeDates {
            if activeDate == indexPathDate {
                activeView.alpha = 1
                break
            } else {
                activeView.alpha = 0
            }
        }
    }
}
