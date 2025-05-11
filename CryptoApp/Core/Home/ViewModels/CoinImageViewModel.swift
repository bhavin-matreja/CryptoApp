//
//  CoinImageViewModel.swift
//  CryptoApp
//
//  Created by Bhavin Matreja on 11/05/25.
//

import Foundation
import SwiftUI
import Combine

class CoinImageViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var isLoading = true
    
    private let coinModel: CoinModel
    private let dataService: CoinImageService
    private var cancellables = Set<AnyCancellable>()
    
    init (coin: CoinModel) {
        self.coinModel = coin
        self.dataService = CoinImageService(coin: coin)
        addSubcribers()
    }
    
    private func addSubcribers() {
        dataService.$image
            .sink { [weak self] _ in
                self?.isLoading = false
            } receiveValue: { [weak self] (returnedImage) in
                self?.image = returnedImage
            }
            .store(in: &cancellables)

    }
}
