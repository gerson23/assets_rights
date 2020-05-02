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
    
    @State private var selection: Int
    @State var showIntro: Bool
    
    init() {
        self._selection = State(initialValue: 0)
        self._showIntro = State(initialValue: false)
    }
    
    func checkState() {
        let distance = settings.introductionAcceptedDate.timeIntervalSince(RELEASE_DATE)
        
        if(!settings.introductionAccepted) {
            self.showIntro.toggle()
        }
        else if(settings.introductionAccepted && distance < 0) {
            self.showIntro.toggle()
        }
    }
    
    var body: some View {
        TabView(selection: $selection) {
            Home()
                .tag(0)
                .tabItem {
                    TabViewItem(iconName: "house.fill", caption: "Principal")
                    }
            
            Overview()
                .tag(1)
                .tabItem {
                    TabViewItem(iconName: "doc.plaintext", caption: "Resumo")
                }
            
            Operations()
                .tag(2)
                .tabItem {
                    TabViewItem(iconName: "plus.slash.minus", caption: "Operações")
                }
            
            Settings()
                .tag(3)
                .tabItem {
                    TabViewItem(iconName: "wrench.fill", caption: "Ajustes")
                }
        }
        .accentColor(.mainColor)
        .sheet(isPresented: self.$showIntro) {
            Introduction(isPresented: self.$showIntro)
                .environmentObject(self.settings)
        }
        .onAppear(perform: checkState)
    }
}

struct TabViewItem : View {
    var iconName: String
    var caption: String
    
    var body: some View {
        VStack {
            Image(systemName: self.iconName)
            Text(self.caption)
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
