//
//  CommonForm.swift
//  Assets Rights
//
//  Created by Gerson Carlos on 24/05/20.
//  Copyright © 2020 Gerson Carlos. All rights reserved.
//

import SwiftUI

enum LineType {
    case text, currency, percentage, integer
}

struct FieldLine: View {
    var title: String
    var placeholder: String
    var lineType: LineType
    @Binding var field: String
    
    func getKeyboard() -> UIKeyboardType {
        if lineType == .currency || lineType == .percentage {
            return .decimalPad
        }
        else if lineType == .integer {
            return .numberPad
        }
        else {
            return .alphabet
        }
    }
    
    func handleEditChanged(_ changed: Bool) {
        if !changed {
            if lineType == .currency {
                let doubleValue = currencyFormat.number(from: currencyFormat.currencySymbol + field) ?? 0
                field = currencyFormat.string(from: doubleValue) ?? ""
            }
            else if lineType == .percentage {
                field = field + " %"
            }
        }
        else {
            field = ""
        }
    }
    
    var body: some View {
        HStack {
            Text(title)
            TextField(placeholder, text: $field, onEditingChanged: handleEditChanged)
                .keyboardType(getKeyboard())
                .multilineTextAlignment(.trailing)
                .font(.system(size: 17, weight: .thin, design: .default))
        }
    }
}

struct PickerLabel: View {
    var title: String
    var value: String
        
    var body: some View {
        HStack {
             Text(title)
             Spacer()
             Text(value)
                 .fontWeight(.thin)
                 .multilineTextAlignment(.trailing)
          }
    }
}
