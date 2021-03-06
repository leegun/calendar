//
//  XibInstantiatable.swift
//  DataLoadingViewController
//
//  Created by Yoshikuni Kato on 2016/06/22.
//  Copyright © 2016年 Ohako Inc. All rights reserved.
//

import UIKit

protocol XibInstantiatable {
    func instantiate()
}

extension XibInstantiatable where Self: UIView {
    func instantiate() {
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false

        view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}
