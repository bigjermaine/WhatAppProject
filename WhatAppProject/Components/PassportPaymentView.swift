//
//  PassportPaymentView.swift
//  ScanAndPay
//
//  Created by Daniel Jermaine on 02/05/2025.
//


import SwiftUI

struct PassportPaymentView: View {
    @State private var selectedPaymentMethod: PaymentGateway?
    @State private var isInformationVerified = false
    @StateObject var chatViewModel = ChatViewModel()

    enum PaymentMethod: String, CaseIterable {
        case paystack = "Paystack"
        case paypal = "Paypal"
        case gtb = "GTB"
        case ogaranya = "Ogaranya"
    }
    
    var body: some View {
        ZStack {
        ScrollView {
         
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 20) {
                        HStack(spacing:10){
                            Image(systemName: "person.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                            
                            Text("Apache Florence")
                                .font(.title)
                                .fontWeight(.bold)
                        }
                        Text("Passport Type: Standard")
                            .font(.headline)
                        
                        Text("Booklet Type: 32 Pages")
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity,alignment: .leading)
                    .padding()
                    .padding(.vertical,5)
                    .foregroundColor(.white)
                    .background(
                        Image("passportHeaderBackground")
                            .resizable()
                            .frame(maxWidth: .infinity,maxHeight: 500)
                            .cornerRadius(8)
                    )
                    .padding(.bottom, 20)
                    
                    
                    // Payment Options
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Select Payment Method")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.leading,15)
                        
                        ForEach(chatViewModel.paymentsOptions, id: \.self) { method in
                            PaymentMethodRow(method: method, isSelected: selectedPaymentMethod == method) {
                                chatViewModel.paymentRequest = PaymentRequest(gatewayId: method.id, applicationConfigurationId:"3a199b65-f594-392b-ad8d-558871b326cd", userId: "3a19949b-005b-4ac7-c8bc-f86c204a8bcd", amount:64500, currency: "NGN")
                                selectedPaymentMethod = method
                            }
                        }
                    }
                    
                    Divider()
                        .padding(.vertical)
                    
                    // Summary
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Summary")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        VStack(spacing: 12) {
                            HStack {
                                Text("BOOKLET FEE")
                                    .fontWeight(.medium)
                                    .foregroundStyle(.gray)
                                Text("32 Pages")
                                
                                Spacer()
                                Text("N60,000")
                                    .fontWeight(.bold)
                                    .foregroundStyle(.accent)
                            }
                            
                            HStack {
                                Text("CONTACTLESS FEE")
                                    .fontWeight(.medium)
                                    .foregroundStyle(.gray)
                                Spacer()
                                Text("N4,500")
                                    .fontWeight(.bold)
                                    .foregroundStyle(.accent)
                            }
                            
                            Divider()
                            
                            HStack {
                                Text("TOTAL COST")
                                    .fontWeight(.medium)
                                    .foregroundStyle(.gray)
                                Spacer()
                                Text("N64,500")
                                    .fontWeight(.bold)
                                    .foregroundStyle(.accent)
                            }
                        }
                        .font(.subheadline)
                        
                        Toggle(isOn: $isInformationVerified) {
                            Text("Check this to verify your information is correct")
                                .font(.caption)
                        }
                    }
                    
                    Spacer()
                    
                    // Proceed Button
                    Button(action: {
                        // Handle payment
                        chatViewModel.initiatPayment()
                    }) {
                        Text("Proceed to Payment")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isInformationVerified && selectedPaymentMethod != nil ? Color.accent : Color.gray)
                            .cornerRadius(10)
                    }
                    .disabled(!isInformationVerified || selectedPaymentMethod == nil)
                    .padding(.top, 20)
                }
                .padding()
                .onAppear{
                    chatViewModel.getPaymentsOptions()
                }
              
            }
            if chatViewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .black))
                    
             }
        }
        .sheet(isPresented: $chatViewModel.didOpen) {
                    if !chatViewModel.link.isEmpty {
                        PaymentWebViewContainer(
                            isPresented: $chatViewModel.didOpen,
                            urlString: chatViewModel.link
                        )
                    }
                }
    }
}

struct PaymentMethodRow: View {
    let method: PaymentGateway
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                RemoteImageView(url: method.logoURL)
                    .frame(width: 50, height: 50)
                    .cornerRadius(25)
                    .padding(.horizontal)
                VStack(alignment: .leading, spacing: 4) {
                    Text(method.name)
                        .font(.headline)
                    // Payment method details
                    Group {
                        Text("Card, Bank Transfer, USSD")
                      
                        }
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
            )
            .buttonStyle(PlainButtonStyle())
        }
      
    }


struct PassportPaymentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PassportPaymentView()
        }
    }
}


struct RemoteImageView: View {
    let url: URL?
    var placeholder: Image = Image(systemName: "photo")
    var errorImage: Image = Image(systemName: "exclamationmark.triangle")
    
    var body: some View {
        AsyncImage(
            url: url,
            transaction: Transaction(animation: .easeInOut)
        ) { phase in
            switch phase {
            case .empty:
                placeholder
                    .foregroundColor(.gray)
                
            case .success(let image):
                image
                    .resizable()
                    .transition(.opacity)
                
            case .failure:
                errorImage
                    .foregroundColor(.red)
                
            @unknown default:
                EmptyView()
            }
        }
    }
}
