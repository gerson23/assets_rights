//
//  AddStock.swift
//  Assets Rights
//
//  Created by Gerson Carlos on 30/06/19.
//  Copyright © 2019 Gerson Carlos. All rights reserved.
//

import SwiftUI
import Foundation

struct AddStock : View {
    @Binding var isPresented: Bool
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var stockStore: StockStore
    
    @State var stock: Stock = Stock()
    @State var action = Action.default
    @State var fields = ActionField()
    
    static let tickerFormat: TickerFormatter = TickerFormatter()
    
    //integerFormat.numberStyle = NumberFormatter.Style.none
    
    let currentDate = Date()
    
    @State var errorTicker = true
    @State var disabledAdd = true
    
    let patternTicker = "^[A-Z0-9]+[A-Z][0-9]+$"
    let patternCompany = "^[A-Z0-9]+[A-Z]"
    
    func tickerChecker() {
        self.stock.ticker = self.stock.ticker.uppercased()
        let result = self.stock.ticker.range(of: self.patternTicker, options: .regularExpression)
        if result?.lowerBound == nil || result?.upperBound == nil {
            self.errorTicker = true
            self.disabledAdd = true
        }
        else {
            if verifyTicker(self.stock.ticker) {
                self.errorTicker = false
                self.disabledAdd = false
            }
            else {
                self.errorTicker = true
                self.disabledAdd = true
            }
        }
    }
    
    /// Verify if a given ticker is valid against the database of valid stocks
    ///
    /// - Parameters:
    ///   - ticker: Ticker string from user input
    /// - Returns: *true* if it is a valid ticker. *false* otherwise.
    func verifyTicker(_ ticker: String) -> Bool {
        let fixTicker = ticker.uppercased()
        let companyRng = fixTicker.range(of: patternCompany, options: .regularExpression)
        let company = String(fixTicker[companyRng!])
        
        
        if let companyData = stockData[company] {
            for stock in companyData.stocks {
                if stock.ticker == ticker {
                    if(stock.bdi == "002") {
                        self.stock.type = TypeStock.stock
                    } else if(stock.bdi == "012") {
                        self.stock.type = TypeStock.fii
                    } else if(stock.bdi == "014") {
                        self.stock.type = TypeStock.fund
                    }
                    return true
                }
            }
        }
        
        return false
    }
    
    func currencyString2Double(_ stringVal: String) -> Double? {
        let converted: Double = Double(truncating: currencyFormat.number(from: stringVal) ??
            currencyFormat.number(from: currencyFormat.currencySymbol + stringVal) ??
            NS_INVALID_NUMBER)
        if(converted == INVALID_NUMBER) {
            return nil
        }
        return converted
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(alignment: .center) {
                Button(action: {
                    self.isPresented = false
                }) { Text("Cancelar") }
                Spacer()
                Text("Nova Ação")
                    .font(.headline)
                    .bold()
                Spacer()
                Button(action: {
                    if let range = self.stock.ticker.range(of: self.patternCompany, options: .regularExpression) {
                        self.stock.company = String(self.stock.ticker[range])
                    }
                    var movement: Action
                    if let avgPriceDouble = self.currencyString2Double(self.fields.avgPrice) {
                        if let quantityInt = Int(self.fields.quantity) {
                            if let taxesDouble = self.currencyString2Double(self.fields.taxes) {
                                movement = Action(actionDate: self.action.actionDate, avgPrice: avgPriceDouble, taxes: taxesDouble, quantity: quantityInt, type: self.action.type)
                            }
                            else {
                                self.fields.taxes = ""
                                return
                            }
                        }
                        else {
                            self.fields.quantity = ""
                            return
                        }
                    }
                    else {
                        self.fields.avgPrice = ""
                        return
                    }

                    self.stock.movement.append(movement)
                    self.stockStore.addStock(self.stock)
                    self.isPresented = false
                    self.stock = Stock()
                    self.fields = ActionField()
                }) { Text("Adicionar") }
                    .disabled(self.disabledAdd)
            }
            .padding(.top)
            .padding(.leading)
            .padding(.trailing)
            
            
            // TODO: add proper formatter
            Form {
                Section(header: Text("CÓDIGO")) {
                    HStack {
                        TextField("Código Ação", text: $stock.ticker, onEditingChanged: { changed in
                            if(!changed) {
                                self.tickerChecker()
                            }
                            else {
                                self.tickerChecker()
                            }
                        })
                            .disableAutocorrection(true)
                        if(errorTicker && self.stock.ticker != "") {
                            Image(systemName: "exclamationmark.circle")
                                .foregroundColor(.red)
                        }
                        else if(!errorTicker && self.stock.ticker != "") {
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(.green)
                        }
                    }

                }
                
                Section(header: Text("MOVIMENTAÇÃO")) {
                    Picker("", selection: $action.type) {
                        ForEach(TypeAction.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    .foregroundColor(.blue)
                    
                    DatePicker("Data execução", selection: $action.actionDate, displayedComponents: .date)
                }
                Section(footer: Text("Taxas incluem: corretagem, impostos e emolumentos")) {
                    FieldLine(title: "Preço médio", placeholder: "R$", keyboard: .decimalPad, field: $fields.avgPrice)
                    FieldLine(title: "Quantidade", placeholder: "1...", keyboard: .numberPad, field: $fields.quantity)
                    FieldLine(title: "Taxas", placeholder: "R$", keyboard: .decimalPad, field: $fields.taxes)
                }
            }
        }
        .accentColor(.mainColor)
    }
}

struct FieldLine: View {
    var title: String
    var placeholder: String
    var keyboard: UIKeyboardType
    @Binding var field: String
    
    var body: some View {
        HStack {
            Text(title)
            if(keyboard == .decimalPad) {
                TextField(placeholder, text: $field, onEditingChanged: {changed in
                    if(!changed) {
                        let doubleValue = currencyFormat.number(from: currencyFormat.currencySymbol + self.field) ?? 0
                        self.field = currencyFormat.string(from: doubleValue) ?? ""
                    }
                    else { self.field = "" }
                })
                    .keyboardType(keyboard)
                    .multilineTextAlignment(.trailing)
            } else {
                TextField(placeholder, text: $field)
                    .keyboardType(keyboard)
                    .multilineTextAlignment(.trailing)
            }
        }
    }
}

struct ActionField {
    var avgPrice: String = ""
    var quantity: String = ""
    var taxes: String = ""
}

class TickerFormatter: Formatter {
    override func string(for obj: Any?) -> String? {
        if let stringContent = obj as? String {
            return stringContent.lowercased()
        }
        return nil
    }
    
    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        if string == "foo" {
            return false
        }
        let stringConverted = string.uppercased()
        obj?.pointee = stringConverted as AnyObject
        return true
    }
}

#if DEBUG
/*struct AddStock_Previews : PreviewProvider {
    @State static var presented = true

    static var previews: some View {

        AddStock(isPresented: $presented).environmentObject(UserData())
    }
}*/
#endif
