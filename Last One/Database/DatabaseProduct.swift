//
//  DatabaseProduct.swift
//  Client1
//
//  Created by ii on 13.06.23.
//
import Foundation
import GRDB
import SwiftUI


struct DatabaseProduct: Codable, FetchableRecord, PersistableRecord, Identifiable, Hashable {
    var id: Int? = nil
    var vendorId: String = ""
    var productId: String = ""
    var categoryId: String = ""
    var name: String = ""
    var description: String = ""
    var price: Double = 0
    var amount: Int = 0
    
    enum Columns: String, ColumnExpression { case productId
    }
}
/*
var namePresentation: String? {
    let presentation = "\(givenName) \(familyName)".trimmingCharacters(in: .whitespacesAndNewlines)

    if presentation.isEmpty {
        return nil
    }

    return presentation
}*/
