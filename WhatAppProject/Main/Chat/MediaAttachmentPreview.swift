//
//  MediaAttachmentPreview.swift
//  WhatAppProject
//
//  Created by Daniel Jermaine on 17/04/2025.
//

import SwiftUI

struct MediaAttachmentPreview: View {
    let selectedPhotos:[MediaImageModel]
    let actionHanler:(_ action: UserAction ) -> Void
    var body: some View {
        ScrollView(.horizontal,showsIndicators: false) {
            HStack {
                ForEach(selectedPhotos,id: \.id) { photos in
                    thumbnailImageView(photos: photos)
                }
            }
            .frame(height: Constants.listHeight)
            .frame(maxWidth: .infinity)
            .background(.whatsAppWhite)
        }
    }
    
     private func thumbnailImageView(photos:MediaImageModel) -> some View {
        Button {
            
        }label: {
            Image(uiImage: photos.photo)
                .resizable()
                .scaledToFill()
                .frame(width: Constants.imageDimen,height:Constants.imageDimen)
                .cornerRadius(5)
                .clipped()
                .overlay(alignment: .topTrailing) {
                    cancelButton(photo:photos)
                }
                .overlay() {
                    playButton()
                }
        }
    }
    private func cancelButton(photo:MediaImageModel) -> some View {
        Button{
            actionHanler(.remove(photo))
        }label: {
            Image(systemName: "xmark")
                .scaledToFit()
                .imageScale(.small)
                .padding(5)
                .foregroundColor(.white)
                .background(Color.white.opacity(0.5))
                .clipShape(Circle())
                .shadow(radius: 3)
                .padding(2)
                .bold()
        }
    }
    
    private func playButton()  -> some View {
        Button{
            
        }label: {
            Image(systemName: "play.fill")
                .scaledToFit()
                .imageScale(.medium)
                .padding(10)
                .foregroundColor(.white)
                .background(Color.white.opacity(0.5))
                .clipShape(Circle())
                .shadow(radius: 3)
                .padding(2)
                .bold()
        }
    }
    
    
    private func audioAttachments()  -> some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .leading, endPoint: .trailing)
                .edgesIgnoringSafeArea(.all)
        
            playButton()
        }
        .frame(width: Constants.imageDimen * 2,height:Constants.imageDimen)
        .cornerRadius(5)
    }
}

extension MediaAttachmentPreview {
    enum UserAction {
        case remove(_ item:MediaImageModel)
    }
}

#Preview {
    MediaAttachmentPreview(selectedPhotos: [], actionHanler:{ _ in } )
}

extension MediaAttachmentPreview {
    enum Constants {
        static let listHeight:CGFloat = 100
        static let imageDimen:CGFloat = 80
    }
}
