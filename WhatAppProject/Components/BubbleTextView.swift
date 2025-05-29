//
//  BubbleTextView.swift
//  WhatAppProject
//
//  Created by Daniel Jermaine on 15/04/2025.
//



import SwiftUI

struct BubbleTextView: View {
    let item:MessageItem
    let showDateHeader: Bool
    let dateHeaderText: String
    var body: some View {
        VStack{
            if showDateHeader {
                HStack {
                    Spacer()
                    Text(dateHeaderText)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.vertical, 6)
                        .frame(maxWidth: .infinity)
                    Spacer()
                }
             }
            VStack(alignment: .leading, spacing:3){
                Text(item.text)
                    .padding(10)
                    .background(item.backgroundColor)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
                    .applyTail(item.direction)
                timeStampTextView()
            }
            .shadow(color:Color(.systemGray3), radius:5)
            .frame(maxWidth: .infinity,alignment: item.alignment)
            .padding(.leading,item.direction == .received ? 5 : 100)
            .padding(.trailing,item.direction == .received ? 100 : 5)
        }
        .onAppear{
            print(showDateHeader)
        }
        
    }
    private func timeStampTextView() -> some View {
        HStack{
            Text(item.date.formattedTime)
                .font(.system(size: 13))
                .foregroundStyle(.gray)
            if item.direction == .sent {
                Image(.seen)
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 15,height: 15)
                    .foregroundStyle(Color(.systemRed ))
            }
        }
    }
}


#Preview {
    ScrollView{
        BubbleTextView(item: .receivedPlaceholder, showDateHeader: true, dateHeaderText: "jermaine")
       
    }
    .frame(maxWidth: .infinity)
    .background(Color.gray.opacity(0.3))
}
