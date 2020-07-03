//
//  Home.swift
//  Assets Rights
//
//  Created by Gerson Carlos on 07/07/19.
//  Copyright © 2019 Gerson Carlos. All rights reserved.
//

import SwiftUI

enum GraphType: String, Hashable, Codable, CaseIterable {
    case by_type = "POR TIPO"
    case by_year = "POR ANO"
}

struct Home : View {
    // Temporary bug fix, needs to pass environment to presentation
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var stockStore: StockStore
    
    @Environment(\.horizontalSizeClass) var sizeClass
    
    @State var showAddStock = false;
    @State var showAction = false;
    @State var showAlert = false;
    @State var selection: GraphType = GraphType.by_type;
    
    var addButton: some View {
        Button(action: { self.showAddStock.toggle() }) {
            VStack {
                Image(systemName: "plus.app.fill")
                    .imageScale(.large)
                Text("Nova Ação")
            }
        }
    }
    
    var actions: ActionSheet {
        ActionSheet(title: Text("Escolha tipo de novo bem"),
                    //message: Text("Escolha tipo de novo bem"),
                    buttons: [
                        .default(Text("Ações"), action: { self.showAddStock.toggle() }),
                        //.default(Text("Fundos"), action: {self.showAlert.toggle() }),
                        .cancel(Text("Cancelar"))])
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Bens e Direitos")
                .font(.custom("Optima-ExtraBlack", size: 40))
            
            Picker("", selection: $selection) {
                ForEach(GraphType.allCases, id: \.self) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.top)
            .padding(.horizontal)

            StockGraph(self.stockStore.stocks, self.$selection)
            .navigationBarHidden(sizeClass != .compact)
        }
    }
}

#if DEBUG
struct Home_Previews : PreviewProvider {
    static var previews: some View {
        Home()
    }
}
#endif
