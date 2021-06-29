//
//  Preview.swift
//  MyNetflix
//
//  Created by Hamlit Jason on 2021/06/29.
//

// https://developer.apple.com/documentation/avfoundation/avplayerlayer


// 애플 다큐먼트에서 찾아서 이 코드를 그대로 가져옴!
import UIKit
import AVFoundation

class PlayerView: UIView {
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    // Override UIView property
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
}
