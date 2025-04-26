//
//  Entity+Extensions.swift
//  image-magic
//
//  Created by mahi  on 26/04/2025.
//

extension FeedEntity {
    var feed: Feed? {
        guard let id, let title else { return nil }
        let imageEntities = images?.array as? [ImageEntity] ?? []
        let feedImages = imageEntities.compactMap { $0.image }
        return .init(id: id, title: title, description: feedDescription, datetime: datetime, views: Int(views), ups: Int(ups), downs: Int(downs), commentCount: Int(commentCount), favoriteCount: Int(favoriteCount), images: feedImages)
    }
}

extension ImageEntity {
    var image: Feed.Image? {
        guard let id, let title, let type, let link else { return nil }
        guard let mediaType = Feed.Image.MediaType(rawValue: type) else { return nil }
        return .init(id: id, title: title, datetime: datetime, size: size, type: mediaType, link: link, gifv: gifv)
    }
}
