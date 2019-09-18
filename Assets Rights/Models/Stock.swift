//
//  Stock.swift
//  Assets Rights
//
//  Created by Gerson Carlos on 30/06/19.
//  Copyright © 2019 Gerson Carlos. All rights reserved.
//

import SwiftUI

struct Stock: Hashable, Codable, Identifiable {
    var id: UUID
    var ticker: String
    var company: String
    var movement: [Action]
    var type: TypeStock
    
    init(id: UUID? = nil, ticker: String? = nil, movement: [Action]? = nil) {
        self.id = UUID()
        self.ticker = ""
        self.movement = []
        self.company = ""
        self.type = TypeStock.stock
    }
}

struct Action: Hashable, Codable {
    var actionDate: Date
    var avgPrice: Double
    var taxes: Double
    var quantity: Int
    var type: TypeAction
    
    static let `default` = Self(actionDate: Date(), avgPrice: 0.0, taxes: 0.0, quantity: 0, type: TypeAction.buy)
    
    init(actionDate: Date? = nil, avgPrice: Double? = nil, taxes: Double? = nil, quantity: Int? = nil, type: TypeAction? = nil) {
        self.actionDate = actionDate ?? Date()
        self.avgPrice = avgPrice ?? 0.00
        self.taxes = taxes ?? 0.00
        self.quantity = quantity ?? 0
        self.type = type ?? TypeAction.buy
    }
}

enum TypeAction: String, CaseIterable, Hashable, Codable {
    case buy = "Compra"
    case sell = "Venda"
}

enum TypeStock: String, CaseIterable, Hashable, Codable {
    case fii = "Código 73 (FIIs)"
    case stock = "Código 31 (Ações)"
}
