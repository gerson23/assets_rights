//
//  KeyboardHelper.swift
//  Assets Rights
//
//  Created by Gerson Carlos on 30/06/20.
//  Copyright © 2020 Gerson Carlos. All rights reserved.
//

import Foundation
import UIKit

class KeyboardHelper: ObservableObject {
    @Published var height: CGFloat = 0.0
    
    private func listenKeyboardNotifications() {
        // Adding observer for when keyboard is shown
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidShowNotification, object: nil, queue: .main) { notification in
            guard let userInfo = notification.userInfo,
                  let keyboardRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
            
            self.height = keyboardRect.height
            
        }
        
        // Adding observer for when keyboard is dismissed
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidHideNotification, object: nil, queue: .main) { notification in
            self.height = 0.0
        }
    }
    
    init() {
        listenKeyboardNotifications()
    }
}
