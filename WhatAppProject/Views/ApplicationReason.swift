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
    var reason: String {
        switch self {
        case .expiredPassport:
           return  "Expired"
        case .exhaustedPages:
            return  "Exhausted"
        case .lostPassport:
            return  "Lost"
        }
    }
    var id: String { self.rawValue }
}

struct ApplicationReasonView: View {
    @State private var selectedReason: ApplicationReason = .expiredPassport
    @State private var passportNumber = ""
    @State private var dateOfBirth = ""
    @State private var availablePassport:Bool =  false
    @State private var showDatePicker: Bool = false
    @State private var selectedDate: Date = Date()
    @StateObject private var viewModel: StepViewModel = .init()
      
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
                                viewModel.selectedReason = reason
                            }) {
                                HStack {
                                    Image(systemName: viewModel.selectedReason == reason ? "largecircle.fill.circle" : "circle")
                                        .foregroundColor(.accentColor)
                                    Text(reason.rawValue)
                                        .font(.subheadline)
                                        .foregroundColor(.black)
                                }
                                .padding(8)
                            }
                        }
                    }
                    if  viewModel.selectedReason  == .lostPassport {
                        HStack {
                            Image(systemName: availablePassport == true ? "checkmark.square.fill" : "square")
                                .foregroundColor(availablePassport == true ? .green : .gray)
                            Text("If you do not have a profile, please enter your ticket number.")
                                .font(.subheadline)
                        }
                        .padding(.horizontal)
                        .onTapGesture {
                            availablePassport.toggle()
                            
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
                        
                        switch  viewModel.selectedReason {
                        case.exhaustedPages:
                            currentPassport
                        case.expiredPassport:
                            currentPassport
                        case.lostPassport:
                            if availablePassport {
                                LostPassport
                            }else {
                                currentPassport
                            }
                            
                        }
                        
                    }
                    
                    Button(action: {
                        if  viewModel.selectedReason == .lostPassport {
                            
                        }else {
                            viewModel.checkEligibility()
                        }
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
                .sheet(isPresented: $showDatePicker) {
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                showDatePicker = false
                            }) {
                                Text("ee")
                                    .fontWeight(.bold)
                            }
                            .padding()
                        }
                        
                        DatePicker(
                            "Select Date of Birth",
                            selection: $selectedDate,
                            displayedComponents: .date
                        )
                        .datePickerStyle(WheelDatePickerStyle())
                        .labelsHidden()
                        .padding()
                        .onChange(of: selectedDate) { newValue in
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy-MM-dd"
                            dateOfBirth = formatter.string(from: newValue)
                            viewModel.birthDate =  formatter.string(from: newValue)
                        }
                        
                        Spacer()
                    }
                    .padding()
                }
            }
        }
    }
}

struct ApplicationReasonView_Previews: PreviewProvider {
    static var previews: some View {
        ApplicationReasonView()
    }
}

extension ApplicationReasonView {
    var currentPassport:some View {
        VStack(alignment: .leading){
            VStack(alignment: .leading,spacing: 10){
                TextFieldWithBottomLine(placeholder: "Current Passport No", text:  $viewModel.docNo)
            }
            VStack(alignment: .leading,spacing: 10){
                TextFieldWithBottomLine(
                    placeholder: "Date of Birth (YYYY-MM-DD)",
                    text: Binding(
                        get: { dateOfBirth },
                        set: { _ in
                            
                            
                        }
                    )
                )
                .disabled(true)
                .onTapGesture {
                    showDatePicker = true
                }
                
            }
        }
    }
    
    var LostPassport:some View {
        VStack(alignment: .leading){
            VStack(alignment: .leading,spacing: 10){
                Text("Lastname")
                    .font(.subheadline)
                
                TextFieldWithBottomLine(placeholder: "Lastname", text:  $viewModel.docNo)
            }
            VStack(alignment: .leading,spacing: 10){
              
                TextFieldWithBottomLine(
                    placeholder: "Date of Birth (YYYY-MM-DD)",
                    text: Binding(
                        get: { dateOfBirth },
                        set: { _ in
                         
                        } // disables manual typing
                    )
                )
                .disabled(true)
                .onTapGesture {
                    showDatePicker = true
                }
                
            }
            }
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

