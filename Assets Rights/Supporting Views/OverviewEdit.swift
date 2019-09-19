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
    
    var body: some View {
        VStack {
            Text(company.social_name)
                .fontWeight(.light)
                .foregroundColor(.gray)
            List(stock.movement) { action in
                EditRow(action: action)
            }
        }
        .navigationBarTitle("Extrato")
    }
}

struct EditRow: View {
    var action: Action
    var valueFormat: String
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        //formatter.dateFormat = "dd/MM/yyyy"
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
            }
            VStack(alignment: .leading) {
                Text(action.type.rawValue)
                    .italic()
                Text("\(action.actionDate, formatter: Self.dateFormatter)")
            }
            Spacer()
            Text(String(format: self.valueFormat, action.avgPrice*Double(action.quantity)))
                .bold()
                .foregroundColor(action.type == TypeAction.buy ? .green : .red)
         }
        .font(.system(size: 18))
    }
}
/*struct OverviewEdit_Previews: PreviewProvider {
    static var previews: some View {
        OverviewEdit(stock: Stock(), company: Company())
    }
}*/
