//
//  TrackManager.swift
//  AppleMusicStApp
//
//  Created by Hamlit Jason on 2021/06/23.
//

import UIKit
import AVFoundation

class TrackManager {
    // TODO: 프로퍼티 정의하기 - 트랙들, 앨범들, 오늘의 곡
    var tracks : [AVPlayerItem] = [] // AVPlayerItem으로 구현할 수 있다고 한다.
    var albums : [Album] = []
    var todaysTrack : AVPlayerItem?
    
    
    // TODO: 생성자 정의하기
    init() {
        let tracks = loadTracks()
        self.tracks = tracks
        self.albums = loadAlbums(tracks: tracks)
        self.todaysTrack = self.tracks.randomElement()
    }

    // TODO: 트랙 로드하기
    func loadTracks() -> [AVPlayerItem] {
        // 1. 파일들 읽어서 AVPlayerItem 타입의 형태로 만들기.
        let urls = Bundle.main.urls(forResourcesWithExtension: "mp3", subdirectory: nil) ?? [] // .mp3 파일 가져오는데 없으면 깡통들 세팅해주기 - bundle은 앱 안을 이야기함.
        let items = urls.map { url in
            return AVPlayerItem(url: url)
        }
        return items
    }
    
    // TODO: 인덱스에 맞는 트랙 로드하기
    func track(at index: Int) -> Track? {
        let playerItem = tracks[index] // AVPlayerItem 타입이라서 Track타입으로 바꿔야 해
        return playerItem.convertToTrack()
        
    }

    // TODO: 앨범 로딩메소드 구현
    func loadAlbums(tracks: [AVPlayerItem]) -> [Album] {
        let trackList : [Track] = tracks.compactMap { $0.convertToTrack()}
        let albumDics = Dictionary(grouping: trackList) { (track) in track.albumName } // 트랙들을 이용해 딕셔너리를 만들건데, 각각의 이름 별로 트랙들을 나눌건데 이런식으로 그룹핑해서 쓸 수 있다.
        var albums : [Album] = []
        for (key, value) in albumDics {
            let title = key
            let tracks = value
            let album = Album(title: title, tracks: tracks)
            albums.append(album)
        }
        return albums
    }

    // TODO: 오늘의 트랙 랜덤으로 선책
    func loadOtherTodaysTrack() {
        self.todaysTrack = self.tracks.randomElement()
    }
}
