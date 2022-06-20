//
//  ViewController.swift
//  storyboardQRCode
//
//  Created by Apple New on 2022-06-20.
//

import UIKit
import Elements
import CoreImage.CIFilterBuiltins

class ViewController: UIViewController {
    
    private var inputURl = ""
    
    lazy var inputTF : BaseUITextField = {
        let tf = BaseUITextField()
        tf.placeholder = "Enter URL"
        tf.backgroundColor = .systemGray5
        tf.layer.cornerRadius = 15
        return tf
    }()
    
    lazy var createBTN: BaseUIButton = {
        let btn = BaseUIButton()
        btn.setImage(UIImage(systemName: "square.and.arrow.down"), for: .normal)
        btn.addTarget(self, action: #selector(downloadHandler), for: .touchUpInside)
        btn.widthAnchor.constraint(equalToConstant: 50).isActive = true
        btn.layer.cornerRadius = 15
        btn.backgroundColor = .systemGray5
        return btn
    }()
    
    lazy var upperContentStack: HStack = {
        let stack = HStack()
        stack.addArrangedSubview(inputTF)
        stack.addArrangedSubview(createBTN)
        stack.backgroundColor = .systemGray5
        stack.layer.cornerRadius = 15
        return stack
    }()
    
    lazy var QRCodeImageView: BaseUIImageView = {
        let iv = BaseUIImageView()
        iv.image = UIImage(systemName: "qrcode.viewfinder")
        let width = view.frame.size.width-40
        let height = view.frame.size.width-40
        iv.widthAnchor.constraint(equalToConstant: width).isActive = true
        iv.heightAnchor.constraint(equalToConstant: height).isActive = true
        return iv
    }()
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(upperContentStack)
        view.addSubview(QRCodeImageView)
        
        NSLayoutConstraint.activate([
        
            upperContentStack.bottomAnchor.constraint(equalTo: QRCodeImageView.topAnchor, constant: -20),
            upperContentStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            upperContentStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            QRCodeImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            QRCodeImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            
        ])
    }


    
    
    @objc func downloadHandler(){
        if !inputTF.text!.isEmpty{
            inputURl = inputTF.text!
            QRCodeImageView.image = QRCodeGenerator().generateQRCode(forURLString: inputURl)?.uiImage
        }else {
            inputURl = "Error"
        }
    }
}


