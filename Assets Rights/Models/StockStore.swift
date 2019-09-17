//
//  StocksStore.swift
//  Assets Rights
//
//  Created by Gerson Carlos on 07/07/19.
//  Copyright © 2019 Gerson Carlos. All rights reserved.
//

import SwiftUI
import Combine

class StockStore : ObservableObject, Identifiable {
    @Published var stocks: [Stock]
    
    /// Initialize stocks array trying to get data from UserDefault. If not able to get from there, defaults to empty array.
    init() {
        let rawData = UserDefaults.standard.data(forKey: "stocks")
        
        // nothing saved yet
        if rawData == nil {
            self.stocks = []
            return
        }
        
        // try to decode and save
        do {
            try self.stocks = PropertyListDecoder().decode([Stock].self, from: rawData!)
        } catch {
            print("Error when decoding stock data")
            self.stocks = []
        }
    }

    /// Adds a stock to the stock array and persists it to UserDefaults.
    ///
    /// - Parameters:
    ///   - newStock:The new Stock object to be added. It should contain a movement
    func addStock(_ newStock: Stock) {
        for stock in self.stocks {
            if stock.ticker == newStock.ticker {
                let idx = self.stocks.firstIndex(of: stock)!
                self.stocks[idx].movement.append(newStock.movement[0])
                return
            }
        }
        
        self.stocks.append(newStock)
        
        do {
            let data = try PropertyListEncoder().encode(self.stocks)
            UserDefaults.standard.set(data, forKey: "stocks")
        } catch {
            print("Could not encode stocks")
        }
    }
    
    /// Clears all information of the current user, removing data from UserDefault and from memory as well.
    func clearAll() {
        UserDefaults.standard.removeObject(forKey: "stocks")
        self.stocks = []
    }
}
