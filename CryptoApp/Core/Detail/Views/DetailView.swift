//
//  DetailView.swift
//  CryptoApp
//
//  Created by Bhavin Matreja on 12/05/25.
//

import SwiftUI

struct DetailView: View {
    
    @StateObject var vm: DetailViewModel
    
    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
        print("Initializing Detail view for \(coin.name)")
    }
    
    var body: some View {
        Text("Hello")
    }
}

#Preview {
    DetailView(coin: dev.coin)
}
