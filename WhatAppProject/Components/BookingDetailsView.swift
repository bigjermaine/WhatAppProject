//
//  BookingDetailsView.swift
//  WhatAppProject
//
//  Created by Daniel Jermaine on 05/05/2025.
//


import SwiftUI

struct BookingDetailsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Booking Information Section
            VStack(alignment: .leading, spacing: 8) {
                Text("Booking ID")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text("L98SZAY")
                    .font(.body)
                
                Text("Payment Reference")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.top, 8)
                Text("47263YSDU87")
                    .font(.body)
                
                Text("Price")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.top, 8)
                Text("NGN 100,000.00")
                    .font(.body)
            }
            
            Divider()
                .padding(.vertical, 8)
            
            // Hotel Information Section
            VStack(alignment: .leading, spacing: 8) {
                Text("**Riviera Resort, Lekki**")
                    .font(.headline)
                Text("18, Kenneth Agbakuru Street, Off Access Bank Admiralty Way, Lekki Phase1")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Image(systemName: "square")
                        Text("Check In: Fri, Apr 8th")
                    }
                    HStack {
                        Image(systemName: "square")
                        Text("Check Out: Sun, Apr 10th")
                    }
                }
                .padding(.top, 8)
            }
            
            Divider()
                .padding(.vertical, 8)
            
            // Room Information Section
            VStack(alignment: .leading, spacing: 8) {
                Text("1 room x 10 nights incl. taxes")
                    .font(.subheadline)
                
                Text("Room Type")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.top, 8)
                Text("**Super Deluxe**")
                    .font(.body)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Booking Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct BookingDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BookingDetailsView()
        }
    }
}