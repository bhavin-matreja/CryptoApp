//
//  HomeStatsView.swift
//  CryptoApp
//
//  Created by Bhavin Matreja on 11/05/25.
//

import SwiftUI

struct HomeStatsView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @Binding var showPortfolio: Bool
        
        var body: some View {
            HStack {
                ForEach(vm.statistics) { stat in
                    StatisticView(stat: stat)
                        .frame(width: UIScreen.main.bounds.width / 3)
                }
            }
            .frame(width: UIScreen.main.bounds.width,
                   alignment: showPortfolio ? .trailing : .leading
            )
        }
}
