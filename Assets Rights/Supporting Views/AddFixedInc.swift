//
//  AddFixedInc.swift
//  Assets Rights
//
//  Created by Gerson Carlos on 17/05/20.
//  Copyright © 2020 Gerson Carlos. All rights reserved.
//

import SwiftUI

struct AddFixedInc: View {
    @Binding var isPresented: Bool
    
    @ObservedObject var keyboardHelper = KeyboardHelper()
    
    @State var name = TypeFixedInc.cdb
    @State var name2 = TypeReturn.pre

    @State var institution = ""
    
    @State var showDummy: Bool? = false
    
    @State var fixedInc = FixedInc()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(alignment: .center) {
                Button(action: {
                    self.isPresented = false
                }) { Text("Cancelar") }
                Spacer()
                Text("Adicionar título")
                    .font(.headline)
                    .bold()
                Spacer()
                Button(action: {
                        self.isPresented = false
                }) { Text("Adicionar") }
            }
            .padding(.top)
            .padding(.leading)
            .padding(.trailing)
            
            Form {
                Section(header: Text("IDENTIFICAÇÃO")) {
                    DisclosureGroup {
                        Picker("Tipo", selection: $fixedInc.type ) {
                            ForEach(TypeFixedInc.allCases, id: \.self) { type in
                                Text(type.rawValue).tag(type)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                    } label: {
                        PickerLabel(title: "Produto", value: fixedInc.type.rawValue)
                    }
                    FieldLine(title: "Emissor", placeholder: "Fibra, Original, Agibank...", lineType: .text, field: $fixedInc.issuer)
                    FieldLine(title: "Corretora", placeholder: "Rico, XP, Nova Futura...", lineType: .text, field: $fixedInc.custody)
                }
                
                Section(header: Text("DATAS")) {
                    DatePicker("Compra", selection: $fixedInc.buyDate, in: ...Date(), displayedComponents: .date)
                    FieldLine(title: "Prazo", placeholder: "dias", lineType: .integer, field: $fixedInc.maturity)
                }
                
                Section(header: Text("VALORES"), footer: Text("").padding(.bottom, keyboardHelper.height)) {
                    FieldLine(title: "Valor Inicial", placeholder: "R$", lineType: .currency, field: $fixedInc.invested)
                    DisclosureGroup {
                        Picker("Tipo", selection: $fixedInc.typeCoupon ) {
                            ForEach(TypeReturn.allCases, id: \.self) { type in
                                Text(type.rawValue).tag(type)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                    } label: {
                        PickerLabel(title: "Tipo Rentabilidade", value: fixedInc.typeCoupon.rawValue)
                    }
                    FieldLine(title: "Taxa Rentabilidade", placeholder: "%", lineType: .percentage, field: $fixedInc.coupon)
                }
            }
        }
        .accentColor(.mainColor)
    }
}


struct AddFixedInc_Previews: PreviewProvider {
    static var previews: some View {
        AddFixedInc(isPresented: .constant(true))
    }
}
