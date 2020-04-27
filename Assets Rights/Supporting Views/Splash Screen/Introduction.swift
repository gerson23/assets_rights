//
//  Introduction.swift
//  Assets Rights
//
//  Created by Gerson Carlos on 25/04/20.
//  Copyright © 2020 Gerson Carlos. All rights reserved.
//

import SwiftUI

struct Introduction: View {
    @EnvironmentObject var settings: SettingsStore

    @Binding var isPresented: Bool
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                VStack {
                    IntroTitle(content: "Introduzindo")
                    IntroTitle(content: "Bens e Direitos")
                }
                .padding(.vertical, 30)
                
                IntroItem(title: "Resumo para declaração", content: "Resumo item a item dispostos por código para inserção direta no programa do IRPF com posição atual consolidada", imageName: "printer")
                    .animation(.linear(duration: 1))
                
                IntroItem(title: "Resumo gráfico", content: "Acompanhe facilmente a evolução patrimonial de acordo com os tipos de ativos ou ano a ano através de belos gráficos", imageName: "chart.bar").transition(AnyTransition.opacity.animation(.easeIn(duration: 1)))
                
                Spacer()
                
                Text("Ao clicar em continuar aceita os Termos e Condições. Bens e Direitos é um aplicativo para referência apenas e não se responsabiliza por problemas legais oriundos do uso dos dados.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Button(action: {
                    self.isPresented.toggle()
                    self.settings.introductionAccepted.toggle()
                    self.settings.introductionAcceptedDate = Date()
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .frame(width: geometry.size.width, height: 50)
                            .foregroundColor(Color("AR-Blue"))
                    
                        Text("Continuar")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                    }
                }
            }
        }
        .padding(.horizontal, 30)
    }
}

struct IntroTitle: View {
    var content: String
    
    var body: some View {
        Text(self.content)
            .font(.largeTitle)
            .bold()
    }
}
struct Introduction_Previews: PreviewProvider {
    @State var presented = true
    
    static var previews: some View {
        Introduction(isPresented: .constant(true))
    }
}
