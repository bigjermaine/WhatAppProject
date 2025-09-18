//
//  EventCell.swift
//  WhatAppProject
//
//  Created by Daniel Jermaine on 18/09/2025.
//


import SwiftUI

struct ActiveCenterEventCell: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            // Event Image with Label
            ZStack(alignment: .topLeading) {
                Image("eventImage")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 140)
                    .clipped()
                  
                
                Text("Event")
                    .font(.caption)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(6)
                    .padding(8)
            }
            
            // Event Info
            VStack(alignment: .leading, spacing: 8) {
                Text("ART MEETS FASHION LAGOS")
                    .font(.headline)
                    .foregroundColor(.primary)
                    .padding(.horizontal)
                  
                
                HStack(spacing: 4) {
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                    Text("Lagos, Nigeria")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
                
                
                // Date
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                    Text("Date")
                        .font(.subheadline)
                    Spacer()
                    Text("March 15, 2025")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding()
              
                
                // Time and Tickets
                HStack {
                    VStack {
                        Text("Time")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("7:30 PM")
                            .font(.headline)
                            .foregroundColor(.primary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.green.withAlphaComponent(0.1)))
                    .cornerRadius(8)
                    
                    VStack {
                        Text("Tickets")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("03")
                            .font(.headline)
                            .foregroundColor(.primary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.green.withAlphaComponent(0.1)))
                    .cornerRadius(8)
                }
                .padding(.horizontal)
               
                
                Divider()
                    .padding(.vertical)
                HStack {
                    Text("NTL-4456")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.orange.opacity(0.2))
                        .foregroundColor(.orange)
                        .cornerRadius(6)
                    
                    Spacer()
                    
                    Image(systemName: "ellipsis")
                        .rotationEffect(.degrees(90))
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
           
        }
       
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 4)
        .padding()
        
    }
  
}

#Preview {
    EventCell()
}
