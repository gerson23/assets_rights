//
//  ContentCompat.swift
//  Assets Rights
//
//  Created by Gerson Carlos on 01/07/20.
//  Copyright © 2020 Gerson Carlos. All rights reserved.
//

import SwiftUI

struct ContentCompact: View {
    @State private var selection: TypeView = TypeView.home
    @State var showAction = false
    @Binding  var selectedSheet: AddSheet
    @Binding var showAddStock: Bool


    var actions: ActionSheet {
        ActionSheet(title: Text("Escolha tipo de novo bem"),
                    //message: Text("Escolha tipo de novo bem"),
                    buttons: [
                        .default(Text("Ações"), action: {
                            self.selectedSheet = .stock
                            self.showAddStock.toggle()
                        }),
                        //.default(Text("Fundos"), action: {self.showAlert.toggle() }),
                        .default(Text("Renda Fixa"), action: {
                            self.selectedSheet = .fixed
                            self.showAddStock.toggle()
                        }),
                        .cancel(Text("Cancelar"))])
    }
    
    var body: some View {
        VStack {
        // Get main view
        if(selection == TypeView.home) {
            Home()
        }
        else if(selection == TypeView.overview) {
            NavigationView {
                Overview()
            }
        }
        else if(selection == TypeView.operations) {
            NavigationView {
                Operations()
            }
        }
        else if(selection == TypeView.settings) {
            NavigationView {
                Settings()
            }
        }
        
        Divider()
        
        HStack(alignment: .center) {
            TabViewItem(iconName: "house", iconSelected: "house.fill", caption: "Principal", id: TypeView.home, selection: self.$selection)
            TabViewItem(iconName: "list.bullet", iconSelected: "list.bullet", caption: "Resumo", id: TypeView.overview, selection: self.$selection)
            Button(action: {self.showAction.toggle()}) {
                Image(systemName: "plus.rectangle.fill")
                    .scaledToFill()
                    .font(.system(size: 40))
            }
            .actionSheet(isPresented: $showAction) {
                actions
            }
            TabViewItem(iconName: "arrow.up.arrow.down.square", iconSelected: "arrow.up.arrow.down.square.fill", caption: "Operações", id: TypeView.operations, selection: self.$selection)
            TabViewItem(iconName: "wrench", iconSelected: "wrench.fill", caption: "Ajustes", id: TypeView.settings, selection: self.$selection)
        }
        }
    }
}
