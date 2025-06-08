//
//  Untitled.swift
//  WhatAppProject
//
//  Created by Daniel Jermaine on 15/04/2025.
//
import SwiftUI
import PhotosUI
import Combine


class ChatViewModel: ObservableObject {
    @Published var messageItem: [MessageItem] = []
    @Published var messageText: String = ""
    @Published var showPhotoPicker: Bool = false
    @Published var photoPickerItems: [PhotosPickerItem] = []
    @Published var selectedPhotos: [MediaImageModel] = []
    @Published var supportTicket:SupportTicket?
    @Published var paymentsOptions:[PaymentGateway] = []
    @Published var paymentRequest:PaymentRequest?
    @Published var isLoading: Bool = false
    @Published var didOpen : Bool = false
    @Published var docNo:String = ""
    @Published var birthDate:String = ""
    @Published var appReason:String = ""
    @Published var link:String = ""
    var subscriptions = Set<AnyCancellable>()
    private var messagePollingTimer: Timer?
    private let supportTicketService: SupportTicketRequestProtocol
    
    var sendButtonIsEnabled: Bool {
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
    
    var showPhotoPickerPreview: Bool {
        return !photoPickerItems.isEmpty
    }
    
    init(supportTicketService: SupportTicketRequestProtocol = SupportTicketService()) {
        self.supportTicketService = supportTicketService
        onPhotoPickerSelection()
        
    }
    
    
    func checkEligibility(){
        Task{
            do {
                let _ =  try await supportTicketService.getEligiblity(docNo: docNo, birthdate: birthDate, appReason: appReason)
                await MainActor.run {
                    
                }
            }catch {
                print("Error loading support ticket messages: \(error.localizedDescription)")
            }
        }
    }
    
    func startObservingMessages(ticketNo: String) {
        // Cancel previous timer if exists
        messagePollingTimer?.invalidate()
        
        // Load immediately
        loadSupportTicketMessages(ticketNo: "306-4558E411-7431")
        // Then poll every 5 seconds
        messagePollingTimer = Timer.scheduledTimer(
            withTimeInterval: 5.0,
            repeats: true
        ) { [weak self] _ in
            self?.loadSupportTicketMessages(ticketNo: "306-4558E411-7431")
        }
    }
    
    func stopObservingMessages() {
        messagePollingTimer?.invalidate()
        messagePollingTimer = nil
    }
    
    func loadSupportTicketMessages(ticketNo: String = "306-4558E411-7431") {
        Task {
            do {
                let ticket = try await supportTicketService.fetchSupportTicket(byTicketNo: ticketNo)
                await MainActor.run {
                    self.convertSupportMessagesToMessageItems(ticket.messages ?? [],
                                                              isAgent: ticket.agentName)
                    self.supportTicket = ticket
                }
            } catch {
                await MainActor.run {
                    self.messageItem = self.placeholderMessages()
                }
            }
        }
    }
    
    @MainActor
    func getPaymentsOptions() {
        isLoading =  true
        Task {
            do {
                isLoading =  false
                let ticket = try await supportTicketService.getPayments()
                await MainActor.run {
                    paymentsOptions = ticket.data.items
                }
            } catch {
                print("Error loading support ticket messages: \(error.localizedDescription)")
                
            }
        }
    }
    @MainActor
    func initiatPayment(){
        isLoading =  true
        Task {
            do {
                guard let paymentRequest = paymentRequest else {return}
                let ticket = try await supportTicketService.initiatePayment(payment: paymentRequest)
                isLoading =  false
                await MainActor.run {
                    link =  ticket.data.link
                    didOpen  =   true
                }
            } catch {
                isLoading =  false
                print("Error loading support ticket messages: \(error.localizedDescription)")
                
            }
        }
        
    }
    
    private func convertSupportMessagesToMessageItems(_ messages: [SupportMessage], isAgent: String) {
        let newMessages = messages.map { message -> MessageItem in
            let direction: MessageDirection = message.isSenderAgent ? .received : .sent
            let date = DateFormatter.supportDateFormatter.date(from: message.creationTime) ?? Date()
            
            return MessageItem(
                text: message.content,
                type: .text,
                direction: direction,
                date: date,
                senderName: message.senderName,
                isAgent: message.isSenderAgent
            )
        }
        
        self.messageItem = newMessages.sorted(by: { $0.date < $1.date })
    }
    
    private func placeholderMessages() -> [MessageItem] {
        return [
            MessageItem(
                text: "Hi There",
                type: .text,
                direction: .sent,
                date: Calendar.current.date(byAdding: .day, value: -30, to: Date())!,
                senderName: "Support Agent",
                isAgent: true
            ),
            MessageItem(
                text: "Check Out This Photo",
                type: .photo,
                direction: .received,
                date: Calendar.current.date(byAdding: .day, value: -7, to: Date())!,
                senderName: "Customer",
                isAgent: false
            ),
            MessageItem(
                text: "How can I help you today?",
                type: .text,
                direction: .sent,
                date: Date(),
                senderName: "Support Agent",
                isAgent: true
            )
        ]
    }
    
    func addMessage(message: MessageItem) {
        messageItem.append(message)
    }
    
    func handleText(_ action: TextInputArea.UserAction) {
        switch action {
        case .presentPhotoPicker:
            showPhotoPicker = true
        case .sendMessage:
            let base64Images = selectedPhotos.compactMap { $0.photo.base64String }
            
            sendMessages(model: SendMessageModel(content: messageText, photo: base64Images))
            let message = MessageItem(
                text: messageText,
                type: .text,
                direction: .sent,
                date: Date(),
                senderName: "You",
                isAgent: true,
                images:base64Images
            )
            messageItem.append(message)
            messageText = ""
            selectedPhotos.removeAll()
            photoPickerItems.removeAll()
        }
        
        
    }
    
    
    func sendMessages(model:SendMessageModel) {
        Task {
            do {
                let ticket = try await supportTicketService.sendMessage(ticketId:supportTicket?.id ?? "", model: model)
                print(ticket)
                await MainActor.run {
                    
                }
            } catch {
                print("Error loading support ticket messages: \(error.localizedDescription)")
                // Fallback to placeholder messages if API fails
            }
        }
    }
    private func onPhotoPickerSelection() {
        $photoPickerItems.sink { [weak self] photoItems in
            guard let self = self else { return }
            Task {
                for photoItem in photoItems {
                    guard
                        let data = try? await photoItem.loadTransferable(type: Data.self),
                        let uiImage = UIImage(data: data),
                        let id = photoItem.itemIdentifier
                    else { return }
                    
                    if !self.selectedPhotos.contains(where: { $0.id == id }) {
                        self.selectedPhotos.insert(MediaImageModel(id: id, photo: uiImage), at: 0)
                    }
                }
            }
        }
        .store(in: &subscriptions)
    }
    
    func mediaPreviewActions(actions: MediaAttachmentPreview.UserAction) {
        switch actions {
        case .remove(let image):
            selectedPhotos.removeAll { $0.id == image.id }
            photoPickerItems.removeAll { $0.itemIdentifier == image.id }
        }
    }
}


extension UIImage {
    
    var base64String: String? {
        guard let imageData = self.jpegData(compressionQuality: 0.8) else {
            return nil
        }
        return imageData.base64EncodedString()
    }
}



// Abstraction
protocol PaymentProcessor {
    func processPayment(amount: Double)
}

// Low-level module
class StripePaymentProcessor: PaymentProcessor {
    func processPayment(amount: Double) {
        print("Processing payment of \(amount) via Stripe.")
    }
}

// High-level module
class CheckoutService {
    private let paymentProcessor: PaymentProcessor
    
    init(paymentProcessor: PaymentProcessor) {
        self.paymentProcessor = paymentProcessor
    }
    
    func checkout(amount: Double) {
        paymentProcessor.processPayment(amount: amount)
    }
}

// Usage
let stripeProcessor = StripePaymentProcessor()
let checkout = CheckoutService(paymentProcessor: stripeProcessor)
let y = checkout.checkout(amount: 100)


