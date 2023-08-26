//
//  OrdersModel.swift
//  Client1
//
//  Created by ii on 30.06.23.
//

import Foundation

struct ResponseEntries: Codable {
    var id: String
    var state: String
    var entries: [Order]
}

struct Entries: Codable {
    var entries: [Order]
}

struct Order: Codable {
    var amount: Int
    var productID: String
}


