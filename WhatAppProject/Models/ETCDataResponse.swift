//
//  ETCDataResponse.swift
//  WhatAppProject
//
//  Created by Daniel Jermaine on 30/05/2025.
//

import Foundation

struct ETCDataResponse: Codable {
    let data: [ETCData]
    let reason: String
    let status: Bool
    let stepno: String
}

struct ETCData: Codable {
    let docno: String?
    let birthdate: String?
    let lastname: String?
    let firstname: String?
    let middlename: String?
    let gender: String?
    let birthstate: String?
    let issuedate: String?
    let expirydate: String?
    let doctype: String?
    let issueplace: String?
    let faceimage: String?
    let personalno: String?
    let nationality: String?
    let olddocno: String?
    let reason: String?
    let iserror: Bool?
    let status: Bool?
}
