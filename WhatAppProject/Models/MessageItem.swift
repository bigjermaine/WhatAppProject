//
//  MessageItem.swift
//  WhatAppProject
//
//  Created by Daniel Jermaine on 15/04/2025.
//



import Foundation
import SwiftUI

struct MessageItem:Identifiable , Equatable {
    let id = UUID().uuidString
    let text:String
    let type:MessageType
    let direction:MessageDirection
    var date:Date
    static let sentPlaceHolder = MessageItem(text: "Holy spagehetti", type: .text, direction: .sent, date: Date())
    static let receivePlaceHolder = MessageItem(text: "Holy spagehetti", type: .text, direction: .received, date: Date())
    
    var backgroundColor:Color {
        return direction  == .sent ? .bubbleGreen : .bubbleWhite
        
    }
    
    var alignment:Alignment {
        return direction == .received ? .leading :.trailing
    }
    static func == (lhs: MessageItem, rhs: MessageItem) -> Bool {
           return lhs.id == rhs.id
       }
}

enum MessageType {
    case text, photo, video, audio
}

enum MessageDirection {
    case sent, received
    
    static var random:MessageDirection {
        return [MessageDirection.sent,.received].randomElement() ?? .sent
    }
}
