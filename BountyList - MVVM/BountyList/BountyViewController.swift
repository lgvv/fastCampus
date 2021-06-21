
//
//  ViewController.swift
//  BountyList
//
//  Created by Hamlit Jason on 2021/06/20.
//

import UIKit

class BountyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numOfBountyInfoList
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ListCell else {
            return UITableViewCell() // guard 조건 실패시 이걸로 캐스팅하게끔
        } // for은 셀의 위치 같은걸 표시
        
        let bountyInfo = viewModel.bountyInfo(at:indexPath.row) // bountyInfoList에서 인덱스에 해당하는거 가져오고
        cell.update(info: bountyInfo)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("-->\(indexPath.row)")
        
        performSegue(withIdentifier: "showDetail", sender: indexPath.row) // sender는 세그 수행에 있어 오브젝트를 같이 껴서 보낼 수 있는 파라미터
        // sender에다가 indexPath.row를 주니까 prepare 수행시,
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }

}

class ListCell : UITableViewCell {
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
