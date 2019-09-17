//
//  About.swift
//  Assets Rights
//
//  Created by Gerson Carlos on 07/07/19.
//  Copyright © 2019 Gerson Carlos. All rights reserved.
//

import SwiftUI
import Foundation

struct About : View {
    var body: some View {
        VStack {
            Text("Sobre isso aqui")
                .foregroundColor(.secondary)
        }
        .navigationBarTitle("Sobre", displayMode: .inline)
    }
}

#if DEBUG
struct About_Previews : PreviewProvider {
    static var previews: some View {
        About()
    }
}
#endif
