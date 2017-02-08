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
    @IBOutlet weak var calendarView: UICollectionView!
    @IBOutlet weak var calendarHeight: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!

    var calendarManager: CalendarManager!

    override func viewDidLoad() {

        if let calendarManager = CalendarManager() { self.calendarManager = calendarManager }
        monthLabel.text = calendarManager.title
        calendarView.delegate = self
        calendarView.dataSource = self
        self.reloadData(weekCount: calendarManager.weekCount)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CalendarViewController.tapContentView(_:)))
        contentView.addGestureRecognizer(tapGesture)
    }

    @IBAction func prevMonth(_ sender: Any) {
        if let layout = calendarView.collectionViewLayout as? UICollectionViewFlowLayout { layout.scrollDirection = .vertical }
        if let calendarManager = calendarManager.prevCalendar() { self.calendarManager = calendarManager }
        self.reloadData(weekCount: calendarManager.weekCount)
        monthLabel.text = calendarManager.title
    }

    @IBAction func nextMonth(_ sender: Any) {
        if let layout = calendarView.collectionViewLayout as? UICollectionViewFlowLayout { layout.scrollDirection = .vertical }
        if let calendarManager = calendarManager.nextCalendar() { self.calendarManager = calendarManager }
        self.reloadData(weekCount: calendarManager.weekCount)
        monthLabel.text = calendarManager.title
    }

    func tapContentView(_ gestureRecognizer: UITapGestureRecognizer) {
        if let layout = calendarView.collectionViewLayout as? UICollectionViewFlowLayout { layout.scrollDirection = .horizontal }
        self.reloadData(weekCount: 1)
    }
    
    func reloadData(weekCount: Int) {
        self.calendarHeight.constant = CGFloat(weekCount * 50)
        self.view.layoutIfNeeded()
        self.calendarView.reloadData()
    }
}

extension CalendarViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        calendarManager.selectedDate = calendarManager.dates[indexPath.row]
        collectionView.reloadData()
    }
}

extension CalendarViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = collectionView.frame.size.width / CGFloat(calendarManager.daysPerWeek)
        let height: CGFloat = 50
        return CGSize(width: width, height: height)
    }
}

extension CalendarViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return calendarManager.dayCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath)

        if let cell = cell as? CalendarCell {
            calendarManager.configure(cell: cell, indexPath: indexPath)
        }
        return cell
    }
}
