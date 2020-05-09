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
        ZStack(alignment: .bottom) {
            TabView(selection: $selection) {
                Home()
                    .tag(TypeView.home)
                    .tabItem {
                        Text("")
                    }
                
                Overview()
                    .tag(TypeView.overview)
                    .tabItem {
                        Text("")
                    }
                
                Operations()
                    .tag(TypeView.operations)
                    .tabItem {
                        Text("")
                    }
                
                Settings()
                    .tag(TypeView.settings)
                    .tabItem {
                        Text("")
                    }
            }
            HStack(alignment: .center) {
                TabViewItem(iconName: "house", caption: "Principal", id: TypeView.home, selection: self.$selection)
                TabViewItem(iconName: "folder", caption: "Resumo", id: TypeView.overview, selection: self.$selection)
                Button(action: {self.showAction.toggle()}) {
                    Image(systemName: "plus.circle.fill")
                        .scaledToFill()
                        .font(.system(size: 50))
                }
                .actionSheet(isPresented: $showAction) {
                    actions
                }
                TabViewItem(iconName: "arrow.up.arrow.down.square", caption: "Operações", id: TypeView.operations, selection: self.$selection)
                TabViewItem(iconName: "wrench", caption: "Ajustes", id: TypeView.settings, selection: self.$selection)

            }
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
    var caption: String
    var id: TypeView
    
    @Binding var selection: TypeView
    
    var body: some View {
        VStack {
            Image(systemName: selection == id ? self.iconName + ".fill" : self.iconName)
                .imageScale(.large)
                .font(Font.body.weight(.thin))
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
