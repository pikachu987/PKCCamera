//
//  PKCViewController.swift
//  Pods
//
//  Created by guanho on 2017. 4. 2..
//
//

import UIKit
import AVFoundation
import MediaPlayer


class PKCCameraViewController: UIViewController {
    var captureSession = AVCaptureSession()
    var captureDeviceInput : AVCaptureDeviceInput?
    var previewLayer : AVCaptureVideoPreviewLayer?
    var captureDevice : AVCaptureDevice?
    let stillImageOutput = AVCaptureStillImageOutput()
    
    fileprivate static var cameraPosition: AVCaptureDevicePosition = .back
    
    var topView: PKCCameraTopView!
    var bottomView: PKCCameraBottomView!
    var centerView: UIView!
    
    var visualEffectView: UIVisualEffectView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black

        self.topView = PKCCameraTopView()
        self.centerView = UIView()
        self.bottomView = PKCCameraBottomView()
        self.bottomView.delegate = self
        
        
        let volumeView = MPVolumeView(frame: CGRect(x: 0, y: -100, width: 0, height: 0))
        self.view.addSubview(volumeView)
        
        self.topView.translatesAutoresizingMaskIntoConstraints = false
        self.centerView.translatesAutoresizingMaskIntoConstraints = false
        self.bottomView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.topView)
        self.view.addSubview(self.centerView)
        self.view.addSubview(self.bottomView)
        
        self.topView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.topView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.topView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.topView.bottomAnchor.constraint(equalTo: self.centerView.topAnchor).isActive = true
        self.topView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        self.centerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.centerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.centerView.bottomAnchor.constraint(equalTo: self.bottomView.topAnchor).isActive = true
        self.bottomView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.bottomView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.bottomView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.bottomView.heightAnchor.constraint(equalToConstant: 145).isActive = true
        
        self.visualEffectView = UIVisualEffectView()
        self.visualEffectView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-145-45)
        self.visualEffectView.effect = UIBlurEffect(style: .dark)
        self.centerView.addSubview(self.visualEffectView)
        
        self.cameraSelected()
    }
    
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let anyTouch = touches.first
        guard let touchPoint = anyTouch?.location(in: self.view) else{
            return
        }
        self.focusTo(point: touchPoint)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(volumeChanged(notification:)),
            name: NSNotification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification"),
            object: nil
        )
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(
            self,
            name: NSNotification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification"),
            object: nil
        )
    }
    
    
    func volumeChanged(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let volumeChangeType = userInfo["AVSystemController_AudioVolumeChangeReasonNotificationParameter"] as? String {
                if volumeChangeType == "ExplicitVolumeChange" {
                    self.capture()
                }
            }
        }
    }
    
    
    func cameraSelected(){
        DispatchQueue.global().async {
            let devices = AVCaptureDevice.devices()
            for device in devices! {
                if ((device as AnyObject).hasMediaType(AVMediaTypeVideo)) {
                    if PKCCameraViewController.cameraPosition == .front{
                        if((device as AnyObject).position == AVCaptureDevicePosition.front) {
                            self.captureDevice = device as? AVCaptureDevice
                            self.setCaptureCamera()
                            break
                        }
                    }else{
                        if((device as AnyObject).position == AVCaptureDevicePosition.back) {
                            self.captureDevice = device as? AVCaptureDevice
                            self.setCaptureCamera()
                            break
                        }
                    }
                }
            }
        }
    }
    
    
    
    
    func setCaptureCamera(){
        DispatchQueue.main.async {
            do{
                if self.captureDeviceInput != nil{
                    self.captureSession.removeInput(self.captureDeviceInput)
                }
                if self.captureSession.isRunning{
                    self.captureSession.stopRunning()
                }
                try self.captureDeviceInput = AVCaptureDeviceInput(device: self.captureDevice)
                self.captureSession.addInput(self.captureDeviceInput)
                self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
                self.previewLayer?.frame = self.view.layer.frame
                self.captureSession.startRunning()
                self.previewLayer?.removeFromSuperlayer()
                self.centerView.layer.addSublayer(self.previewLayer!)
                
                self.stillImageOutput.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
                if self.captureSession.canAddOutput(self.stillImageOutput) {
                    self.captureSession.addOutput(self.stillImageOutput)
                }
                
                self.visualEffectView.removeFromSuperview()
                
                if PKCCameraViewController.cameraPosition == .back{
                    if let device = self.captureDevice {
                        do{
                            try device.lockForConfiguration()
                            device.focusMode = .locked
                            device.unlockForConfiguration()
                        }catch {
                            print("locaForConfiguration error")
                        }
                    }
                }
            }catch{
                print("error")
            }
        }
    }
    
    
    func capture(){
        if let videoConnection = stillImageOutput.connection(withMediaType: AVMediaTypeVideo) {
            stillImageOutput.captureStillImageAsynchronously(from: videoConnection) {
                (imageDataSampleBuffer, error) -> Void in
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
                let pkcImageVC = PKCImageViewController()
                pkcImageVC.imageData = imageData
                pkcImageVC.cameraPosition = PKCCameraViewController.cameraPosition
                self.navigationController?.pushViewController(pkcImageVC, animated: true)
            }
        }
    }
    
    
    func focusTo(point : CGPoint) {
        if point.y < self.topView.frame.size.height || point.y > self.bottomView.frame.origin.y{
            return
        }
        if PKCCameraViewController.cameraPosition == .back{
            self.focusAction(point, handler: { (point) in
                if let device = self.captureDevice {
                    do{
                        let touchPercent = point.x / UIScreen.main.bounds.width
                        try device.lockForConfiguration()
                        device.setFocusModeLockedWithLensPosition(Float(touchPercent), completionHandler: { (time) in
                        })
                        device.unlockForConfiguration()
                    }catch{
                        print("Touch could not be used")
                    }
                }
            })
        }else{
            self.focusAction(point){ (point) in }
        }
    }
    
    
    
    func focusAction(_ point: CGPoint, handler: @escaping ((CGPoint) -> Void)){
        var touchView: UIView? = UIView(frame: CGRect(origin: CGPoint(x: point.x-40, y: point.y-40), size: CGSize(width: 80, height: 80)))
        touchView?.layer.masksToBounds = false
        touchView?.layer.cornerRadius = 40
        touchView?.layer.borderColor = UIColor.gray.cgColor
        touchView?.layer.borderWidth = 1
        touchView?.clipsToBounds = true
        self.view.addSubview(touchView!)
        touchView?.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        handler(point)
        UIView.animate(withDuration: TimeInterval(0.5), animations: {
            touchView?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }, completion: { (_) in
            touchView?.removeFromSuperview()
            touchView = nil
            handler(point)
        })
    }
    
}


extension PKCCameraViewController: PKCCameraBottomDelegate{
    func pkcCameraBottomCancel() {
        if let pkcNavVC = self.navigationController as? PKCNavigationController{
            pkcNavVC.pkcDelegate?.pkcNavigationCancel()
        }
        self.dismiss(animated: true, completion: nil)
    }
    func pkcCameraBottomSwitch() {
        self.visualEffectView.removeFromSuperview()
        self.centerView.addSubview(self.visualEffectView)
        if PKCCameraViewController.cameraPosition == .back{
            PKCCameraViewController.cameraPosition = .front
        }else{
            PKCCameraViewController.cameraPosition = .back
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { 
            UIView.transition(with: self.centerView, duration: 0.5, options: UIViewAnimationOptions.transitionFlipFromLeft, animations: nil)
            self.cameraSelected()
        }
    }
    func pkcCameraBottomShutter() {
        self.capture()
    }
}
