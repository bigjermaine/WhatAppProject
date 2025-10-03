//
//  FabricInstructionsView.swift
//  WhatAppProject
//
//  Created by Daniel Jermaine on 02/10/2025.
//

import SwiftUI

struct FabricInstructionsView: View {
    @State private var selectedOptions: Set<String> = ["No scented detergent", "Iron only"]
    @State private var customInstructions: String = "No scented detergent, Iron only, Please deliver before 5pm"
    @Environment(\.dismiss) var dismiss
    let options = [
        "No scented detergent",
        "Hypoallergenic fabric only",
        "Eco-friendly laundry preferred",
        "Iron only",
        "Extra starch for shirts"
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                Spacer()
            }
            .padding(.top, 2)
            // Title
            Text("Any special instructions for your fabrics?")
                .font(Font(UIFont.satoshi( weight: .regular, size: 14)))
                
            
            VStack(alignment: .leading, spacing: 20) {
                WrapView(data: options, id: \.self) { option in
                    Button(action: {
                        if selectedOptions.contains(option) {
                            selectedOptions.remove(option)
                        } else {
                            selectedOptions.insert(option)
                        }
                        updateCustomInstructions()
                    }) {
                        Text(option)
                            .font(.subheadline)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(selectedOptions.contains(option) ? Color.blue.opacity(0.15) : Color.gray.opacity(0.15))
                            .foregroundColor(selectedOptions.contains(option) ? .blue : .black)
                            .clipShape(Capsule())
                    }
                }
                .padding(.horizontal)
                
                // Textfield for extra instructions
                TextEditor(text: $customInstructions)
                    .font(Font(UIFont.satoshi( weight: .regular, size: 14)))
                    .frame(height: 100)
                    .padding(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .padding(.horizontal)
                
                // Continue button
                Button(action: {
                    print("Final Instructions: \(customInstructions)")
                }) {
                    Text("Continue")
                        .font(Font(UIFont.satoshi( weight: .regular, size: 14)))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.top)
            .background(Color.white)
        }
        .padding()
        .background(Color(red: 240/255, green: 246/255, blue: 255/255))
    }
    
    private func updateCustomInstructions() {
        customInstructions = selectedOptions.joined(separator: ", ")
    }
}

// Helper for wrapping tags in multiple lines
struct WrapView<Data: RandomAccessCollection, ID: Hashable, Content: View>: View {
    let data: Data
    let id: KeyPath<Data.Element, ID>
    let content: (Data.Element) -> Content
    
    init(data: Data, id: KeyPath<Data.Element, ID>, @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.id = id
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometry in
            self.generateContent(in: geometry)
        }
        .frame(height: calculateHeight())
    }
    
    private func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        
        return VStack{
            ZStack(alignment: .topLeading) {
                ForEach(data, id: id) { item in
                    self.content(item)
                        .font(Font(UIFont.satoshi( weight: .regular, size: 14)))
                        .padding([.horizontal, .vertical], 4)
                        .alignmentGuide(.leading) { d in
                            if (abs(width - d.width) > g.size.width) {
                                width = 0
                                height -= d.height
                            }
                            let result = width
                            if item[keyPath: id] == data.last?[keyPath: id] {
                                width = 0 // last item
                            } else {
                                width -= d.width
                            }
                            return result
                        }
                        .alignmentGuide(.top) { _ in
                            let result = height
                            if item[keyPath: id] == data.last?[keyPath: id] {
                                height = 0 // last item
                            }
                            return result
                        }
                }
            }
        }
    }
    
    private func calculateHeight() -> CGFloat {
        // Default estimated height
        return CGFloat(data.count * 40)
    }
}

struct FabricInstructionsView_Previews: PreviewProvider {
    static var previews: some View {
        FabricInstructionsView()
    }
}
