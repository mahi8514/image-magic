//
//  FeedPreview.swift
//  image-magic
//
//  Created by mahi  on 27/04/2025.
//

@testable import image_magic
import Foundation

extension Feed {
    
    static var preview: Feed {
        .init(id: "123",
              title: "Test feed",
              description: "Test feed description",
              datetime: Date().timeIntervalSince1970,
              views: 550,
              ups: 75,
              downs: 12,
              commentCount: 24,
              favoriteCount: 15,
              images: nil)
    }
    
}
