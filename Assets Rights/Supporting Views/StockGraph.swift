//
//  StockGraph.swift
//  Assets Rights
//
//  Created by Gerson Carlos on 19/04/20.
//  Copyright © 2020 Gerson Carlos. All rights reserved.
//

import SwiftUI

let MAX_CAPSULE_WIDTH: Double = 40
let STOCK_LABELS: [TypeStock:String] = [
    TypeStock.fii: "FII",
    TypeStock.fund: "Fundos",
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
                    let stockAmount = calcTotalbyStock(movements: stock.movement)
                    self.stockData[GraphType.by_type]![typeName]! += stockAmount.0
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
            let stockAmount = calcTotalbyStock(movements: stock.movement)
            
            for (year, total) in stockAmount.2 {
                yearsTotal[year] = (yearsTotal[year] ?? 0.0) + total
            }
        }
        
        for (year, total) in yearsTotal {
            self.stockData[GraphType.by_year]![year] = total
            if(total > self.maxData[GraphType.by_year]!) {
                self.maxData[GraphType.by_year] = total
            }
        }
                
        // General data wrapup
        GraphType.allCases.forEach {
            let type = $0
            
            if(self.maxData[type] == 0) {
                self.maxData[type] = 1
            }
            
            self.labels[type] = Array(self.stockData[type]!.keys).sorted()
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal){
                HStack {
                    Spacer()
                    ForEach(self.labels[self.selectedType]!, id: \.self) { key in
                        VStack {
                            Text(currencyDouble2String(curDouble: self.stockData[self.selectedType]![key] ?? 0.0))
                                .font(.callout)
                            StockGraphCapsule(value: self.stockData[self.selectedType]![key] ?? 0.0, maxValue: self.maxData[self.selectedType]!, width: Double(geometry.size.width - 150) / Double(self.stockData.count), height: Double(geometry.size.height - 100))
                            Text(key)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct StockGraphCapsule: View {
    var value: Double
    var maxValue: Double
    var width: CGFloat
    var fheight: CGFloat
    @State var height: CGFloat = 0.0
    
    init(value: Double, maxValue: Double, width: Double, height: Double) {
        self.value = value
        self.maxValue = maxValue
        self.fheight = CGFloat(height)
        if(width < MAX_CAPSULE_WIDTH) {
            self.width = CGFloat(width)
        }
        else {
            self.width = CGFloat(MAX_CAPSULE_WIDTH)
        }
    }
    
    func fillAnimation() {
        withAnimation(Animation.spring()) {
            self.height = self.fheight
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottom){
            Capsule()
                .fill(Color.gray)
                .opacity(0.1)
                .frame(width: CGFloat(width), height: self.fheight)
            Capsule()
                .frame(width: CGFloat(width), height: CGFloat(value) / CGFloat(maxValue) * self.height)
                .foregroundColor(.accentColor)
        }
        .onAppear(perform: fillAnimation)
    }
}

/*struct StockGraph_Previews: PreviewProvider {
    static var previews: some View {
        StockGraph([], GraphType.by_type)
    }
}*/
