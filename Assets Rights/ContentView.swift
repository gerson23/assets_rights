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
    
    @State private var selection = 0
    
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
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
