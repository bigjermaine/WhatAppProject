//
//  StepPaymentInstruction.swift
//  WhatAppProject
//
//  Created by Daniel Jermaine on 04/06/2025.
//

import SwiftUI

struct StepPaymentInstruction: View {
    var body: some View {
        ReusableAccountView(content: {
            ScrollView{
                VStack(alignment: .leading, spacing: 16) {
                    // Header
                    Text("Payment Instructions")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    // Instruction Description
                    Text("Before you proceed to payment, please ensure you have your payment card details with you. You will be redirected to a secure payment platform to complete your payment.")
                        .font(.body)
                        .foregroundColor(.gray)
                    
                    // Illustration and Guide
                    VStack(spacing: 12) {
                        Image("card_payment") // Add your illustration image to Assets
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                        
                        Text("STEP Payment Guide")
                            .font(.headline)
                            .foregroundColor(.black)
                        
                        Text("Note: You may be required to verify your payment transaction before you can proceed to the summary page for final submission. Tap the button below to proceed.")
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(.center)
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                        
                        // Proceed Button
                        Button(action: {
                            // Handle payment action
                        }) {
                            Text("PROCEED TO PAYMENT")
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.accentColor)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                    .background(Color(.white))
                    .cornerRadius(12)
                    .shadow(radius: 4)
                }
                .padding()
                .background(Color.white)
                
                
                Spacer()
            }
                
               
        }, navigationBarTitle: "STEP Enrollment Guide")
    }
}

#Preview {
    StepPaymentInstruction()
}


