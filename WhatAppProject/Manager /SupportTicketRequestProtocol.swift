//
//  SupportTicketRequestProtocol.swift
//  WhatAppProject
//
//  Created by Daniel Jermaine on 05/05/2025.
//

import Foundation


protocol SupportTicketRequestProtocol {
    func fetchSupportTicket(byTicketNo ticketNo: String) async throws -> SupportTicket
    
    func sendMessage(
        ticketId: String,
        model:SendMessageModel
    ) async throws -> SendMessageResponse

    func getPayments() async throws -> GatewayResponse
    func initiatePayment(payment:PaymentRequest) async throws -> PaymentLinkResponse
    func getEligiblity(docNo: String, birthdate: String, appReason: String)  async throws -> ETCDataResponse
    func getDocumentTypes() async throws -> DocumentList
    func uploadDocumentTypes(documents: DocumentList) async throws -> DocumentList
    
}

// MARK: - Service Implementation
class SupportTicketService: SupportTicketRequestProtocol {
 
    
    private let domain: String
    private let urlSession: URLSession
    let  token = ""

  
    
    init(domain: String = "https://epms.irissmart.com:7005", urlSession: URLSession = .shared) {
        self.domain = domain
        self.urlSession = urlSession
    }
    
    func fetchSupportTicket(byTicketNo ticketNo: String) async throws -> SupportTicket {
        
        let urlString = "\(domain)/api/notification-service/support-requests/by-ticket-no/\(ticketNo)"
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        // Add authentication header if needed
     
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await urlSession.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            let decoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd, HH:mm:ss"
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            
            do {
              let data =  try decoder.decode([SupportTicket].self, from: data)
                return data.first!
            } catch {
                throw NetworkError.decodingError
            }
        case 401:
            throw NetworkError.unauthorized
        case 404:
            throw NetworkError.notFound
        default:
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }
    }
    
    func getDocumentTypes() async throws -> DocumentList {
        let urlString = "\(domain)/api/document-service/document/get-by-regno"
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let (data, response) = try await urlSession.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
              do {
                let data =  try decoder.decode(DocumentList.self, from: data)
                return data
            } catch {
                print("Decoding error: \(error)")
                throw NetworkError.decodingError
            }
            
        case 401:
            throw NetworkError.unauthorized
        case 400...499:
            
            let errorMessage = try? JSONDecoder().decode(APIErrorResponse.self, from: data)
            throw NetworkError.serverError(statusCode: errorMessage?.code ?? 400)
            
        default:
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }
    }
    
    
    func uploadDocumentTypes(documents: DocumentList) async throws -> DocumentList {
        let urlString = "\(domain)/api/document-service/document/create-documents"
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        // Encode the documents and set them as the request body
        do {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase // If your backend expects snake_case
            request.httpBody = try encoder.encode(documents)
        } catch {
          
           
        }
        
        let (data, response) = try await urlSession.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let responseData = try decoder.decode(DocumentList.self, from: data)
                return responseData
            } catch {
                throw NetworkError.decodingError
            }
            
        case 401:
            throw NetworkError.unauthorized
        case 400...499:
            let errorMessage = try? JSONDecoder().decode(APIErrorResponse.self, from: data)
            throw NetworkError.serverError(statusCode: errorMessage?.code ?? 400)
            
        default:
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }
    }
   
    
    func getEligiblity(docNo: String, birthdate: String, appReason: String) async throws -> ETCDataResponse {
        let encodedDocNo = docNo.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let encodedBirthdate = birthdate.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let encodedAppReason = appReason.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

        let urlString = "\(domain)/api/appointment-service/appointment/step/get-eligibility-record?docNo=\(encodedDocNo)&birthdate=\(encodedBirthdate)&appReason=\(encodedAppReason)"

        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let (data, response) = try await urlSession.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
              do {
                let data =  try decoder.decode(ETCDataResponse.self, from: data)
        
                return data
            } catch {
                print("Decoding error: \(error)")
                throw NetworkError.decodingError
            }
            
        case 401:
            throw NetworkError.unauthorized
        case 400...499:
            
            let errorMessage = try? JSONDecoder().decode(APIErrorResponse.self, from: data)
            throw NetworkError.serverError(statusCode: errorMessage?.code ?? 400)
            
        default:
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }
    }
    
  
      func sendMessage(
          ticketId: String,
          model:SendMessageModel
      ) async throws -> SendMessageResponse {
          let urlString = "\(domain)/api/notification-service/support-requests/applicant/\(ticketId)/send-message"
          
          guard let url = URL(string: urlString) else {
              throw NetworkError.invalidURL
          }
        
          var request = URLRequest(url: url)
          request.httpMethod = "POST"
          request.setValue("application/json", forHTTPHeaderField: "Content-Type")
          request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
          let requestBody = model
          let encoder = JSONEncoder()
          encoder.keyEncodingStrategy = .convertToSnakeCase
          request.httpBody = try encoder.encode(requestBody)
          
          let (data, response) = try await urlSession.data(for: request)
          
          guard let httpResponse = response as? HTTPURLResponse else {
              throw NetworkError.invalidResponse
          }
          
          switch httpResponse.statusCode {
          case 200...299:
              let decoder = JSONDecoder()
              decoder.keyDecodingStrategy = .convertFromSnakeCase
              let dateFormatter = DateFormatter()
              dateFormatter.dateFormat = "yyyy-MM-dd, HH:mm:ss"
              decoder.dateDecodingStrategy = .formatted(dateFormatter)
              
              do {
                  let data =  try decoder.decode(SendMessageResponse.self, from: data)
                  return data
              } catch {
                  print("Decoding error: \(error)")
                  throw NetworkError.decodingError
              }
              
          case 401:
              throw NetworkError.unauthorized
          case 400...499:
              let errorMessage = try? JSONDecoder().decode(APIErrorResponse.self, from: data)
              throw NetworkError.serverError(statusCode: errorMessage?.code ?? 400)
              
          default:
              throw NetworkError.serverError(statusCode: httpResponse.statusCode)
          }
      }
    
    func initiatePayment(payment: PaymentRequest) async throws -> PaymentLinkResponse {
        let urlString = "\(domain)/api/payment-service/transactions/initialise"
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
      
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let requestBody = payment
        
        let encoder = JSONEncoder()
        request.httpBody = try encoder.encode(requestBody)
        
        let (data, response) = try await urlSession.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let data =  try decoder.decode(PaymentLinkResponse.self, from: data)
                return data
            } catch {
                throw NetworkError.decodingError
            }
            
        case 401:
            throw NetworkError.unauthorized
        case 400...499:
            let errorMessage = try? JSONDecoder().decode(APIErrorResponse.self, from: data)
            throw NetworkError.serverError(statusCode: errorMessage?.code ?? 400)
            
        default:
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }
    }
   
    func getPayments() async throws -> GatewayResponse {
        let urlString = "\(domain)/api/payment-service/gateways"
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let (data, response) = try await urlSession.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
              do {
                let data =  try decoder.decode(GatewayResponse.self, from: data)
                print(data)
                return data
            } catch {
                print("Decoding error: \(error)")
                throw NetworkError.decodingError
            }
            
        case 401:
            throw NetworkError.unauthorized
        case 400...499:
            let errorMessage = try? JSONDecoder().decode(APIErrorResponse.self, from: data)
            throw NetworkError.serverError(statusCode: errorMessage?.code ?? 400)
            
        default:
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }
    }
  }

