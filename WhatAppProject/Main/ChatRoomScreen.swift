//
//  ChatRoomScreen.swift
//  WhatAppProject
//
//  Created by Daniel Jermaine on 15/04/2025.
//
import SwiftUI
import PhotosUI

struct ChatRoomScreen: View {
    @StateObject var chatViewModel = ChatViewModel()
    @State private var keyboardHeight: CGFloat = 0
    var body: some View {
        MessageListView(viewModel: chatViewModel)
        .safeAreaInset(edge: .bottom) {
            bottomAreaView
                .keyboardAdaptive()
        }
        .toolbar{
            leadingNAVItem()
            trailingNAVItem()
        }
        .ignoresSafeArea(edges:.bottom)
        .animation(.easeInOut, value: chatViewModel.showPhotopIckerPreview)
        .photosPicker(isPresented: $chatViewModel.showPhotoPicker, selection: $chatViewModel.photoPickerItmes,maxSelectionCount:6,photoLibrary: .shared())
        
           
      }
    
    var bottomAreaView: some View {
        VStack{
            if chatViewModel.showPhotopIckerPreview {
                MediaAttachmentPreview(selectedPhotos: chatViewModel.selectedPhotos, actionHanler:{ action in
                    chatViewModel.mediaPreviewActions(actions: action)})
            }
            Divider()
            TextInputArea(text: $chatViewModel.messageText, sendButtonIsEnabled: chatViewModel.sendButtonIsEnabled, actionHandler: {
                action in
                chatViewModel.handleText(action)
              
            })
            Divider()
        }
    }
}

extension ChatRoomScreen {
    @ToolbarContentBuilder
    private func leadingNAVItem() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            HStack{
                Circle()
                    .frame(width: 35,height: 35)
                
                Text("QaUser12")
                    .bold()
            }
        }
    }
    
    @ToolbarContentBuilder
    private func trailingNAVItem() -> some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            HStack{
                Button{
                    
                }label: {
                    Image(systemName: "video")
                }
                
                Button{
                    
                }label: {
                    Image(systemName: "phone")
                }
            }
        }
    }
}
#Preview {
    NavigationStack{
        ChatRoomScreen()
    }
}

extension View {
    func keyboardAdaptive() -> some View {
        ModifiedContent(content: self, modifier: KeyboardAdaptive())
    }
}

struct KeyboardAdaptive: ViewModifier {
    @State private var keyboardHeight: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .padding(.bottom, keyboardHeight)
            .animation(.easeOut(duration: 0.16), value: keyboardHeight)
            .onAppear {
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
                    guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
                    keyboardHeight = keyboardFrame.height
                }
                
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                    keyboardHeight = 0
                }
            }
            .onDisappear {
                NotificationCenter.default.removeObserver(self)
            }
    }
}
