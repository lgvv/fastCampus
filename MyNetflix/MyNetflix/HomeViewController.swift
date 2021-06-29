//
//  HomeViewController.swift
//  MyNetflix
//
//  Created by Hamlit Jason on 2021/06/29.
//

import UIKit
import AVFoundation

class HomeViewController: UIViewController {

    var awardRecommendListViewController: RecommendListViewController!
    var hotRecommendListViewController: RecommendListViewController!
    var myRecommendListViewController: RecommendListViewController!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "award" {
            let destinationVC = segue.destination as? RecommendListViewController
            awardRecommendListViewController = destinationVC
            awardRecommendListViewController.viewModel.updateType(.award)
            awardRecommendListViewController.viewModel.fetchItems()
        } else if segue.identifier == "hot" {
            let destinationVC = segue.destination as? RecommendListViewController
            hotRecommendListViewController = destinationVC
            hotRecommendListViewController.viewModel.updateType(.hot)
            hotRecommendListViewController.viewModel.fetchItems()
        } else if segue.identifier == "my" {
            let destinationVC = segue.destination as? RecommendListViewController
            myRecommendListViewController = destinationVC
            myRecommendListViewController.viewModel.updateType(.my)
            myRecommendListViewController.viewModel.fetchItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func playButtonTapped(_ sender: Any) {
        
        print("--> 재생 클릭")
        // 인터스텔라에 대한 정보를 검색API로 가져온다.
        // 거기서 인터스텔라 객체 하나를 가져온다.
        // 그 객체를 이용해서 PlayerViewController를 띄운다.
        
        // 인터스텔라 이미지이지만 검색API에 나오지 않아서 토토로로 하버림
        SearchAPI.search("totoro") { movies in
            guard let interstella = movies.first else { // 검색된 값들중 첫번째
                print("--> guard 아웃 : 서치 값이 없음.")
                return
                
            } // 첫번째 원소 가져오고
            DispatchQueue.main.async {
                let url = URL(string: interstella.previewURL)!
                let item = AVPlayerItem(url: url)
                
                let sb = UIStoryboard(name: "Player", bundle: nil)
                let vc = sb.instantiateViewController(identifier: "PlayerViewController") as! PlayerViewController
                vc.modalPresentationStyle = .fullScreen
                vc.player.replaceCurrentItem(with: item)
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
}
