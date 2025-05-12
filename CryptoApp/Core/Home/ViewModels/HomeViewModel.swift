//
//  HomeViewModel.swift
//  CryptoApp
//
//  Created by Bhavin Matreja on 10/05/25.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var statistics: [StatisticModel] = []
    
    @Published var allCoins: [CoinModel] = []
    @Published var porfolioCoins: [CoinModel] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
        getPortfolioCoins()
    }
    
    func addSubscribers() {
        
        // below search subcriber is already subscribed to coins, so removing this
        /*
        dataService.$allCoins
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellable)
         */
        
        $searchText
            .combineLatest(coinDataService.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        // updates market data
        marketDataService.$marketData
            .combineLatest($porfolioCoins)
            .map(mapGlobalMarketData)
            .sink { [weak self] (returnedStats) in
                self?.statistics = returnedStats
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    func reloadData() {
        isLoading = false
        coinDataService.getCoins()
        marketDataService.getData()
        HapticManager.notification(type: .success) // small vibration on device when we reload
    }
    
    private func filterCoins(text:String, coins:[CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else {
            return coins
        }
        let lowercasedText = text.lowercased()
        return coins.filter { coins in
            coins.name.lowercased().contains(lowercasedText) ||
            coins.symbol.lowercased().contains(lowercasedText) ||
            coins.id.lowercased().contains(lowercasedText)
        }
    }
    
    private func mapGlobalMarketData(marketDataModel: MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatisticModel] {
        var stats: [StatisticModel] = []
        
        guard let data = marketDataModel else { return stats }
        
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange:
        data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        
        let portfolioValue = portfolioCoins
            .map { CoinModel -> Double in
                    return CoinModel.currentHoldingsValue }
            .reduce(0, +) // returns sum of all [Doubles]
        
    
        let previousValue =
                   portfolioCoins
                       .map { (coin) -> Double in
                           let currentValue = coin.currentHoldingsValue
                           let percentChange = coin.priceChangePercentage24H ?? 0 / 100
                           let previousValue = currentValue / (1 + percentChange)
                           return previousValue
                       }
                       .reduce(0, +)

        let percentageChange = ((portfolioValue - previousValue) / previousValue)
        
        let portfolio = StatisticModel(title: "Portfolio Value", value: portfolioValue.asCurrencyWith2Decimals(), percentageChange: 0)
               
        stats.append(contentsOf: [
            marketCap, volume, btcDominance, portfolio
        ])
        return stats
    }
    
    func getPortfolioCoins() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.porfolioCoins.append(dev.coin)
            self.porfolioCoins.append(dev.coin)
        }

    }
}
