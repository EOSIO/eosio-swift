//
//  DateExtensions.swift
//  EosioSwiftFoundation
//
//  Created by Steve McCoole on 1/30/19.
//  Copyright © 2019 block.one. All rights reserved.
//

import Foundation

public extension Date {
    
    /**
        Returns the current data and time as a timestamp.
    */
    static func getFormattedTime() -> String {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let timeString = dateFormatter.string(from: now)
        return timeString
    }
    
    /**
        Initializes a `Data` object from a timestamp string.
 
        - Parameters:
            - yyyyMMddTHHmmss: The timestamp string.
        - Returns: A `Date` object or `nil` if the timestamp string can't be converted to `Date`.
    */
    public init?(yyyyMMddTHHmmss: String?) {
        guard let yyyyMMddTHHmmss = yyyyMMddTHHmmss else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        if let date = formatter.date(from: yyyyMMddTHHmmss) {
            self = date
        } else {
            return nil
        }
    }
    
    /**
        Returns a string representation of the `Date` object.
    */
    public var yyyyMMddTHHmmss: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: self)
    }
    
}

