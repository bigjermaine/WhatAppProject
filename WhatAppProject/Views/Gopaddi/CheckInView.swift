//
//  CheckInView.swift
//  WhatAppProject
//
//  Created by Daniel Jermaine on 09/09/2025.

import SwiftUI


struct CheckInView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedID: String? = nil
    @State private var selectedFile: URL? = nil
    @State private var isUploading = false
    @State private var uploadFailed = false
    let idTypes = ["National ID card", "Drivers license", "Passport"]
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.black)
                }
                
                Text("Check in")
                    .font(.headline)
                Spacer()
            }
            Divider()
                .padding(5)
            VStack(spacing:20){
                // Info Text
                Text("Before we can hand over your room key, we just need to confirm your identity. Please upload a valid photo ID (passport, driver’s license, or government-issued ID).")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                // Picker
                VStack(alignment: .leading, spacing: 8) {
                    Text("ID type")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Menu {
                        ForEach(idTypes, id: \.self) { type in
                            Button(type) {
                                selectedID = type
                                selectedFile = nil // Reset file selection when ID changes
                            }
                        }
                    } label: {
                        HStack {
                            Text(selectedID ?? "Select ID type")
                                .foregroundColor(selectedID == nil ? .gray : .black)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    }
                }
                
                // File Upload Section (shown only when ID is selected)
                if selectedID != nil {
                    FileUploadView(
                        selectedFile: $selectedFile,
                        isUploading: $isUploading,
                        uploadFailed: $uploadFailed, selectedID: $selectedID)
                    
                }
                
                Spacer()
                
                // Bottom Buttons
                // Bottom Buttons
                HStack(spacing: 16) {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Cancel")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .foregroundColor(.black)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                            )
                            .cornerRadius(12)
                    }
                    
                    Button(action: {
                        // Handle verification
                    }) {
                        Text("Verify")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(selectedID == nil || selectedFile == nil ? Color.gray.opacity(0.2) : Color.blue)
                            .foregroundColor(selectedID == nil || selectedFile == nil ? .gray : .white)
                            .cornerRadius(12)
                    }
                    .disabled(selectedID == nil || selectedFile == nil)
                }
            }
            .padding(.top)
        }
        .padding()
    }
}

#Preview {
    CheckInView()
}

struct FileUploadView: View {
    @Binding var selectedFile: URL?
    @Binding var isUploading: Bool
    @Binding var uploadFailed: Bool
    @Binding  var selectedID: String?
    var body: some View {
        VStack(spacing: 10) {
            if selectedID != nil {
                Image(systemName: "arrow.up.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color.gray)
                
                Text("Choose a file")
                    .font(.headline)
                    .foregroundColor(Color.black)
                
                Text("JPEG, PNG, PDF, and MP4 formats, up to 50 MB.")
                    .font(.caption)
                    .foregroundColor(Color.gray)
                
                Button(action: {
                    isUploading = true
                    uploadFailed = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        selectedFile = URL(string: "file://id_card.png")
                        
                    }
                }) {
                    Text("Browse file")
                        .padding(8)
                    
                }
                .font(.subheadline)
                .background(Color.white)
                .foregroundColor(.black)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
                .cornerRadius(4)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.8), style: StrokeStyle(lineWidth: 1, dash: [5]))
        )
        .cornerRadius(8)
        if  isUploading {
            HStack(spacing: 10) {
                Image(systemName: "doc.fill")
                    .resizable()
                    .frame(width: 40,height: 40)
                    .foregroundColor(.green)
                VStack(alignment: .leading) {
                    HStack{
                        Text("File1")
                        
                    }
                    .foregroundColor(.black)
                    HStack{
                      
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .frame(width: 13, height: 13)
                           
                        Text("0 KB of 120 KB • \(isUploading ? "Uploading..." : "")")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    ProgressView(value: 0.04)
                        .tint(.blue)
                        .frame(height: 10)
                    
                }
                
                Spacer()
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .foregroundColor(.gray)
                    .opacity(0.5)
                    .frame(width: 20, height: 20,alignment: .topTrailing)
                    .background(Color.white)
                    .padding(.bottom,40)
            }
            .frame(height: 94
            )
            .padding(.horizontal)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
            .cornerRadius(8)
            
        }
    }
}


