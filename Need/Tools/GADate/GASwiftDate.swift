//
//  GASwiftDate.swift
//  Need
//
//  Created by houjianan on 2020/4/4.
//  Copyright © 2020 houjianan. All rights reserved.
//

import Foundation
import SwiftDate

class GASwiftDate {
    static var region: Region {
        let region = Region(calendar: Calendars.gregorian, zone: Zones.current, locale: Locales.chineseChina)
        SwiftDate.defaultRegion = region
        return region
    }
    
    static var currentDateRegion: DateInRegion {
        let dateRegion = DateInRegion(Date(), region: GASwiftDate.region)
        return dateRegion
    }
    
    static func initDate(_ string: String, format: String = "yyyy-MM-dd HH:mm:ss") -> DateInRegion? {
        guard let dateRegion = DateInRegion.init(string, format: format, region: GASwiftDate.region) else { return nil }
        return dateRegion
    }
    
    static func dateRegion(date: Date) -> DateInRegion {
        let dateRegion = DateInRegion(date, region: GASwiftDate.region)
        return dateRegion
    }
    
}

extension Date {
    var dateString: String {
        let dateRegion = DateInRegion(self, region: GASwiftDate.region)
        return dateRegion.toString()
    }
    
    func dateString(formate: GADateFormatType = .y_m_d_h_m_s) -> String {
        let dateRegion = GASwiftDate.dateRegion(date: self)
        return dateRegion.toFormat(formate.rawValue)
    }
}

extension String {
    func ga_formateDate(format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let date = GASwiftDate.initDate(self, format: format)
        return date?.toString() ?? ""
    }
}

extension DateInRegion {
    var yearString: String {
        return String(self.year)
    }
    var monthString: String {
        return String(self.month)
    }
    var dayString: String {
        return String(self.day)
    }
    var weekdayString: String {
        return String(self.weekday)
    }
    var hourString: String {
        return String(self.hour)
    }
    var minuteString: String {
        return String(self.minute)
    }
    var secondString: String {
        return String(self.second)
    }
}
