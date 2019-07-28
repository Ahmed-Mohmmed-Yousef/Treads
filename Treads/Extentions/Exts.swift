//
//  Exts.swift
//  Treads
//
//  Created by Ahmed on 7/26/19.
//  Copyright © 2019 Ahmed, ORG. All rights reserved.
//

import Foundation

extension Double{
    func metersToMilies(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return ((self / 1609.34) * divisor).rounded() / divisor
    }
}

extension Int{
    func formatTimeDurationToString() -> String{
        let seconds = self % 60
        let minutes = (self / 60) % 60
        let hours = (self / 3600) % 24
        if hours == 0{
            return String(format: "%02d:%02d",minutes,seconds )
        }
        return String(format: "%02d:%02d:%02d", hours,minutes,seconds )
    }
}

extension NSDate{
    func getDateString() -> String{
        let calender = Calendar.current
        let month = calender.component(.month, from: self as Date)
        let day = calender.component(.day, from: self as Date)
        let year = calender.component(.year, from: self as Date)
        return "\(month)/\(day)/\(year)"
    }
}
