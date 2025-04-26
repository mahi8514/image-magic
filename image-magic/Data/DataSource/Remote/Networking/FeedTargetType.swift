//
//  FeedTargetType.swift
//  image-magic
//
//  Created by mahi  on 26/04/2025.
//

enum FeedTargetType: TargetType {
    
    case feeds(page: Int)
    
    var scheme: String {
        return "https"
    }
    
    var baseURL: String {
        APIConfig.baseUrl
    }
    
    var path: String {
        switch self {
        case .feeds(let page):
            return "/3/gallery/hot/time/day/\(page)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .feeds:
            return .get
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .feeds:
            return ["Authorization": "Client-ID \(APIKeys.imgurClientId)"]
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .feeds:
            return .requestPlain
        }
    }
    
    private var parameters: HTTPParameters {
        var parameters: HTTPParameters = [:]
        // Add parameters if needed
        return parameters
    }
}
