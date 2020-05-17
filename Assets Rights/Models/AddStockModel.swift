//
//  AddStockModel.swift
//  Assets Rights
//
//  Created by Gerson Carlos on 16/05/20.
//  Copyright © 2020 Gerson Carlos. All rights reserved.
//

import SwiftUI
import Combine

class AddStockModel: ObservableObject {
    @Published var stock = Stock() {
        didSet {
            tickerChecker()
        }
    }
    @Published var action = Action()
    @Published var fields = ActionField()
    var company: Company?
    var paper: Paper?
    
    // Needs to set later as it is an environment object
    var stockStore: StockStore?
    
    // Validation state
    var errorTicker = true
    var disabledAdd = true
    
    func setStore(_ ss: StockStore) {
        self.stockStore = ss
    }
    
    /// Convert entered text to uppercase and check its validity
    func tickerChecker() {
        self.stock.ticker = self.stock.ticker.uppercased()
        
        let result = self.stock.ticker.range(of: patternTicker, options: .regularExpression)
        if result?.lowerBound == nil || result?.upperBound == nil {
          self.errorTicker = true
          self.disabledAdd = true
        }
        else {
            
            let type = self.stockStore?.verifyTicker(self.stock.ticker)
            if type?.0 != nil {
                self.stock.type = type!.0!
                self.company = type?.1
                for stock in self.company!.stocks {
                    if stock.ticker == self.stock.ticker {
                        self.paper = stock
                    }
                }
                self.errorTicker = false
                self.disabledAdd = false
            }
            else {
                self.errorTicker = true
                self.disabledAdd = true
            }
        }
        
        if let range = self.stock.ticker.range(of: patternCompany, options: .regularExpression) {
            self.stock.company = String(self.stock.ticker[range])
        }
    }
    
    /// Check if field values are set properly, converting to corresponding data type and save into Action.
    ///
    /// - Returns: *true* if all are valid; *false* otherwise
    func fieldsChecker() -> Bool {
        if let avgPriceDouble = currencyString2Double(self.fields.avgPrice) {
            if let quantityInt = Int(self.fields.quantity) {
                if let taxesDouble = currencyString2Double(self.fields.taxes) {
                    //self.a = Action(actionDate: self.action.actionDate, avgPrice: avgPriceDouble, taxes: taxesDouble, quantity: quantityInt, type: self.action.type)
                    self.action.avgPrice = avgPriceDouble
                    self.action.quantity = quantityInt
                    self.action.taxes = taxesDouble
                    
                    return true
                }
                else {
                    self.fields.taxes = ""
                    return false
                }
            }
            else {
                self.fields.quantity = ""
                return false
            }
        }
        else {
            self.fields.avgPrice = ""
            return false
        }
    }
    
    /// Resets all data
    func resetData() {
        self.stock = Stock()
        self.fields = ActionField()
        self.action = Action()
    }
    
    /// Commit stock data to store
    func commitStock() -> Bool {
        // check field values
        if !fieldsChecker() {
            return false
        }
        
        self.stock.movement.append(self.action)
        self.stockStore?.addStock(self.stock)
        
        return true
    }
}

struct ActionField {
    var avgPrice: String = ""
    var quantity: String = ""
    var taxes: String = ""
}
