//
//  PKCImageViewController.swift
//  Pods
//
//  Created by guanho on 2017. 4. 2..
//
//

import UIKit
import AVFoundation

@available(iOS 9.0, *)
class PKCImageViewController: UIViewController {
    var imageData: Data?
    var cameraPosition: AVCaptureDevicePosition = .back
    
    
    var topView: PKCImageTopView!
    var imageView: UIImageView!
    var bottomView: PKCImageBottomView!
    
    var imageValue = UIImage()
    
    
    
    override func viewDidLoad() {
        self.topView = PKCImageTopView()
        self.imageView = UIImageView()
        self.bottomView = PKCImageBottomView()
        self.bottomView.delegate = self
        
        guard let data = self.imageData, let tempImg = UIImage(data: data), let img = self.cropImage(tempImg, toRect: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-45-140)) else {
            return
        }
        if self.cameraPosition == .front{
            guard let degreeImage = self.imageRotatedByDegrees(img, degrees: 0, flip: true) else {
                return
            }
            self.imageValue = degreeImage
            self.imageView = UIImageView(image: degreeImage)
        }else{
            self.imageValue = img
            self.imageView = UIImageView(image: img)
        }
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.clipsToBounds = true
        
        self.topView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.bottomView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.topView)
        self.view.addSubview(self.imageView)
        self.view.addSubview(self.bottomView)
        
        self.topView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.topView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.topView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.topView.bottomAnchor.constraint(equalTo: self.imageView.topAnchor).isActive = true
        self.topView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        self.imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.imageView.bottomAnchor.constraint(equalTo: self.bottomView.topAnchor).isActive = true
        self.bottomView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.bottomView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.bottomView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.bottomView.heightAnchor.constraint(equalToConstant: 145).isActive = true
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    
    
    
    
    
    func cropImage(_ image: UIImage, toRect rect:CGRect) -> UIImage? {
        let xValue = image.size.width * rect.origin.x / UIScreen.main.bounds.width
        let yValue = image.size.height * rect.origin.y / UIScreen.main.bounds.height
        let widthValue = image.size.width * rect.size.width / UIScreen.main.bounds.width
        let heightValue = image.size.height * rect.size.height / UIScreen.main.bounds.height
        guard let imageRef = image.cgImage?.cropping(to: CGRect(x: yValue, y: xValue, width: heightValue, height: widthValue)) else {
            return nil
        }
        guard let img = self.imageRotatedByDegrees(UIImage(cgImage:imageRef), degrees: 90, flip: false) else {
            return nil
        }
        return img
    }
    
    func imageRotatedByDegrees(_ image: UIImage, degrees: CGFloat, flip: Bool) -> UIImage? {
        let degreesToRadians: (CGFloat) -> CGFloat = {
            return $0 / 180.0 * CGFloat(Double.pi)
        }
        let rotatedViewBox = UIView(frame: CGRect(origin: CGPoint.zero, size: image.size))
        let t = CGAffineTransform(rotationAngle: degreesToRadians(degrees))
        rotatedViewBox.transform = t
        let rotatedSize = rotatedViewBox.frame.size
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap = UIGraphicsGetCurrentContext()
        bitmap?.translateBy(x: rotatedSize.width / 2.0, y: rotatedSize.height / 2.0);
        bitmap?.rotate(by: degreesToRadians(degrees));
        var yFlip: CGFloat
        if(flip){
            yFlip = CGFloat(-1.0)
        } else {
            yFlip = CGFloat(1.0)
        }
        bitmap?.scaleBy(x: yFlip, y: -1.0)
        guard let cgImg = image.cgImage else{
            return nil
        }
        bitmap?.draw(cgImg, in: CGRect(x: -image.size.width / 2, y: -image.size.height / 2, width: image.size.width, height: image.size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
}

@available(iOS 9.0, *)
extension PKCImageViewController: PKCImageBottomDelegate{
    func pkcImageBottomRetake() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    func pkcImageBottomUse() {
        if let pkcNavVC = self.navigationController as? PKCNavigationController{
            pkcNavVC.pkcDelegate?.pkcNavigationImage(self.imageValue, viewController: self, navigationViewController: self.navigationController)
        }
    }
}


