//
//  DefaultStyle.swift
//  AppleMusicStApp
//
//  Created by Hamlit Jason on 2021/06/23.
//

import UIKit
// 다크모드와 관련한 코드
class DefaultStyle {
    public enum Colors {
        public static let tint : UIColor = {
            if #available(iOS 13.0, *) {
                return UIColor { traitCollction in
                    if traitCollction.userInterfaceStyle == .dark {
                        return .white
                    } else {
                        return .black
                    }
                }
            } else {
                return .black
            }
        }()
    }
}
