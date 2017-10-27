//
//  DateFormatterExtension.swift
//  RxAstroChannels
//
//  Created by Candice H on 10/27/17.
//  Copyright © 2017 Candice H. All rights reserved.
//

import Foundation

extension DateFormatter {
    func date(fromSwapiString dateString: String) -> Date? {
        self.dateFormat = "yyyy-MM-dd HH:mm:ss.S"
        self.timeZone = TimeZone(abbreviation: "UTC")
        self.locale = Locale.current
        return self.date(from: dateString)
    }
}
