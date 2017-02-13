//
//  Content.swift
//  CalendarViewDemo
//
//  Created by g.lee on 2017/02/10.
//  Copyright © 2017年 g.lee. All rights reserved.
//

import Foundation

struct Content {
    let title: String
    let calendarDate: Date

    static var dummy: [Content] {
        let content = Content(title: "今日はいい天気でした！", calendarDate: Calendar(identifier: .gregorian).startOfDay(for: Date()))
        let content2 = Content(title: "今日は気にせず運動できました！", calendarDate: Date(timeIntervalSince1970: content.calendarDate.timeIntervalSince1970 + 60*60*24))
        let content3 = Content(title: "今日は怪我をして大変でした！", calendarDate: Date(timeIntervalSince1970: content2.calendarDate.timeIntervalSince1970 + 60*60*24*2))
        let content4 = Content(title: "今日はゴルフをして、初めて１００切りました。", calendarDate: Date(timeIntervalSince1970: content2.calendarDate.timeIntervalSince1970 + 60*60*24*4))
        let content5 = Content(title: "休みだったのでプールで泳ぎました！", calendarDate: Date(timeIntervalSince1970: content2.calendarDate.timeIntervalSince1970 + 60*60*24*8))
        let content6 = Content(title: "今日は１０ｋｍランニングをしました！", calendarDate: Date(timeIntervalSince1970: content2.calendarDate.timeIntervalSince1970 + 60*60*24*14))
        return [content, content2, content3, content4, content5, content6]
    }
}
