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
        NavigationView {
            VStack(alignment: .center) {
                Picker("", selection: $selection) {
                    ForEach(GraphType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.top)

                StockGraph(self.stockStore.stocks, self.$selection)
                
                Button(action: { self.showAction = true }) {
                    VStack {
                        Image(systemName: "plus.circle.fill")
                            .imageScale(.large)
                            .foregroundColor(.blue)
                            .scaledToFill()
                        Text("Adicionar")
                            .font(.caption)
                            .foregroundColor(.blue)
                            .padding(.top)
                    }
                    .font(.system(size: 40))
                }
                .padding(.bottom)
                .actionSheet(isPresented: $showAction) {
                    actions
                }
                                
                .sheet(isPresented: $showAddStock) {
                    AddStock(isPresented: self.$showAddStock)
                        .environmentObject(self.userData)
                        .environmentObject(self.stockStore)
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Indisponível no momento"))
                }
            }
            .navigationBarTitle("Bens e Direitos")
            //.background(Color.purple.opacity(0.1))
            //  .edgesIgnoringSafeArea(.top)
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
