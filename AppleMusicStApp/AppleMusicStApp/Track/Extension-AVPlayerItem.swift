//
//  Extension-AVPlayerItem.swift
//  AppleMusicStApp
//
//  Created by Hamlit Jason on 2021/06/23.
//

import AVFoundation
import UIKit

extension AVPlayerItem {
    func convertToTrack() -> Track? {
        let metadatList = asset.metadata // AVPlayItem 객체 안에 asset이라는 프로퍼티가 있고, 거기에는 메타데이터라고 해갖고, 어떤 곡이란 파일이 있을때, 곡 음원도 있고, 곡 음원의 메타데이터라고 해가지고 아티스트 정보, 타이블, 곡의 썸네일 등의 정보도 들어있는데, 이런 정보들을 가져올 수가 있다.
        
        var trackTitle: String?
        var trackArtist: String?
        var trackAlbumName: String?
        var trackArtwork: UIImage?
        
        // 음악파일에서 곡의 메타데이터를 추출해내서 트랙을 만들수가 있다. - 직접 구현할 필요보다 검색해서 쓰는걸로 해요.
        for metadata in metadatList {
            if let title = metadata.title {
                trackTitle = title
            }
            
            if let artist = metadata.artist {
               trackArtist = artist
            }
            
            if let albumName = metadata.albumName {
                trackAlbumName = albumName
            }
            
            if let artwork = metadata.artwork {
                trackArtwork = artwork
            }
        }
        
        guard let title = trackTitle,
            let artist = trackArtist,
            let albumName = trackAlbumName,
            let artwork = trackArtwork else {
                return nil
        }
        return Track(title: title, artist: artist, albumName: albumName, artwork: artwork)
    }
}
 
extension AVMetadataItem {
    var title: String? {
        guard let key = commonKey?.rawValue, key == "title" else {
            return nil
        }
        return stringValue
    }
    
    var artist: String? {
        guard let key = commonKey?.rawValue, key == "artist" else {
            return nil
        }
        return stringValue
    }
    
    var albumName: String? {
        guard let key = commonKey?.rawValue, key == "albumName" else {
            return nil
        }
        return stringValue
    }
    
    var artwork: UIImage? {
        guard let key = commonKey?.rawValue, key == "artwork", let data = dataValue, let image = UIImage(data: data) else {
            return nil
        }
        return image
    }
}

extension AVPlayer {
    var isPlaying: Bool {
        guard self.currentItem != nil else { return false }
        return self.rate != 0
    }
}
