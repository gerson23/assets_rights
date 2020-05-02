//
//  OperationsDetail.swift
//  Assets Rights
//
//  Created by Gerson Carlos on 02/05/20.
//  Copyright © 2020 Gerson Carlos. All rights reserved.
//

import SwiftUI

struct OperationsDetail: View {
    var title : String
    
    var body: some View {
        VStack {
            Text("Hello, World!")
        }
        .navigationBarTitle(self.title)
    }
}

struct OperationsDetail_Previews: PreviewProvider {
    static var previews: some View {
        OperationsDetail(title: "Operações em Teste")
    }
}
