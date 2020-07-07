//
//  FixedInc.swift
//  Assets Rights
//
//  Created by Gerson Carlos on 17/05/20.
//  Copyright © 2020 Gerson Carlos. All rights reserved.
//

import SwiftUI

enum TypeFixedInc: String, CaseIterable, Hashable, Codable {
    case cdb = "CDB"
    case lci = "LCI"
    case lca = "LCA"
    case lc = "LC"
    case cra = "CRA"
}

enum TypeReturn: String, CaseIterable, Hashable, Codable {
    case pre = "Pré-fixado"
    case ipca = "IPCA+"
    case cdi = "Pós-fixado"
}

struct FixedInc: Hashable, Codable, Identifiable {
    internal init(type: TypeFixedInc? = nil, issuer: String? = nil, custody: String? = nil, buyDate: Date? = nil, maturity: String? = nil, invested: String? = nil, typeCoupon: TypeReturn? = nil, coupon: String? = nil) {
        self.id = UUID()
        self.type = type ?? TypeFixedInc.cdb
        self.issuer = issuer ?? ""
        self.custody = custody ?? ""
        self.buyDate = buyDate ?? Date()
        self.maturity = maturity ?? ""
        self.invested = invested ?? ""
        self.typeCoupon = typeCoupon ?? TypeReturn.pre
        self.coupon = coupon ?? ""
    }
    
    var id: UUID
    var type: TypeFixedInc
    var issuer: String
    var custody: String
    var buyDate: Date
    var maturity: String
    var invested: String
    var typeCoupon: TypeReturn
    var coupon: String
}
