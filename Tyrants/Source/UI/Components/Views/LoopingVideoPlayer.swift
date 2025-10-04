import AVKit
import SwiftUI

struct LoopingVideoPlayer: UIViewRepresentable {
    let videoName: String
    let videoType: String
    
    func makeUIView(context: Context) -> UIView {
        return LoppingPlayerView(videoName: videoName, videoType: videoType)
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Empty
    }
}

final class LoppingPlayerView: UIView {
    private var playerLoop: AVPlayerLooper?
    private let queuePlayer = AVQueuePlayer()
    
    init(videoName: String, videoType: String) {
        super.init(frame: .zero)
        guard let path = Bundle.main.path(forResource: videoName, ofType: videoType) else {
            print("Video não encontrado: \(videoName).\(videoType)")
            return
        }
        let url = URL(filePath: path)
        let playerItem = AVPlayerItem(url: url)
        
        let playerLayer = AVPlayerLayer(player: queuePlayer)
        playerLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(playerLayer)
        
        playerLoop = AVPlayerLooper(player: queuePlayer, templateItem: playerItem)
        queuePlayer.play()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.sublayers?.first?.frame = bounds
    }
}
