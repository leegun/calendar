//
//  StoryboardInstantiatable.swift
//  DryEyeRhythm
//
//  Created by Yoshikuni Kato on 2016/04/14.
//  Copyright © 2016年 Ohako Inc. All rights reserved.
//

import UIKit

protocol StoryboardInstantiatable {}

extension StoryboardInstantiatable {
    static func instantiate() -> Self {
        let storyBoard = UIStoryboard(name: String(describing: Self.self), bundle: nil)
        // swiftlint:disable force_cast
        return storyBoard.instantiateInitialViewController() as! Self
    }
}
