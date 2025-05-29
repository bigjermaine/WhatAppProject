//
//  SupportTicketRequestProtocol.swift
//  WhatAppProject
//
//  Created by Daniel Jermaine on 05/05/2025.
//

import Foundation

// MARK: - Request Protocol
protocol SupportTicketRequestProtocol {
    func fetchSupportTicket(byTicketNo ticketNo: String) async throws -> SupportTicket
    
    func sendMessage(
        ticketId: String,
        model:SendMessageModel
    ) async throws -> SendMessageResponse

    func getPayments() async throws -> GatewayResponse
    func initiatePayment(payment:PaymentRequest) async throws -> PaymentLinkResponse
}

// MARK: - Service Implementation
class SupportTicketService: SupportTicketRequestProtocol {
    private let domain: String
    private let urlSession: URLSession
    let  token = "eyJhbGciOiJSUzI1NiIsImtpZCI6IkIyNTdFM0QzMjcwRjU1NjI5QjFCQjdBREYwQjg3MzY4NjI1OUE0ODAiLCJ4NXQiOiJzbGZqMHljUFZXS2JHN2V0OExoemFHSlpwSUEiLCJ0eXAiOiJhdCtqd3QifQ.eyJzdWIiOiIzYTE1ZGU2YS0zY2RkLWEwNWMtMmUzMS02NDAwOGUwNmI3YWUiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiJsdW1teXNtYXJ0IiwiZW1haWwiOiJuZXdzdW5mYWRAeWFob28uY29tIiwicm9sZSI6Im1vYmlsZWFkbWluIiwiZ2l2ZW5fbmFtZSI6Ik9sdW1pZGUgU21hcnQiLCJmYW1pbHlfbmFtZSI6IkZhZGF5b21pIiwicGhvbmVfbnVtYmVyIjoiKzIzNDgwOTM1NTE5NzMiLCJwaG9uZV9udW1iZXJfdmVyaWZpZWQiOiJUcnVlIiwiZW1haWxfdmVyaWZpZWQiOiJUcnVlIiwidW5pcXVlX25hbWUiOiJsdW1teXNtYXJ0Iiwib2lfcHJzdCI6Ik1vYmlsZSIsIm9pX2F1X2lkIjoiM2ExOWI3YTAtM2I1Ny01YzM5LTNkZjQtNWU0ZmJiMjVjZGQ5IiwiY2xpZW50X2lkIjoiTW9iaWxlIiwib2lfdGtuX2lkIjoiM2ExOWI3YTAtM2Q2Ny04ZmZmLTc4NmYtY2E3NmMwMTNlYTAzIiwic2NvcGUiOiJvZmZsaW5lX2FjY2VzcyBvcGVuaWQgcHJvZmlsZSBlbWFpbCBwaG9uZSIsImp0aSI6IjkzMzYyMDE1LTg5ODEtNGEyOC1hZDczLTY1ZWFiMGZmOWYyYiIsImV4cCI6MTc0NjUzNjEyNSwiaXNzIjoiaHR0cDovLzE3Mi4zMS4xMC4yMjo1MDAxLyIsImlhdCI6MTc0NjUzMjUyNX0.zTVqNrL354sGzpbhz7832hqRHLSVQ82ZXPAf3BMK88B2XUDJ2KTZhrbdzwtYZD2gFJzDNH2_7PVdhYxzedBwleYoxdhkpbEh3mOHTZRHBzmCu4rMV6C3DZ5CvL1YhgcIiL1CNtWLSjdInzxVKP0ufknveTAfFiL9Hn22GTnt6_NQj9NoKyj4cJqkTBX10F6W89w_y5VE0HLDNpB6DH9yffM_JMDDkZvmRFQUL17xrKwvX1Y3mwR7sIspAAjBC8GXbVBv-vUebhj2nGx-7afiGNkpu5CkRf-Zeqpk_7LymU0JGkCsPc9IZhl5tdpUensSo9IWIryVDUE9HhCgKDAAv8iD9kQ15m6NprZlNEm-r_hgnsVpU-O4fte9_tM5Rplt3BQPAT77Io8kqISC2rYErkNx8tRoHLSx7hFZcn4nHRMyfpcW3pky6ij04H0dcVvv-lOreun8tmXJ45Lo5MQw090ZsVnN52GnIJ-OqGn7GGn-I46zh-BGnfhC2hiTPNLfo3GRVYSO2cXgsJgqvxDr11fcrlKN83TVLdEQ5rpWbmnyQaQ9bEm35GjMQT4Hp8-rME2Ed1SxXK1lQGTaSRUYEh6DOWw7F-pImRaoIi0J3TiXDLiP96iZ2vWJVTe_JjwfkPc8e7oAQw5OYUln4o4-WWGZspVj4LWh3AWCnM_JkT4"
    init(domain: String = "https://epms.irissmart.com:7006", urlSession: URLSession = .shared) {
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
                print("Decoding error: \(error)")
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
