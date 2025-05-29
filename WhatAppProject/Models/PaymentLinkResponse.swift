//
//  PaymentLinkResponse.swift
//  WhatAppProject
//
//  Created by Daniel Jermaine on 06/05/2025.
//

import Foundation

struct PaymentLinkResponse: Codable {
    let data: PaymentLinkData
    let errors: [String]  // Could be [ErrorObject] if errors have structure
    let success: Bool
    let code: Int
    let message: String
}

struct PaymentLinkData: Codable {
    let link: String
    let reference: String
    var paymentURL: URL? {
        return URL(string: link)
    }
}

struct PaymentRequest: Codable {
    let gatewayId: String
    let applicationConfigurationId: String
    let userId: String
    let amount: Int
    let currency: String
    
    // Custom coding keys to match JSON naming
    private enum CodingKeys: String, CodingKey {
        case gatewayId
        case applicationConfigurationId = "ApplicationConfigurationId"
        case userId
        case amount
        case currency
    }
    
    // Computed property for amount formatting
    var formattedAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currency
        return formatter.string(from: NSNumber(value: amount)) ?? "\(currency) \(amount)"
    }
}
