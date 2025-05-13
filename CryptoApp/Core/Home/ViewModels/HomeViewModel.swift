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
    @Published var showLaunchScreen: Bool = true
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var sortOption: SortOption = .holdings
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private var cancellables = Set<AnyCancellable>()
    
    enum SortOption {
        case rank, rankReversed, holdings, holdingsRevered, price, priceRevered
    }
    
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
            .combineLatest(coinDataService.$allCoins, $sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
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
    
    private func filterAndSortCoins(text:String, coins:[CoinModel], sort: SortOption) -> [CoinModel] {
        var filteredCoins = filterCoins(text: text, coins: coins)
        sortCoinsAndReturnSameArray(sort: sort, coins: &filteredCoins)
//        let sortedCoins = sortCoins(sort: sort, coins: filteredCoins)
        return filteredCoins
    }
    
    
    private func sortCoinsAndReturnSameArray(sort: SortOption, coins: inout [CoinModel]) {
        switch sort {
        case .rank, .holdings:
            coins.sort { coin1, coin2 in
                return coin1.rank < coin2.rank
            }
            // shorter version coins.sorted(by: { $0.rank < $1.rank })
        case .rankReversed, .holdingsRevered:
            coins.sort(by: { $0.rank > $1.rank })
        case .price:
            coins.sort(by: { $0.currentPrice > $1.currentPrice })
        case .priceRevered:
            coins.sort(by: { $0.currentPrice < $1.currentPrice })
        }
    }
    
    private func sortCoins(sort: SortOption, coins: [CoinModel]) -> [CoinModel] {
        switch sort {
        case .rank, .holdings:
            return coins.sorted { coin1, coin2 in
                return coin1.rank < coin2.rank
            }
            // shorter version coins.sorted(by: { $0.rank < $1.rank })
        case .rankReversed, .holdingsRevered:
            return coins.sorted(by: { $0.rank > $1.rank })
        case .price:
            return coins.sorted(by: { $0.currentPrice > $1.currentPrice })
        case .priceRevered:
            return coins.sorted(by: { $0.currentPrice < $1.currentPrice })
        }
    }
    
    private func sortPortfolioCoinsIfNeeded (coins: [CoinModel]) -> [CoinModel] {
        // will only sort by holdings or reversedholdings if needed
        switch sortOption {
        case .holdings:
            return coins.sorted (by: { $0.currentHoldingsValue > $1.currentHoldingsValue })
        case .holdingsRevered:
            return coins.sorted(by: { $0.currentHoldingsValue < $1.currentHoldingsValue })
        default:
            return coins
        }
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.porfolioCoins.append(dev.coin)
            self.porfolioCoins.append(dev.coin)
            self.showLaunchScreen = false
        }

    }
}
