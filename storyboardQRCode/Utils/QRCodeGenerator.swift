//
//  QRCodeGenerator.swift
//  storyboardQRCode
//
//  Created by Apple New on 2022-06-20.
//

import UIKit
import Elements
import CoreImage.CIFilterBuiltins

struct QRCodeGenerator {
    private let context = CIContext()
    private let filter = CIFilter.qrCodeGenerator()
    
    public func generateQRCode(forURLString urlString: String) -> QRCode? {
        guard !urlString.isEmpty else { return nil}
        
        let data = Data(urlString.utf8)
        filter.setValue(data, forKey: "inputMessage")
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        
        if let outputImage = filter.outputImage?.transformed(by: transform) {
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent){
                let qrCode = QRCode(urlString: urlString, uiImage: UIImage(cgImage: cgImage))
                return qrCode
            }
        }
        return nil
    }
}
