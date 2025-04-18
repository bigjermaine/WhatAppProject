//
//  BubbleModifier.swift
//  WhatAppProject
//
//  Created by Daniel Jermaine on 15/04/2025.
//


import SwiftUI

private struct BubbleModifier:ViewModifier {
    var direction:MessageDirection
    
    func body(content:Content) -> some View {
        content.overlay(alignment: direction == .received ? .bottomLeading : . bottomTrailing) {
            BubbleTailView(direction: direction)
        }
    }
    
    var backgroundColor:Color {
        return direction  == .sent ? .bubbleGreen : .bubbleWhite
        
    }
}


extension View {
    func  applyTail(_ direction:MessageDirection) -> some View {
        self.modifier(BubbleModifier(direction:direction))
    }
}
