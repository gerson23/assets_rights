//
//  HomeSplit.swift
//  Assets Rights
//
//  Created by Gerson Carlos on 01/07/20.
//  Copyright © 2020 Gerson Carlos. All rights reserved.
//

import SwiftUI
import UIKit

struct HomeSplitController: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) ->  UISplitViewController {
        let splitViewController = UISplitViewController(style: .doubleColumn)
        
        splitViewController.delegate = context.coordinator
        splitViewController.setViewController(UIHostingController(rootView: TestView()), for: .primary)
        splitViewController.setViewController(UIHostingController(rootView: Home().environmentObject(StockStore())), for: .secondary)
        splitViewController.setViewController(UIHostingController(rootView: ContentView().environmentObject(StockStore()).environmentObject(SettingsStore())), for: .compact)
        splitViewController.preferredDisplayMode = .oneBesideSecondary
        return splitViewController
    }
    
    func updateUIViewController(_ uiView: UISplitViewController, context: Context) {
        return
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UISplitViewControllerDelegate {
        var parent: HomeSplitController
        
        init(_ homeSplitController: HomeSplitController) {
            self.parent = homeSplitController
        }
    }
}

struct TestView: View {
    var body: some View {
        List {
            Text("ok")
            Text("okok")
        }
        .listStyle(SidebarListStyle())
    }
}
