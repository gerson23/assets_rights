//
//  Settings.swift
//  Assets Rights
//
//  Created by Gerson Carlos on 07/07/19.
//  Copyright © 2019 Gerson Carlos. All rights reserved.
//

import SwiftUI

struct Settings : View {
    @EnvironmentObject var settings: SettingsStore
    @State var notifications = false
    
    var body: some View {
        //NavigationView {
            // Keeping VStack for now as Form is crashing sibbling views
            //Form {
            /*VStack(alignment: .leading, spacing: 30) {
                Section {
                    Toggle(isOn: $settings.isNotificationEnabled) {
                        Text("Habilitar notificações")
                    }
                }
                
                Section {
                    NavigationLink(destination: About()) {
                        Text("Sobre")
                    }
                }
                
                Section {
                    Button(action: {
                        self.notifications = true
                    }) {
                        Text("Deletar todos dados")
                            .foregroundColor(.red)
                    }
                }
            }*/
            SettingsForm(settings: settings, notifications: $notifications)
            .navigationBarTitle(Text("Ajustes"))
            .alert(isPresented: $notifications) {
                Alert(title: Text("Dados deletados"))
            }
     //   }
    }
}

#if DEBUG
struct Settings_Previews : PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
#endif
