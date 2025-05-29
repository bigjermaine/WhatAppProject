//
//  SendMessageResponse.swift
//  WhatAppProject
//
//  Created by Daniel Jermaine on 05/05/2025.
//

import Foundation
struct SendMessageResponse: Codable {
    let supportRequestId: String
    let receiverId: String
    let content: String
    let isSenderAgent: Bool
    let creationTime: String
    let creatorId: String
    let senderName: String
    let media: [String]
    let id: String
}
