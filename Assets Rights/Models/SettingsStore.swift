//
//  SettingsStore.swift
//  Assets Rights
//
//  Created by Gerson Carlos on 07/07/19.
//  Copyright © 2019 Gerson Carlos. All rights reserved.
//

import SwiftUI
import Combine

class  SettingsStore : ObservableObject, Identifiable {
    var objectWillChange = PassthroughSubject<Void, Never>()
    
    private let defaults: UserDefaults
    private let cancellable: Cancellable
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        
        defaults.register(defaults: [
            Keys.notificationEnabled: false
        ])
        
        cancellable = NotificationCenter.default
            .publisher(for: UserDefaults.didChangeNotification)
            .map { _ in () }
            .subscribe(objectWillChange)
    }
    
    var isNotificationEnabled: Bool {
        set { defaults.set(newValue, forKey: Keys.notificationEnabled)}
        get { defaults.bool(forKey: Keys.notificationEnabled)}
    }
    
    var introductionAccepted: Bool {
        set { defaults.set(newValue, forKey: Keys.introductionAccepted)}
        get { defaults.bool(forKey: Keys.introductionAccepted)}
    }
    
    var introductionAcceptedDate: Date {
        set { defaults.set(newValue, forKey: Keys.introductionAcceptedDate)}
        get { defaults.object(forKey: Keys.introductionAcceptedDate) as! Date}
    }
    
    private enum Keys {
        static let notificationEnabled = "notification_enabled"
        static let introductionAccepted = "intro_accepted"
        static let introductionAcceptedDate = "intro_date"
    }
}
