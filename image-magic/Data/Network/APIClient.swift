//
//  APIClient.swift
//  image-magic
//
//  Created by mahi  on 26/04/2025.
//

import Foundation

protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol { }

class APIClient<Target: TargetType> {
    
    private let urlSession: URLSessionProtocol
    private let keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy
    private let dateDecodingStrategy: JSONDecoder.DateDecodingStrategy
    
    init(urlSession: URLSessionProtocol = URLSession.shared,
         keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase,
         dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .formatted(.yearMonthDayFormatter)) {
        self.urlSession = urlSession
        self.keyDecodingStrategy = keyDecodingStrategy
        self.dateDecodingStrategy = dateDecodingStrategy
    }
    
    func request<T: Decodable>(target: Target) async throws -> T {
        let request = try target.makeURLRequest()
        print(request.cURL())
        let (data, response) = try await urlSession.data(for: request)
        return try handleResponse(data: data, response: response)
    }
    
    private func handleResponse<T: Decodable>(data: Data, response: URLResponse) throws -> T {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        if (200..<300).contains(httpResponse.statusCode) {
            return try decode(data: data)
        } else {
            throw NetworkError(from: httpResponse.statusCode)
        }
    }
    
    private func decode<T: Decodable>(data: Data) throws -> T {
        do {
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = keyDecodingStrategy
            jsonDecoder.dateDecodingStrategy = dateDecodingStrategy
            let decodedResponse = try jsonDecoder.decode(T.self, from: data)
            return decodedResponse
        } catch {
            throw NetworkError.decodingError
        }
    }
    
}
