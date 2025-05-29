//
//  PaymentWebView.swift
//  WhatAppProject
//
//  Created by Daniel Jermaine on 06/05/2025.
//


import SwiftUI
import WebKit

struct PaymentWebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.load(URLRequest(url: url))
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
}

struct PaymentWebViewContainer: View {
    @Binding var isPresented: Bool
    let urlString: String
    
    var body: some View {
        NavigationStack {
            if let url = URL(string: urlString) {
                PaymentWebView(url: url)
                    .navigationTitle("Complete Payment")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Done") {
                                isPresented = false
                            }
                        }
                    }
            } else {
                Text("Invalid payment URL")
                    .navigationTitle("Error")
            }
        }
    }
}