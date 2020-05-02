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
    @EnvironmentObject var stockStore: StockStore
    @Environment(\.presentationMode) var presentationMode
    
    var stock: Stock
    var company: Company
    var totals: Action
    var stockPaper: Paper
    
    @State var showRemoveAlert = false    
    
    init(_ stock: Stock, _ company: Company) {
        self.stock = stock
        self.company = company
        self.totals = Action()
        self.stockPaper = Paper(bdi: "", desc_bdi: "", spec: "", ticker: "")
        
        // TODO: complete total calculation
        for action in self.stock.movement {
            if(action.type == TypeAction.buy) {
                self.totals.avgPrice = (self.totals.avgPrice*Double(self.totals.quantity) + action.avgPrice*Double(action.quantity) + action.taxes)/Double(self.totals.quantity + action.quantity)
                self.totals.quantity += action.quantity
            }
            else {
                self.totals.quantity -= action.quantity
            }
        }
        
        for paper in company.stocks {
            if(paper.ticker == stock.ticker) {
                self.stockPaper = paper
                break
            }
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
                    //FormLine(title: "Razão Social", content: self.company.social_name)
                    //FormLine(title: "CNPJ", content: "00.000.000/0001-00")
                    FormLine(title: "Especificação", content: company.short_name + " " + stockPaper.spec)
                }
                Section(header: Text("Valores")) {
                    FormLine(title: "Quantidade", content: String(totals.quantity))
                    FormLine(title: "Total Investido", content: currencyDouble2String(curDouble: totals.avgPrice * Double(totals.quantity)))
                    FormLine(title: "Preço Médio", content: currencyDouble2String(curDouble: totals.avgPrice, isAverage: true))
                }
                Section {
                    NavigationLink(destination: OverviewEdit(stock: self.stock, company: self.company)) {
                        Text("Extrato")
                            .foregroundColor(.accentColor)
                    }
                    Button(action: { self.showRemoveAlert = true }) {
                        Text("Remover título")
                            .foregroundColor(.red)
                    }
                    .alert(isPresented: $showRemoveAlert) {
                        Alert(title: Text("Certeza que deseja remover?"), message: Text("Essa ação não poderá ser desfeita"), primaryButton: .destructive(Text("Remover")) {
                            self.stockStore.removeStock(stock: self.stock)
                            self.presentationMode.wrappedValue.dismiss()
                            }, secondaryButton: .cancel())
                    }
                    
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
