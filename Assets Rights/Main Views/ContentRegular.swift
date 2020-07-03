//
//  ContentRegular.swift
//  Assets Rights
//
//  Created by Gerson Carlos on 01/07/20.
//  Copyright © 2020 Gerson Carlos. All rights reserved.
//

import SwiftUI

struct ContentRegular: View {
    @Binding var showAddStock: Bool
        
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: HomeSidebar()) {
                    Label("Principal", systemImage: "house")
                }
                NavigationLink(destination: Overview()) {
                    Label("Resumo", systemImage: "list.bullet")
                }
                NavigationLink(destination: Operations()) {
                    Label("Operações", systemImage: "arrow.up.arrow.down.square")
                }
                NavigationLink(destination: Settings()) {
                    Label("Ajustes", systemImage: "wrench")
                }
                Spacer()

                Button(action: {
                    self.showAddStock.toggle()
                }) {
                    Image(systemName: "plus.rectangle.fill")
                        .scaledToFill()
                        .font(.system(size: 40))
                }
            }
            .listStyle(SidebarListStyle())
            .navigationTitle("Menu")
           
            HomeSidebar()
            
            Home()
        }
    }
}
