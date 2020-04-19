//
//  Home.swift
//  Assets Rights
//
//  Created by Gerson Carlos on 07/07/19.
//  Copyright © 2019 Gerson Carlos. All rights reserved.
//

import SwiftUI

struct Home : View {
    // Temporary bug fix, needs to pass environment to presentation
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var stockStore: StockStore
    
    @State var showAddStock = false;
    @State var showAction = false;
    @State var showAlert = false;
    var x = stockData
    
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
            VStack(alignment: .leading) {
                
                StockGraph(self.stockStore.stocks)
                
                Button(action: { self.showAction = true }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .imageScale(.large)
                            .foregroundColor(.orange)
                            .scaledToFill()
                        Text("Adicionar Bem")
                            .foregroundColor(.orange)
                    }
                    .font(.system(size: 23))
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
