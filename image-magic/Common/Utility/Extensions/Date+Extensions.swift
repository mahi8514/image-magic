//
//  Date+Extensions.swift
//  image-magic
//
//  Created by mahi  on 27/04/2025.
//

import Foundation

extension Date {
    
    func relativeTimeDescription(to date: Date = Date()) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: date)
    }
    
}
