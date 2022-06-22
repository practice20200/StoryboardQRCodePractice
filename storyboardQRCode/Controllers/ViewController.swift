//
//  ViewController.swift
//  storyboardQRCode
//
//  Created by Apple New on 2022-06-20.
//

import UIKit
import Elements
import RxCocoa
import RxSwift
import CoreImage.CIFilterBuiltins

class ViewController: UIViewController {
    
    private var inputURl = ""
    var savedImage: UIImage?
    private let tfCheckerViewModel = textFieldCheckerViewModel()
    private let disposeBag = DisposeBag()
    
    lazy var inputTF : BaseUITextField = {
        let tf = BaseUITextField()
        tf.placeholder = "Enter URL"
        tf.backgroundColor = .systemGray5
        tf.layer.cornerRadius = 15
        return tf
    }()

    lazy var deleteBTN: BaseUIButton = {
        let btn = BaseUIButton()
        btn.setImage(UIImage(systemName: "delete.left"), for: .normal)
        btn.addTarget(self, action: #selector(deleteHandler), for: .touchUpInside)
        btn.widthAnchor.constraint(equalToConstant: 50).isActive = true
        btn.layer.cornerRadius = 15
        btn.backgroundColor = .systemGray5
        return btn
    }()
    
    lazy var createBTN: BaseUIButton = {
        let btn = BaseUIButton()
        btn.setImage(UIImage(systemName: "doc.badge.plus"), for: .normal)
        btn.addTarget(self, action: #selector(createHandler), for: .touchUpInside)
        btn.widthAnchor.constraint(equalToConstant: 50).isActive = true
        btn.layer.cornerRadius = 15
        btn.backgroundColor = .systemGray5
        return btn
    }()
    
    lazy var leftContentStack: HStack = {
        let stack = HStack()
        stack.addArrangedSubview(inputTF)
        stack.addArrangedSubview(deleteBTN)
        stack.backgroundColor = .systemGray5
        stack.layer.cornerRadius = 15
        return stack
    }()
    
    lazy var upperContentStack: HStack = {
        let stack = HStack()
        stack.addArrangedSubview(leftContentStack)
        stack.addArrangedSubview(createBTN)
        return stack
    }()
    
    lazy var QRCodeImageView: BaseUIImageView = {
        let iv = BaseUIImageView()
        let image = UIImage(systemName: "qrcode.viewfinder")
        let configuration =
            UIImage.SymbolConfiguration(hierarchicalColor: .systemGray4)
        iv.preferredSymbolConfiguration = configuration
        iv.image = image
        let width = view.frame.size.width-40
        let height = view.frame.size.width-40
        iv.widthAnchor.constraint(equalToConstant: width).isActive = true
        iv.heightAnchor.constraint(equalToConstant: height).isActive = true
        return iv
    }()
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        title = "QRCode"
        
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
        
        // creatBTN behaviour
        inputTF.becomeFirstResponder()
        inputTF.rx.text.map { $0 ?? "" }.bind(to: tfCheckerViewModel.urlTextPublishSubject).disposed(by: disposeBag)
        tfCheckerViewModel.isValid().bind(to: createBTN.rx.isEnabled).disposed(by: disposeBag)
        tfCheckerViewModel.isValid().map{$0 ? 1 : 0.1}.bind(to: createBTN.rx.alpha).disposed(by: disposeBag)
        
        let downloadBTN = UIBarButtonItem(image: UIImage(systemName: "arrow.down.to.line.circle.fill"), style: .plain, target: self, action: #selector(downloadHandler))
        navigationItem.rightBarButtonItem = downloadBTN
        
    }
    
    func successAlertAction(){
        let alertView = UIAlertController(title: "Success", message: "Your QRCode was successfully saved", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default)
        alertView.addAction(OKAction)
        present(alertView, animated: true)
    }
    
    func failAlertAction(){
        let alertView = UIAlertController(title: "Error", message: "Your QRCode was not saved", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default)
        alertView.addAction(OKAction)
        present(alertView, animated: true)
    }

    
    @objc func deleteHandler(){
        inputTF.text = ""
    }
    
    @objc func createHandler(){
        if !inputTF.text!.isEmpty{
            inputURl = inputTF.text!
            savedImage = QRCodeGenerator().generateQRCode(forURLString: inputURl)?.uiImage
            QRCodeImageView.image = QRCodeGenerator().generateQRCode(forURLString: inputURl)?.uiImage
        }else {
            inputURl = "Error"
            failAlertAction()
        }
    }
    
    @objc func downloadHandler(){
        
        guard let savedImage = QRCodeGenerator().generateQRCode(forURLString: inputURl)?.uiImage else {
            failAlertAction()
            return
        }
        successAlertAction()
        ImageSaver().saveImage(image: savedImage)
    }
}

