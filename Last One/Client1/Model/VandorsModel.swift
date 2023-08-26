//
//  VandorsModel.swift
//  Client1
//
//  Created by ii on 11.06.23.
//

import Foundation
struct VandorListDto: Codable {
    var page: VandorPageDto
    var vendors: [VandorPreviewDto]
}

struct VandorPageDto: Codable {
    var per: Int
    var pageCount: Int
    var page: Int
    var total: Int
}
struct VandorPreviewDto: Codable, Hashable {
    var id: String?
    var name: String?
    var productsCount: Int?
}