struct APIErrorResponse: Decodable {
    let message: String
    let code: Int
}

// MARK: - Error Handling
enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
    case unauthorized
    case notFound
    case serverError(statusCode: Int)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .decodingError:
            return "Failed to decode response"
        case .unauthorized:
            return "Authentication required"
        case .notFound:
            return "Ticket not found"
        case .serverError(let statusCode):
            return "Server error with status code: \(statusCode)"
        }
    }
}

// MARK: - Usage Example
struct SupportTicketManager {
    private let service: SupportTicketRequestProtocol
    
    init(service: SupportTicketRequestProtocol = SupportTicketService()) {
        self.service = service
    }
    
    func loadTicket(byNumber ticketNo: String) async {
        do {
            let ticket = try await service.fetchSupportTicket(byTicketNo: ticketNo)
            print("Successfully fetched ticket:")
            printTicketDetails(ticket)
            
            if let messages = ticket.messages {
                print("\nMessages (\(messages.count)):")
                messages.forEach { printMessage($0) }
            }
        } catch {
            print("Error fetching ticket: \(error.localizedDescription)")
        }
    }
    
    private func printTicketDetails(_ ticket: SupportTicket) {
        print("""
        Ticket No: \(ticket.ticketNo)
        Status: \(ticket.status)
        Topic: \(ticket.topic)
        Applicant: \(ticket.applicantName) (\(ticket.applicantEmail))
        Agent: \(ticket.agentName) (\(ticket.agentEmail))
        Created: \(ticket.creationTime)
        Last Modified: \(ticket.lastModificationTime)
        Device: \(ticket.deviceInfo)
        """)
    }
    
    private func printMessage(_ message: SupportMessage) {
        print("""
        - [\(message.isSenderAgent ? "Agent" : "User")] \(message.senderName):
          \(message.content)
          \(message.creationTime)
        """)
    }
}
