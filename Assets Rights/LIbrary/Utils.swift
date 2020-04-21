//
//  Utils.swift
//  Assets Rights
//
//  Created by Gerson Carlos on 20/09/19.
//  Copyright © 2019 Gerson Carlos. All rights reserved.
//

import Foundation

let currencyFormat: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.locale = Locale.current
    formatter.numberStyle = .currency
    return formatter
}()

func currencyDouble2String(curDouble: Double, isAverage: Bool = false) -> String {
    if(isAverage) { currencyFormat.minimumFractionDigits = 3 }
    let currencyNS: NSNumber = curDouble as NSNumber
    let returnVal: String = currencyFormat.string(from: currencyNS) ?? currencyFormat.currencySymbol
    if(isAverage) { currencyFormat.minimumFractionDigits = 2 }
    
    return returnVal
}

func calcTotalbyStock(movements: [Action]) -> (Double, Int, [String: Double]) {
    var amount = 0.0
    var quantity = 0
    var yearTotal: [String: Double] = [:]
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YYYY"
    
    let sortedMoves = movements.sorted(by: {$0.actionDate < $1.actionDate})
    var lastYear = (Int(dateFormatter.string(from: sortedMoves[0].actionDate)) ?? 1) - 1
    
    for move in sortedMoves {
        let moveYear = Int(dateFormatter.string(from: move.actionDate))!
        var yearDiff = moveYear - lastYear
        
        if(yearDiff == 1) {
            lastYear += 1
            yearTotal[String(lastYear)] = amount
        }
        else if (yearDiff > 1) {
            repeat {
                lastYear += 1
                yearTotal[String(lastYear)] = amount
                yearDiff -= 1
            } while(yearDiff >= 1)
        }
        
        if move.type == TypeAction.buy {
            amount += (move.avgPrice * Double(move.quantity)) + move.taxes
            quantity += move.quantity
        }
        // removes quantity keeping average price
        else if move.type == TypeAction.sell {
            let quantity_sold = move.quantity
            amount = (amount/Double(quantity)) * Double(quantity - quantity_sold)
            quantity = quantity_sold
        }
        
        yearTotal[String(moveYear)] = amount
    }
    
    // Fill up in case there's no movement in the current year
    let thisYear = Int(dateFormatter.string(from: Date()))!
    while(lastYear < thisYear) {
        lastYear += 1
        yearTotal[String(lastYear)] = amount
    }
            
    return (amount, quantity, yearTotal)
}

// CONSTANTS
let NS_INVALID_NUMBER: NSNumber = 99999999
let INVALID_NUMBER: Double = 99999999
