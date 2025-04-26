//
//  TargetType.swift
//  image-magic
//
//  Created by mahi  on 26/04/2025.
//

import Foundation

typealias HTTPHeaders = [String: String]
typealias HTTPParameters = [String: String]

protocol TargetType {
    
    var scheme: String { get }
    
    var baseURL: String { get }
    
    var path: String { get }
    
    var method: HTTPMethod { get }
    
    var headers: HTTPHeaders? { get }
    
    var task: HTTPTask { get }
    
}

extension TargetType {
    
    func asURL() throws -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host =  baseURL
        urlComponents.path = path
        
        guard let url = urlComponents.url else {
            throw NetworkError.invalidURL
        }
        return url
    }
    
    func makeURLRequest() throws -> URLRequest {
        var request = URLRequest(url: try asURL())
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        
        switch task {
        case .requestPlain:
            return request
        case .requestParameters(let parameters):
            request.updateQueryParameters(with: parameters)
            return request
        case .requestJSONEncodable(let encodable, let encoder):
            request.httpBody = try encoder.encode(encodable)
            let contentTypeHeaderName = "Content-Type"
            if request.value(forHTTPHeaderField: contentTypeHeaderName) == nil {
                request.setValue("application/json", forHTTPHeaderField: contentTypeHeaderName)
            }
            return request
        }
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case put = "PUT"
    case patch = "PATCH"
}

enum HTTPTask {
    
    case requestPlain
    case requestJSONEncodable(Encodable, encoder: JSONEncoder = JSONEncoder())
    case requestParameters(parameters: HTTPParameters)
    
}
