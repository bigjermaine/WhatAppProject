//
//  TextInputArea.swift
//  WhatAppProject
//
//  Created by Daniel Jermaine on 15/04/2025.
//



import SwiftUI


struct TextInputArea: View {
    @Binding var text: String
    var sendButtonIsEnabled: Bool
    let actionHandler: (_ action:UserAction) -> Void
    var body: some View {
        HStack(alignment: .bottom, spacing: 5) {
            imagePickerButton()
            audioRecordedButton()
            messageTextfield()
            sendMessageButton()
        }
        .padding()
        .background(Color("WhatsAppWhite")) // Assuming you have this color defined
    }
    
    private func imagePickerButton() -> some View {
        Button {
            actionHandler(.presentPhotoPicker)
        } label: {
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 22))
                .foregroundColor(.gray)
        }
    }
    
    private func sendMessageButton() -> some View {
        Button {
            actionHandler(.sendMessage)
        } label: {
            Image(systemName: "arrow.up")
                .fontWeight(.heavy)
                .foregroundColor(.white)
                .padding(8)
                .background(sendButtonIsEnabled ? Color.gray : Color.blue)
                .clipShape(Circle())
        }
        .disabled(sendButtonIsEnabled)
    }
    
    private func audioRecordedButton() -> some View {
        Button {
          
        } label: {
            Image(systemName: "mic.fill")
                .font(.system(size: 18, weight: .heavy))
                .foregroundColor(.white)
                .padding(8)
                .background(Color.blue)
                .clipShape(Circle())
                .padding(.horizontal, 3)
                
        }
        .disabled(sendButtonIsEnabled)
    }
    
    private func messageTextfield() -> some View {
        TextField("Message...", text: $text, axis: .vertical)
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemGray6))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color(.systemGray5), lineWidth: 1)
            )
    }
}
extension TextInputArea {
    enum UserAction  {
        case presentPhotoPicker
        case sendMessage
    }
}
struct TextInputArea_Previews: PreviewProvider {
    static var previews: some View {
        TextInputArea(text: .constant("Type your message here"), sendButtonIsEnabled: true, actionHandler: {action in ()})
            .previewLayout(.sizeThatFits)
    }
}
