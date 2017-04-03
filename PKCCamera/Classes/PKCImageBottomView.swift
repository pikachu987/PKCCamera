//
//  PKCImageBottomView.swift
//  Pods
//
//  Created by guanho on 2017. 4. 2..
//
//

import UIKit

protocol PKCImageBottomDelegate {
    func pkcImageBottomRetake()
    func pkcImageBottomUse()
}

class PKCImageBottomView: UIView {
    
    
    var delegate: PKCImageBottomDelegate?
    
    init() {
        super.init(frame: CGRect(x: 0, y: UIScreen.main.bounds.height-140, width: UIScreen.main.bounds.width, height: 140))
        self.backgroundColor = .black
        
        self.createBottomView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func createBottomView(){
        let view = UIView()
        view.backgroundColor = UIColor(red:0.08, green:0.08, blue:0.08, alpha:1.00)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        view.heightAnchor.constraint(equalToConstant: 80).isActive = true
        self.createRetakeButton(view)
        self.createUseButton(view)
    }
    
    
    func createRetakeButton(_ view: UIView){
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Retake", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        button.addTarget(self, action: #selector(self.retakeAction(sender:)), for: .touchUpInside)
    }
    
    
    
    func createUseButton(_ view: UIView){
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Use Photo", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        button.addTarget(self, action: #selector(self.useAction(sender:)), for: .touchUpInside)
    }
    
    func useAction(sender: UIButton) {
        self.delegate?.pkcImageBottomUse()
    }
    func retakeAction(sender: UIButton) {
        self.delegate?.pkcImageBottomRetake()
    }
}

