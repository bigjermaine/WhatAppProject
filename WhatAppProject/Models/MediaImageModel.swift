//
//  MediaImageModel.swift
//  WhatAppProject
//
//  Created by Daniel Jermaine on 18/04/2025.
//

import Foundation
import PhotosUI

struct MediaImageModel {
    var id:String
    var photo:UIImage
}


struct SendMessageModel:Codable {
    var content:String
    var photo:[String]
}
