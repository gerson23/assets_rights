//
//  ContentView.swift
//  Assets Rights
//
//  Created by Gerson Carlos on 30/06/19.
//  Copyright © 2019 Gerson Carlos. All rights reserved.
//

import SwiftUI

struct ContentView : View {
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var settings: SettingsStore
    @EnvironmentObject var stockStore: StockStore

    
    @State private var selection: TypeView = TypeView.home
    @State var showIntro = false
    @State var showAddStock = false
    @State var showAction = false
    
    func checkState() {
        let distance = settings.introductionAcceptedDate.timeIntervalSince(RELEASE_DATE)
        
        if(!settings.introductionAccepted) {
            self.showIntro.toggle()
        }
        else if(settings.introductionAccepted && distance < 0) {
            self.showIntro.toggle()
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
        VStack {
            // Get main view
            if(selection == TypeView.home) {
                Home()
            }
            else if(selection == TypeView.overview) {
                Overview()
            }
            else if(selection == TypeView.operations) {
                Operations()
            }
            else if(selection == TypeView.settings) {
                Settings()
            }
         
            // Custom tab bar
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
            .padding(.top, 4)
        }
        .accentColor(.mainColor)
        .sheet(isPresented: self.$showIntro) {
            Introduction(isPresented: self.$showIntro)
                .environmentObject(self.settings)
        }
        .sheet(isPresented: $showAddStock) {
            AddStock(isPresented: self.$showAddStock)
                .environmentObject(self.userData)
                .environmentObject(self.stockStore)
        }
        .onAppear(perform: checkState)
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

enum TypeView: Int {
    case home = 0, overview, operations, settings
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
