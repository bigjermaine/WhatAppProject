//
//  ApplicationReason.swift
//  WhatAppProject
//
//  Created by Daniel Jermaine on 28/05/2025.
//


import SwiftUI

enum ApplicationReason: String, CaseIterable, Identifiable {
    case expiredPassport = "Expired Passport"
    case exhaustedPages = "Exhausted Pages"
    case lostPassport = "Lost Passport"
    var id: String { self.rawValue }
}

struct ApplicationReasonView: View {
    @State private var selectedReason: ApplicationReason = .expiredPassport
    @State private var passportNumber = ""
    @State private var dateOfBirth = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 40) {
                VStack(alignment: .leading){
                    Text("Why are you applying?")
                        .font(.headline)
                    
                    Text("Please select from the options below that best describe your application reason")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    HStack {
                        ForEach(ApplicationReason.allCases) { reason in
                            Button(action: {
                                selectedReason = reason
                            }) {
                                HStack {
                                    Image(systemName: selectedReason == reason ? "largecircle.fill.circle" : "circle")
                                        .foregroundColor(.accentColor)
                                    Text(reason.rawValue)
                                        .font(.subheadline)
                                        .foregroundColor(.black)
                                }
                                .padding(8)
                            }
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 3)
                .padding(.vertical)
                
                VStack {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(selectedReason.rawValue)
                            .font(.headline)
                        
                        Text("Kindly provide the necessary information relevant to the selected application reason")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        VStack(alignment: .leading,spacing: 10){
                            Text("Current Passport No")
                                .font(.subheadline)
                              
                            TextFieldWithBottomLine(placeholder: "Current Passport No", text:  $passportNumber)
                        }
                        VStack(alignment: .leading,spacing: 10){
                            Text("Date of Birth (YYYY-MM-DD)")
                                .font(.subheadline)
                            
                            TextFieldWithBottomLine(placeholder: "Date of Birth (YYYY-MM-DD)", text:  $dateOfBirth)
                        }
                      
                       
                        
                    }
                    
    
                    Button(action: {
                        // Check eligibility action
                    }) {
                        Text("CHECK ELIGIBILITY")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .cornerRadius(8)
                    }
                    
                    Spacer()
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 3)
                .padding(.vertical)
            }
            .padding()
        }
    }
}

struct ApplicationReasonView_Previews: PreviewProvider {
    static var previews: some View {
        ApplicationReasonView()
    }
}


// Reusable form field component
struct FormField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    let required: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.subheadline)
                
                if required {
                    Text("*")
                        .foregroundColor(.red)
                }
            }
            
            TextField(placeholder, text: $text)
                .padding(12)
                .background(Color(UIColor.systemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
        }
    }
}


struct TextFieldWithBottomLine: View {
    @Binding var text: String
    @State private var isSecure: Bool = true
    private var placeholder = ""
    private var isPassword: Bool = false
    private var isDisabled: Bool = false
    private var isPlaceholderAnimationActive: Bool
    private var hidePlaceholderWhenTyping: Bool
    private let padding: CGFloat
    private var keyboardType: UIKeyboardType = .default
    @FocusState private var isFocused: Bool
    
    init(placeholder: String,
         text: Binding<String>,
         isPassword: Bool = false,
         isDisabled: Bool = false,
         isPlaceholderAnimationActive: Bool = true,
         hidePlaceholderWhenTyping: Bool = false,
         padding: CGFloat = 10.0,
         keyboardType: UIKeyboardType = .default) {
        self.placeholder = placeholder
        self._text = text
        self.isPassword = isPassword
        self.isDisabled = isDisabled
        self.padding = padding
        self.keyboardType = keyboardType
        self.isPlaceholderAnimationActive = isPlaceholderAnimationActive
        self.hidePlaceholderWhenTyping = hidePlaceholderWhenTyping
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .leading) {
                    Text(placeholder)
                        .font(.callout.weight(.regular))
                        .foregroundStyle(.gray)
                        .if(isPlaceholderAnimationActive, content: { view in
                                view.offset(y: text.isEmpty ? 0 : -20)
                        })
                        .scaleEffect(text.isEmpty ? 1 : 0.8, anchor: .leading)
                        .if(hidePlaceholderWhenTyping) { view in
                            view.opacity(text.isEmpty ? 1 : 0)
                        }
                        .if(isPlaceholderAnimationActive) { view in
                            view.padding(.bottom, text.isEmpty ? 0 : 20)
                        }
                
                VStack(spacing: 3) {
                    HStack {
                        if isPassword && isSecure {
                            SecureField("", text: $text)
                                .disableAutocorrection(true)
                                .autocapitalization(.none)
                                .textInputAutocapitalization(.never)
                                .keyboardType(keyboardType)
                                .focused($isFocused)
                                .submitLabel(.next)
                                .tint(.black)
                        } else {
                            TextField("", text: $text)
                                .disabled(isDisabled)
                                .disableAutocorrection(true)
                                .autocapitalization(.none)
                                .textInputAutocapitalization(.never)
                                .keyboardType(keyboardType)
                                .focused($isFocused)
                                .submitLabel(.next)
                                .foregroundStyle(isDisabled ? .gray : .black)
                                .tint(.black)
                        }
                        if isPassword {
                            Button(action: {
                                isSecure.toggle()
                            }) {
                                Image(systemName: isSecure ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .foregroundColor(.black)
                    
                    HorizontalLine(color: .gray)
                    
                }
            }
        }
        .padding(.bottom, padding)
    }
}



struct HorizontalLine: View {
    private var color: Color? = nil
    private var height: CGFloat = 1.0
    
    init(color: Color, height: CGFloat = 1.0) {
        self.color = color
        self.height = height
    }
    
    var body: some View {
        HorizontalLineShape()
            .fill(self.color!)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: height, maxHeight: height)
    }
}


struct HorizontalLineShape: Shape {
    
    func path(in rect: CGRect) -> Path {

        let fill = CGRect(x: 0, y: 0, width: rect.size.width, height: rect.size.height)
        var path = Path()
        path.addRoundedRect(in: fill, cornerSize: CGSize(width: 2, height: 2))
        
        return path
    }
}

