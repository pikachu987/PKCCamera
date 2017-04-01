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
    func pkcCameraImage(_ image: UIImage)
}

public class PKCCamera: NSObject {
    
    var delegate: PKCCameraDelegate?
    
    var isCrop: Bool = false
    
    var isQuickCameraOpen = true
    
    var isDeniedAlert = true
    
    var bundleIdentifier = ""
    
    private var deniedAlertTitle = ""
    private var deniedAlertMessage = "권한을 승인해 주셔야 카메라가 보입니다.\n설정창으로 이동하시겠습니까?"
    private var deniedAlertConfirm = "이동하기"
    private var deniedAlertCancel = "취소"
    
    var picker = UIImagePickerController()
    
    override init() {
        super.init()
        self.picker.sourceType = .camera
        self.picker.delegate = self
        
        if AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) == .authorized{
            self.delegate?.pkcCameraGranted?()
            if self.isQuickCameraOpen{
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
                    if self.isQuickCameraOpen{
                        self.cameraOpen()
                    }
                }else{
                    self.delegate?.pkcCameraDenied?()
                    self.deniedAlert()
                }
            })
        }
    }
    
    func deniedAlertMessage(_ title: String, message: String, confirm: String, cancel: String){
        self.deniedAlertTitle = title
        self.deniedAlertMessage = message
        self.deniedAlertConfirm = confirm
        self.deniedAlertCancel = cancel
    }
    
    private func deniedAlert(){
        if self.isDeniedAlert{
            guard let vc = self.delegate?.pkcCameraVisibleViewController() else {
                return
            }
            if self.bundleIdentifier == ""{
                guard let identifier = Bundle.main.bundleIdentifier else {
                    return
                }
                self.bundleIdentifier = identifier
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
    
    public func cameraOpen(){
        guard let vc = self.delegate?.pkcCameraVisibleViewController() else {
            return
        }
        self.delegate?.pkcCameraOpen?()
        if self.isCrop{
            //할껍니다...... 진짜 할겁니다... 이건 내 자신에게 하는 말입니다... 꼭 할껍니다....
        }else{
            vc.present(self.picker, animated: true, completion: nil)
        }
    }
    
    
    
    
}


extension PKCCamera: UIImagePickerControllerDelegate{
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let choseImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            self.delegate?.pkcCameraImage(choseImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.delegate?.pkcCameraCancel?()
        picker.dismiss(animated: true, completion: nil)
    }
}

extension PKCCamera: UINavigationControllerDelegate{
    
}
