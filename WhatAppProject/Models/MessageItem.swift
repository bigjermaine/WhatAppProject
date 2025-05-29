//
//  MessageItem.swift
//  WhatAppProject
//
//  Created by Daniel Jermaine on 15/04/2025.
//



import Foundation
import SwiftUI

// Updated MessageItem struct
struct MessageItem: Identifiable, Equatable {
    let id = UUID().uuidString
    let text: String
    let type: MessageType
    let direction: MessageDirection
    let date: Date
    let senderName: String
    let isAgent: Bool
    var images:[String] = []
    
    static let sentPlaceholder = MessageItem(
        text: "Sample sent message",
        type: .text,
        direction: .sent,
        date: Date(),
        senderName: "You",
        isAgent: true
    )
    
    static let receivedPlaceholder = MessageItem(
        text: "Sample received message",
        type: .text,
        direction: .received,
        date: Date(),
        senderName: "Customer",
        isAgent: false
    )
    
    var backgroundColor: Color {
        return direction == .sent ? .bubbleGreen : .bubbleWhite
    }
    
    var alignment: Alignment {
        return direction == .received ? .leading : .trailing
    }
    
    static func == (lhs: MessageItem, rhs: MessageItem) -> Bool {
        return lhs.id == rhs.id
    }
}

// DateFormatter extension for consistent date handling
extension DateFormatter {
    static let supportDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd, HH:mm:ss"
        return formatter
    }()
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
