//
//  GatewayResponse.swift
//  WhatAppProject
//
//  Created by Daniel Jermaine on 06/05/2025.
//
import Foundation

struct GatewayResponse: Codable {
    let data: GatewayData
    let success: Bool
    let errorMessage: String?
    let errorMessages: [String]
}

struct GatewayData: Codable {
    let items: [PaymentGateway]
    let totalCount: Int
    let page: Int
    let pageSize: Int
    let totalPages: Int
}

struct PaymentGateway: Codable, Identifiable,Hashable {
    let name: String
    let logoUrl: String
    let contactPerson: String
    let contactNumber: String
    let clientId: String
    let clientSecret: String
    let callbackUrl: String
    let status: String
    let priority: Int
    let gatewayType: String
    let lastModificationTime: String?
    let lastModifierId: String?
    let creationTime: String
    let creatorId: String
    let id: String
    
    // Computed property to get status as Bool if needed
    var isOnline: Bool {
        return status.lowercased() == "online"
    }
    
    // Computed property to get logo URL
    var logoURL: URL? {
        return URL(string: logoUrl)
    }
}
