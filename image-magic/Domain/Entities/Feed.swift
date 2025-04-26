//
//  Untitled.swift
//  image-magic
//
//  Created by mahi  on 26/04/2025.
//

struct Response<T: Codable>: Codable {
    let data: T?
    let success: Bool
    let status: Int
}

struct Feed: Codable {
    
    let id: String
    let title: String
    let description: String?
    let datetime: Double
    let views: Int
    let ups: Int
    let downs: Int
    let commentCount: Int
    let favoriteCount: Int
    let images: [Image]?
    
    struct Image: Codable {
        let id: String
        let title: String?
        let datetime: Double
        let size: Double
        let type: MediaType
        let link: String
        let gifv: String?
        
        enum MediaType: String, Codable {
            case gifImage = "image/gif"
            case jpegImage = "image/jpeg"
            case pngImage = "image/png"
            case video = "video/mp4"
        }
    }
}

extension Feed: Equatable {
    static func == (lhs: Feed, rhs: Feed) -> Bool {
        lhs.id == rhs.id
    }
}

extension Feed: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
