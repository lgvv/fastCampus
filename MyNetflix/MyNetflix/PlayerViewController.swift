//
//  PlayerViewController.swift
//  MyNetflix
//
//  Created by Hamlit Jason on 2021/06/29.
//

import UIKit
import AVFoundation

class PlayerViewController: UIViewController {

    @IBOutlet weak var playerView: PlayerView!
    @IBOutlet weak var controlView: UIView!
    @IBOutlet weak var playButton: UIButton!
    
    let player = AVPlayer()
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
        // 그냥 랜드스케이프는 좌우 둘다, 좌 or 우 하나만 줄수도 있음
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerView.player = player // 애플 다큐먼트에서 가져온 코드PlayerView를 PlayerViewController 안에 있는 View가 상속받고, 이거의 플레이어는 output이라고 화면에 보여주는걸 담당하는데 그거에 우리가 선언한 player를 넣어서 보여주라고 한다.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        play()
    }
    
    @IBAction func togglePlayButton(_ sender: Any) {
        if player.isPlaying {
            pause() // 내장함수랑 메소드명이 겹쳐서 인스턴스 메소드를 구현해줘야 올바르게 작동함
        } else {
            play()
        }
    }
    
    func play() {
        player.play()
        playButton.isSelected = true
        
    }
    
    func pause() {
        player.pause()
        playButton.isSelected = false
    }
    
    func reset() {
        pause()
        dismiss(animated: false, completion: nil)
    }
    
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        reset()
        dismiss(animated: false, completion: nil)
    }
}

extension AVPlayer {
    var isPlaying: Bool { // 플레이어가 진행중인지 아닌지 확인하는 코드
        guard self.currentItem != nil else { return false }
        return self.rate != 0
    }
}
