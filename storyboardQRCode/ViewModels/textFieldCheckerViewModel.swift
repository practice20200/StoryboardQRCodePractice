//
//  textFieldCheckerViewModel.swift
//  storyboardQRCode
//
//  Created by Apple New on 2022-06-20.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
class textFieldCheckerViewModel {
    let urlTextPublishSubject = PublishSubject<String>()

    func isValid() -> Observable<Bool>{
        return urlTextPublishSubject.asObservable().startWith("").map { username in
            username.count > 0
        }.startWith(false)
    }
}
