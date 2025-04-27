//
//  Date+Extensions.swift
//  image-magic
//
//  Created by mahi  on 27/04/2025.
//

import Foundation

extension Date {
    
    var relativeTimeDescription: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
    
}
