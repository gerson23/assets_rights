//
//  AssetsRightsApp.swift
//  Assets Rights
//
//  Created by Gerson Carlos on 29/06/20.
//  Copyright © 2020 Gerson Carlos. All rights reserved.
//

import SwiftUI

@main
struct AssetsRightsApp: App {
    @StateObject private var settingsStore = SettingsStore()
    @StateObject private var stockStore = StockStore()
    @StateObject private var userData = UserData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(settingsStore)
                .environmentObject(stockStore)
                .environmentObject(userData)
        }
    }
}
