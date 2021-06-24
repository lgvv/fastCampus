//
//  HomeViewController.swift
//  AppleMusicStApp
//
//  Created by Hamlit Jason on 2021/06/23.
//

import UIKit

class HomeViewController : UIViewController {
    
    let trackManager : TrackManager = TrackManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension HomeViewController : UICollectionViewDataSource {
    
    // 몇개가 표시될까?
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // TODO : 트랙매니저에서 트랙갯수 가져오기
        return trackManager.tracks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrackCollectionViewCell", for: indexPath) as? TrackCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let track = trackManager.track(at: indexPath.item)
        cell.updateUI(item: track)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let item = trackManager.todaysTrack else {
                return UICollectionReusableView()
            }
            
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TrackCollectionHeaderView", for: indexPath) as? TrackCollectionHeaderView else {
                return UICollectionReusableView()
            }
            
            header.update(with: item)
            header.tapHandler = { item in
                let playerStoryboard = UIStoryboard.init(name: "Player", bundle: nil) // 스토리보드 파일 객체 생성
                guard let playerVC = playerStoryboard.instantiateViewController(identifier: "PlayerViewController") as? PlayerViewController else { return } // 플레이어스토리보드에서 ID에 해당하는 ViewController 찾기
                playerVC.simplePlayer.replaceCurrentItem(with: item) // 싱글톤 패턴을 이용해서 갈아끼기
                self.present(playerVC, animated: true, completion: nil)
            }
            
            return header
        default:
            return UICollectionReusableView()
        }
    }
        
}

extension HomeViewController : UICollectionViewDelegate {
    // 클릭했을 때 어떻게 할까?
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO : 곡 클릭시 플레이어뷰 띄우기
        let playerStoryboard = UIStoryboard.init( name: "Player", bundle: nil) // 플레이어스토리보드를 가져오는 객체
        guard let playerVC = playerStoryboard.instantiateViewController(identifier: "PlayerViewController") as? PlayerViewController else {
            return
        }
        let item = trackManager.tracks[indexPath.item] // 트랙매니저한테 물어보고
        playerVC.simplePlayer.replaceCurrentItem(with: item) // 싱글톤 패턴을 이용해서 갈아끼기
        present(playerVC, animated: true, completion: nil)
        
    }
}

extension HomeViewController : UICollectionViewDelegateFlowLayout {
    // 셀 사이즈는 어떻게 할까?
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 20 - card(width) - 20 - card(width) - 20
        // TODO : 셀 사이즈 구하기
        let itemSpacing : CGFloat = 20 // 아이템 사이의 간격
        let margin : CGFloat = 20 // 좌우 margin
        let width = (collectionView.bounds.width - itemSpacing - margin * 2) / 2
        //print("-->\(collectionView.bounds.width), width \(width)")
        let height = width + 60 // 높이는 고정 높이 유지하게끔.
        
        
        return CGSize(width: width, height: height)
    }
}
