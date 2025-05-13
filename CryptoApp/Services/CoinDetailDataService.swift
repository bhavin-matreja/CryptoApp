//
//  CoinDetailDataService.swift
//  CryptoApp
//
//  Created by Bhavin Matreja on 13/05/25.
//

import Foundation
import Combine

class CoinDetailDataService {
    @Published var coinDetails: CoinDetailModel? = nil
    
    var coinDetailSubscription: AnyCancellable?
    let coin: CoinModel
    
    init(coin: CoinModel) {
        self.coin = coin
        getCoinDetails()
    }
    
    func getCoinDetails() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else { return }

               
        
        coinDetailSubscription = NetworkingManager.download(url: url)
            .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedCoinsDetails) in
                self?.coinDetails = returnedCoinsDetails
                // Publisher basically assumes that this url will send data over time, so when we call it stays listening in case we have more published values in the future. But we know its just a get request, so it will hit once only.
                self?.coinDetailSubscription?.cancel()
            })
    }
}
