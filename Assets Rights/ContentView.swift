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
                VStack {
                    Image(systemName: "house.fill")
                    Text("Principal")
                }
            }
            
            Overview()
            .tag(1)
            .tabItem {
                VStack {
                    Image(systemName: "doc.plaintext")
                    Text("Resumo")
                }
            }
            
            Settings()
            .tag(2)
            .tabItem {
                VStack {
                    Image(systemName: "wrench.fill")
                    Text("Ajustes")
                }
            }
        }
        .sheet(isPresented: self.$showIntro) {
            Introduction(isPresented: self.$showIntro)
                .environmentObject(self.settings)
        }
        .onAppear(perform: checkState)
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
