//
//  Overview.swift
//  Assets Rights
//
//  Created by Gerson Carlos on 07/07/19.
//  Copyright © 2019 Gerson Carlos. All rights reserved.
//

import SwiftUI

struct Overview : View {
    @EnvironmentObject var stockStore: StockStore
          
    func deleteAction(at offsets: IndexSet) {
        stockStore.removeStock(at: offsets.first ?? -1)
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(TypeStock.allCases, id: \.self) { type in
                    Section(header: Text(type.rawValue)) {
                        ForEach(self.stockStore.stocks) { stock in
                            if(stock.type == type) {
                                StockRow(stock: stock)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteAction)
            }
            .navigationBarTitle("Resumo")
        }
    }
}

struct StockRow: View {
    var stock: Stock
    
    var body: some View {
        NavigationLink(destination: OverviewDetail(stock, stockData[stock.company]!)) {
           HStack {
               Text(stock.ticker)
               Spacer()
               Text(String(stockData[stock.company]!.short_name))
                   .fontWeight(.light)
                   .foregroundColor(.gray)
           }
        }
    }
}
#if DEBUG
struct Overview_Previews : PreviewProvider {
    static var previews: some View {
        Overview().environmentObject(StockStore())
    }
}
#endif
