//
//  DetailViewController.swift
//  BountyList
//
//  Created by Hamlit Jason on 2021/06/20.
//

import UIKit

class DetailViewController: UIViewController {

    // MVVM
    // 모든 개발자가 그런건 아니지만 무엇이 필요한지 적어보고 시작하는 것도 좋다.
    
    // Model
    // - BountyInfo > 만들자
    
    // View
    // - imgView, nameLabel, bountyLabel
    // > view들은 viewModel을 통해서 구성되기 ?
    
    // ViewModel
    // - DetailViewModel > 만들기
    // > 만들고, View 레이어에서 필요한 메소드 만들기
    // > 모델을 가지고 있기 ,, BountyInfo 들
    
    @IBOutlet weak var imgView : UIImageView!
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var bountyLabel : UILabel!
    
    let viewModel = DetailViewModel()
    
    override func viewDidLoad() { // 메모리에 올라왔을 때
        super.viewDidLoad()
        updateUI()
        prepareAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) { // 뷰가 보여지기 전에
        super.viewDidAppear(animated)
        showAnimation()
    }
    
    private func prepareAnimation() {
        nameLabel.transform = CGAffineTransform(translationX: view.bounds.width, y: 0).scaledBy(x: 3, y: 3).rotated(by: 180) // 위치이통 - 스케일은 3배 - 회전은 180도
        bountyLabel.transform = CGAffineTransform(translationX: view.bounds.width, y: 0).scaledBy(x: 3, y: 3).rotated(by: 180) // 위치이통 - 스케일은 3배 - 회전은 180도
    
        nameLabel.alpha = 0
        bountyLabel.alpha = 0
    }
    
    private func showAnimation() {
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 2, options: .allowUserInteraction, animations: {
            self.nameLabel.transform = CGAffineTransform.identity // 변형이 없는 모습의 정보로
            self.nameLabel.alpha = 1
        }, completion: nil)
        
        UIView.animate(withDuration: 1, delay: 0.2, usingSpringWithDamping: 0.6, initialSpringVelocity: 2, options: .allowUserInteraction, animations: {
            self.bountyLabel.transform = CGAffineTransform.identity
            self.bountyLabel.alpha = 1
        }, completion: nil)
        
        UIView.transition(with: imgView, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)

    }
    
    func updateUI() {
        if let bountyInfo = self.viewModel.bountyInfo {
            imgView.image = bountyInfo.image
            nameLabel.text = bountyInfo.name
            bountyLabel.text = "\(bountyInfo.bounty)"
        }
    }

    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil) // 현재 뷰 컨트롤러는 사라진다.
    }
    
}

class DetailViewModel {
    var bountyInfo: BountyInfo?
    
    func update(model : BountyInfo?){
        bountyInfo = model
    }
}
