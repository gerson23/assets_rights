//
//  OverviewDetail.swift
//  Assets Rights
//
//  Created by Gerson Carlos on 11/09/19.
//  Copyright © 2019 Gerson Carlos. All rights reserved.
//

import SwiftUI
import Foundation

struct OverviewDetail: View {
    var stock: Stock
    var company: Company
    var totals: Action
    
    
    init(_ stock: Stock, _ company: Company) {
        self.stock = stock
        self.company = company
        self.totals = Action()
        
        // TODO: complete total calculation
        for action in self.stock.movement {
            self.totals.quantity += action.quantity
            self.totals.avgPrice += action.avgPrice
        }
    }
    
    var body: some View {
        VStack {
            Text(self.company.social_name)
                .fontWeight(.light)
                .foregroundColor(.gray)
                .padding(.leading)
            Form {
                Section(header: Text("Dados do papel")) {
                    FormLine(title: "Razão Social", content: self.company.social_name)
                    FormLine(title: "CNPJ", content: "00.000.000/0001-00")
                }
                Section(header: Text("Valores")) {
                    FormLine(title: "Quantidade", content: String(totals.quantity))
                    FormLine(title: "Preço Médio", content: String(totals.avgPrice))
                }
            }
        }
        .navigationBarTitle(stock.ticker)
    }
}

struct FormLine: View {
    var title: String
    var content: String
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(content)
                .fontWeight(.light)
        }
    }
}

struct OverviewDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            OverviewDetail(Stock(), Company(code: "1", short_name: "2", social_name: "3", stocks: []))
        }
    }
}
