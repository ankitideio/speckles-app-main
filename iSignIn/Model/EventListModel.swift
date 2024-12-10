//
//  HomeData.swift
//  EventManagement
//
//  Created by meet sharma on 05/07/23.
//

import Foundation

//MARK: - EVENTLISTMODEL

struct EventListModel{
    var name:String?
    var img:String?
    init(name: String? = nil, img: String? = nil) {
        self.name = name
        self.img = img
    }
}
