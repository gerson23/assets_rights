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

// CONSTANTS
let NS_INVALID_NUMBER: NSNumber = 99999999
let INVALID_NUMBER: Double = 99999999
