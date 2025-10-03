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
        ServiceCategory(title: "Room cleaning", systemImage: "roomCleaningIcon"),
        ServiceCategory(title: "Fabrics", systemImage: "fabricsIcon"),
        ServiceCategory(title: "Toiletries", systemImage: "toiletriesIcon"),
        ServiceCategory(title: "Report issue", systemImage: "reportIssueIcon"),
        ServiceCategory(title: "Furnishings", systemImage: "furnishingIcon"),
        ServiceCategory(title: "Guest help", systemImage: "guestHelpIcon")
    ]
    
    let roomNumber = "312"
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                
                // Top message
                Text("Thank you! **Room \(roomNumber)** confirmed. How can we assist you with housekeeping service today?")
                    .font(Font(UIFont.satoshi( weight: .regular, size: 16)))
                    .foregroundColor(.black)
                    .padding(.top, 10)
                
                Text("Please select a service category below")
                    .font(Font(UIFont.satoshi( weight: .regular, size: 12)))
                    .foregroundColor(.black)
                
                // Grid of categories
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(categories) { category in
                        NavigationLink {
                            ServiceDetailView(service: category)
                        } label: {
                            VStack(spacing: 16) {
                                Image(category.systemImage)
                                    .font(.system(size: 36, weight: .regular))
                                    .foregroundColor(Color(red: 49/255, green: 119/255, blue: 204/255)) // blue accent
                                    .padding(.top, 8)
                                
                                Text(category.title)
                                    .font(Font(UIFont.satoshi( weight: .regular, size: 14)))
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.center)
                                    .padding(.bottom, 8)
                            }
                            .frame(maxWidth: .infinity, minHeight: 90)
                            .background(Color.white)
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color(red: 230/255, green: 238/255, blue: 250/255), lineWidth: 1.2)
                            )
                           
                        }
                    }
                }
                .padding(10)
                .background(Color.white)
                .cornerRadius(18)
                .padding(.vertical, 6)
                
               
                
                // Timestamp
                Text("03:50 AM")
                    .font(Font(UIFont.satoshi( weight: .regular, size: 14)))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
            }
            .padding()
            .navigationBarBackButtonHidden(true)
            .background(Color(red: 240/255, green: 246/255, blue: 255/255))
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

