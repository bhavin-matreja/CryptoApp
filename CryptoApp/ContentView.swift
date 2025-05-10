//
//  ContentView.swift
//  CryptoApp
//
//  Created by Bhavin Matreja on 10/05/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            
            VStack {
                Text("Accent color")
                    .foregroundColor(Color.theme.accent)
                
                Text("Secondary color")
                    .foregroundColor(Color.theme.secondaryText)
                
                Text("Red")
                    .foregroundColor(Color.theme.red)
                
                Text("green")
                    .foregroundColor(Color.theme.green)
            }
        }
    }
}





#Preview {
    ContentView()
}
