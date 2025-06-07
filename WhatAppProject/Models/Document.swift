//
//  Document.swift
//  WhatAppProject
//
//  Created by Daniel Jermaine on 07/06/2025.
//


struct Document: Codable, Identifiable {
    let docName: String
    let docDescription: String
    let id: Int
}

// For an array of documents:
typealias DocumentList = [Document]