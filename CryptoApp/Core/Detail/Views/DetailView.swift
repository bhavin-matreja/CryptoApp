//
//  DetailView.swift
//  CryptoApp
//
//  Created by Bhavin Matreja on 12/05/25.
//

import SwiftUI

struct DetailView: View {
    
    let coin: CoinModel
    init(coin: CoinModel) {
        self.coin = coin
        print("Initializing Detail view for \(coin.name)")
    }
    
    var body: some View {
        Text(coin.name)
    }
}

#Preview {
    DetailView(coin: dev.coin)
}
