//
//  DetailViewModel.swift
//  CryptoApp
//
//  Created by Bhavin Matreja on 13/05/25.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
    
    private let coinDetailService: CoinDetailDataService
    
    @Published var coinDetails: CoinDetailModel? = nil
    
    private var cancellable = Set<AnyCancellable>()
    
    init(coin: CoinModel) {
        self.coinDetailService = CoinDetailDataService(coin: coin)
        self.addSubscribers()
    }
    
    private func addSubscribers() {
        coinDetailService.$coinDetails
            .sink { [weak self] (returnedCoinDetails) in
                print("RECEIVED COIN DETAILS")
                print(returnedCoinDetails)
                self?.coinDetails = returnedCoinDetails
            }
            .store(in: &cancellable)
    }
}
