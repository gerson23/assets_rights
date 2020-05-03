//
//  Operations.swift
//  Assets Rights
//
//  Created by Gerson Carlos on 01/05/20.
//  Copyright © 2020 Gerson Carlos. All rights reserved.
//

import SwiftUI

let OPTIONS : [[String:String]] = [
    ["title": "Operações Comuns / Day-Trade", "short_title": "Ações Comuns", "type": TypeStock.stock.rawValue],
    ["title": "Operações Fundos Invest. Imob.", "short_title": "FIIs", "type": TypeStock.fii.rawValue, "icon": "book"],
    ["title": "Operações Gerais", "short_title": "Bens Gerais", "type": TypeStock.fund.rawValue, "icon": "arrow.swap"]
]

let years = ["2020", "2019", "2018", "2017", "2016", "2015", "2014"]

struct Operations: View {
    @EnvironmentObject var stockStore: StockStore

    @State var selectedYear: Int = 0
    @State var showOptions = false
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Ano-Calendário \(years[self.selectedYear])")
                        .font(.callout)
                    Spacer()
                    OptionsButton(showOptions: self.$showOptions)
                }
                .padding(.horizontal, 20)

                VStack {
                    ForEach(OPTIONS, id: \.self) { opt in
                        NavigationLink(destination: OperationsDetail(title: opt["short_title"]!, year: years[self.selectedYear], type: TypeStock(rawValue: opt["type"]!)!)) {

                            OperationCard(title: opt["title"]!, icon: opt["icon"] ?? "arrow.up.and.down")
                        }
                        .disabled(self.showOptions)
                    }

                    Spacer()

                }
                .onTapGesture {
                    if(self.showOptions) {
                        self.showOptions.toggle()
                    }
                }
                //.opacity(self.showOptions ? 0.50 : 1)
                .blur(radius: self.showOptions ? 10 : 0, opaque: false)

                .overlay(
                    VStack {
                        if(self.showOptions) {
                            VStack {
                                Picker("Ano", selection: $selectedYear) {
                                    ForEach(0 ..< years.count) {
                                        Text(years[$0])
                                    }

                                }
                                .font(.headline)
                            }
                            .padding()
                        }
                    }
                    .background(Color(UIColor.systemBackground)), alignment: .top)

                Spacer()
                            }
            .navigationBarTitle("Operações")
        }
    }
}

struct OptionsButton: View {
    @Binding var showOptions: Bool
    
    var body: some View {
        VStack() {
            Button(action: {self.showOptions.toggle()}) {
                HStack {
                    Image(systemName: "slider.horizontal.3")
                    Text("Opções")
                }
            }
        }
    }
}

struct OperationCard : View {
    var title : String
    var icon : String
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 12).fill(Color(UIColor.systemGray6)).shadow(radius: 2)
            HStack {
            VStack(alignment: .leading) {
                Text(self.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text("blablab")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
                Spacer()
                Image(systemName: self.icon)
                    .font(.system(size: 40))
                    .foregroundColor(.secondary)
            }
            .padding()
        }
        .padding()
    }
}

struct Operations_Previews: PreviewProvider {
    static var previews: some View {
        Operations()
    }
}
