//
//  HomeViewModel.swift
//  CryptoApp
//
//  Created by Bhavin Matreja on 10/05/25.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var allCoins: [CoinModel] = []
    @Published var porfolioCoins: [CoinModel] = []
    @Published var searchText: String = ""
    
    private let dataService = CoinDataService()
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
        getPortfolioCoins()
    }
    
    func addSubscribers() {
        dataService.$allCoins
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellable)
    }
    
    func getPortfolioCoins() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.porfolioCoins.append(dev.coin)
            self.porfolioCoins.append(dev.coin)
        }

    }
}
