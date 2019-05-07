//
//  DateExtensions.swift
//  EosioSwift
//
//  Created by Steve McCoole on 1/30/19.
//  Copyright (c) 2017-2019 block.one and its contributors. All rights reserved.
//

import Foundation

public extension Date {

    /// Get the current date and time, formatted.
    ///
    /// - Returns: The current data and time as a timestamp.
    static func getFormattedTime() -> String {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let timeString = dateFormatter.string(from: now)
        return timeString
    }

    /// Initializes a `Data` object from a timestamp string.
    ///
    /// - Parameter yyyyMMddTHHmmss: The timestamp string.
    /// - Returns: `nil` if the timestamp string cannot be converted to a `Date`.
    init?(yyyyMMddTHHmmss: String?) {
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

    /// Returns a string representation of the `Date` object.
    var yyyyMMddTHHmmss: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: self)
    }

    /// Returns a DateFormatter instance customized for `JSONEncoder.dateEncodingStrategy`.
    static let asTransactionTimestamp: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

}
