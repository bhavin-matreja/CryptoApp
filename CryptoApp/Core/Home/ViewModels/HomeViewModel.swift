//
//  HomeViewModel.swift
//  CryptoApp
//
//  Created by Bhavin Matreja on 10/05/25.
//

import Foundation

class HomeViewModel: ObservableObject {
    
    @Published var allCoins: [CoinModel] = []
    @Published var porfolioCoins: [CoinModel] = []
    
    init() {
        getAllCoins()
        getPortfolioCoins()
    }
    
    func getAllCoins() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.allCoins.append(dev.coin)
            self.allCoins.append(dev.coin)
        }

    } 
    
    func getPortfolioCoins() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.porfolioCoins.append(dev.coin)
            self.porfolioCoins.append(dev.coin)
        }

    }
}
