//
//  CoinDataService.swift
//  CryptoApp
//
//  Created by Bhavin Matreja on 10/05/25.
//

import Foundation
import Combine

class CoinDataService {
    @Published var allCoins: [CoinModel] = []
    
    var coinSubscription: AnyCancellable?
    
    init() {
        getCoins()
    }
    
    private func getCoins() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else {
            return
        }
        
        coinSubscription = URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap { (output) -> Data in
                guard
                    let response = output.response as? HTTPURLResponse,
                    response.statusCode >= 200 && response.statusCode < 300 else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .receive(on: DispatchQueue.main)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink { (completion) in
                switch completion {
                case .finished:
                    print("finished")
                    break
                case .failure(let error):
                    print("Error \(error)")
                }
            } receiveValue: { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
                // Publisher basically assumes that this url will send data over time, so when we call it stays listening in case we have more published values in the future. But we know its just a get request, so it will hit once only.
                self?.coinSubscription?.cancel()
            }

                
                
    }
}
