//
//  SupportTicket.swift
//  WhatAppProject
//
//  Created by Daniel Jermaine on 05/05/2025.
//


import Foundation

// MARK: - Data Models
struct SupportTicket: Codable {
    let applicantId: String
    let agentId: String
    let topic: String
    let supportRoleName: String
    let applicantEmail: String
    let agentEmail: String
    let feature: String
    let status: String
    let applicantName: String
    let agentName: String
    let deviceInfo: String
    let ticketNo: String
    let helpdeskTicketNo: String?
    let creationTime: String
    let lastModificationTime: String
    let aId: Int?
    let refId: Int?
    let isRead: Bool
    let messages: [SupportMessage]?
    let id:String
}

struct SupportMessage: Codable {
    let supportRequestId: String
    let receiverId: String
    let content: String
    let isSenderAgent: Bool
    let creationTime: String
    let creatorId: String
    let senderName: String
}
