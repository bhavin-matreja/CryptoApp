//
//  LaunchView.swift
//  CryptoApp
//
//  Created by Bhavin Matreja on 13/05/25.
//

import SwiftUI

struct LaunchView: View {
    
    @State private var showLoadingText = false
    
    var body: some View {
        ZStack {
            Color.launch.background
                .ignoresSafeArea()
            
            Image("logo-transparent")
                .resizable()
                .frame(width: 100, height: 100)
            /*
             Want to keep the image as is, because actual launch screen it is kept exactly in the center
             */
            ZStack {
                if showLoadingText {
                    Text("Loading your portfolio...")
                        .font(.headline)
                        .foregroundColor(Color.launch.accent)
                        .fontWeight(.heavy)
                        .transition(AnyTransition.scale.animation(.easeIn))
                }
            }
            .offset(y: 70)
            .onAppear {
                showLoadingText.toggle()
            }
        }
    }
}

#Preview {
    LaunchView()
}
