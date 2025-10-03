//
//  FabricItem.swift
//  WhatAppProject
//
//  Created by Daniel Jermaine on 02/10/2025.
//

import SwiftUI

struct FabricItem: Identifiable {
    let id = UUID()
    let name: String
    var count: Int = 0
}

struct FabricsRequestView: View {
    @Environment(\.dismiss) var dismiss
    @State private var items: [FabricItem] = [
        FabricItem(name: "Towels"),
        FabricItem(name: "Linen"),
        FabricItem(name: "Baby bedding"),
        FabricItem(name: "Extra pillow"),
        FabricItem(name: "Blanket"),
        FabricItem(name: "Topper")
    ]
    let roomNumber: String = "312"
    let serviceName: String = "fabrics"
    
    var totalCount: Int {
        items.map { $0.count }.reduce(0, +)
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                // Top bar
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.headline)
                            .foregroundColor(.primary)
                    }
                    Spacer()
                }
                .padding(.top, 2)
                
                // Title
                Text("Thanks! How can we assist you with \(serviceName) today?")
                    .font(Font(UIFont.satoshi( weight: .regular, size: 14)))
                    .foregroundColor(.black)
                
                Text("Please select what you'd like to request:")
                    .font(Font(UIFont.satoshi( weight: .regular, size: 14)))
                    .foregroundColor(.gray)
                
                // Item list
                VStack(spacing: 10) {
                    ForEach(items.indices, id: \.self) { idx in
                        let item = items[idx]
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(item.name)
                                    .font(Font(UIFont.satoshi( weight: .regular, size: 14)))
                                    .foregroundColor(.black)
                                Text("Free")
                                    .font(Font(UIFont.satoshi( weight: .regular, size: 14)))
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            if item.count == 0 {
                                Button(action: {
                                    items[idx].count = 1
                                }) {
                                    Image(systemName: "plus")
                                        .frame(width: 26, height: 26)
                                        .background(Color(red: 240/255, green: 246/255, blue: 255/255))
                                        .cornerRadius(7)
                                        .foregroundColor(.gray)
                                }
                            } else {
                                HStack(spacing: 2) {
                                    Button(action: {
                                        if items[idx].count > 0 {
                                            items[idx].count -= 1
                                        }
                                    }) {
                                        Image(systemName: "minus")
                                            .frame(width: 22, height: 22)
                                            .background(Color(red: 240/255, green: 246/255, blue: 255/255))
                                            .cornerRadius(7)
                                            .foregroundColor(Color(red: 49/255, green: 119/255, blue: 204/255))
                                    }
                                    Text("\(item.count)")
                                        .font(.body)
                                        .frame(width: 22)
                                        .foregroundColor(.primary)
                                    Button(action: {
                                        items[idx].count += 1
                                    }) {
                                        Image(systemName: "plus")
                                            .frame(width: 22, height: 22)
                                            .background(Color(red: 240/255, green: 246/255, blue: 255/255))
                                            .cornerRadius(7)
                                            .foregroundColor(Color(red: 49/255, green: 119/255, blue: 204/255))
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(red: 230/255, green: 238/255, blue: 250/255), lineWidth: 1.2)
                        )
                    }
                }
                .padding(10)
                .background(Color.white)
                .cornerRadius(18)
                .padding(.vertical, 4)
                
                HStack{
                    // Summary and button
                    Text("Total Items:")
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .padding(.top, 4)
                    Spacer()
                    Text("\(totalCount)")
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .padding(.top, 4)
                }
                
                Button(action: {
                    // Handle continue action
                }) {
                    Text("Continue")
                        .font(Font(UIFont.satoshi( weight: .regular, size: 14)))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(Color(red: 22/255, green: 109/255, blue: 246/255))
                        .cornerRadius(8)
                }
                .padding(.top, 2)
                
                // Timestamp
                Text("03:50 AM")
                    .font(Font(UIFont.satoshi( weight: .regular, size: 14)))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 2)
            }
            .padding()
            .background(Color(red: 240/255, green: 246/255, blue: 255/255))
        }
    }
}

#Preview {
    FabricsRequestView()
}
