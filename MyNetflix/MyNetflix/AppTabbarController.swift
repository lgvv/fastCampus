//
//  ViewController.swift
//  MyNetflix
//
//  Created by Hamlit Jason on 2021/06/29.
//

import UIKit

class AppTabbarController: UITabBarController {
    
   override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}
