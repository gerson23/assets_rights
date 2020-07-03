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

    @Environment(\.horizontalSizeClass) var sizeClass
    
    @State private var selectedSheet: AddSheet = .stock
    @State var showIntro = false
    @State var showAddStock = false
    @State var showAddFixedInc = false
    
    func checkState() {
        let distance = settings.introductionAcceptedDate.timeIntervalSince(RELEASE_DATE)
        print(distance)
        print(settings.introductionAccepted)
        
        if(!settings.introductionAccepted) {
            self.showIntro.toggle()
        }
        else if(settings.introductionAccepted && distance < 0) {
            self.showIntro.toggle()
        }
    }
    

   
    var body: some View {
        VStack {
            // Custom tab bar
            if sizeClass == .compact {
                ContentCompact(selectedSheet: $selectedSheet, showAddStock: $showAddStock)
            }
            else {
                ContentRegular(showAddStock: $showAddStock)
            }
        }
        .accentColor(.mainColor)
        .sheet(isPresented: self.$showIntro) {
            Introduction(isPresented: self.$showIntro)
                .environmentObject(self.settings)
        }
        .sheet(isPresented: $showAddStock) {
            if self.selectedSheet == .stock {
                AddStock(isPresented: self.$showAddStock)
                    .environmentObject(self.userData)
                    .environmentObject(self.stockStore)
            }
            else if self.selectedSheet == .fixed {
                AddFixedInc(isPresented: self.$showAddStock)
            }
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

enum AddSheet {
    case stock, fixed
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
