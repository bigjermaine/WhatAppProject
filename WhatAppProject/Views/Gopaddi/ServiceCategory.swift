//
//  ServiceCategory.swift
//  WhatAppProject
//
//  Created by Daniel Jermaine on 01/10/2025.
//


import SwiftUI

struct ServiceCategory: Identifiable {
    let id = UUID()
    let title: String
    let systemImage: String
}

struct HousekeepingView: View {
    @Environment(\.dismiss) var dismiss
    
    let categories: [ServiceCategory] = [
        ServiceCategory(title: "Room cleaning", systemImage: "bed.double"),
        ServiceCategory(title: "Fabrics", systemImage: "tshirt"),
        ServiceCategory(title: "Toiletries", systemImage: "shower"),
        ServiceCategory(title: "Report issue", systemImage: "exclamationmark.bubble"),
        ServiceCategory(title: "Furnishings", systemImage: "lamp.table"),
        ServiceCategory(title: "Guest help", systemImage: "person.2.questionmark")
    ]
    
    let roomNumber = "312"
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                
                // Top message
                Text("Thank you! **Room \(roomNumber)** confirmed. How can we assist you with housekeeping service today?")
                    .font(.body)
                    .foregroundColor(.primary)
                    .padding(.top, 10)
                
                Text("Please select a service category below")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                // Grid of categories
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(categories) { category in
                        NavigationLink {
                            ServiceDetailView(service: category)
                        } label: {
                            VStack(spacing: 8) {
                                Image(systemName: category.systemImage)
                                    .font(.system(size: 28))
                                    .foregroundColor(.blue)
                                
                                Text(category.title)
                                    .font(.body)
                                    .foregroundColor(.primary)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity, minHeight: 90)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        }
                    }
                }
                .padding(.top, 8)
                
               
                
                // Timestamp
                Text("03:50 AM")
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
            }
            .padding()
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.headline)
                    }
                }
            }
        }
    }
}

// Mock detail screen
struct ServiceDetailView: View {
    let service: ServiceCategory
    
    var body: some View {
        VStack {
            Text("You selected **\(service.title)**")
                .font(.title2)
                .padding()
            Spacer()
        }
        .navigationTitle(service.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    HousekeepingView()
}
