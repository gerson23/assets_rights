//
//  OverviewEdit.swift
//  Assets Rights
//
//  Created by Gerson Carlos on 18/09/19.
//  Copyright © 2019 Gerson Carlos. All rights reserved.
//

import SwiftUI
import Foundation

struct OverviewEdit: View {
    var stock: Stock
    var company: Company
    
    @State var showDetails = false
    
    var body: some View {
        VStack {
            Text(company.social_name)
                .fontWeight(.light)
                .foregroundColor(.gray)
            ForEach(stock.movement) { action in
                VStack {
                    Button(action: { self.showDetails = !self.showDetails }) {
                        EditRow(action: action)
                    }
                    if(self.showDetails) { EditDetails(action: action) }
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
    var valueFormat: String
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    init(action: Action) {
        self.action = action
        self.valueFormat = (action.type == TypeAction.buy ? "+ R$ %.2f" : "- R$ %.2f")
    }

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
            Text(currencyDouble2String(curDouble: action.avgPrice*Double(action.quantity)))
                .bold()
                .foregroundColor(action.type == TypeAction.buy ? .green : .red)
         }
    }
}

struct EditDetails: View {
    var action: Action
    
    var body: some View {
        VStack {
            HStack {
                Text("Quantidade")
                    .bold()
                Spacer()
                Text("\(action.quantity)")
            }
            Button(action: { print("ok") }) {
                Image(systemName: "xmark.circle")
                Text("Remover")
            }
            .foregroundColor(.red)
        }
    }
}

/*struct OverviewEdit_Previews: PreviewProvider {
    static var previews: some View {
        OverviewEdit(stock: Stock(), company: Company())
    }
}*/
