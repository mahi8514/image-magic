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
        TabView {
            if contents.isEmpty {
                ForEach(medias, id: \.id) { _ in
                    ProgressView()
                        .frame(width: size.width, height: size.height * 0.8)
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
        .tabViewStyle(.page(indexDisplayMode: medias.count > 1 ? .always : .never))
        .frame(width: size.width, height: size.height * 0.8)
        .task {
            await loadMedias()
        }
    }
    
    private func imageView(image: UIImage) -> some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .frame(width: size.width, height: size.height * 0.8)
    }
    
    private func videoView(avPlayer: AVPlayer) -> some View {
        VideoPlayerView(player: avPlayer, size: size)
    }
    
    private func loadMedias() async {
        var resolvedContents: [ResolvedContent] = []
        
        for media in medias {
            if let linkUrl = URL(string: media.link) {
                if media.type.isImage {
                    if let image = await ImageCacher.shared.loadImage(from: linkUrl) {
                        resolvedContents.append(.init(image: media, type: .image(image)))
                    }
                } else {
                    if let player = await loadPlayer(url: linkUrl) {
                        resolvedContents.append(.init(image: media, type: .video(player)))
                    }
                }
            }
        }
        
        contents = resolvedContents
    }
    
    private func loadPlayer(url: URL) async -> AVPlayer? {
        let asset = AVURLAsset(url: url)
        do {
            let tracks: [AVAssetTrack] = try await asset.load(.tracks)
            if let track = tracks.first {
                let _ = try await track.load(.preferredTransform)
                let player = AVPlayer(playerItem: AVPlayerItem(asset: asset))
                return player
            } else {
                print("Cannot play the asset")
                return nil
            }
        } catch {
            print("Failed to load asset: \(error.localizedDescription)")
            return nil
        }
    }
}

                        
                        
                        
