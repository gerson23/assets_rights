//
//  IntroItem.swift
//  Assets Rights
//
//  Created by Gerson Carlos on 25/04/20.
//  Copyright © 2020 Gerson Carlos. All rights reserved.
//

import SwiftUI

struct IntroItem: View {
    var title: String
    var content: String
    var imageName: String
    
    var body: some View {
        HStack {
            Image(systemName: self.imageName)
                .imageScale(.large)
                .font(.system(size: 30))
                .foregroundColor(.accentColor)
                .padding(.horizontal)
            VStack(alignment: .leading) {
                Text(self.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(self.content)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical)
    }
}

struct IntroItem_Previews: PreviewProvider {
    static var previews: some View {
        IntroItem(title: "Hello World", content: "blab balblab balb alba", imageName: "plus.circle.fill")
    }
}
