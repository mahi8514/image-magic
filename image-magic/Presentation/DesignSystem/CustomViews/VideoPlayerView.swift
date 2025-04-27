//
//  VideoPlayerView.swift
//  image-magic
//
//  Created by mahi  on 27/04/2025.
//

import SwiftUI
import AVKit

struct VideoPlayerView: View {
    let player: AVPlayer
    let size: CGSize
    
    @State private var isVisible: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            VideoPlayer(player: player)
                .frame(width: size.width, height: size.height * 0.8)
                .allowsHitTesting(false)
                .onAppear {
                    DispatchQueue.main.async {
                        checkVisibility(frame: geo.frame(in: .global))
                    }
                }
                .onChange(of: geo.frame(in: .global)) { oldFrame, newFrame in
                    DispatchQueue.main.async {
                        checkVisibility(frame: newFrame)
                    }
                }
        }
        .frame(width: size.width, height: size.height * 0.8)
    }
    
    private func checkVisibility(frame: CGRect) {
        let visibleHeightLimit = size.height * 0.8
        let visibleWidthLimit = size.width

        let screen = UIScreen.main.bounds

        let visibleHeight = max(0, min(frame.maxY, screen.maxY) - max(frame.minY, screen.minY))
        let visibleWidth = max(0, min(frame.maxX, screen.maxX) - max(frame.minX, screen.minX))

        let verticalVisibility = visibleHeight / visibleHeightLimit
        let horizontalVisibility = visibleWidth / visibleWidthLimit

        let isMostlyVisible = verticalVisibility >= 0.8 && horizontalVisibility >= 0.8

        if isMostlyVisible {
            if !isVisible {
                player.play()
                isVisible = true
            }
        } else {
            if isVisible {
                player.pause()
                isVisible = false
            }
        }
    }
}
