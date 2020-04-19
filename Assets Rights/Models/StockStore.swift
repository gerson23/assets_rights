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
                self.updateToDefaults()
                return
            }
        }
        
        self.stocks.append(newStock)
        
        self.updateToDefaults()
    }
    
    /// Removes a given stock at an index and persists to database
    ///
    /// - Parameters:
    ///   - index: Index of the stock to be removed from the application.
    ///   Does nothing if negative.
    func removeStock(at index: Int) {
        if(index < 0) { return }
        
        self.stocks.remove(at: index)
        self.updateToDefaults()
    }
    
    /// Wrapper to remove a given Stock object
    /// - Parameters:
    ///   - stock: Stock object to be removed
    func removeStock(stock: Stock) {
        let index = self.stocks.firstIndex(of: stock) ?? -1
        self.removeStock(at: index)
    }
    
    func removeAction(action: Action, from stock: Stock) {
        if let idxStock = self.stocks.firstIndex(of: stock) {
            if let idxAction = self.stocks[idxStock].movement.firstIndex(of: action) {
                print(idxAction)
                print(idxStock)
                self.stocks[idxStock].movement.remove(at: idxAction)
                self.updateToDefaults()
            }
        }
    }
    
    /// Clears all information of the current user, removing data from UserDefault and from memory as well.
    func clearAll() {
        UserDefaults.standard.removeObject(forKey: "stocks")
        self.stocks = []
    }
    
    /// Private function to update the current state to the DB (UserDefaults currently)
    private func updateToDefaults() {
        do {
            let data = try PropertyListEncoder().encode(self.stocks)
            UserDefaults.standard.set(data, forKey: "stocks")
        } catch {
            print("Could not encode stocks")
        }
    }
}
