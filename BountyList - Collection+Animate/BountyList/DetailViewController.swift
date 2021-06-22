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
    @IBOutlet weak var nameLabelCenterX: NSLayoutConstraint!
    @IBOutlet weak var bountyLabelCenterX: NSLayoutConstraint!
    
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
        nameLabelCenterX.constant = view.bounds.width // 확실하게 뷰의 바깥으로 내보내기 위해서
        bountyLabelCenterX.constant = view.bounds.width // 확실하게 뷰의 바깥으로 내보내기 위해서
    }
    
    private func showAnimation() {
        nameLabelCenterX.constant = 0
        bountyLabelCenterX.constant = 0
        
        /* 가장 간랸한
        UIView.animate(withDuration: 0.3) { // 0.3초동안
            self.view.layoutIfNeeded() // 레이아웃을 다시 해야할 필요가 있다면 다시 해라   
        }*/
        
        /* 조금 더 스탠다드한
        UIView.animate(withDuration: 0.3,
                       delay: 0.1,
                       options: .curveEaseIn,
                       animations : {
            self.view.layoutIfNeeded()
        }, completion: nil)
        */
        
        // 글자가 스프링처럼 튕기는 코드
        UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 0.6, initialSpringVelocity: 2, options: .allowUserInteraction, animations: self.view.layoutIfNeeded, completion: nil)
         
        
        // 카드가 돌아감
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
