//
//  DetailViewController.swift
//  BountyList
//
//  Created by Hamlit Jason on 2021/06/20.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imgView : UIImageView!
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var bountyLabel : UILabel!
    
    var name: String?
    var bounty : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
    }
    
    func updateUI() {
        
        if let name = self.name, let bounty = self.bounty { // 옵셔널이니까 조건의 데이터 들이 있을 때
            let img = UIImage(named: "\(name).jpg")
            imgView.image = img
            nameLabel.text = name
            bountyLabel.text = "\(bounty)"
        }
       
    }

    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil) // 현재 뷰 컨트롤러는 사라진다.
    }
    
}
