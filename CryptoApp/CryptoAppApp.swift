//
//  CryptoAppApp.swift
//  CryptoApp
//
//  Created by Bhavin Matreja on 10/05/25.
//

import SwiftUI
import SwiftData

@main
struct CryptoAppApp: App {
    
    @StateObject private var vm = HomeViewModel()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView()
                    .navigationBarHidden(true)
            }
            .environmentObject(vm)
        }
    }
}
