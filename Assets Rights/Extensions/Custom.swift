//
//  Custom.swift
//  Assets Rights
//
//  Created by Gerson Carlos on 01/05/20.
//  Copyright © 2020 Gerson Carlos. All rights reserved.
//

import SwiftUI

extension Color {
    	static let mainColor = Color("AR-Blue")
}

public struct KeyboardDismissModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

extension Form {
    public func hideKeyboardOnTap() -> some View {
        return modifier(KeyboardDismissModifier())
    }
}
