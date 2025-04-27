//
//  TargetTypeTests.swift
//  image-magic
//
//  Created by mahi  on 27/04/2025.
//

import XCTest
@testable import image_magic

final class TargetTypeTests: XCTestCase {
    
    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        
    }
    
    func testURLRequestPlainTask() throws {
        let urlString = "https://example.com/fetch"
        let targetTypeUrlRequest = try MockTargetType.feedFetch.makeURLRequest()
        XCTAssertEqual(targetTypeUrlRequest.url!.absoluteString, urlString)
        XCTAssertEqual(targetTypeUrlRequest.httpMethod, HTTPMethod.get.rawValue)
    }
    
    func testURLRequestParametersTask() throws {
        let category = "tech"
        let urlString = "https://example.com/fetch?category=\(category)"
        let targetTypeUrlRequest = try MockTargetType.feedFetchByGallery(category).makeURLRequest()
        XCTAssertEqual(targetTypeUrlRequest.url!.absoluteString, urlString)
        XCTAssertEqual(targetTypeUrlRequest.httpMethod, HTTPMethod.get.rawValue)
    }
    
    func testURLRequestEncodableTask() throws {
        let urlString = "https://example.com/add"
        let targetTypeUrlRequest = try MockTargetType.upload(.preview).makeURLRequest()
        XCTAssertEqual(targetTypeUrlRequest.url!.absoluteString, urlString)
        XCTAssertNotNil(targetTypeUrlRequest.allHTTPHeaderFields)
        if let headers = targetTypeUrlRequest.allHTTPHeaderFields {
            XCTAssertTrue(headers.keys.contains("Content-Type"), "Headers should contain 'Content-Type' key")
        } else {
            XCTFail("Failed to unwrap headers")
        }
        XCTAssertNotNil(targetTypeUrlRequest.httpBody)
        XCTAssertEqual(targetTypeUrlRequest.httpMethod, HTTPMethod.post.rawValue)
    }
    
}
