//
//  HomeSidebar.swift
//  Assets Rights
//
//  Created by Gerson Carlos on 03/07/20.
//  Copyright © 2020 Gerson Carlos. All rights reserved.
//

import SwiftUI

struct HomeSidebar: View {
    var body: some View {
        List {
            NavigationLink(destination: Home()) {
                Text("Gráficos")
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Principal")
    }
}
