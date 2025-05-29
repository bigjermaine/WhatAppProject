//
//  StepView.swift
//  WhatAppProject
//  Created by Daniel Jermaine on 28/05/2025.

import SwiftUI

struct StepView: View {
    var body: some View {
        ReusableAccountView(content: {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }, navigationBarTitle: "STEP Enrollment Guide")
    }
}

#Preview {
    StepView()
}

struct ReusableAccountView<Content: View, OffsetView: View, TopImageView: View>: View {
    @State var content: () -> Content
    @State var offsetImageAndText: () -> OffsetView
    @State var topImageView: () -> TopImageView
    let imageString: String
    let navigationBarTitle: String
    let navigationBarTitleTextColor: Color
    let bottomViewOffset: CGFloat
    let topViewOffset: CGFloat
    let ignoreSafeAreaBottom: Bool
    
    init(
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder offsetImageAndText: @escaping () -> OffsetView = { EmptyView() },
        @ViewBuilder topImageView: @escaping () -> TopImageView = { EmptyView() },
        navigationBarTitle: String,
        navigationBarTitleTextColor: Color = .black,
        imageString: String = "light_green_shade2",
        bottomViewOffset: CGFloat = 0.2,
        topViewOffset: CGFloat = 0.18,
        ignoreSafeAreaBottom: Bool = false
    ) {
        self.content = content
        self.offsetImageAndText = offsetImageAndText
        self.topImageView = topImageView
        self.navigationBarTitle = navigationBarTitle
        self.navigationBarTitleTextColor = navigationBarTitleTextColor
        self.imageString = imageString
        self.bottomViewOffset = bottomViewOffset
        self.topViewOffset = topViewOffset
        self.ignoreSafeAreaBottom = ignoreSafeAreaBottom
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                VStack {
                    Image(imageString)
                        .resizable()
                        .ignoresSafeArea()
                        .aspectRatio(contentMode: .fit)
                    Spacer()
                }
                topImageView()
                    .frame(maxWidth: .infinity, maxHeight: geo.size.height * topViewOffset)
            }
            .overlay {
                ZStack(alignment: .top) {
                    UnevenRoundedRectangle(cornerRadii: .init(topLeading: 35, topTrailing: 35))
                        .fill(.white)
                    content()
                        .padding(.top)
                    offsetImageAndText()
                }
                .padding(.top, geo.size.height * bottomViewOffset)
            }
            .onTapGesture {
                
            }
            .navigationBarTitle(navigationBarTitle)
            .navigationBarTitleDisplayMode(.inline)
            .if(ignoreSafeAreaBottom, content: { view in
                view.ignoresSafeArea(edges: .bottom)
            })
        }
    }
}


extension View {
    
    /// Allows using modifiers conditionally
    @ViewBuilder
    func `if`<Content: View>(_ conditional: Bool, content: (Self) -> Content) -> some View {
        if conditional {
            content(self)
        } else {
            self
        }
    }
    
    @available(iOS 14, *)
    func navigationBarTitleTextColor(_ color: Color) -> some View {
        let uiColor = UIColor(color)
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: uiColor ]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: uiColor ]
        return self
    }
}
