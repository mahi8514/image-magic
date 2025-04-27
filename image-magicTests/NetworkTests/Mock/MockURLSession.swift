//
//  MockURLSession.swift
//  image-magic
//
//  Created by mahi  on 27/04/2025.
//

@testable import image_magic
import Foundation

class MockURLSession: URLSessionProtocol {
    var data: Data?
    var response: URLResponse?
    var error: Error?

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        if let error = error {
            throw error
        }
        guard let data = data, let response = response else {
            throw NSError(domain: "MockSession Error", code: 500, userInfo: nil)
        }
        return (data, response)
    }
}
