//
//  SettingsModel.swift
//  EventManagement
//
//  Created by meet sharma on 05/07/23.
//

import Foundation

//MARK: - SETTINGSMODEL

struct SettingsModel{
    var title:String?
    var img:String?
    init(title: String? = nil, img: String? = nil) {
        self.title = title
        self.img = img
    }
}
