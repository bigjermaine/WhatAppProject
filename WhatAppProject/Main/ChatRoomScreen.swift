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
            .onTapGesture {
                hideKeyboard()
            }
        .safeAreaInset(edge: .bottom) {
            bottomAreaView
               
        }
        .toolbar{
            leadingNAVItem()
            trailingNAVItem()
        }
       // .ignoresSafeArea(edges:.bottom)
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
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil,
                                        from: nil,
                                        for: nil)
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




struct MessageListView1: View {
    @ObservedObject var viewModel: ChatViewModel
    @State private var scrollToBottomId: UUID?
    
    var body: some View {
        ScrollViewReader { proxy in
            List {
                ForEach(viewModel.messageItem.indices, id: \.self) { index in
                    let message = viewModel.messageItem[index]
                    let showDateHeader = shouldShowDateHeader(for: index)
                    
                    messageCell(for: message, showDateHeader: showDateHeader)
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .id(index == viewModel.messageItem.count - 1 ? scrollToBottomId : nil)
                }
            }
            .listStyle(PlainListStyle())
            .background(Color.clear)
            .onChange(of: viewModel.messageItem.count) { _ in
                withAnimation {
                    scrollToBottom(using: proxy)
                }
            }
            .onAppear {
                scrollToBottomId = UUID()
            }
        }
    }
    
    private func messageCell(for message: MessageItem, showDateHeader: Bool) -> some View {
        Group {
            switch message.type {
            case .photo:
                BubbleImageView(item: message)
            case .text:
                BubbleTextView(
                    item: message,
                    showDateHeader: showDateHeader,
                    dateHeaderText: message.date.relativeDateString
                )
            case .video, .audio:
                BubbleAudioView(item: message)
            }
        }
    }
    
    private func shouldShowDateHeader(for index: Int) -> Bool {
        guard index > 0 else { return true }
        let current = viewModel.messageItem[index].date.relativeDateString
        let previous = viewModel.messageItem[index - 1].date.relativeDateString
        return current != previous
    }
    
    private func scrollToBottom(using proxy: ScrollViewProxy) {
        guard !viewModel.messageItem.isEmpty else { return }
        let lastIndex = viewModel.messageItem.count - 1
        scrollToBottomId = UUID()
        proxy.scrollTo(lastIndex, anchor: .bottom)
    }
}



//
//struct MessageListView1: View {
//    @ObservedObject var viewModel: ChatViewModel
//    @State private var scrollToBottomId: UUID?
//    
//    var body: some View {
//        VStack{
//            ScrollViewReader { proxy in
//                ScrollView {
//                    ForEach(viewModel.messageItem.indices, id: \.self) { index in
//                        let message = viewModel.messageItem[index]
//                        let showDateHeader = shouldShowDateHeader(for: index)
//                        
//                        messageCell(for: message, showDateHeader: showDateHeader)
//                            .listRowInsets(EdgeInsets())
//                            .listRowSeparator(.hidden)
//                            .listRowBackground(Color.clear)
//                            .id(index == viewModel.messageItem.count - 1 ? scrollToBottomId : nil)
//                    }
//                }
//                .listStyle(PlainListStyle())
//                .background(Color.clear)
//                .onChange(of: viewModel.messageItem.count) { _ in
//                    withAnimation {
//                        scrollToBottom(using: proxy)
//                    }
//                }
//                
//                bottomAreaView
//            }
//            
//        }
//    }
//    var bottomAreaView: some View {
//        VStack{
////            if viewModel.showPhotopIckerPreview {
////                MediaAttachmentPreview(selectedPhotos: viewModel.selectedPhotos, actionHanler:{ action in
////                    viewModel.mediaPreviewActions(actions: action)})
////            }
////            Divider()
//            TextInputArea(text: $viewModel.messageText, sendButtonIsEnabled: viewModel.sendButtonIsEnabled, actionHandler: {
//                action in
//                viewModel.handleText(action)
//              
//            })
//           // Divider()
//        }
//    }
//    private func messageCell(for message: MessageItem, showDateHeader: Bool) -> some View {
//        Group {
//            switch message.type {
//            case .photo:
//                BubbleImageView(item: message)
//            case .text:
//                BubbleTextView(
//                    item: message,
//                    showDateHeader: showDateHeader,
//                    dateHeaderText: message.date.relativeDateString
//                )
//            case .video, .audio:
//                BubbleAudioView(item: message)
//            }
//        }
//    }
//    
//    private func shouldShowDateHeader(for index: Int) -> Bool {
//        guard index > 0 else { return true }
//        let current = viewModel.messageItem[index].date.relativeDateString
//        let previous = viewModel.messageItem[index - 1].date.relativeDateString
//        return current != previous
//    }
//    
//    private func scrollToBottom(using proxy: ScrollViewProxy) {
//        guard !viewModel.messageItem.isEmpty else { return }
//        let lastIndex = viewModel.messageItem.count + 4
//        scrollToBottomId = UUID()
//        proxy.scrollTo(lastIndex, anchor: .bottom)
//    }
//}
//
//
