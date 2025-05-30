//
//  BubbleImageView.swift
//  WhatAppProject
//
//  Created by Daniel Jermaine on 15/04/2025.
//



import SwiftUI

struct BubbleImageView: View {
    let item:MessageItem
    var body: some View {
        HStack{
            if item.direction == .sent {
                Spacer()
            }
            if item.direction == .sent {
                shareButton()
            }
            messageTextView()
                .overlay(
                playButton()
                )
            if item.direction == .received {
                shareButton()
                    .opacity(item.type == .video ? 1: 0)
            }
            
            if item.direction == .received {Spacer()}
        }
    }
    private func messageTextView() -> some View {
        VStack(alignment: .leading,spacing: 0) {
            Image(.stubImage0)
                .resizable()
                .scaledToFill()
                .frame(width: 220,height: 180)
                .clipShape(
                    RoundedRectangle(cornerRadius: 10,style: .continuous)
                )
                .background(
                    RoundedRectangle(cornerRadius: 10,style: .continuous)
                        .fill(Color(.systemGray5))
                    
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10,style: .continuous)
                        .stroke(Color(.systemGray5))
                    
                )
                .padding(5)
                .overlay(alignment:.bottomTrailing){
                    timeStampTextView()
                    
                }
            Text(item.text)
                .padding([.horizontal,.bottom],8)
                .frame(maxWidth:.infinity,alignment: .leading)
                .frame(width: 220)
        }
        .background(item.backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 10,style: .continuous))
        .applyTail(item.direction)
        .shadow(color:Color(.systemGray3), radius:5)
    }
    
    private func playButton() -> some View {
        Image(systemName: "play.fill")
            .padding()
            .imageScale(.large)
            .background(.thinMaterial)
            .clipShape(Circle())
    }
    private func shareButton() -> some View {
        Button {
            
        }label:{
          Image(systemName: "arrowshape.turn.up.right.fill")
                .padding(10)
                .foregroundColor(.white)
                .background(Color.gray)
                .background(.thinMaterial)
                .clipShape(Circle())
        }
    }
    private func timeStampTextView()  -> some View {
        HStack{
            Text("11:13 Am")
                .font(.system(size: 12))
            if item.direction == .sent {
                Image(.seen)
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 15,height: 15)
            }
                 
        }
        .padding(.vertical,2.5)
        .padding(.horizontal,8)
        .foregroundColor(.white)
        .foregroundStyle(.white)
        .background(Color(.systemGray3))
        .clipShape(Capsule())
        .padding(12)
    }
}

#Preview {
    ScrollView{
        BubbleImageView(item:.sentPlaceholder)
        BubbleImageView(item:.receivedPlaceholder)
    }
    .frame(maxWidth: .infinity)
    .padding(.horizontal)
    .background(Color.gray.opacity(0.3))
}
