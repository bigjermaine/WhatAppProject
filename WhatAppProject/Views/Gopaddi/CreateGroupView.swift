//
//  CreateGroupView.swift
//  WhatAppProject
//
//  Created by Daniel Jermaine on 25/08/2025.
//


import SwiftUI

struct CreateGroupView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var groupName: String = ""
    @State private var groupDescription: String = ""
    
    let maxNameLength = 100
    let maxDescriptionLength = 400
    
    var body: some View {
        VStack {
            // Nav bar
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                        .font(.system(size: 18, weight: .medium))
                }
                Text("New group")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            
            ScrollView {
                VStack(spacing: 24) {
                    
                    // Group Image Placeholder
                    ZStack {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 100, height: 100)
                        
                        Image(systemName: "camera.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                    }
                    .padding(.top, 20)
                    
                    // Group name
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("Group name")
                                .font(.subheadline)
                            Spacer()
                            Text("\(groupName.count)/\(maxNameLength)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        TextField("Enter group name", text: $groupName)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                            .onChange(of: groupName) { newValue in
                                if newValue.count > maxNameLength {
                                    groupName = String(newValue.prefix(maxNameLength))
                                }
                            }
                    }
                    
                    // Group description
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("Group Description")
                                .font(.subheadline)
                            Spacer()
                            Text("\(groupDescription.count)/\(maxDescriptionLength)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        TextEditor(text: $groupDescription)
                            .frame(height: 120)
                            .padding(8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                            .onChange(of: groupDescription) { newValue in
                                if newValue.count > maxDescriptionLength {
                                    groupDescription = String(newValue.prefix(maxDescriptionLength))
                                }
                            }
                    }
                    
                }
                .padding(.horizontal)
            }
            
            Spacer()
            
            // Create button
            Button(action: {
                print("Create group tapped: \(groupName), \(groupDescription)")
            }) {
                Text("Create group")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

#Preview {
    CreateGroupView()
}
