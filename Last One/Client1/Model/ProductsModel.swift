//
//  ProductModel.swift
//  Client1
//
//  Created by II on 10.06.23.
//

import Foundation


struct ProductListDto: Codable {
    var page: PageDto
    var products: [ProductPreviewDto]
}

struct PageDto: Codable {
    var per: Int
    var pageCount: Int
    var page: Int
    var total: Int
}
struct ProductPreviewDto: Codable,Hashable {
    var vendorId: String
    var id: String
    var categoryId: String
    var name: String
    var description: String
    var price: Double
    
}
