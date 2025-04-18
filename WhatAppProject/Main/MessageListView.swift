//
//  MessageListView.swift
//  WhatAppProject
//
//  Created by Daniel Jermaine on 15/04/2025.
//
import SwiftUI
import UIKit

struct MessageListView: UIViewControllerRepresentable {
    let viewModel: ChatViewModel
    
    func makeUIViewController(context: Context) -> MessageListControllerViewController {
        MessageListControllerViewController(viewModel: viewModel)
    }
    
    func updateUIViewController(_ uiViewController: MessageListControllerViewController, context: Context) {
        // Update the view controller if needed
        // For example, if your viewModel is Observable:
        // uiViewController.viewModel = viewModel
    }
}

#Preview {
    MessageListView(viewModel:chatPreViewwModel)
}
