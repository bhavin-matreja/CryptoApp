//
//  Double.swift
//  CryptoApp
//
//  Created by Bhavin Matreja on 10/05/25.
//

import Foundation

extension Double {
    
    ///  Converts a double into a currency with 2 decimal places
    ///  ```
    /// Convert 0.123456 to $0.12
    ///  ```
    private var currencyFormatter2: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        // below are defaults, if required can change
//        formatter.locale = .current
//        formatter.currencyCode = "usd"
//        formatter.currencySymbol = "$"
        return formatter
    }
    
    ///  Converts a double into a currency with 2-6 decimal places
    ///  ```
    /// Convert 1234.56 to $1,234.56
    /// Convert 12.3456 to $12.3456
    /// Convert 0.123456 to $0.123456
    ///  ```
    private var currencyFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        // below are defaults, if required can change
//        formatter.locale = .current
//        formatter.currencyCode = "usd"
//        formatter.currencySymbol = "$"
        return formatter
    }
    
    ///  Converts a double into a currency as a String with 2-6 decimal places
    ///  ```
    /// Convert 0.123456 to "$0.123456"
    ///  ```
    func asCurrencyWith2Decimals() -> String {
        let number = NSNumber(value: self)
        return currencyFormatter2.string(from: number) ?? "$0.00"
    }
    
    ///  Converts a double into a currency as a String with 2-6 decimal places
    ///  ```
    /// Convert 1234.56 to "$1,234.56"
    /// Convert 12.3456 to "$12.3456"
    /// Convert 0.123456 to "$0.123456"
    ///  ```
    func asCurrencyWith6Decimals() -> String {
        let number = NSNumber(value: self)
        return currencyFormatter.string(from: number) ?? "$0.00"
    }
    
    ///  Converts a double into a string representation
    ///  ```
    /// Convert 1.23456 to "1.23"
    ///  ```
    func asNumberString() -> String {
        return String(format: "%.2f", self)
    }
    
    ///  Converts a double into a string representation with percentage symbol
    ///  ```
    /// Convert 1.23456 to "1.23%"
    ///  ```
    func asPercentString() -> String {
        return asNumberString() + "%"
    }
}
