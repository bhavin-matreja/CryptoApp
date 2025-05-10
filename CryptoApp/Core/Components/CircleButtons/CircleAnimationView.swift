//
//  CircleAnimationView.swift
//  CryptoApp
//
//  Created by Bhavin Matreja on 10/05/25.
//

import SwiftUI

struct CircleAnimationView: View {
    
    @Binding var animate: Bool
    
    var body: some View {
        
        Circle()
               .stroke(lineWidth: 5.0)
               .scale(animate ? 1.0 : 0.0)
               .opacity(animate ? 0.0 : 1.0)
               .animation(animate ? .easeOut(duration: 0.5) : .none, value: animate)
                   
                   
//        Circle()
//            .stroke(lineWidth: 5.0)
//            .scale(animate ? 1.0 : 0.0)
//            .opacity(animate ? 0.0 : 1.0)
//            .animation(animate ? Animation.easeOut(duration: 10) : .none)
//            .onAppear {
//                animate.toggle()
//            }
    }
}

#Preview {
    CircleAnimationView(animate: .constant(true))
        .foregroundColor(.red)
        .frame(width: 100, height: 100)
}
