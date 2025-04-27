//
//  ImageCacher.swift
//  image-magic
//
//  Created by mahi  on 27/04/2025.
//

import UIKit

actor ImageCacher {
    static let shared = ImageCacher()
    
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
