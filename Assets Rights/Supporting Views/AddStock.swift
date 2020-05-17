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
    
    @ObservedObject var addStockModel = AddStockModel()
    
    static let tickerFormat: TickerFormatter = TickerFormatter()
        
    let currentDate = Date()

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
                    if self.addStockModel.commitStock() {
                        self.addStockModel.resetData()
                        self.isPresented = false
                    }
                    else {
                        self.addStockModel.disabledAdd = true
                    }
                }) { Text("Adicionar") }
                    .disabled(addStockModel.disabledAdd)
            }
            .padding(.top)
            .padding(.leading)
            .padding(.trailing)
            
            
            // TODO: add proper formatter
            Form {
                Section(header: Text("CÓDIGO")) {
                    HStack {
                        TextField("Código Ação", text: $addStockModel.stock.ticker)
                            .disableAutocorrection(true)
                        if(addStockModel.errorTicker && addStockModel.stock.ticker != "") {
                            Image(systemName: "exclamationmark.circle")
                                .foregroundColor(.red)
                        }
                        else if(!addStockModel.errorTicker && addStockModel.stock.ticker != "") {
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(.green)
                        }
                    }
                    if !addStockModel.errorTicker && addStockModel.stock.ticker != "" {
                        VStack(alignment: .leading) {
                            Text(addStockModel.company!.social_name)
                                .font(.headline)
                            Text("\(addStockModel.paper!.spec.trimmingCharacters(in: .whitespaces)) - \(addStockModel.paper!.desc_bdi)")
                                .fontWeight(.thin)
                        }
                        .transition(AnyTransition.slide)
                    }
                }
                
                Section(header: Text("MOVIMENTAÇÃO")) {
                    Picker("", selection: $action.type) {
                        ForEach(TypeAction.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    .foregroundColor(.blue)
                    
                    DatePicker("Data execução", selection: $addStockModel.action.actionDate, displayedComponents: .date)
                }
                Section(footer: Text("Taxas incluem: corretagem, impostos e emolumentos")) {
                    FieldLine(title: "Preço médio", placeholder: "R$", keyboard: .decimalPad, field: $addStockModel.fields.avgPrice)
                    FieldLine(title: "Quantidade", placeholder: "1...", keyboard: .numberPad, field: $addStockModel.fields.quantity)
                    FieldLine(title: "Taxas", placeholder: "R$", keyboard: .decimalPad, field: $addStockModel.fields.taxes)
                }
            }
        }
        .accentColor(.mainColor)
        .onAppear(perform: {
            self.addStockModel.setStore(self.stockStore)
        })
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
