
//
//  ViewController.swift
//  BountyList
//
//  Created by Hamlit Jason on 2021/06/20.
//

import UIKit

class BountyViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    
    // MVVM
    // 모든 개발자가 그런건 아니지만 무엇이 필요한지 적어보고 시작하는 것도 좋다.
    
    // Model
    // - BountyInfo > 만들자
    
    // View
    // - ListCell 필요한 정보를 ViewModel한테서 받아오기 (ViewController가 아니라!)
    // > ListCell은 ViewModel로 부터 받은 정보로 업데이트 하기
    
    // ViewModel
    // - BountyViewModel > 만든다.
    // > 만들고, View 레이어에서 필요한 메소드 만들기
    // > 모델을 가지고 있기 ,, BountyInfo 들
    
    let viewModel = BountyViewModel()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // DetailViewContoller한테 전달한 데이터 정보
        if segue.identifier == "showDetail" {
            let vc = segue.destination as? DetailViewController
            
            if let index = sender as? Int { // indexPath.row의 값이 sender통해 전달 돼
                
                let bountyInfo = viewModel.bountyInfo(at:index) // bountyInfoList에서 인덱스에 해당하는거 가져오고
                
                vc?.viewModel.update(model: bountyInfo) // 뷰모델을 통해 이렇게 접근해야 해
                
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // UICollectionViewDataSource
    // 몇개를 보여줄까요?
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numOfBountyInfoList
    }
    // 셀은 어떻게 표현할까요?
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCell", for: indexPath) as? GridCell else {
            return UICollectionViewCell()
        }
        
        let bountyinfo = viewModel.bountyInfo(at: indexPath.item)
        cell.update(info: bountyinfo)
        
        return cell
    
    }
    
    // UICollectionViewDelegate
    // 셀이 클릭되었을 때 어떻게 할까요?
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("-->\(indexPath.item)")
        performSegue(withIdentifier: "showDetail", sender: indexPath.item)
    }
    
    // UICollectionViewDelegateFlowLayout
    // 셀의 사이즈가 디바이스 마다 조금씩 변경되어야 할 필요가 있어서 - 가로폭이 다르기 때문에
    // cell size 계산할거다( 목표 : 다양한 디바이스에서 일관적인 디자인 보여주기 위해 )
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemSpacing : CGFloat = 10
        let textAreaHeight : CGFloat = 65
        
        let width : CGFloat = (collectionView.bounds.width - itemSpacing) / 2
        let height : CGFloat = width * 10/7 + textAreaHeight
        
        return CGSize(width: width, height: height)
    }
   

}

class GridCell : UICollectionViewCell {
    @IBOutlet weak var imgView : UIImageView!
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var bountyLabel : UILabel!
    
    func update(info : BountyInfo) {
        
        imgView.image = info.image
        nameLabel.text = info.name
        bountyLabel.text = "\(info.bounty)"
    }
}

class BountyViewModel {
    let bountyInfoList : [BountyInfo] = [
        BountyInfo(name: "brook", bounty: 33000000),
        BountyInfo(name: "chopper", bounty: 50),
        BountyInfo(name: "franky", bounty: 44000000),
        BountyInfo(name: "luffy", bounty: 300000000),
        BountyInfo(name: "nami", bounty: 16000000),
        BountyInfo(name: "robin", bounty: 80000000),
        BountyInfo(name: "sanji", bounty: 77000000),
        BountyInfo(name: "zoro", bounty: 120000000)
    ]
    
    var sortedList : [BountyInfo] {
        let sortedList = bountyInfoList.sorted { prev, next  in
            return prev.bounty > next.bounty
        }
        
        return sortedList
    }
    
    var numOfBountyInfoList : Int {
        return bountyInfoList.count
    }
    
    func bountyInfo(at index : Int) -> BountyInfo {
        return sortedList[index]
    }
    
}
