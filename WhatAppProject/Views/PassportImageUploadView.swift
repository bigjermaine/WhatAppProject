//
//  PassportImageUploadView.swift
//  WhatAppProject
//
//  Created by Daniel Jermaine on 09/10/2025.
//


import SwiftUI
import PhotosUI
import UIKit

struct PassportImageUploadView: View {
    @StateObject private var viewModel = PassportsImageUploadViewModel()
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            VStack(spacing: 24) {
                VStack(spacing: 24) {
                    ZStack(alignment: .top) {
                        // Decorative background pinned to top
                        Image("light_green_shade2")
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity, maxHeight: 200, alignment: .top)
                            .clipped()
                            .ignoresSafeArea()
                        
                        // Avatar area with trailing camera button
                        ZStack(alignment: .trailing) {
                            if let image = viewModel.selectedImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 200, height: 200)
                                    .clipShape(Circle())
                                    .clipped()
                            } else {
                                Circle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 200, height: 200)
                                    .overlay {
                                        Image(systemName: "person.crop.circle")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 80, height: 80)
                                            .foregroundColor(Color.gray.opacity(0.7))
                                    }
                            }
                            
                            Button {
                                viewModel.isShowingSourcePicker = true
                            } label: {
                                Image(systemName: hasApertureCamera ? "camera.aperture" : "camera")
                                    .font(.system(size: 24, weight: .medium))
                                    .foregroundColor(.white)
                                    .frame(width: 56, height: 56)
                                    .background(Color(red: 0.12, green: 0.36, blue: 0.34))
                                    .clipShape(Circle())
                                    .shadow(color: .white.opacity(0.6), radius: 4, x: 0, y: 0)
                            }
                            .accessibilityLabel("Add photo")
                            .offset(x: 16)
                        }
                        .frame(maxHeight: .infinity, alignment: .top)
                        .padding(.top, 40)
                    }
                    
                    PhotosPicker(selection: $viewModel.selectedItem, matching: .images, preferredItemEncoding: .automatic) {
                        EmptyView()
                    }
                    .frame(width: 0, height: 0)
                    .opacity(0.001)
                    .allowsHitTesting(false)
                    
                    Text("Please upload an ICAO compliant image")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    
                    Spacer()
                    
                    Button {
                        print("Proceed tapped")
                    } label: {
                        Text("PROCEED")
                            .fontWeight(.semibold)
                            .tracking(1.5)
                            .foregroundColor(.white)
                            .frame(height: 56)
                            .frame(maxWidth: .infinity)
                            .background(Color(red: 0.12, green: 0.36, blue: 0.34))
                            .cornerRadius(28)
                    }
                    .padding(.horizontal, 24)
                    .disabled(!viewModel.canProceed)
                    .opacity(viewModel.canProceed ? 1 : 0.6)
                    
                }
                .frame(maxWidth: .infinity,maxHeight: .infinity)
                Spacer()
            }
            .padding(.bottom, 48)
            .navigationBarHidden(true)
            .confirmationDialog("Select Photo Source", isPresented: $viewModel.isShowingSourcePicker, titleVisibility: .visible) {
                Button("Take Photo") { viewModel.isTakingPhoto = true }
                Button("Choose from Library") {
                    viewModel.isPresentingImagePicker = true
                }
                Button("Cancel", role: .cancel) { }
            }
            .onChange(of: viewModel.selectedItem) { _ in
                Task {
                    await viewModel.handleSelectedItemChange()
                }
            }
            .overlay(alignment: .center) {
                if viewModel.isPresentingImagePicker {
                    PhotosPicker(selection: $viewModel.selectedItem, matching: .images) {
                        Color.clear
                            .contentShape(Rectangle())
                            .onAppear { /* no-op */ }
                    }
                    .onChange(of: viewModel.selectedItem) { _ in
                        viewModel.isPresentingImagePicker = false
                    }
                }
            }
            .sheet(isPresented: $viewModel.isTakingPhoto) {
                CameraPicker(image: Binding(
                    get: { viewModel.selectedImage },
                    set: { newImage in
                        viewModel.selectedImage = newImage
                        viewModel.isTakingPhoto = false
                    }
                ))
                .ignoresSafeArea()
            }
        }
    }
    
    private var hasApertureCamera: Bool {
        UIImage(systemName: "camera.aperture") != nil
    }
}

#Preview {
    PassportImageUploadView()
}



final class PassportsImageUploadViewModel: ObservableObject {
    @Published var selectedImage: UIImage?
    @Published var isPresentingImagePicker: Bool = false
    @Published var isTakingPhoto: Bool = false
    @Published var selectedItem: PhotosPickerItem?
    @Published var isShowingSourcePicker: Bool = false
    
    var canProceed: Bool {
        selectedImage != nil
    }
    
    func handleSelectedItemChange() async {
        if let newValue = selectedItem,
           let data = try? await newValue.loadTransferable(type: Data.self),
           let uiImage = UIImage(data: data) {
            selectedImage = uiImage
        }
    }
}

struct CameraPicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraPicker
        init(parent: CameraPicker) { self.parent = parent }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            picker.dismiss(animated: true)
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }

    func makeCoordinator() -> Coordinator { Coordinator(parent: self) }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        picker.allowsEditing = false
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}
