//
//  BottomView.swift
//  Pods
//
//  Created by guanho on 2017. 4. 2..
//
//

import UIKit

protocol PKCCameraBottomDelegate {
    func pkcCameraBottomCancel()
    func pkcCameraBottomSwitch()
    func pkcCameraBottomShutter()
}

class PKCCameraBottomView: UIView {
    class ShutterButton: UIButton{
        override var isHighlighted: Bool {
            didSet {
                if (isHighlighted) {
                    self.backgroundColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1)
                }
                else {
                    self.backgroundColor = UIColor.white
                }
                
            }
        }
    }
    
    var delegate: PKCCameraBottomDelegate?
    
    init() {
        super.init(frame: CGRect(x: 0, y: UIScreen.main.bounds.height-140, width: UIScreen.main.bounds.width, height: 140))
        self.backgroundColor = .black
        
        let photoLbl = self.createPhotoLabel()
        let bottomView = self.createBottomView()
        photoLbl.bottomAnchor.constraint(equalTo: bottomView.topAnchor, constant: -20).isActive = true
        self.createCancelButton(bottomView)
        self.createSwitchButton(bottomView)
        self.createShutterView(bottomView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func createPhotoLabel() -> UILabel{
        let label = UILabel()
        label.textColor = UIColor(red: 228/255, green: 199/255, blue: 73/255, alpha: 1)
        label.text = "PHOTO"
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        label.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        label.heightAnchor.constraint(equalToConstant: 10).isActive = true
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        return label
    }
    
    func createBottomView() -> UIView{
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        view.heightAnchor.constraint(equalToConstant: 65).isActive = true
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        return view
    }
    
    func createCancelButton(_ view: UIView){
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Cancel", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        button.addTarget(self, action: #selector(self.cancelAction(sender:)), for: .touchUpInside)
    }
    
    
    
    func createSwitchButton(_ view: UIView){
        let button = UIButton()
        button.setTitle("Rotate", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        button.addTarget(self, action: #selector(self.switchAction(sender:)), for: .touchUpInside)
    }
    
    func createShutterView(_ view: UIView){
        let view_ = UIView()
        view_.backgroundColor = .black
        view_.layer.borderColor = UIColor.white.cgColor
        view_.layer.borderWidth = 6
        view_.layer.cornerRadius = 33
        view_.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(view_)
        view_.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        view_.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        view_.widthAnchor.constraint(equalToConstant: 66).isActive = true
        view_.heightAnchor.constraint(equalToConstant: 66).isActive = true
        self.createShutterButton(view_)
    }
    
    
    func createShutterButton(_ view: UIView){
        let button = ShutterButton()
        button.backgroundColor = .white
        button.layer.cornerRadius = 24
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant: 48).isActive = true
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        button.addTarget(self, action: #selector(self.shutterAction(sender:)), for: .touchUpInside)
    }
    
    
    
    func cancelAction(sender: UIButton) {
        self.delegate?.pkcCameraBottomCancel()
    }
    func switchAction(sender: UIButton) {
        self.delegate?.pkcCameraBottomSwitch()
    }
    func shutterAction(sender: ShutterButton) {
        self.delegate?.pkcCameraBottomShutter()
    }
}
