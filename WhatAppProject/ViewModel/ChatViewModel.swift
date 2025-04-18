//
//  Untitled.swift
//  WhatAppProject
//
//  Created by Daniel Jermaine on 15/04/2025.
//
import SwiftUI
import PhotosUI
import Combine
class ChatViewModel:ObservableObject {
    
    @Published var messageItem:[MessageItem] = []
    @Published var messageText:String = ""
    @Published var showPhotoPicker:Bool = false
    @Published var photoPickerItmes:[PhotosPickerItem] = []
    @Published var selectedPhotos:[MediaImageModel] = []
    var subscriptions = Set<AnyCancellable>()
    
    var sendButtonIsEnabled:Bool {
        messageText.isEmpty
    }
    var groupedMessages: [String: [MessageItem]] {
        Dictionary(grouping: messageItem) { message in
            message.date.relativeDateString
        }
    }
    
    var sortedGroupKeys: [String] {
        groupedMessages.keys.sorted { lhs, rhs in
            guard
                let lhsDate = groupedMessages[lhs]?.first?.date,
                let rhsDate = groupedMessages[rhs]?.first?.date
            else { return false }
            return lhsDate < rhsDate
        }
    }

    var showPhotopIckerPreview:Bool {
        return !photoPickerItmes.isEmpty
      
    }
    
    
    init() {
        self.messageItem = [
            .init(
                text: "Hi There",
                type: .text,
                direction: .sent,
                date: Calendar.current.date(byAdding: .day, value: -30, to: Date())! // 1 month ago
            ),
            .init(
                text: "Check Out This Photo",
                type: .photo,
                direction: .received,
                date: Calendar.current.date(byAdding: .day, value: -7, to: Date())! // 1 week ago
            ),
            .init(
                text: "Check Out This Video",
                type: .video,
                direction: .sent,
                date: Calendar.current.date(byAdding: .day, value: -3, to: Date())! // 3 days ago
            ),
            .init(
                text: "",
                type: .audio,
                direction: .sent,
                date: Calendar.current.date(byAdding: .hour, value: -2, to: Date())! // 2 hours ago
            ),
            .init(
                text: "How are you?",
                type: .text,
                direction: .received,
                date: Calendar.current.date(byAdding: .month, value: -6, to: Date())! // 6 months ago
            ),
            .init(
                text: "Meeting tomorrow?",
                type: .text,
                direction: .sent,
                date: Calendar.current.date(byAdding: .day, value: -1, to: Date())! // Yesterday
            ),
        ]
        onPhotoPickerSelction()
    }
    
    func addMessage(message:MessageItem){
      
        print(messageItem)
        
    }
    
    func handleText(_ action:TextInputArea.UserAction) {
        switch action {
        case .presentPhotoPicker:
            showPhotoPicker =  true
        case .sendMessage:
            let message = MessageItem(text: messageText, type: .text, direction: .sent, date: Date())
            messageItem.append(message)
            messageText  = ""
        }
    }
    
    private func onPhotoPickerSelction() {
        $photoPickerItmes.sink { [weak self] photoItems in
            guard let self = self else { return }
            Task {
                for photoItem in photoItems {
                    guard
                        let data = try? await photoItem.loadTransferable(type: Data.self),
                        let uimage = UIImage(data: data),
                        let id = photoItem.itemIdentifier
                    else { return }
                    
                    // Check if photo with this ID already exists
                    if !self.selectedPhotos.contains(where: { $0.id == id }) {
                        self.selectedPhotos.insert(MediaImageModel(id: id, photo: uimage), at: 0)
                    }
                }
            }
        }
        .store(in: &subscriptions)
    }
    
    func mediaPreviewActions(actions:MediaAttachmentPreview.UserAction) {
        switch actions {
        case .remove(let image):
            selectedPhotos.removeAll { $0.id == image.id}
            photoPickerItmes.removeAll { $0.itemIdentifier == image.id}
        }
        
    }
}
