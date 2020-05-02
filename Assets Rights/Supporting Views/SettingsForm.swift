//
//  SettingsForm.swift
//  Assets Rights
//
//  Created by Gerson Carlos on 07/07/19.
//  Copyright © 2019 Gerson Carlos. All rights reserved.
//

import SwiftUI

struct SettingsForm : View {
    @EnvironmentObject var stockStore: StockStore
    @State var settings: SettingsStore
    @Binding var notifications: Bool
    
    var body: some View {
        Form {
            Section {
                Toggle(isOn: $settings.isNotificationEnabled) {
                    Text("Habilitar notificações")
                }
            }
            
            
            Section {
                NavigationLink(destination: About()) {
                    Text("Sobre")
                }
                NavigationLink(destination: Introduction(isPresented: .constant(true))) {
                    Text("Introdução")
                }
            }
            
            Section {
                Button(action: {
                    self.stockStore.clearAll()
                    self.notifications = true
                }) {
                    Text("Deletar todos dados")
                        .foregroundColor(.red)
                }
            }
        }
    }
}

#if DEBUG
/*struct SettingsForm_Previews : PreviewProvider {
    @State var x = false

    static var previews: some View {
        SettingsForm(settings: SettingsStore(), notifications: x)
    }
}*/
#endif
