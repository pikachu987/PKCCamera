//
//  TopView.swift
//  Pods
//
//  Created by guanho on 2017. 4. 2..
//
//

import UIKit

class PKCCameraTopView: UIView{
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 45))
        self.backgroundColor = .black
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
