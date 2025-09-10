//
//  CheckInView.swift
//  WhatAppProject
//
//  Created by Daniel Jermaine on 09/09/2025.

import SwiftUI

enum StateUploadCheckIn{
    case selected
    case success
    case failed
}

struct CheckInView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedID: String? = nil
    @State private var selectedFile: URL? = nil
    @State private var isUploading = false
    @State private var uploadFailed = false
    let idTypes = ["National ID card", "Drivers license", "Passport"]
    @State var stateUploadCheckIn:StateUploadCheckIn = .selected
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
            .padding()
            Divider()
                .padding(.horizontal,5)
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
                
                if selectedID != nil {
                    FileUploadView(
                        selectedFile: $selectedFile,
                        isUploading: $isUploading,
                        uploadFailed: $uploadFailed, selectedID: $selectedID, stateUploadCheckIn: $stateUploadCheckIn)
                    .padding(.top)
                    
                }
                
                Spacer()
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
                    .disabled(selectedFile == nil)
                }
            }
            .padding(.top)
            .padding()
        }
        
            }
        }
     



#Preview {
    CheckInView()
}

struct FileUploadView: View {
    @Binding var selectedFile: URL?
    @Binding var isUploading: Bool
    @Binding var uploadFailed: Bool
    @Binding var selectedID: String?
    @Binding var stateUploadCheckIn:StateUploadCheckIn
    var body: some View {
        VStack(alignment:.leading) {
            Text("Upload \(selectedID ?? "")")
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
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                stateUploadCheckIn = .selected
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    stateUploadCheckIn = .failed
                                    
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                                    
                                    stateUploadCheckIn = .success
                                    
                                    
                                }
                                
                            }
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
        }
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
                        switch stateUploadCheckIn {
                        case .selected:
                            Text("0 KB of 120 KB • \(isUploading ? "Uploading..." : "")")
                                .font(.caption)
                                .foregroundColor(.gray)
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .frame(width: 13, height: 13)
                        case .success:
                         Text("0 KB of 120 KB •")
                             .font(.caption)
                             .foregroundColor(.gray)
                            
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.system(size: 20))
                                Text("Completed")
                                .font(.caption)
                        case .failed:
                            Text("0 KB of 120 KB • ")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Image(systemName: "xmark.octagon.fill") // Failed icon
                                .foregroundColor(.red)
                                .font(.system(size: 20))
                                Text("Failed")
                                .font(.caption)
                        }
                        
            
                    }
                    switch stateUploadCheckIn {
                    case.failed:
                       Text("Try Again")
                            .underline()
                            .foregroundStyle(.red)
                    case.selected:
                        ProgressView(value: 0.04)
                            .tint(.blue)
                            .frame(height: 10)
                    case.success:
                        EmptyView()
                    }
                  
                    
                }
                
                Spacer()
                switch stateUploadCheckIn {
                case.failed:
                    Image(systemName: "trash.fill")
                        .resizable()
                        .foregroundColor(.red)
                        .opacity(0.5)
                        .frame(width: 20, height: 20, alignment: .topTrailing)
                        .background(Color.white)
                        .clipShape(Circle()) // keeps it neat
                        .padding(.bottom, 40)

                case.selected:
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .foregroundColor(.gray)
                        .opacity(0.5)
                        .frame(width: 20, height: 20,alignment: .topTrailing)
                        .background(Color.white)
                        .padding(.bottom,40)
                case.success:
                    Image(systemName: "trash.fill")
                        .resizable()
                        .foregroundColor(.gray)
                        .opacity(0.5)
                        .frame(width: 20, height: 20, alignment: .topTrailing)
                        .background(Color.white)
                        .clipShape(Circle()) // keeps it neat
                        .padding(.bottom, 40)

                }
              
            }
            .frame(height: 94
            )
            .padding(.horizontal)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(stateUploadCheckIn == .failed ? Color.red :  Color.gray.opacity(0.3), lineWidth: 1)
            )
            .cornerRadius(8)
            
        }
    }
}


