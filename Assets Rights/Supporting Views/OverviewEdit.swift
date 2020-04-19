//
//  OverviewEdit.swift
//  Assets Rights
//
//  Created by Gerson Carlos on 18/09/19.
//  Copyright © 2019 Gerson Carlos. All rights reserved.
//

import SwiftUI
import Foundation

class StateHolder: ObservableObject {
    @Published var showDetails: [UUID:Bool] = [:]
    
    init(actions: [Action]) {
        for action in actions {
            self.showDetails[action.id] = false
        }
    }
}

struct OverviewEdit: View {
    var stock: Stock
    var company: Company
    
    @ObservedObject var state: StateHolder
    
    init(stock: Stock, company: Company) {
        self.stock = stock
        self.company = company
        
        self.state = StateHolder(actions: self.stock.movement)
    }
    
    var body: some View {
        VStack {
            Text(company.social_name)
                .fontWeight(.light)
                .foregroundColor(.gray)
            ForEach(stock.movement) { move in
                VStack {
                    Button(action: { self.state.showDetails[move.id] = !self.state.showDetails[move.id]! }) {
                        EditRow(action: move)
                    }
                    if(self.state.showDetails[move.id]!) { EditDetails(action: move, stock: self.stock) }
                }
                .padding()
                Divider()
            }
            Spacer()

        }
        .navigationBarTitle("Extrato")
    }
}

struct EditRow: View {
    var action: Action
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateStyle = .medium
        return formatter
    }()

    var body: some View {
        HStack {
            if(action.type == TypeAction.buy) {
                Image(systemName: "square.and.arrow.down.fill")
                    .foregroundColor(.green)
            }
            else if(action.type == TypeAction.sell) {
                Image(systemName: "square.and.arrow.up.fill")
                    .foregroundColor(.red)
                    .font(.system(size: 18))
            }
            VStack(alignment: .leading) {
                Text(action.type.rawValue)
                    .italic()
                Text("\(action.actionDate, formatter: Self.dateFormatter)")
            }
                .foregroundColor(.primary)
            Spacer()
            Text(currencyDouble2String(curDouble: action.avgPrice*Double(action.quantity) + (action.type == TypeAction.buy ? action.taxes : -action.taxes)))
                .bold()
                .foregroundColor(action.type == TypeAction.buy ? .green : .red)
         }
    }
}

struct EditDetails: View {
    @EnvironmentObject var stockStock: StockStore
    
    var action: Action
    var stock: Stock
    
    @State var showRemoveAlert = false
    
    var body: some View {
        VStack {
            EditDetailsRow(label: "Quantidade", currency: false, valueDouble: 0.0, valueInt: action.quantity)
            EditDetailsRow(label: "Preço Médio", currency: true, valueDouble: action.avgPrice, valueInt: 0)
            EditDetailsRow(label: "Taxas", currency: true, valueDouble: action.taxes, valueInt: 0)
            Button(action: { self.showRemoveAlert = true }) {
                Image(systemName: "xmark.circle")
                Text("Remover")
            }
            .foregroundColor(.red)
            .alert(isPresented: $showRemoveAlert) {
                Alert(title: Text("Confirmar remocão?"), primaryButton: .destructive(Text("Remover")) {
                    self.stockStock.removeAction(action: self.action, from: self.stock)
                    }, secondaryButton: .cancel())
            }
        }
    }
}

struct EditDetailsRow: View {
    var label: String
    var currency: Bool
    var valueDouble: Double
    var valueInt: Int
    
    var body: some View {
        HStack {
            Text(label)
                .bold()
            Spacer()
            Text(currency ? currencyDouble2String(curDouble: valueDouble) : String(valueInt))
        }
    }
}

/*struct OverviewEdit_Previews: PreviewProvider {
    static var previews: some View {
        OverviewEdit(stock: Stock(), company: Company())
    }
}*/
