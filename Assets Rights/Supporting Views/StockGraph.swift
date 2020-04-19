//
//  StockGraph.swift
//  Assets Rights
//
//  Created by Gerson Carlos on 19/04/20.
//  Copyright © 2020 Gerson Carlos. All rights reserved.
//

import SwiftUI

let MAX_CAPSULE_WIDTH: Double = 50

struct StockGraph: View {
    var stockData: [TypeStock: Double] = [:]
    var maxData: Double = 0.0
    
    init(_ stocks: [Stock]) {
        TypeStock.allCases.forEach {
            let type = $0
            self.stockData[type] = 0.0
            
            for stock in stocks {
                if(stock.type == type) {
                    for move in stock.movement {
//                        if(move.type == TypeAction.buy)
                        self.stockData[type]! += move.avgPrice * Double(move.quantity)
                    }
                }
            }
            if(self.stockData[type]! > self.maxData) {
                self.maxData += self.stockData[type]!
            }
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                ForEach(TypeStock.allCases, id: \.self) { type in
                    VStack {
                        Text(currencyDouble2String(curDouble: self.stockData[type] ?? 0.0))
                            .font(.callout)
                        StockGraphCapsule(value: self.stockData[type] ?? 0.0, maxValue: self.maxData, width: Double(geometry.size.width - 150) / Double(self.stockData.count))
                        Text(type.rawValue)
                    }
                }
            }
        }
    }
}

struct StockGraphCapsule: View {
    var value: Double
    var maxValue: Double
    var width: Double
    
    init(value: Double, maxValue: Double, width: Double) {
        self.value = value
        self.maxValue = maxValue
        if(width < MAX_CAPSULE_WIDTH) {
            self.width = width
        }
        else {
            self.width = MAX_CAPSULE_WIDTH
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottom){
            Capsule()
                .fill(Color.gray)
                .opacity(0.1)
                .frame(width: CGFloat(width), height: 400)
            Capsule()
                .frame(width: CGFloat(width), height: CGFloat(value) / CGFloat(maxValue) * 400)
                .animation(.easeIn(duration: 0.5))
        }
    }
}

struct StockGraph_Previews: PreviewProvider {
    static var previews: some View {
        StockGraph([])
    }
}
