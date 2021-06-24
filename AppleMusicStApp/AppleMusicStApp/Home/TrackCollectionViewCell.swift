//
//  TrackCollectionViewCell.swift
//  AppleMusicStApp
//
//  Created by Hamlit Jason on 2021/06/23.
//

import UIKit

class TrackCollectionViewCell : UICollectionViewCell {
    @IBOutlet weak var trackThumbnail : UIImageView!
    @IBOutlet weak var trackTitle : UILabel!
    @IBOutlet weak var trackArtist : UILabel!
    
    override func awakeFromNib() { // 스토리보드에 있는 아이템에서 실제로 앱 안의 어떤 UICollectionView로 로드될때, 이 메소드가 호출된다.
        super.awakeFromNib()
        trackThumbnail.layer.cornerRadius = 4
        trackArtist.textColor = UIColor.systemGray
    }
    
    func updateUI(item : Track?) {
        // TODO : // 곡정보 표시하기
        guard let track = item else { return }
        trackThumbnail.image = track.artwork
        trackTitle.text = track.title
        trackArtist.text = track.artist
    }
    
}
