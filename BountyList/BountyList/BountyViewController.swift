
//
//  ViewController.swift
//  BountyList
//
//  Created by Hamlit Jason on 2021/06/20.
//

import UIKit

class BountyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let nameList = ["brook","chopper","franky","luffy","nami","robin","sanji","zoro"]
    let bountyList = [33000000, 50, 44000000, 300000000, 16000000, 80000000, 77000000, 120000000]
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // DetailViewContoller한테 전달한 데이터 정보
        if segue.identifier == "showDetail" {
            let vc = segue.destination as? DetailViewController
            
            if let index = sender as? Int { // indexPath.row의 값이 sender통해 전달 돼
                vc?.name = nameList[index]
                vc?.bounty = bountyList[index]
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bountyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ListCell else {
            return UITableViewCell() // guard 조건 실패시 이걸로 캐스팅하게끔
        } // for은 셀의 위치 같은걸 표시
        
        let img = UIImage(named: "\(nameList[indexPath.row]).jpg")
        cell.imgView.image = img
        cell.nameLabel.text = nameList[indexPath.row]
        cell.bountyLabel.text = String(bountyList[indexPath.row])
        
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
}
