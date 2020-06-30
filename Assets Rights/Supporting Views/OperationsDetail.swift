//
//  OperationsDetail.swift
//  Assets Rights
//
//  Created by Gerson Carlos on 02/05/20.
//  Copyright © 2020 Gerson Carlos. All rights reserved.
//

import SwiftUI

struct OperationsDetail: View {
    @EnvironmentObject var stockStore: StockStore

    var title: String
    var year: String
    var type: TypeStock
    var dateSource: DateFormatter
    var dateMonthInt: DateFormatter
    
    @State var displayContent = false
    @State var months: [Int:OperationMonth] = [:]

    
    init(title: String, year: String, type: TypeStock) {
        self.title = title
        self.year = year
        self.type = type
        
        self.dateSource = DateFormatter()
        self.dateSource.dateFormat = "dd/M/yyyy"
        
        self.dateMonthInt = DateFormatter()
        self.dateMonthInt.dateFormat = "M"
        
        let dateMonth = DateFormatter()
        dateMonth.dateFormat = "MMMM"
        
        var tempMonth: [Int:OperationMonth] = [:]
        
        for m in 1...12 {
            tempMonth[m] = OperationMonth(desc: dateMonth.string(from: self.dateSource.date(from: "01/\(m)/2020")!), netTotal: 0.0, taxes: 0.0)
        }
        self._months = /*State<[Int : OperationMonth]>*/.init(initialValue: tempMonth)
    }
    
    func updateValues() {
        for stock in stockStore.stocks {
            if stock.type != self.type {
                continue
            }
            let stockTotals = calcTotalbyStock(movements: stock.movement)
            var result = 0.0
            var yamount = stockTotals.2[String(Int(year)!-1)] ?? YearAmount(amount: 0.0, quantity: 0)
            
            // calculate monthly results
            for move in stock.movement {
                let startYear = dateSource.date(from: "01/01/\(self.year)")!
                let endYear = dateSource.date(from: "31/12/\(self.year)")!
                
                if move.actionDate >= startYear && move.actionDate <= endYear {
                    if move.type == TypeAction.buy {
                        yamount.amount += move.avgPrice*Double(move.quantity) + move.taxes
                        yamount.quantity += move.quantity
                    }
                    else {
                        let relativeBuy = yamount.avgPrice * Double(move.quantity)
                        result = (move.avgPrice * Double(move.quantity) - move.taxes) - relativeBuy
                        self.months[Int(dateMonthInt.string(from: move.actionDate))!]?.netTotal = result
                    }
                }
            }
        }
    }
    
    var body: some View {
        List {
            ForEach(months.keys.sorted(), id: \.self) { month in
                HStack {
                    Text(self.months[month]!.desc)
                        .font(.headline)
                    Spacer()
                    ValuesColumn(netAmount: self.months[month]!.netTotal, taxAmount: self.months[month]!.taxes)
                }
                .contextMenu {
                    Text("Helllo")
                }
                //.blur(radius: self.displayContent ? 0 : 10, opaque: true)
                //.blur(radius: self.displayContent ? 0 : 9, opaque: false)
            }
        }
            .onAppear(perform: self.updateValues)


        .navigationBarTitle("\(self.title)")
        .navigationBarItems(trailing: Text(self.year))
    }
}

struct ValuesColumn: View {
    var netAmount: Double
    var taxAmount: Double
    
    var body: some View {
        HStack {
            VStack {
                Text("Resultado Líquido")
                    .font(.caption)
                Text(currencyDouble2String(curDouble: netAmount))
                    .foregroundColor(netAmount > 0 ? Color.green : netAmount < 0 ? Color.red : Color.primary)
                    .padding(.vertical)
                    .font(.system(size: 20))
            }
            VStack {
                Text("Imposto Devido")
                    .font(.caption)
                Text(currencyDouble2String(curDouble: taxAmount))
                    .padding(.vertical)
                    .font(.system(size: 20))
            }
        }
    }
}

struct OperationMonth {
    var desc: String
    var netTotal: Double
    var taxes: Double
}

struct OperationsDetail_Previews: PreviewProvider {
    static var previews: some View {
        OperationsDetail(title: "Operações em Teste", year: "2020", type: TypeStock.stock)
    }
}
