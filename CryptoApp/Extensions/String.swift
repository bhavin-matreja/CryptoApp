//
//  String.swift
//  CryptoApp
//
//  Created by Bhavin Matreja on 13/05/25.
//

import Foundation

extension String {
    
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
