//
//  CalendarCell.swift
//  CalendarViewDemo
//
//  Created by g.lee on 2017/02/06.
//  Copyright © 2017年 g.lee. All rights reserved.
//

import UIKit

class CalendarCell: UICollectionViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var activeView: RounedView!

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    func todayLabel(selected: Bool) {
        if selected {
            dayLabel.backgroundColor = .red
            dayLabel.textColor = .white
            dayLabel.layer.cornerRadius = 15
            dayLabel.layer.masksToBounds = true
        } else {
            dayLabel.backgroundColor = .clear
            dayLabel.textColor = .red
        }
    }

    func defaultLabel(selected: Bool) {
        if selected {
            dayLabel.backgroundColor = .darkGray
            dayLabel.textColor = .white
            dayLabel.layer.cornerRadius = 15
            dayLabel.layer.masksToBounds = true
        } else {
            dayLabel.backgroundColor = .clear
            dayLabel.textColor = .darkGray
        }
    }
}
