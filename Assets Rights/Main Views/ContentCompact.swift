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
        ZStack(alignment: .bottom) {
            TabView(selection: $selection) {
                Home().tabItem {
                    Label("Principal", systemImage: selection == TypeView.home ? "house.fill" : "house")
                }.tag(TypeView.home)
                
                NavigationView { Overview() }.tabItem {
                    Label("Resumo", systemImage: "list.bullet")
                }.tag(TypeView.overview)
                
                NavigationView { Operations() }.tabItem {
                    Label("Operações", systemImage: selection == TypeView.operations ? "arrow.up.arrow.down.square.fill" : "arrow.up.arrow.down.square")
                }.tag(TypeView.operations)
                
                NavigationView { Settings() }.tabItem {
                    Label("Ajustes", systemImage: selection == TypeView.settings ? "wrench.fill" : "wrench")
                }.tag(TypeView.settings)
            }
        
            Button(action: {self.showAction.toggle()}) {
                Image(systemName: "plus.circle.fill")
                    .scaledToFill()
                    .font(.system(size: 60))
            }
            .padding(.bottom, 20)
            .actionSheet(isPresented: $showAction) {
                actions
            }
        }
    }
}

struct TabViewItem : View {
    var iconName: String
    var iconSelected: String
    var caption: String
    var id: TypeView
    
    @Binding var selection: TypeView
    
    var body: some View {
        VStack {
            Image(systemName: selection == id ? self.iconSelected  : self.iconName)
                .imageScale(.large)
                .font(Font.body.weight(selection == id ? .heavy : .light))
            Text(self.caption)
                .font(.caption)
        }
        .padding(.horizontal)
        .onTapGesture {
            self.selection = self.id
        }
    }
}
