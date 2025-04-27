//
//  UtilityTests.swift
//  image-magic
//
//  Created by mahi  on 27/04/2025.
//

import XCTest
@testable import image_magic

final class UtilityTests: XCTestCase {
    
    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        
    }
    
    func testYearMonthDayFormatter() throws {
        let dateFormatter = DateFormatter.yearMonthDayFormatter
        let calendar = Calendar.current
        let components: DateComponents = .init(year: 2025, month: 2, day: 20)
        let date = calendar.date(from: components)!
        let formattedDate = dateFormatter.string(from: date)
        XCTAssertEqual(formattedDate, "2025-02-20")
        let convertedDate = dateFormatter.date(from: "2025-02-20")
        XCTAssertNotNil(convertedDate)
        XCTAssertEqual(calendar.dateComponents([.year, .month, .day], from: convertedDate!), components)
    }
    
    func testRelativeDateDescription() throws {
        let dateSince1970 = Date(timeIntervalSince1970: 1745766236)
        let relativeDateCheck = Date(timeIntervalSince1970: 1745785005)
        let relativeDate = dateSince1970.relativeTimeDescription(to: relativeDateCheck)
        XCTAssertEqual(relativeDate, "5 hours ago")
    }
    
    func testcURL() throws {
        let expectedPlainRequestcURL = "curl -X GET 'https://example.com/fetch' "
        XCTAssertEqual(expectedPlainRequestcURL, try MockTargetType.feedFetch.makeURLRequest().cURL())
        
        let expectedParametersRequestcURL = "curl -X GET 'https://example.com/fetch?category=tech' "
        XCTAssertEqual(expectedParametersRequestcURL, try MockTargetType.feedFetchByGallery("tech").makeURLRequest().cURL())
    }
    
}
