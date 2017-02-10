//
//  DateCollectionViewController.swift
//  CalendarViewDemo
//
//  Created by g.lee on 2017/02/08.
//  Copyright © 2017年 g.lee. All rights reserved.
//

import UIKit

class DateCollectionViewController: UIViewController, StoryboardInstantiatable {

    @IBOutlet weak var collectionView: UICollectionView!

    let cellHeight = 50
    var dateCollection: DateCollection!
    var height: CGFloat {
        return CGFloat(dateCollection.weekCount * cellHeight)
    }
    var didChangeMonth: ((String) -> Void)?
    var didChangeDate: ((Date) -> Void)?

    override func viewDidLoad() {

        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }

    func reload(selectedDate: Date? = nil) {
        guard let selectedDate = selectedDate else { return }
        dateCollection.selectedDate = selectedDate
        didChangeMonth?(dateCollection.title)
        didChangeDate?(dateCollection.selectedDate)
        collectionView.reloadData()
    }
}

extension DateCollectionViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        reload(selectedDate: dateCollection.dates[indexPath.row])
    }
}

extension DateCollectionViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.size.width / CGFloat(dateCollection.daysPerWeek)
        let height = CGFloat(cellHeight)
        return CGSize(width: width, height: height)
    }
}

extension DateCollectionViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dateCollection.dayCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCell", for: indexPath) as! DateCell
        cell.configure(dateCollection: dateCollection, indexPath: indexPath)

        return cell
    }
}
