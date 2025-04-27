//
//  FeedItemView.swift
//  image-magic
//
//  Created by mahi  on 27/04/2025.
//

import SwiftUI
import AVKit

struct FeedItemView: View {
    
    let feed: Feed
    let size: CGSize
    
    @State private var loadedImage: UIImage? = nil
    
    var body: some View {
        VStack {
            
            VStack(alignment: .leading) {
                
                MediaContainer(medias: feed.images ?? [], size: size)
                
                Text(feed.title)
                    .font(.callout)
                    .lineLimit(1)
                    .padding(.horizontal)
            }
            
            Divider()
        }
    }
}


struct MediaContainer: View {
    
    struct ResolvedContent {
        let image: Feed.Image
        let type: ResolvedContentType
        
        enum ResolvedContentType {
            case image(UIImage)
            case video(AVPlayer)
        }
    }
    
    private let medias: [Feed.Image]
    private let size: CGSize
    
    init(medias: [Feed.Image], size: CGSize) {
        self.medias = medias
        self.size = size
    }
    
    @State private var contents: [ResolvedContent] = []
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                if contents.isEmpty {
                    ForEach(medias, id: \.id) { _ in
                        ProgressView()
                            .frame(width: size.width, height: size.height * 0.5)
                    }
                } else {
                    ForEach(contents, id: \.image.id) { content in
                        switch content.type {
                        case .image(let image):
                            imageView(image: image)
                        case .video(let player):
                            videoView(avPlayer: player)
                        }
                    }
                }
            }
            
        }
        .task {
            await loadMedias()
        }
    }
    
    private func imageView(image: UIImage) -> some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .frame(width: size.width)
    }
    
    private func videoView(avPlayer: AVPlayer) -> some View {
        VideoPlayer(player: avPlayer)
            .frame(width: size.width, height: size.height * 0.5)
    }
    
    private func loadMedias() async {
        var resolvedContents: [ResolvedContent] = []
        
        for media in medias {
            if let linkUrl = URL(string: media.link) {
                if media.type.isImage {
                    if let image = await ImageCache.shared.loadImage(from: linkUrl) {
                        resolvedContents.append(.init(image: media, type: .image(image)))
                    }
                } else {
                    resolvedContents.append(.init(image: media, type: .video(.init(url: linkUrl))))
                }
            }
        }
        
        contents = resolvedContents
    }
}











actor ImageCache {
    static let shared = ImageCache()
    
    private let memoryCache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func loadImage(from url: URL) async -> UIImage? {
        let cacheKey = url.absoluteString as NSString
        
        // 1. Check memory cache
        if let cachedImage = memoryCache.object(forKey: cacheKey) {
            return cachedImage
        }
        
        // 2. Check disk cache
        let fileURL = getDiskCacheURL(for: url)
        if let image = await readImageFromDisk(at: fileURL) {
            memoryCache.setObject(image, forKey: cacheKey)
            return image
        }
        
        // 3. Download from network
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else {
                return nil
            }
            
            // Save to memory and disk
            memoryCache.setObject(image, forKey: cacheKey)
            await writeImageToDisk(data, at: fileURL)
            
            return image
        } catch {
            return nil
        }
    }
    
    private func getDiskCacheURL(for url: URL) -> URL {
        let fileName = url.lastPathComponent
        let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return cachesDirectory.appendingPathComponent(fileName)
    }
    
    private func readImageFromDisk(at fileURL: URL) async -> UIImage? {
        return await withCheckedContinuation { continuation in
            if let image = UIImage(contentsOfFile: fileURL.path) {
                continuation.resume(returning: image)
            } else {
                continuation.resume(returning: nil)
            }
        }
    }
    
    private func writeImageToDisk(_ data: Data, at fileURL: URL) async {
        await withCheckedContinuation { continuation in
            do {
                try data.write(to: fileURL)
                continuation.resume()
            } catch {
                continuation.resume()
            }
        }
    }
    
    func clearCache() async {
            // Clear in-memory cache
            memoryCache.removeAllObjects()
            
            // Clear disk cache
            await withCheckedContinuation { continuation in
                let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
                do {
                    let fileURLs = try FileManager.default.contentsOfDirectory(at: cachesDirectory, includingPropertiesForKeys: nil)
                    for fileURL in fileURLs {
                        try? FileManager.default.removeItem(at: fileURL)
                    }
                } catch {
                    print(String(describing: error))
                }
                continuation.resume()
            }
        }
}

                        
                        
                        
