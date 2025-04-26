//
//  DateFormatter+Extension.swift
//  image-magic
//
//  Created by mahi  on 26/04/2025.
//

import Foundation

extension DateFormatter {
    static var yearMonthDayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
}
