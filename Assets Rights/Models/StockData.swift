//
//  StockData.swift
//  Assets Rights
//
//  Created by Gerson Carlos on 11/09/19.
//  Copyright © 2019 Gerson Carlos. All rights reserved.
//

import SwiftUI

let stockData: [String: Company] = load("stocks_data.json")

struct Company: Hashable, Codable {
    var code: String
    var short_name: String
    var social_name: String
    var stocks: [Paper]
}

struct Paper: Hashable, Codable {
    var bdi: String
    var desc_bdi: String
    var spec: String
    var ticker: String
}

func load<T: Decodable>(_ filename: String, as type: T.Type = T.self) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
