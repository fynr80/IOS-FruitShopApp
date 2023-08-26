//
//  CategoriesModel.swift
//  Client1
//
//  Created by ii on 11.06.23.
//

import Foundation
struct CategoryListDto: Codable {
    var page: CategoryPageDto
    var categories: [CategoryPreviewDto]
}

struct CategoryPageDto: Codable {
    var per: Int
    var pageCount: Int
    var page: Int
    var total: Int
}
struct CategoryPreviewDto: Codable, Hashable {
    var id: String?
    var name: String?
    var productsCount: Int?
}
