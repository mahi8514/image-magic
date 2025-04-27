//
//  MockTragetType.swift
//  image-magic
//
//  Created by mahi  on 27/04/2025.
//

@testable import image_magic
import Foundation

enum MockTargetType: TargetType {
    case feedFetch
    case feedFetchByGallery(String)
    case upload(Feed)
        
    var scheme: String {
        return "https"
    }
    
    var baseURL: String {
        return "example.com"
    }
    
    var path: String {
        switch self {
        case .feedFetch, .feedFetchByGallery:
            return "/fetch"
        case .upload:
            return "/add"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .feedFetch, .feedFetchByGallery:
            return .get
        case .upload:
            return .post
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .feedFetch, .feedFetchByGallery, .upload:
            return nil
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .feedFetch:
            return .requestPlain
        case .feedFetchByGallery:
            return .requestParameters(parameters: ["category": "tech"])
        case .upload(let body):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            encoder.dateEncodingStrategy = .formatted(.yearMonthDayFormatter)
            return .requestJSONEncodable(body, encoder: encoder)
        }
    }
}
