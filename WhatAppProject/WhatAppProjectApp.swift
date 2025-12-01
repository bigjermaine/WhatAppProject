//
//  WhatAppProjectApp.swift
//  WhatAppProject
//
//  Created by Daniel Jermaine on 15/04/2025.
//

import SwiftUI
import FirebaseCore
import FirebaseCrashlytics

@main
struct WhatAppProjectApp: App {
    init() {
        FirebaseApp.configure()
        // Initialize Crashlytics
        Crashlytics.crashlytics().log("App started")
        // You can set user IDs, custom keys, and more here.
        // Example: Crashlytics.crashlytics().setUserID("user123")
    }
    var body: some Scene {
        WindowGroup {
            NavigationStack{
              //  ContentView1()
            }
        }
    }
}
