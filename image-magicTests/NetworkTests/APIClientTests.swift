//
//  APIClientTests.swift
//  image-magicTests
//
//  Created by mahi  on 27/04/2025.
//

import XCTest
@testable import image_magic

final class APIClientTests: XCTestCase {
    
    var mockURLSession: MockURLSession!
    var apiClient: APIClient<MockTargetType>!

    override func setUpWithError() throws {
        mockURLSession = MockURLSession()
        apiClient = APIClient(urlSession: mockURLSession)
    }

    override func tearDownWithError() throws {
        apiClient = nil
        mockURLSession = nil
    }
    
    func testFeedFetchSuccess() async throws {
        
        let expected: Response<[Feed]> = .init(data: [Feed.preview], success: true, status: 200)
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        
        let jsonData = try! encoder.encode(expected)
        
        mockURLSession.data = jsonData
        
        mockURLSession.response = HTTPURLResponse(url: try MockTargetType.feedFetch.asURL(), statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let response: Response<[Feed]> = try await apiClient.request(target: .feedFetch)
        
        XCTAssertEqual(response.data, expected.data)
        XCTAssertEqual(response.status, expected.status)
        XCTAssertEqual(response.success, expected.success)
    }
    
    func testArticleFetchDecodingError() async throws {
        
        struct AnyKey: CodingKey {
            var stringValue: String
            var intValue: Int?

            init?(stringValue: String) {
                self.stringValue = stringValue
            }

            init?(intValue: Int) {
                self.stringValue = "\(intValue)"
                self.intValue = intValue
            }
        }
        
        let expected: Response<[Feed]> = .init(data: [Feed.preview], success: true, status: 200)
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .custom { codingPath in
            let lastKey = codingPath.last!
            return AnyKey(stringValue: lastKey.stringValue + "_corrupted")!
        }
        
        let jsonData = try! encoder.encode(expected)
        
        mockURLSession.data = jsonData
        
        mockURLSession.response = HTTPURLResponse(url: try MockTargetType.feedFetch.asURL(), statusCode: 200, httpVersion: nil, headerFields: nil)
        
        do {
            let _ : Response<[Feed]> = try await apiClient.request(target: .feedFetch)
            XCTFail("Expected failure, but got success")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .decodingError, "Expected NetworkError.decodingError but got \(error)")
        } catch {
            XCTFail("Expected error")
        }
    }
    
    func testArticleFetchUnauthorizedError() async throws {
        mockURLSession.data = Data()
        mockURLSession.response = HTTPURLResponse(url: try MockTargetType.feedFetch.asURL(), statusCode: 401, httpVersion: nil, headerFields: nil)
        
        do {
            let _ : Response<[Feed]> = try await apiClient.request(target: .feedFetch)
            XCTFail("Expected failure, but got success")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .unauthorized, "Expected NetworkError.decodingError but got \(error)")
        } catch {
            XCTFail("Expected error")
        }
    }

}

