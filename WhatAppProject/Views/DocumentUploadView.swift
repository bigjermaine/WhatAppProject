//
//  DocumentUploadView.swift
//  WhatAppProject
//
//  Created by Daniel Jermaine on 08/09/2025.
//
import SwiftUI
import PhotosUI

struct DocumentUploadView: View {
    @StateObject private var vm = DocumentUploadViewModel(stepNo: "STEP-2025-898485")
    var body: some View {
        NavigationStack {
                if vm.isLoading {
                    ProgressView("Loading...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Upload your single travel emergency passport document for approval")
                                .font(.system(size: 15))
                                .foregroundColor(.gray)
                                .padding(.horizontal)
                            
                            Toggle(isOn: $vm.nameChanged) {
                                Text("My name has changed")
                                    .font(.system(size: 15))
                                    .foregroundColor(.black)
                            }
                            .padding(.horizontal)
                            
                            Text("Check this box if your name has changed since your last document submission (e.g., after marriage or other legal change).")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                                .padding(.horizontal)
                            
                            HStack {
                                Text("Upload Document")
                                    .font(.system(size: 16, weight: .semibold))
                                Spacer()
                                Button(action: {
                                    vm.resetAllImages()
                                }) {
                                    Text("RESET ALL")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 6)
                                        .background(Color.accentColor)
                                        .cornerRadius(6)
                                }
                            }
                            .padding(.horizontal)
                            
                            VStack(spacing: 15) {
                                ForEach(vm.documents) { doc in
                                    DocumentCardView(doc: doc) { image in
                                        vm.setImage(for: doc, image: image)
                                    }
                                }
                            }
                            .padding(.horizontal)
                            
                            Button(action: {
                                Task {
                                    let success = await vm.uploadDocuments()
                                    print(success ? "✅ Uploaded" : "❌ Upload failed")
                                }
                            }) {
                                Text("SUBMIT DOCUMENTS")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.accentColor)
                                    .cornerRadius(10)
                            }
                            .padding()
                        }
                        .padding(.top)
                    }
                }
            }
            .navigationTitle("Document Upload")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        // Dismiss or custom back action
                    }) {
                        Image(systemName: "chevron.left")
                    }
                }
            }
            .task {
                await vm.fetchDocuments(appReason: "3") // Example: Lost
            }
        
    }
}


#Preview {
    DocumentUploadView()
}


// MARK: - Document Card with Image Picker
struct DocumentCardView: View {
    let doc: DocumentType
    var onImagePicked: (UIImage) -> Void
    @State private var selectedItem: PhotosPickerItem?
    @State private var showFullscreen = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                Image(systemName: "doc.text.fill")
                    .font(.system(size: 22))
                    .foregroundColor(.black)
                    .padding(.top, 6)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(doc.docName)
                        .font(.system(size: 16, weight: .semibold))
                    Text(doc.docDescription)
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                PhotosPicker(
                    selection: $selectedItem,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    Image(systemName: "arrow.up.doc")
                        .font(.system(size: 22))
                        .foregroundColor(.black)
                }
            }
            
            if let image = doc.image {
                HStack {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .clipped()
                        .cornerRadius(8)
                        .onTapGesture { showFullscreen = true }
                    
                    Spacer()
                    Image(systemName: "arrow.right")
                        .font(.system(size: 20))
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        .onChange(of: selectedItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    onImagePicked(uiImage)  // 👈 push back to ViewModel
                }
            }
        }
        .fullScreenCover(isPresented: $showFullscreen) {
            if let image = doc.image {
                ZStack(alignment: .topTrailing) {
                    Color.black.ignoresSafeArea()
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black)
                    
                    Button(action: { showFullscreen = false }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                            .padding()
                    }
                }
            }
        }
    }
}


@MainActor
class DocumentUploadViewModel: ObservableObject {
    @Published var documents: [DocumentType] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var nameChanged:Bool = false
    private let stepNo: String
    private let feature = "STEP"
    
    init(stepNo: String) {
        self.stepNo = stepNo
    }
    
    /// Fetch document types
    func fetchDocuments(appReason: String) async {
        isLoading = true
        defer { isLoading = false }
        
        guard let url = URL(string: "https://your.api/document-service/document/document-type/\(feature)/\(appReason)") else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            var decoded = try JSONDecoder().decode([DocumentType].self, from: data)
            // ensure local image placeholder exists
            decoded = decoded.map { doc in
                var mutable = doc
                mutable.image = nil
                return mutable
            }
            self.documents = decoded
        } catch {
            self.errorMessage = "Failed to load documents: \(error.localizedDescription)"
        }
    }
    
    /// Update selected image
    func setImage(for doc: DocumentType, image: UIImage) {
        if let index = documents.firstIndex(where: { $0.id == doc.id }) {
            documents[index].image = image
        }
    }
    
    /// Upload all documents
    func uploadDocuments() async -> Bool {
        let uploads = documents.compactMap { doc -> [String: Any]? in
            guard let uiImage = doc.image,
                  let imageData = uiImage.jpegData(compressionQuality: 0.8) else { return nil }
            let base64 = imageData.base64EncodedString()
            
            return [
                "regNo": stepNo,
                "docTypeId": doc.id,
                "feature": feature,
                "docImage": base64,
                "isFaceImage": false
            ]
        }
        
        guard let url = URL(string: "https://your.api/document-service/document/create-documents"),
              let body = try? JSONSerialization.data(withJSONObject: uploads) else {
            return false
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse {
                return httpResponse.statusCode == 200
            }
        } catch {
            self.errorMessage = "Upload failed: \(error.localizedDescription)"
        }
        return false
    }
    func resetAllImages() {
        for i in documents.indices {
            documents[i].image = nil
        }
        
    }
}
struct DocumentType: Codable, Identifiable, Hashable {
    let id: Int
    let docName: String
    let docDescription: String
    
    // Local-only, not part of Codable
    var image: UIImage? = nil
    
    enum CodingKeys: String, CodingKey {
        case id
        case docName
        case docDescription
    }
}
