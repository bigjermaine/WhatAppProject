//
//  FabricRequestConfirmationView.swift
//  WhatAppProject
//
//  Created by Assistant on 02/10/2025.
//

import SwiftUI

struct FabricRequestConfirmationView: View {
    @Environment(\.dismiss) private var dismiss
    
    // You can customize these inputs as needed
    let items: [(name: String, quantity: Int)] = [
        ("Linen", 1),
        ("Toppers", 2)
    ]
    let instructions: String = "No scented detergent, Iron only, Please deliver before 5pm"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Top bar
            HStack(alignment: .center) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                Spacer()
            }
            .padding(.top, 2)

            // Success message
            Text("Your request has been submitted successfully. Our housekeeping team will deliver your items shortly.")
                .font(.subheadline)
                .foregroundColor(.black)
                .padding(.horizontal, 2)
            
            // Card
            VStack(alignment: .leading, spacing: 0) {
                // Status row
                HStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(Color.green.opacity(0.18))
                            .frame(width: 30, height: 30)
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.system(size: 22, weight: .medium))
                    }
                    Text("Request confirmed")
                        .foregroundColor(.green)
                        .font(.subheadline.weight(.medium))
                    Spacer()
                }
                .padding(.top, 16)
                .padding(.horizontal, 16)
                
                // Service type
                VStack(alignment: .leading, spacing: 8) {
                    Divider().padding(.vertical, 8)
                    Text("Service type")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("Fabrics")
                        .font(.headline.weight(.semibold))
                        .foregroundColor(.black)
                        .padding(.bottom, 4)
                    
                    // Special Instructions section
                    Text("Special Instructions")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.top, 8)
                        .padding(.bottom, 2)
                    // Item List
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(items, id: \.name) { item in
                            HStack(alignment: .top) {
                                Text("•")
                                Text("\(item.quantity) x \(item.name)")
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                            }
                        }
                    }
                    .padding(.bottom, 8)
                    
                    // Instructions Box
                    Text(instructions)
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .padding(12)
                        .background(Color(red: 248/255, green: 251/255, blue: 255/255))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.gray)
                            
                        )
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
            .background(Color.white)
            .cornerRadius(14)
            .shadow(color: Color.black.opacity(0.03), radius: 3, x: 0, y: 2)
            .padding(.horizontal, 2)
            
            // Buttons row
            HStack(alignment: .center, spacing: 12) {
                Button(action: { /* clear action */ }) {
                    Text("Clear")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(Color.black)
                        .background(Color.white)
                        .cornerRadius(8)
                }
                Button(action: { /* continue action */ }) {
                    Text("Continue")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .padding(.horizontal)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal, 2)
            Text("You can track your fabrics order status here")
                .font(Font(UIFont.satoshi( weight: .regular, size: 14)))
                .foregroundColor(.black)
            OrderStatusTrackerView(
                currentStep: 4,
                steps: [
                    .init(title: "Request received", icon: "doc.fill"),
                    .init(title: "Assigned", icon: "person.3.fill"),
                    .init(title: "In progress", icon: "gearshape.fill"),
                    .init(title: "Complete", icon: "checkmark.circle.fill"),
                    .init(title: "Complete", icon: "checkmark.circle.fill"),
                
                ]
            )
            .padding(.horizontal, 2)
          
            // Time label at bottom left
            HStack {
                Text("03:50 AM")
                    .font(.caption2)
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding(.top, 8)
            .padding(.leading, 2)
        }
        .padding()
        .background(Color(red: 240/255, green: 246/255, blue: 255/255).ignoresSafeArea())
    }
}

 struct OrderStatusTrackerView: View {
    struct Step: Identifiable {
        let id = UUID()
        let title: String
        let icon: String
    }
    let currentStep: Int // zero-based index
    let steps: [Step]
    private let activeColor = Color(red: 0.18, green: 0.54, blue: 1.0)
    private let inactiveColor = Color.gray.opacity(0.35)
    private let bgColor = Color(red: 232/255, green: 244/255, blue: 255/255)
    private let borderColor = Color(red: 0.18, green: 0.54, blue: 1.0, opacity: 0.18)
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
          

            HStack(alignment: .center) {
                Image(systemName: "doc.on.doc.fill")
                    .foregroundColor(activeColor)
                    .font(.system(size: 15, weight: .bold))
                Text("Order #101237…")
                    .font(.system(.subheadline, design: .monospaced).weight(.semibold))
                    .foregroundColor(.black)
                Spacer()
                Button(action: {}) {
                    Text("View order")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(activeColor)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.bottom, 8)
            // Progress tracker
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 0) {
                    ForEach(steps.indices, id: \.self) { idx in
                        VStack(spacing: 4) {
                            ZStack {
                                if idx == 0 {
                                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                                        .fill(idx <= currentStep ? activeColor : inactiveColor)
                                        .frame(width: 24, height: 24)
                                    Image(systemName: steps[idx].icon)
                                        .foregroundColor(.white)
                                        .font(.system(size: 13, weight: .semibold))
                                } else {
                                    Circle()
                                        .stroke(idx <= currentStep ? activeColor : inactiveColor, lineWidth: 2)
                                        .background(Circle().fill(Color.white))
                                        .frame(width: 24, height: 24)
                                    Image(systemName: steps[idx].icon)
                                        .foregroundColor(idx <= currentStep ? activeColor : inactiveColor)
                                        .font(.system(size: 13, weight: .semibold))
                                }
                            }
                            .overlay(
                                // Draw a straight line to the next icon (if not last step)
                                GeometryReader { geo in
                                    if idx < steps.count - 1 {
                                        Rectangle()
                                            .fill(idx < currentStep ? activeColor : inactiveColor)
                                            .frame(height: 2)
                                            .frame(width: 44) // matches spacing between icons (tweak as needed for your design)
                                            .offset(x: 24, y: geo.size.height/2 - 1) // offset right from icon, vertically centered
                                    }
                                }
                            )
                            .frame(width: 24, height: 24)
                            Text(steps[idx].title)
                                .lineLimit(1)
                                .font(.caption2.weight(idx == currentStep ? .semibold : .regular))
                                .foregroundColor(idx <= currentStep ? activeColor : inactiveColor)
                                .multilineTextAlignment(.center)
                                .frame(width: steps.count > 4 ? 70 : (idx == 0 ? 72 : idx == steps.count - 1 ? 50 : 58))
                        }
                    }
                }
                .padding(.vertical, 2)
            }
        }
        .padding(16)
       
        .background(.white)
        
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(borderColor, lineWidth: 1)
        )
        .cornerRadius(14)
        .shadow(color: Color.black.opacity(0.04), radius: 3, x: 0, y: 2)
    }
}

#Preview {
    FabricRequestConfirmationView()
}
