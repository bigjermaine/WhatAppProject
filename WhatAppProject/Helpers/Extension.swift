//
//  Extension.swift
//  WhatAppProject
//
//  Created by Daniel Jermaine on 15/04/2025.
//

import Foundation

extension Date {
    // MARK: - Date Representation
    
    /// Returns a formatted string representation of the date:
    /// - If today: "3:30 PM" (time only)
    /// - If yesterday: "Yesterday"
    /// - Otherwise: "02/15/24" (short date format)
    var dayOrTimeRepresentation: String {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        
        if calendar.isDateInToday(self) {
            return formattedTime
        } else if calendar.isDateInYesterday(self) {
            return "Yesterday"
        } else {
            return formattedShortDate
        }
    }
    
    /// Returns time in "h:mm a" format (e.g., "3:30 PM")
    var formattedTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: self)
    }
    
    /// Returns date in "MM/dd/yy" format (e.g., "02/15/24")
    var formattedShortDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        return dateFormatter.string(from: self)
    }
    
    // MARK: - Additional Useful Date Formats
    
    /// Returns date in full day name format (e.g., "Monday")
    var dayName: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
    
    /// Returns date in month and day format (e.g., "Feb 15")
    var monthAndDay: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        return dateFormatter.string(from: self)
    }
    
    /// Returns date in full format (e.g., "February 15, 2024")
    var fullDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: self)
    }
    
    // MARK: - Date Comparison Helpers
    func toString(format: String) -> String {
           let formatter = DateFormatter()
           formatter.dateFormat = format
           return formatter.string(from: self)
       }
    
    var relativeDateString: String {
        let calendar = Calendar.current

        if calendar.isDateInToday(self) {
            return "Today"
        } else if calendar.isDateInYesterday(self) {
            return "Yesterday"
        } else if calendar.isDate(self, equalTo: Date(), toGranularity: .weekOfYear) {
            return self.toString(format: "EEEE") // e.g., "Monday"
        } else if calendar.isDate(self, equalTo: Date(), toGranularity: .year) {
            return self.toString(format: "E, MMM d") // e.g., "Mon, Feb 19"
        } else {
            return self.toString(format: "E, MMM d, yyyy") // e.g., "Mon, Feb 19, 2019"
        }
    }

    
    /// Returns true if the date is within the current week
    var isInCurrentWeek: Bool {
        Calendar.current.isDate(self, equalTo: Date(), toGranularity: .weekOfYear)
    }
    
    /// Returns true if the date is within the current year
    var isInCurrentYear: Bool {
        Calendar.current.isDate(self, equalTo: Date(), toGranularity: .year)
    }
}
