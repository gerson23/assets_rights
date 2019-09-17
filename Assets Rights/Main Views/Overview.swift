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
            
    var body: some View {
        NavigationView {
            List(stockStore.stocks) { stock in
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
            .navigationBarTitle("Resumo")
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
