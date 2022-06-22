//
//  ImageSaveManager.swift
//  storyboardQRCode
//
//  Created by Apple New on 2022-06-22.
//

import Foundation
import Photos
import UIKit

class ImageSaver: NSObject, ObservableObject {
    @Published public var saveResult: ImageSaveResult?
    
    private func addLabel(label: String, toImage image: UIImage) -> UIImage? {
        let font = UIFont.boldSystemFont(ofSize: 24)
        let text: NSString = NSString(string: label)
        
        let attributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: UIColor.systemBlue
        ]
        let textPadding: CGFloat = 8
        let textSize = text.size(withAttributes: attributes)
        let heightOffset = textSize.height + textPadding  //the position of QRcode image
        let width = image.size.width
        let height = image.size.height + heightOffset
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height+heightOffset), false, 0)// Start creating image with assighned the sized of width and hight
        
        if let context = UIGraphicsGetCurrentContext() {
            UIColor.white.setFill()
            let rect = CGRect(x:0,y:0, width: width, height: height)
            context.fill(rect)
        }
        
        text.draw(in: CGRect(x: (width/2) - (textSize.width/2), y: textPadding, width: width, height: height), withAttributes: attributes)
        image.draw(in: CGRect(x: 0, y: heightOffset, width: width, height: height))
        
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    
    public func saveImage(image: UIImage){
        let imageLabel = "Scan my Code"
        let photoLibraryAuthStatus = PHPhotoLibrary.authorizationStatus(for: .addOnly)
        if photoLibraryAuthStatus == .authorized{
            saveImage(image: image, withLable: imageLabel)
            return
        }
        
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { [weak self] status in
            DispatchQueue.main.async {
                if status == .authorized{
                    self?.saveImage(image: image, withLable: imageLabel)
                    return
                }
                self?.saveResult = ImageSaveResult(saveStatus: .libraryPermissionDenied)
            }
        }
    }

    private func saveImage(image: UIImage, withLable label: String){
        if let imageWithLabel = addLabel(label: label, toImage: image){
            UIImageWriteToSavedPhotosAlbum(imageWithLabel, self, #selector(saveFinished), nil)
            return
        }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveFinished), nil)
    }

    @objc private func saveFinished(image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer){
        if error != nil {
            saveResult = ImageSaveResult(saveStatus: .error)
        }else {
            saveResult = ImageSaveResult(saveStatus: .success)
        }
    }
}

enum ImageSaveStatus{
    case success
    case error
    case libraryPermissionDenied
}
