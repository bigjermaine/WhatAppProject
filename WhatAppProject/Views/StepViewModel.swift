//
//  StepViewModel.swift
//  WhatAppProject
//
//  Created by Daniel Jermaine on 28/05/2025.
//

import Foundation


class StepViewModel:ObservableObject {
    
    @Published var docNo:String = ""
    @Published var birthDate:String = ""
    @Published var appReason:String = ""
    @Published var selectedReason: ApplicationReason = .expiredPassport
    private let supportTicketService: SupportTicketRequestProtocol =  SupportTicketService()
    
    func checkEligibility(){
        Task{
            do {
                let eligibility =  try await supportTicketService.getEligiblity(docNo: docNo, birthdate: birthDate, appReason: selectedReason.reason)
                await MainActor.run {
                    print(eligibility)
                }
            }catch {
                print("Error loading support ticket messages: \(error.localizedDescription)")
            }
        }
    }
    
    
    
}
