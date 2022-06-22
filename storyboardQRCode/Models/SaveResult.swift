//
//  SaveResult.swift
//  storyboardQRCode
//
//  Created by Apple New on 2022-06-22.
//

import Foundation
struct ImageSaveResult: Identifiable {
    let id = UUID()
    let saveStatus: ImageSaveStatus
}
