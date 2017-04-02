//
//  PKCCamera.swift
//  Pods
//
//  Created by guanho on 2017. 4. 1..
//
//

import UIKit
import AVFoundation

//Others can not use it. I will write only myself.

@objc
public protocol PKCCameraDelegate {
    @objc optional func pkcCameraGranted()
    @objc optional func pkcCameraDenied()
    @objc optional func pkcCameraUndentermined()
    @objc optional func pkcCameraOpen()
    @objc optional func pkcCameraCancel()
    func pkcCameraVisibleViewController() -> UIViewController
    func pkcCameraImage(_ image: UIImage, navigationController: UINavigationController, visibleViewController: UIViewController)
}

public enum PKCCameraType{
    case onlyCheck, open
}

public class PKCCamera: NSObject {
    
    public var delegate: PKCCameraDelegate?
    
    fileprivate var isDeniedAlert = true
    fileprivate var bundleIdentifier = ""
    
    fileprivate var deniedAlertTitle = ""
    fileprivate var deniedAlertMessage = "권한을 승인해 주셔야 카메라가 보입니다.\n설정창으로 이동하시겠습니까?"
    fileprivate var deniedAlertConfirm = "이동하기"
    fileprivate var deniedAlertCancel = "취소"
    
    fileprivate lazy var picker: UIImagePickerController! = {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        return picker
    }()
    fileprivate lazy var navVC: UINavigationController! = {
        let navVC = UINavigationController()
        navVC.show(self.picker, sender: nil)
        return navVC
    }()
    
    
    private override init() {
        
    }
    
    public init(_ bundleIdentifier: String = "", isDeniedAlert: Bool = true) {
        super.init()
        
        if self.bundleIdentifier == ""{
            if let identifier = Bundle.main.bundleIdentifier{
                self.bundleIdentifier = identifier
            }
        }
        self.isDeniedAlert = isDeniedAlert
    }
    
    
    
    open func deniedAlertMessage(_ title: String, message: String, confirm: String, cancel: String){
        self.deniedAlertTitle = title
        self.deniedAlertMessage = message
        self.deniedAlertConfirm = confirm
        self.deniedAlertCancel = cancel
    }
    
    
    
    fileprivate func deniedAlert(){
        if self.isDeniedAlert{
            guard let vc = self.delegate?.pkcCameraVisibleViewController() else {
                return
            }
            
            let alertController = UIAlertController(title: self.deniedAlertTitle, message: self.deniedAlertMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: self.deniedAlertCancel, style: .cancel, handler: nil))
            alertController.addAction(UIAlertAction(title: self.deniedAlertConfirm, style: .default, handler: { (_) in
                guard let url = URL(string: "\(UIApplicationOpenSettingsURLString)\(self.bundleIdentifier)") else{
                    return
                }
                if #available(iOS 8.0, *) {
                    UIApplication.shared.openURL(url)
                }else{
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }))
            vc.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    open func open(_ type: PKCCameraType = .open){
        if AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) == .authorized{
            self.delegate?.pkcCameraGranted?()
            if type == .open{
                self.cameraOpen()
            }
        }else if AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) == .denied{
            self.delegate?.pkcCameraDenied?()
            self.deniedAlert()
        }else{
            self.delegate?.pkcCameraUndentermined?()
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (isAccess) in
                if isAccess{
                    self.delegate?.pkcCameraGranted?()
                    if type == .open{
                        self.cameraOpen()
                    }
                }else{
                    self.delegate?.pkcCameraDenied?()
                    self.deniedAlert()
                }
            })
        }
    }
    
    fileprivate func cameraOpen(){
        guard let vc = self.delegate?.pkcCameraVisibleViewController() else {
            return
        }
        self.delegate?.pkcCameraOpen?()
        vc.present(self.navVC, animated: true, completion: nil)
    }
    
    
    
    
}


extension PKCCamera: UIImagePickerControllerDelegate{
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let choseImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            self.delegate?.pkcCameraImage(choseImage, navigationController: self.navVC, visibleViewController: self.picker)
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.delegate?.pkcCameraCancel?()
        picker.dismiss(animated: true, completion: nil)
    }
}

extension PKCCamera: UINavigationControllerDelegate{
    
}
