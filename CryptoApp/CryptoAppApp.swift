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
    
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                NavigationStack {
                    HomeView()
                        .navigationBarHidden(true)
                }
                .environmentObject(vm)
                
                // launch view will appear on top
                ZStack {
                    if vm.showLaunchScreen {
                        LaunchView()
                    }
                }
                .zIndex(2.0)
            }
        }
    }
    
}
