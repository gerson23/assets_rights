//
//  UserData.swift
//  Assets Rights
//
//  Created by Gerson Carlos on 07/07/19.
//  Copyright © 2019 Gerson Carlos. All rights reserved.
//

import SwiftUI
import Combine

class UserData : ObservableObject, Identifiable {
    @Published var stocks = [] as [Stock]
}
