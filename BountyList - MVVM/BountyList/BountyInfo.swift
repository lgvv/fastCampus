//
//  BountyInfo.swift
//  BountyList
//
//  Created by Hamlit Jason on 2021/06/21.
//

import UIKit

struct BountyInfo {
    let name : String
    let bounty : Int
    
    var image : UIImage? {
        return UIImage(named: "\(name).jpg")
    }
    
    init(name : String, bounty: Int) {
        self.name = name
        self.bounty = bounty
    }
}
