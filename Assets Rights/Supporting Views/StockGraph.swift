//
//  StockGraph.swift
//  Assets Rights
//
//  Created by Gerson Carlos on 19/04/20.
//  Copyright © 2020 Gerson Carlos. All rights reserved.
//

import SwiftUI

let MAX_CAPSULE_WIDTH: Double = 50
let STOCK_LABELS: [TypeStock:String] = [
    TypeStock.fii: "FII",
    TypeStock.stock: "Ação"]

struct StockGraph: View {
    var stockData: [GraphType: [String: Double]] = [:]
    var maxData: [GraphType: Double] = [:]
    var labels: [GraphType: Array<String>] = [:]
    
    @Binding var selectedType: GraphType
    
    init(_ stocks: [Stock], _ selection: Binding<GraphType>) {
        self._selectedType = selection
        
        GraphType.allCases.forEach {
            let type = $0
            self.stockData[type] = [:]
            self.maxData[type] = 0.0
        }
        
        // BY TYPE
        TypeStock.allCases.forEach {
            let type = $0
            let typeName = STOCK_LABELS[type]!
            
            self.stockData[GraphType.by_type]![typeName] = 0.0
            
            for stock in stocks {
                if(stock.type == type) {
                    for move in stock.movement {
//                        if(move.type == TypeAction.buy)
                        self.stockData[GraphType.by_type]![typeName]! += move.avgPrice * Double(move.quantity)
                    }
                }
            }
            if(self.stockData[GraphType.by_type]![typeName]! > self.maxData[GraphType.by_type]!) {
                self.maxData[GraphType.by_type]! += self.stockData[GraphType.by_type]![typeName]!
            }
        }
        
        
        // BY YEAR
        var yearsTotal: [String: Double] = [:]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY"
        for stock in stocks {
            for move in stock.movement {
                let yearMove = dateFormatter.string(from: move.actionDate)
                let amount = yearsTotal[yearMove] ?? 0.0
                yearsTotal[yearMove] = amount + (move.avgPrice * Double(move.quantity))
            }
        }
        
        for (year, total) in yearsTotal {
            self.stockData[GraphType.by_year]![year] = total
            if(total > self.maxData[GraphType.by_year]!) {
                self.maxData[GraphType.by_year] = total
            }
        }
        
        self.labels[GraphType.by_year] = Array(self.stockData[GraphType.by_year]!.keys)
        self.labels[GraphType.by_type] = Array(self.stockData[GraphType.by_type]!.keys)
        
        // avoid division by 0
        GraphType.allCases.forEach {
            let type = $0
            
            if(self.maxData[type] == 0) {
                self.maxData[type] = 1
            }
            
            self.labels[type] = Array(self.stockData[type]!.keys)
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                ForEach(self.labels[self.selectedType]!, id: \.self) { key in
                    VStack {
                        Text(currencyDouble2String(curDouble: self.stockData[self.selectedType]![key] ?? 0.0))
                            .font(.callout)
                        StockGraphCapsule(value: self.stockData[self.selectedType]![key] ?? 0.0, maxValue: self.maxData[self.selectedType]!, width: Double(geometry.size.width - 150) / Double(self.stockData.count))
                            .animation(.default)
                        Text(key)
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
                .foregroundColor(.blue)
        }
    }
}

/*struct StockGraph_Previews: PreviewProvider {
    static var previews: some View {
        StockGraph([], GraphType.by_type)
    }
}*/
