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
                    checkVisibility(frame: geo.frame(in: .global))
                }
                .onChange(of: geo.frame(in: .global)) { _, frame in
                    checkVisibility(frame: frame)
                }
        }
        .frame(width: size.width, height: size.height * 0.8)
    }
    
    private func checkVisibility(frame: CGRect) {
        let screenHeight = UIScreen.main.bounds.height
        let visibleHeight = max(0, min(frame.maxY, screenHeight) - max(frame.minY, 0))
        let visibility = visibleHeight / (size.height * 0.8)
        
        if visibility >= 0.8 {
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
